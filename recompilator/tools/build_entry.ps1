<#
build_entry.ps1 - THE ONE DRIVER for a build (PACKAGING_FIRST_GAME.md section 6 step 5).

    powershell -NoProfile -ExecutionPolicy Bypass -File recompilator\tools\build_entry.ps1 <game> [-RomPath <path>] [-BuildDir <path>] [-Jobs 2]
    powershell -NoProfile -ExecutionPolicy Bypass -File recompilator\tools\build_entry.ps1 -RomPath <cart>

TWO PATHS, and which one runs is decided by the CART'S OWN SHA-1 against the catalog - never by a
file name, never by a game name.

A) THE CART IS IN THE CATALOG (the lab; a release ships no catalog, so this never happens there):

    1 RECOGNISED            SHA1 of the ROM == entry.json rom.sha1; the ROM is installed as <game>/baserom.z64
    2 BYTE-EXACT ELF        tools/build_elf.py with the bundled toolchain (docker only as a fallback)
    3 SYMBOLS + RECOMPILER  gen_toml.py <game>, then N64Recomp.exe <game>.toml
    - NI SECTION DATA       ONLY when the catalog entry carries tools/gen_ni_data.py (a decomp-shaped entry)
    4 RSP MICROCODE         pass-through in step 2 (the tree carries its ucode tomls; nothing to run yet)
    5 COMPILE               the bundled clang builds <game>pc/module/<game>.dll (MSBuild is the fallback)
    6 RESULT                the artifact, its size, the total

B) THE CART IS IN NO CATALOG - THE BLIND PATH (2026-09-07: no game ships with
   the program). The program reads the cartridge and builds a playable program from it:

    1 RECOGNISED            what the cart says about itself: internal name, serial, entrypoint, size, sha1
    2 BRING-UP              tools/blind_bringup.py authors the tree from the cart's own bytes
    3 BYTE-EXACT ELF        the ROM is rebuilt from the ELF and the bytes must match EXACTLY.
                            A cart that cannot reach this STOPS HERE, loudly, with the reason.
    4 SEGMENTATION          code-vs-data refined until the recompiler and the compiler are clean
    5 SYMBOLS + RECOMPILER  ) the same stages as (A) from here on: the blind path ends with a tree
    6 RSP MICROCODE         ) and an app exactly like any other, and a catalog entry the program
    7 COMPILE               ) authored for itself, marked as locally authored (nothing shipped).
    8 RESULT                )

THERE IS NO PER-GAME CODE HERE. Every game takes the same path; the only branch is the presence of
the FILE tools/gen_ni_data.py inside the catalog entry - never a game name.

STDOUT IS A MACHINE INTERFACE. Exactly these lines and nothing else (the launcher's BUILD screen
parses them; everything else goes to the log named on the first line of the log file):

    STAGE <n> <NAME> START <iso-time>
    STAGE <n> <NAME> OK <seconds> <one-line evidence>
    STAGE <n> <NAME> FAIL <seconds> <one-line reason>
    RESULT OK <exe path> <bytes> <total seconds>
    RESULT FAIL <stage name>

<NAME> may contain spaces: a parser finds the first START/OK/FAIL token after the stage number.
Exit code 0 only after RESULT OK.

Log: _sweep/dispatch/build_<game>_<yyyymmdd_hhmm>.log
#>

[CmdletBinding()]
param(
    # OPTIONAL since 2026-09-07. `-RomPath <cart>` alone is now a whole build: the driver works out
    # which cart it is by READING IT, and if nothing in the catalog matches - which in a release is
    # always, because a release ships no catalog - it brings the cart up blind.
    [Parameter(Position = 0)]
    [string]$Game = '',
    [string]$RomPath = '',
    [string]$BuildDir = '',
    [int]$Jobs = 2,
    # THE USER'S CHOICE. A recipe is the lab's notes on one dump of a game; the blind path is the
    # program's own reading of the cartridge in hand. -Blind builds from the cartridge alone even
    # when a recipe carries its sha1, so a person decides per game which one they want (2026-09-09).
    [switch]$Blind
)

$ErrorActionPreference = 'Stop'

# ---------------------------------------------------------------- paths ------
$root    = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)   # tools -> recompilator -> N64PC
$n64recomp = Join-Path $root 'engine\runtime\N64Recomp\build_cli\Release\N64Recomp.exe'
$catalog = ''; $entry = ''; $gameDir = ''; $pcDir = ''; $baserom = ''; $canonExe = ''

# Every path this driver touches is <root>\<game>... - one function so the game can be decided at
# run time (from the cart) instead of being fixed by the command line.
function Set-GamePaths([string]$g) {
    $script:Game     = $g
    $script:catalog  = Join-Path $root "recompilator\catalog\$g"
    $script:entry    = Join-Path $script:catalog 'entry.json'
    # A GAME LIVES IN <root>/archive/. Games used to be created loose in the root, which turned
    # the folder the program sits in into a pile of per-game directories (2026-09-07).
    # A tree already at the old location is used where it is, so nothing built before moves.
    $oldDir = Join-Path $root $g
    if (Test-Path (Join-Path $oldDir ("{0}.yaml" -f $g))) {
        $script:gameDir = $oldDir
        $script:pcDir   = Join-Path $root "${g}pc"
    } else {
        $arch = Join-Path $root "archive"
        if (-not (Test-Path $arch)) { New-Item -ItemType Directory -Force $arch | Out-Null }
        $script:gameDir = Join-Path $arch $g
        $script:pcDir   = Join-Path $arch "${g}pc"
    }
    $script:baserom  = Join-Path $script:gameDir 'baserom.z64'
    $script:canonExe = Join-Path $script:pcDir "build\windows-x64\Release\${g}pc.exe"
}
Set-GamePaths $Game

# ------------------------------------------------------- the bundled toolchain -
# The end user installs NOTHING. When a toolchain/ directory sits beside the program (or
# _toolchain/ in the lab), stage 2 runs the pipeline natively - a bundled Python + splat and a
# bundled MIPS binutils - and stages 3..4 use the bundled Python and N64Recomp too. Docker is
# only the fallback for a tree that has no toolchain beside it. See tools/make_toolchain.ps1.
$toolchain = ''
$tcCands = @()
if ($env:RECOMPILATOR_TOOLCHAIN) { $tcCands += $env:RECOMPILATOR_TOOLCHAIN }
$tcCands += (Join-Path $root '_toolchain')
$tcCands += (Join-Path $root 'toolchain')
foreach ($c in $tcCands) {
    if ($c -and (Test-Path (Join-Path $c 'mips\bin\mips64-elf-as.exe')) -and
                (Test-Path (Join-Path $c 'python\python.exe'))) { $toolchain = $c; break }
}
$tcPython = ''
$tcRecomp = ''
if ($toolchain) {
    $tcPython = Join-Path $toolchain 'python\python.exe'
    $c = Join-Path $toolchain 'n64recomp\N64Recomp.exe'
    if (Test-Path $c) { $tcRecomp = $c }
}
# every python step goes through these two: the bundled interpreter isolated from the machine
# (-I = no PYTHONPATH, no user site), or the launcher `py -3` when there is no toolchain.
$pyExe = 'py'
$pyPre = '-3 '
if ($tcPython) { $pyExe = $tcPython; $pyPre = '-I ' }
if ($tcRecomp) { $n64recomp = $tcRecomp }

$dispatch = Join-Path $root '_sweep\dispatch'
if (-not (Test-Path $dispatch)) { New-Item -ItemType Directory -Path $dispatch -Force | Out-Null }
$stamp = (Get-Date).ToString('yyyyMMdd_HHmm')
$log   = Join-Path $dispatch ("build_{0}_{1}.log" -f $(if ($Game) { $Game } else { 'addrom' }), $stamp)

$inv = [System.Globalization.CultureInfo]::InvariantCulture

# ------------------------------------------------------------- plumbing ------
function Log([string]$s) {
    if ($null -eq $s) { $s = '' }
    Add-Content -Path $log -Value $s -Encoding Ascii
}

function Emit([string]$s) {
    [Console]::Out.WriteLine($s)
    [Console]::Out.Flush()
    Log "STDOUT> $s"
}

function OneLine([string]$s) {
    if ($null -eq $s) { return '' }
    $t = ($s -replace '[\r\n\t]+', ' ') -replace '\s{2,}', ' '
    $t = $t.Trim()
    if ($t.Length -gt 170) { $t = $t.Substring(0, 167) + '...' }
    return $t
}

$script:stageNo   = 0
$script:stageName = ''
$script:stageT0   = Get-Date
$script:runT0     = Get-Date

function Secs([datetime]$from) {
    return ((Get-Date) - $from).TotalSeconds.ToString('F1', $inv)
}

function Start-Stage([string]$name) {
    $script:stageNo++
    $script:stageName = $name
    $script:stageT0 = Get-Date
    Emit ("STAGE {0} {1} START {2}" -f $script:stageNo, $name, (Get-Date).ToString('yyyy-MM-ddTHH:mm:ss'))
}

function Pass-Stage([string]$evidence) {
    Emit ("STAGE {0} {1} OK {2} {3}" -f $script:stageNo, $script:stageName, (Secs $script:stageT0), (OneLine $evidence))
}

function Fail-Stage([string]$reason) {
    Emit ("STAGE {0} {1} FAIL {2} {3}" -f $script:stageNo, $script:stageName, (Secs $script:stageT0), (OneLine $reason))
    Emit ("RESULT FAIL {0}" -f $script:stageName)
    Log ("FAILED at stage {0} {1}: {2}" -f $script:stageNo, $script:stageName, $reason)
    exit 1
}

# Run a native program with its output captured to files (never `2>&1` into the PowerShell
# pipeline: PS 5.1 wraps every stderr line of a native exe in a NativeCommandError record).
function Invoke-Native([string]$File, [string]$Arguments, [string]$WorkDir, [string]$Tag) {
    $so = Join-Path $env:TEMP ("recompilator_{0}_{1}.out.txt" -f $Game, $Tag)
    $se = Join-Path $env:TEMP ("recompilator_{0}_{1}.err.txt" -f $Game, $Tag)
    foreach ($f in @($so, $se)) { if (Test-Path $f) { [IO.File]::Delete($f) } }
    Log ("--- RUN [{0}] {1} {2}   (cwd {3})" -f $Tag, $File, $Arguments, $WorkDir)
    # -PassThru + WaitForExit(), NOT -Wait: `Start-Process -Wait` waits for the whole process TREE,
    # and MSBuild leaves its worker nodes idle for FIFTEEN MINUTES by default (node reuse). The
    # first hand run of this driver measured COMPILE at 1063.7 s for a build whose exe was linked
    # 162 s in -- the other 15:02 was Start-Process waiting on two idle MSBuild nodes.
    $p = Start-Process -FilePath $File -ArgumentList $Arguments -WorkingDirectory $WorkDir `
                       -NoNewWindow -PassThru `
                       -RedirectStandardOutput $so -RedirectStandardError $se
    $p.WaitForExit()
    $text = ''
    foreach ($f in @($so, $se)) {
        if (Test-Path $f) {
            $c = Get-Content -Path $f -Raw -ErrorAction SilentlyContinue
            if ($c) { $text += $c }
        }
    }
    Log $text
    Log ("--- END [{0}] exit {1}" -f $Tag, $p.ExitCode)
    foreach ($f in @($so, $se)) { if (Test-Path $f) { [IO.File]::Delete($f) } }
    return [pscustomobject]@{ ExitCode = $p.ExitCode; Output = $text }
}

function Sha1OfBytes([byte[]]$bytes) {
    $sha = [System.Security.Cryptography.SHA1]::Create()
    try { return ([BitConverter]::ToString($sha.ComputeHash($bytes)) -replace '-', '').ToLowerInvariant() }
    finally { $sha.Dispose() }
}

function Sha1OfFile([string]$path) {
    $sha = [System.Security.Cryptography.SHA1]::Create()
    $fs = [IO.File]::OpenRead($path)
    try { return ([BitConverter]::ToString($sha.ComputeHash($fs)) -replace '-', '').ToLowerInvariant() }
    finally { $fs.Dispose(); $sha.Dispose() }
}

Add-Type @'
public static class RomSwap {
    // .v64 (byte-swapped, 0x37804012) and .n64 (little-endian words, 0x40123780) images are
    // rewritten into .z64 order in place, so the catalog's sha1 (always of the z64 image) matches.
    public static void Pairs(byte[] b) {
        for (int i = 0; i + 1 < b.Length; i += 2) { byte t = b[i]; b[i] = b[i+1]; b[i+1] = t; }
    }
    public static void Words(byte[] b) {
        for (int i = 0; i + 3 < b.Length; i += 4) {
            byte a = b[i], c = b[i+1], d = b[i+2], e = b[i+3];
            b[i] = e; b[i+1] = d; b[i+2] = c; b[i+3] = a;
        }
    }
}
'@

# Read a user ROM (.z64/.n64/.v64, or a .zip holding one) and return its bytes in z64 order.
function Read-RomBytes([string]$path) {
    $ext = [IO.Path]::GetExtension($path).ToLowerInvariant()
    $bytes = $null
    $member = ''
    if ($ext -eq '.zip') {
        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $zip = [IO.Compression.ZipFile]::OpenRead($path)
        try {
            foreach ($e in $zip.Entries) {
                $ee = [IO.Path]::GetExtension($e.Name).ToLowerInvariant()
                if ($ee -eq '.z64' -or $ee -eq '.n64' -or $ee -eq '.v64') {
                    $ms = New-Object IO.MemoryStream
                    $st = $e.Open()
                    try { $st.CopyTo($ms) } finally { $st.Dispose() }
                    $bytes = $ms.ToArray()
                    $ms.Dispose()
                    $member = $e.Name
                    break
                }
            }
        } finally { $zip.Dispose() }
        if ($null -eq $bytes) { return $null }
    } else {
        $bytes = [IO.File]::ReadAllBytes($path)
        $member = [IO.Path]::GetFileName($path)
    }
    if ($bytes.Length -lt 4) { return $null }
    $magic = '{0:X2}{1:X2}{2:X2}{3:X2}' -f $bytes[0], $bytes[1], $bytes[2], $bytes[3]
    $order = 'z64'
    if ($magic -eq '37804012') { [RomSwap]::Pairs($bytes); $order = 'v64->z64' }
    elseif ($magic -eq '40123780') { [RomSwap]::Words($bytes); $order = 'n64->z64' }
    elseif ($magic -ne '80371240') { $order = "unknown magic 0x$magic" }
    return [pscustomobject]@{ Bytes = $bytes; Member = $member; Order = $order }
}

# --------------------------------------------------------------- header ------
Set-Content -Path $log -Value ("build_entry.ps1  game={0}  started {1}" -f $(if ($Game) { $Game } else { '(to be read from the cart)' }), (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) -Encoding Ascii
Log ("root={0}" -f $root)
Log ("toolchain={0}" -f $(if ($toolchain) { $toolchain } else { '(none: stage 2 falls back to the docker stopgap)' }))
# THE RECOMPILER'S IDENTITY GOES IN THE LOG. 2026-09-08: a 40-cart sweep ran a toolchain copy of
# N64Recomp.exe dated the previous evening while the engine's build was hours newer, and no log
# said which binary had run. Date and size, here and on the stage-5 line, so every build names it.
$n64recompStamp = 'missing'
if (Test-Path $n64recomp) { $ni = Get-Item $n64recomp; $n64recompStamp = ('{0} {1} B' -f $ni.LastWriteTime.ToString('yyyy-MM-dd HH:mm'), $ni.Length) }
Log ("python={0}  n64recomp={1} [{2}]" -f $pyExe, $n64recomp, $n64recompStamp)
Log ("rom-path={0}" -f $(if ($RomPath) { $RomPath } else { '(none given: the tree''s own baserom.z64 is verified in place)' }))
Log ''

# ------------------------------------------------- the cart the user brought -
# Read ONCE, in z64 order, before anything is decided. The file name means nothing here: which
# cartridge this is comes from its own bytes.
$rom = $null
$romSha = ''
if ($RomPath) {
    if (-not (Test-Path $RomPath)) { Start-Stage 'RECOGNISED'; Fail-Stage "no ROM at $RomPath" }
    $rom = Read-RomBytes $RomPath
    if ($null -eq $rom) { Start-Stage 'RECOGNISED'; Fail-Stage "no N64 image inside $RomPath" }
    $romSha = Sha1OfBytes $rom.Bytes
    Log ("rom member={0} order={1} bytes={2} sha1={3}" -f $rom.Member, $rom.Order, $rom.Bytes.Length, $romSha)
}

# WHICH ENTRY, IF ANY. The catalog is searched by the cart's SHA-1 - never by a file name, never by
# a title. No match is not an error: it is the blind path, and in a release it is the only path.
$blindPath = $false
if (-not $Game) {
    if (-not $rom) { Start-Stage 'RECOGNISED'; Fail-Stage 'no game named and no -RomPath: nothing to build' }
    $catRoot = Join-Path $root 'recompilator\catalog'
    $hit = ''
    if ($Blind) { Log 'blind build requested: the catalog is not consulted' }
    if ((Test-Path $catRoot) -and -not $Blind) {
        foreach ($d in (Get-ChildItem -Path $catRoot -Directory -ErrorAction SilentlyContinue)) {
            $ej = Join-Path $d.FullName 'entry.json'
            if (-not (Test-Path $ej)) { continue }
            $j = $null
            try { $j = Get-Content -Path $ej -Raw | ConvertFrom-Json } catch { continue }
            if ($j.rom -and $j.rom.sha1 -and (([string]$j.rom.sha1).ToLowerInvariant() -eq $romSha)) {
                $hit = $d.Name; break
            }
        }
    }
    # A RECIPE THAT CANNOT BE SATISFIED IS NOT A RECIPE. Some trees were brought up with the
    # RAM-snapshot overlay: their linker script places a section out of build/asm/<name>.s.o, which
    # is assembled from a capture of the game's own RDRAM. That capture is ROM-derived, so the
    # export audit refuses to ship it - correctly - and the recipe that depends on it therefore
    # cannot be built by anyone. Turok and Shadows Of The Empire both died at `mips64-elf-ld:
    # cannot find build/asm/ovl_snap_main.s.o` on the 09-08 playtest; they read as
    # "link failed" and "no ELF produced".
    # A recipe is an optimisation over the blind path, never a requirement, so an unsatisfiable one
    # is DROPPED and the cart is brought up blind - the same call as a recipe for a different dump.
    if ($hit) {
        $unmet = @()
        foreach ($ld in (Get-ChildItem -Path (Join-Path $catRoot $hit) -Filter '*_pinned.ld' -File -ErrorAction SilentlyContinue)) {
            # ONLY THE RAM-CAPTURE SECTIONS. Every recipe's linker script names build/asm/*.s.o -
            # that is ordinary splat output, generated from the cart during BYTE-EXACT ELF and never
            # shipped. Matching all of them made this guard drop EVERY recipe to the blind path, which
            # is a silent, wholesale disabling of half the pipeline (Super Mario 64 built blind on
            # 2026-09-08 for this reason and I nearly reported it as the catalog behaving correctly).
            # A capture section is the ovl_snap_* convention and nothing else.
            foreach ($m in ([regex]'build/asm/(ovl_snap[A-Za-z0-9_]*)\.s\.o').Matches([IO.File]::ReadAllText($ld.FullName))) {
                $srcS = Join-Path (Join-Path $catRoot $hit) ('asm' + [char]92 + $m.Groups[1].Value + '.s')
                if (-not (Test-Path $srcS)) { $unmet += $m.Groups[1].Value }
            }
        }
        $unmet = @($unmet | Sort-Object -Unique)
        if ($unmet.Count -gt 0) {
            # Fall back to the blind path, which is how these carts are brought up anyway.
            # MEASURED 2026-09-08, after I briefly concluded the opposite and was wrong: a
            # known-working Turok 1.1 build is 479 functions / 96 KB and a working Shadows Of The
            # Empire is 344 / 119 KB - the same numbers the blind path produces here. A cart of
            # this class keeps its code compressed and runs it out of RAM through the runtime, so
            # a small module is CORRECT for it, not evidence of an empty build. (Castlevania, which
            # plays fully, is 17,245 functions - the contrast is real but it is a class difference,
            # not a quality one.) The recipe is dropped because its RAM capture is ROM-derived and
            # never ships; the blind path needs no capture.
            Log ("catalog entry '{0}' needs {1}, which is derived from a RAM capture and is never shipped -> BLIND BRING-UP" -f $hit, ($unmet -join ', '))
            $hit = ''
        }
    }
    if ($hit) { Set-GamePaths $hit; Log ("catalog match by sha1: {0}" -f $hit) }
    else      { $blindPath = $true;    Log $(if ($Blind) { 'blind build requested -> BLIND BRING-UP' } else { 'no catalog entry carries this sha1 -> BLIND BRING-UP' }) }
}

$elf = ''

if (-not $blindPath) {

# =============================================================== 1 RECOGNISED =
Start-Stage 'RECOGNISED'
if (-not (Test-Path $entry))   { Fail-Stage "no catalog entry at $entry" }
# MATERIALISE THE TREE FROM THE CATALOG ENTRY. On this machine the trees are already here, so this
# never fired and shipping the catalog looked like enough - it is not. A user has the entry and no
# tree, and an entry IS the tree minus everything a build generates. EVERYTHING in the entry travels
# with its structure: app/ becomes the program folder, entry.json stays behind, and the rest -
# including include/macro.inc, without which the assembler stops at the first function - becomes the
# game folder. Copy, never overwrite: a tree the user has already built stays exactly as it is.
$catDir = Split-Path -Parent $entry
if (Test-Path $catDir) {
    $madeGame = 0; $madeApp = 0
    foreach ($f in (Get-ChildItem -LiteralPath $catDir -File -Recurse)) {
        # No literal path separators here on purpose: a backslash in a patch does not always
        # survive the journey into this file, and the last one that did not silently left every
        # relative path with a leading separator so nothing matched (2026-09-07).
        $sep = [IO.Path]::DirectorySeparatorChar
        $rel = $f.FullName.Substring($catDir.Length + 1)
        if ($rel -eq 'entry.json') { continue }
        if ($rel.StartsWith('app' + $sep)) { $dst = Join-Path $pcDir $rel.Substring(4); $isApp = $true }
        else                     { $dst = Join-Path $gameDir $rel;            $isApp = $false }
        $dp = Split-Path -Parent $dst
        if (-not (Test-Path $dp)) { New-Item -ItemType Directory -Force $dp | Out-Null }
        if (-not (Test-Path $dst)) {
            Copy-Item $f.FullName $dst
            if ($isApp) { $madeApp++ } else { $madeGame++ }
        }
    }
    if ($madeGame -or $madeApp) { Log ("materialised the tree from the catalog entry: {0} game file(s), {1} app file(s)" -f $madeGame, $madeApp) }
}
if (-not (Test-Path $gameDir)) { Fail-Stage "no game tree at $gameDir and the catalog entry could not make one" }
if (-not (Test-Path $pcDir))   { Fail-Stage "no app tree at $pcDir and the catalog entry could not make one" }

$entryJson = $null
try { $entryJson = Get-Content -Path $entry -Raw | ConvertFrom-Json }
catch { Fail-Stage "entry.json will not parse: $($_.Exception.Message)" }
$wantSha = ''
if ($entryJson.rom -and $entryJson.rom.sha1) { $wantSha = ([string]$entryJson.rom.sha1).ToLowerInvariant() }
if (-not $wantSha) { Fail-Stage "entry.json carries no rom.sha1" }

$romNote = ''
if ($rom) {
    if ($romSha -ne $wantSha) { Fail-Stage "sha1 $romSha does not match the catalog's $wantSha" }
    $need = $true
    if (Test-Path $baserom) { if ((Sha1OfFile $baserom) -eq $wantSha) { $need = $false } }
    if ($need) {
        [IO.File]::WriteAllBytes($baserom, $rom.Bytes)
        $romNote = "installed as baserom.z64 from $($rom.Member)"
    } else {
        $romNote = "baserom.z64 already carries it ($($rom.Member))"
    }
} else {
    if (-not (Test-Path $baserom)) { Fail-Stage "no ROM given and no $baserom in the tree" }
    $gotSha = Sha1OfFile $baserom
    if ($gotSha -ne $wantSha) { Fail-Stage "baserom.z64 sha1 $gotSha does not match the catalog's $wantSha" }
    $romNote = 'the tree already carries the cart'
}
$romBytes = (Get-Item $baserom).Length
Pass-Stage ("sha1 {0} matches catalog/{1}/entry.json; {2} bytes; {3}" -f $wantSha, $Game, $romBytes, $romNote)

# ========================================================== 2 BYTE-EXACT ELF =
Start-Stage 'BYTE-EXACT ELF'
$elf = Join-Path $gameDir "build\$Game.elf"
$elfHow = ''
if ($toolchain) {
    $elfHow = 'bundled toolchain'
    $buildElfPy = Join-Path $root 'recompilator\tools\build_elf.py'
    $elfArgs = '-I "' + $buildElfPy + '" ' + $Game + ' --root "' + $root + '" --toolchain "' + $toolchain + '"'
    $r = Invoke-Native $tcPython $elfArgs $root 'elf'
} else {
    $elfHow = 'docker stopgap'
    $mount = $root + ':/rb'
    $dockerArgs = 'run --rm --entrypoint sh -v "' + $mount + '" cv64-build -c "sh /rb/recompilator/build_elf.sh ' + $Game + '"'
    $r = Invoke-Native 'docker' $dockerArgs $root 'elf'
}
$verdict = ''
foreach ($line in ($r.Output -split "`n")) {
    if ($line.Contains('BYTE-EXACT: ELF-reconstructed ROM matches')) { $verdict = $line.Trim() }
}
if (-not $verdict) {
    $why = ''
    foreach ($line in ($r.Output -split "`n")) {
        if ($line -match 'FATAL|LINK FAILED|GAS-GIVEUP|MISMATCH|Traceback') { $why = $line.Trim(); break }
    }
    if (-not $why) { $why = "$elfHow exit $($r.ExitCode); no BYTE-EXACT line in the log" }
    Fail-Stage $why
}
if (-not (Test-Path $elf)) { Fail-Stage "byte-exact reported but no ELF at $elf" }
$elfMb = ((Get-Item $elf).Length / 1MB).ToString('F1', $inv)
Pass-Stage ("{0} | {1}.elf {2} MB | {3}" -f $verdict, $Game, $elfMb, $elfHow)

} else {

# ===================================== 1 RECOGNISED (the cart, not the catalog) =
# THE BLIND PATH. A release ships no catalog, so this is what actually runs on a user's machine:
# read the cartridge, say what it is, and build it. Nothing here knows any game.
Start-Stage 'RECOGNISED'
$b = $rom.Bytes
if ($b.Length -lt 0x1000) { Fail-Stage "the file is only $($b.Length) bytes - not an N64 cartridge image" }
if (-not ($b[0] -eq 0x80 -and $b[1] -eq 0x37 -and $b[2] -eq 0x12 -and $b[3] -eq 0x40)) {
    Fail-Stage ("not an N64 cartridge: magic 0x{0:X2}{1:X2}{2:X2}{3:X2} after byte-order normalisation" -f $b[0], $b[1], $b[2], $b[3])
}
$hdrEntry = ([uint32]$b[8] -shl 24) -bor ([uint32]$b[9] -shl 16) -bor ([uint32]$b[10] -shl 8) -bor [uint32]$b[11]
# THE TITLE IS NOT ALWAYS LATIN (Saikyou Habu Shougi (Japan), 2026-09-07). Casting each
# byte to a char is latin1 and turns a Shift-JIS title into mojibake, which then travels into the
# screen and the log. Same rule as recon.py / rom_identity.py: strict ASCII, then cp932, then latin1.
$hdrBytes = New-Object System.Collections.Generic.List[byte]
for ($i = 0x20; $i -lt 0x34; $i++) { if ($b[$i] -eq 0) { break }; [void]$hdrBytes.Add($b[$i]) }
$internal = ''
if ($hdrBytes.Count -gt 0) {
    $arr = $hdrBytes.ToArray()
    $isAscii = $true
    foreach ($x in $arr) { if ($x -gt 0x7F) { $isAscii = $false; break } }
    if ($isAscii) {
        $internal = [Text.Encoding]::ASCII.GetString($arr)
    } else {
        try { $internal = [Text.Encoding]::GetEncoding(932).GetString($arr) }
        catch { $internal = [Text.Encoding]::GetEncoding(28591).GetString($arr) }
    }
    $internal = $internal.Trim()
}
$serial = ''
for ($i = 0x3B; $i -lt 0x3F; $i++) { if ($b[$i] -gt 32) { $serial += [char]$b[$i] } }
Log ("blind cart: internal='{0}' serial={1} entry=0x{2:X8} size={3} sha1={4}" -f $internal, $serial, $hdrEntry, $b.Length, $romSha)
$shownName = $(if ($internal) { $internal } else { '(no internal name)' })
$shownSerial = $(if ($serial) { $serial } else { '----' })
$blindWhy = if ($Blind) { 'recipe set aside by request' } else { 'not in the catalog' }
Pass-Stage ($blindWhy + " - the cart says: '{0}' serial {1}, entry 0x{2:X8}, {3} bytes, sha1 {4}; bringing it up blind" -f $shownName, $shownSerial, $hdrEntry, $b.Length, $romSha)

# ============================== 2 BRING-UP / 3 BYTE-EXACT ELF / 4 SEGMENTATION =
# ONE child (tools/blind_bringup.py) does the whole bring-up, and the driver turns its phase lines
# into the stage table live, so the BUILD screen shows exactly where a cart is and exactly where a
# cart dies. THE PHASES ARE THE STAGES: a cart that cannot be rebuilt byte-for-byte from its own
# ELF fails at BYTE-EXACT ELF with the reason, and nothing half-built is ever reported as a build.
$blindPy = Join-Path $root 'recompilator\tools\blind_bringup.py'
if (-not (Test-Path $blindPy)) { Start-Stage 'BRING-UP'; Fail-Stage "no blind bring-up at $blindPy" }
$bArgs = $pyPre + '"' + $blindPy + '" --rom "' + $RomPath + '" --root "' + $root + '" --jobs ' + [string]([Math]::Max(4, $Jobs * 4))
if ($toolchain) { $bArgs += ' --toolchain "' + $toolchain + '"' }
Log ("--- RUN [bringup] {0} {1}   (cwd {2})" -f $pyExe, $bArgs, $root)

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $pyExe
$psi.Arguments = $bArgs
$psi.WorkingDirectory = $root
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$bp = [System.Diagnostics.Process]::Start($psi)
$bErrTask = $bp.StandardError.ReadToEndAsync()      # drained on a pool thread: never a full-pipe stall

Start-Stage 'BRING-UP'
$blindGame = ''
$blindTitle = ''
$blindFail = ''
$openStage = 'BRING-UP'
$lastPhaseLine = ''
$elfVerdict = ''
while ($true) {
    $line = $bp.StandardOutput.ReadLine()
    if ($null -eq $line) { break }
    Log ("bringup> " + $line)
    if ($line.StartsWith('[blind] ')) {
        # drop the phase word: the stage row already names the phase
        $lastPhaseLine = ($line.Substring(8).Trim() -replace '^\S+\s+', '')
    }
    if ($line -match '^\[blind\] BYTE-EXACT\s+BYTE-EXACT:') { $elfVerdict = $lastPhaseLine }
    if ($line -match '^\[blind\] TREE\s+authored') {
        Pass-Stage $lastPhaseLine
        $openStage = ''
    }
    elseif ($line -match '^\[blind\] BYTE-EXACT\s+rebuilding') {
        Start-Stage 'BYTE-EXACT ELF'; $openStage = 'BYTE-EXACT ELF'
    }
    elseif ($line -match '^\[blind\] BYTE-EXACT\s+all-functions') {
        Pass-Stage $(if ($elfVerdict) { $elfVerdict } else { $lastPhaseLine })
        $openStage = ''
    }
    elseif ($line -match '^\[blind\] SEGMENT\s+code-vs-data') {
        Start-Stage 'SEGMENTATION'; $openStage = 'SEGMENTATION'
    }
    elseif ($line -match '^BRINGUP OK ') {
        $parts = $line.Substring(11).Trim()
        $sp = $parts.IndexOf(' ')
        if ($sp -gt 0) { $blindGame = $parts.Substring(0, $sp); $blindTitle = $parts.Substring($sp + 1) }
        else { $blindGame = $parts; $blindTitle = $parts }
    }
    elseif ($line -match '^BRINGUP FAIL ') {
        $blindFail = $line.Substring(13).Trim()
    }
}
$bp.WaitForExit()
$bErr = ''
try { $bErr = $bErrTask.Result } catch { }
if ($bErr) { Log ("bringup-stderr> " + $bErr) }

if ($blindFail) {
    # The phase the child names decides WHICH stage carries the failure, so 'it did not reach
    # byte-exactness' is never dressed up as something else.
    $phase = ($blindFail -split '\s+', 2)[0]
    $why   = ($blindFail -split '\s+', 2)[1]
    $want  = 'BRING-UP'
    if ($phase -eq 'BYTE-EXACT')   { $want = 'BYTE-EXACT ELF' }
    if ($phase -eq 'SEGMENTATION') { $want = 'SEGMENTATION' }
    if ($openStage -ne $want) {
        if ($openStage) { Fail-Stage ("{0}: {1}" -f $phase, $why) }
        Start-Stage $want
    }
    Fail-Stage $why
}
if (-not $blindGame) {
    if (-not $openStage) { Start-Stage 'BRING-UP' }
    Fail-Stage ("the bring-up ended without a verdict (exit {0}); last line: {1}" -f $bp.ExitCode, $lastPhaseLine)
}
if ($openStage -eq 'SEGMENTATION') { Pass-Stage $lastPhaseLine }

Set-GamePaths $blindGame
$elf = Join-Path $gameDir "build\$Game.elf"
if (-not (Test-Path $elf)) {
    Start-Stage 'BRING-UP'; Fail-Stage "the bring-up reported OK but there is no ELF at $elf"
}

# The entry the program authored for ITSELF, in the user's own catalog folder, so the library lists
# the game from here on. It is marked as locally authored: nothing about this game was shipped.
$expArgs = $pyPre + '"' + (Join-Path $root 'recompilator\tools\export_catalog_entry.py') + '" ' + $Game +
           ' --root "' + $root + '" --authored --force'
$rEnt = Invoke-Native $pyExe $expArgs $root 'catalog'
if (Test-Path $entry) {
    Log ("authored catalog entry: {0}" -f $entry)
} else {
    Log ("WARNING: no catalog entry was written ({0})" -f (OneLine $rEnt.Output))
}

}

# ==================================================== 3 SYMBOLS + RECOMPILER =
Start-Stage 'SYMBOLS + RECOMPILER'
$toml = Join-Path $gameDir "$Game.toml"
$r = Invoke-Native $pyExe ($pyPre + '"' + (Join-Path $root 'recompilator\gen_toml.py') + '" ' + $Game) $root 'gen_toml'
if (-not (Test-Path $toml)) { Fail-Stage "gen_toml.py produced no $Game.toml (exit $($r.ExitCode))" }
$symCount = 0
$stubCount = 0
foreach ($line in ($r.Output -split "`n")) {
    if ($line -match '(\d+)\s+FUNC symbols') { $symCount = [int]$Matches[1] }
    if ($line -match '(\d+)\s+stubs')        { $stubCount = [int]$Matches[1] }
}

# N64Recomp never cleans its output directory: a stale funcs_*.c from a previous emission would be
# compiled into the library. Move the whole directory aside, and put it back if the emit fails.
$rf   = Join-Path $pcDir 'RecompiledFuncs'
$prev = Join-Path $pcDir 'RecompiledFuncs.prev'
if (Test-Path $rf) {
    if (Test-Path $prev) { [IO.Directory]::Delete($prev, $true) }
    Rename-Item -Path $rf -NewName 'RecompiledFuncs.prev'
}
# TELL THE RECOMPILER WHAT THIS HOST ACTUALLY IMPLEMENTS. N64Recomp skips translating the libultra
# functions on its ignored list, but that list is not the same thing as the set the host provides -
# it carries 201 names nothing implements. When a cart REACHES one of those (Super Mario 64 falls
# straight into __osTimerServicesInit, and tail-jumps to __osDequeueThread), the recompiler now
# translates it from the cart instead of emitting a call to a function that exists nowhere. It needs
# this file to tell the two apart; without it, it falls back to its own shorter built-in list and
# re-translates three functions the host already has, which the linker rejects as duplicates.
$env:RECOMPILATOR_HOST_ABI = Join-Path $root 'recompilator\launcher\recomp_host_abi.txt'
if (-not (Test-Path $env:RECOMPILATOR_HOST_ABI)) {
    Log ("no host ABI at {0} - the recompiler will use its built-in list" -f $env:RECOMPILATOR_HOST_ABI)
    $env:RECOMPILATOR_HOST_ABI = $null
}
if (-not (Test-Path $n64recomp)) { Fail-Stage "no N64Recomp.exe at $n64recomp" }
# A TOOLCHAIN COPY OLDER THAN THIS MACHINE'S OWN ENGINE BUILD IS A STALE ARTIFACT, AND THE BUILD
# REFUSES IT. On a user's machine there is no engine build under the root and this is a no-op; on
# the lab tree it is the difference between measuring today's recompiler and yesterday's (2026-09-08).
$engineBuilds = Get-ChildItem -Path (Join-Path $root 'engine\runtime\N64Recomp') -Directory -Filter 'build*' -ErrorAction SilentlyContinue
foreach ($eb in @($engineBuilds)) {
    $own = Join-Path $eb.FullName 'Release\N64Recomp.exe'
    if ((Test-Path $own) -and ($own -ne $n64recomp) -and ((Get-Item $own).LastWriteTime -gt (Get-Item $n64recomp).LastWriteTime.AddMinutes(1))) {
        Fail-Stage ("STALE RECOMPILER: {0} is dated {1} but this machine's engine build {2} is dated {3} - copy the newer one over it and build again" -f $n64recomp, (Get-Item $n64recomp).LastWriteTime.ToString('MM-dd HH:mm'), $own, (Get-Item $own).LastWriteTime.ToString('MM-dd HH:mm'))
    }
}
$r = Invoke-Native $n64recomp ('"' + $Game + '.toml"') $gameDir 'n64recomp'
$funcsH = Join-Path $rf 'funcs.h'
if (-not (Test-Path $funcsH)) {
    if (Test-Path $prev) {
        if (Test-Path $rf) { [IO.Directory]::Delete($rf, $true) }
        Rename-Item -Path $prev -NewName 'RecompiledFuncs'
    }
    $why = ''
    foreach ($line in ($r.Output -split "`n")) {
        if ($line -match 'Error|error:|Failed|failed to') { $why = $line.Trim(); break }
    }
    if (-not $why) { $why = "N64Recomp exit $($r.ExitCode); no RecompiledFuncs/funcs.h" }
    Fail-Stage $why
}
$funcCount = 0
foreach ($line in ($r.Output -split "`n")) {
    if ($line -match 'Function count:\s*(\d+)') { $funcCount = [int]$Matches[1] }
}
$cFiles = (Get-ChildItem -Path $rf -Filter 'funcs_*.c' -ErrorAction SilentlyContinue | Measure-Object).Count
Pass-Stage ("{0} FUNC symbols sized, {1} stubs; N64Recomp function count {2}; emitted funcs.h + {3} funcs_*.c; N64Recomp.exe {4}" -f $symCount, $stubCount, $funcCount, $cFiles, $n64recompStamp)

# ==================== (conditional) NI SECTION DATA - keyed on the FILE, never on a game name ====
$niTool = ''
foreach ($cand in @((Join-Path $catalog 'tools\gen_ni_data.py'), (Join-Path $catalog 'app\tools\gen_ni_data.py'))) {
    if (Test-Path $cand) { $niTool = $cand; break }
}
if ($niTool) {
    Start-Stage 'NI SECTION DATA'
    $niOut = Join-Path $pcDir 'src\ni_section_data.c'
    $inl   = Join-Path $rf 'recomp_overlays.inl'
    $niArgs = $pyPre + '"' + $niTool + '" "' + $elf + '" "' + $niOut + '"'
    if (Test-Path $inl) { $niArgs += ' "' + $inl + '"' }
    $r = Invoke-Native $pyExe $niArgs $root 'gen_ni_data'
    if (-not (Test-Path $niOut)) { Fail-Stage "gen_ni_data.py produced no ni_section_data.c (exit $($r.ExitCode))" }
    $niMb = ((Get-Item $niOut).Length / 1MB).ToString('F1', $inv)
    Pass-Stage ("{0} -> ni_section_data.c, {1} MB" -f (Split-Path -Leaf $niTool), $niMb)
}

# =========================================================== 4 RSP MICROCODE =
Start-Stage 'RSP MICROCODE'
# THIS STAGE IS REAL NOW (2026-09-07). The recompiled microcode is derived from the cartridge and can
# never ship, so a user's machine must regenerate it - and until today nothing in the pipeline ran
# RSPRecomp at all: every tree's rsp/*.cpp was made once, by hand, and this stage said pass-through.
# The first catalog build on a clean machine got all the way to the link and failed on one undefined
# symbol, aspMain. A ucode toml (addresses and names, shippable) is the input; the .cpp it writes is
# generated here and never leaves the machine.
$rspDir = Join-Path $pcDir 'rsp'
$ucodeTomls = @()
# A recipe keeps its microcode configs in ucode/ (export_catalog_entry puts them there), and a
# tree may also carry one at its root. Both are scanned: looking only at the root silently missed
# AeroGauge's graphics microcode and the link failed on `undefined symbol: f3dexnon123`.
# A config's paths are relative to the directory it was AUTHORED against, and the two places carry
# different conventions: one in ucode/ came from a catalog entry and is written against the app tree
# ("../<game>/baserom.z64", "RecompiledFuncs/x.cpp"), while one at the tree root is written against
# the tree. Running both from the same directory resolved one of them wrongly and RSPRecomp wrote
# nothing (AeroGauge's f3dexnon123, 2026-09-07). So each config carries the directory to run it in.
foreach ($pair in @(@{ Dir = $gameDir; Work = $gameDir },
                    @{ Dir = (Join-Path $gameDir 'ucode'); Work = $pcDir })) {
    if (-not (Test-Path $pair.Dir)) { continue }
    foreach ($f in (Get-ChildItem -Path $pair.Dir -Filter '*.toml' -File -ErrorAction SilentlyContinue)) {
        $head = Get-Content -Path $f.FullName -Raw -ErrorAction SilentlyContinue
        if ($head -match 'output_function_name' -and $head -match 'text_offset') {
            $ucodeTomls += [pscustomobject]@{ File = $f; Work = $pair.Work }
        }
    }
}
$rspNote = ''
if ($ucodeTomls.Count -gt 0) {
    $rspRecomp = ''
    foreach ($cand in @((Join-Path $toolchain 'n64recomp/RSPRecomp.exe'),
                        (Join-Path $root 'engine/runtime/N64Recomp/build/Release/RSPRecomp.exe'))) {
        if ($cand -and (Test-Path $cand)) { $rspRecomp = $cand; break }
    }
    if (-not $rspRecomp) { Fail-Stage ('{0} ucode config(s) to build and no RSPRecomp.exe available' -f $ucodeTomls.Count) }
    if (-not (Test-Path $rspDir)) { New-Item -ItemType Directory -Force $rspDir | Out-Null }
    $names = @()
    foreach ($u in $ucodeTomls) {
        $f = $u.File
        $work = $u.Work
        # JUDGE BY THE ARTIFACT, NEVER THE EXIT CODE. Start-Process -PassThru returns ExitCode as
        # $null often enough to be useless, and it did exactly that here: RSPRecomp wrote its 127 KB
        # of recompiled microcode and the stage still called it a failure (2026-09-07).
        $outRel = ''
        foreach ($ln in (Get-Content -Path $f.FullName)) {
            if ($ln -match '^\s*output_file_path\s*=\s*"([^"]+)"') { $outRel = $Matches[1]; break }
        }
        $outPath = if ($outRel) { [IO.Path]::GetFullPath((Join-Path $work $outRel)) } else { '' }
        $before = if ($outPath -and (Test-Path $outPath)) { (Get-Item $outPath).LastWriteTimeUtc } else { [datetime]::MinValue }
        # RSPRecomp RESOLVES THE CONFIG'S PATHS AGAINST THE CONFIG'S OWN DIRECTORY, not the
        # working directory. A shipped config in ucode/ was authored against the app tree, so its
        # "../<game>/baserom.z64" pointed into thin air from there and RSPRecomp said only
        # "Failed to open rom file" (AeroGauge, 2026-09-07). Rewrite both paths to absolute, in a
        # copy, which is correct under either rule and leaves the shipped config untouched.
        # NORMALISE ONLY THE DEFAULT CART PATH. A config may deliberately name a byte source
        # that is NOT the cartridge: a cart which stores its audio microcode COMPRESSED has no
        # copy of it in the ROM at all, so find_ucode locates it in a memory image beside the
        # tree and records that file. Rewriting every rom_file_path to baserom.z64 would point
        # RSPRecomp at the same offset in the WRONG file and emit garbage microcode - worse than
        # the silence it replaced. Keep any source that exists beside the config.
        $absRom = (Join-Path $gameDir 'baserom.z64').Replace([char]92, [char]47)
        foreach ($ln in (Get-Content -Path $f.FullName)) {
            if ($ln -match '^\s*rom_file_path\s*=\s*"([^"]+)"') {
                $named = $Matches[1]
                if ([IO.Path]::GetFileName($named) -ne 'baserom.z64') {
                    # AS WRITTEN, relative to the config's directory - the rule RSPRecomp itself
                    # applies. find_ucode records the source relative to its toml (build/x.bin is
                    # legal); taking only the file name here dropped the directory, and a source
                    # that could not be found fell back SILENTLY to the cartridge at the image's
                    # offset - garbage microcode. Now: resolve as written; missing = refuse.
                    $cand2 = $named
                    if (-not [IO.Path]::IsPathRooted($cand2)) { $cand2 = [IO.Path]::GetFullPath((Join-Path $f.DirectoryName $named)) }
                    if (Test-Path $cand2) { $absRom = $cand2.Replace([char]92, [char]47) }
                    else { Fail-Stage ("{0} names '{1}' as its byte source and nothing is at {2} - refusing to read the cartridge at that offset instead" -f $f.Name, $named, $cand2) }
                }
                break
            }
        }
        # AND SEND IT TO rsp/. That folder is what the module build compiles microcode from;
        # a config authored to write into RecompiledFuncs/ produced a .cpp nothing ever
        # compiled, so the link still failed on the symbol it had just generated.
        $outPath = Join-Path $rspDir ($f.BaseName + '.cpp')
        $absOut = $outPath.Replace([char]92, [char]47)
        $normDir = Join-Path $gameDir '_ucode_run'
        if (-not (Test-Path $normDir)) { New-Item -ItemType Directory -Force $normDir | Out-Null }
        $normToml = Join-Path $normDir $f.Name
        $body = Get-Content -Path $f.FullName -Raw
        $body = [regex]::Replace($body, '(?m)^\s*rom_file_path\s*=.*$',       ('rom_file_path = "'   + $absRom + '"'))
        $body = [regex]::Replace($body, '(?m)^\s*output_file_path\s*=.*$',    ('output_file_path = "' + $absOut + '"'))
        [System.IO.File]::WriteAllText($normToml, $body, (New-Object System.Text.UTF8Encoding($false)))
        New-Item -ItemType Directory -Force (Split-Path $outPath -Parent) | Out-Null
        $r = Invoke-Native $rspRecomp ('"' + $normToml + '"') $work ('rsp_' + $f.BaseName)
        if (-not $outPath) { Fail-Stage ('{0} names no output_file_path' -f $f.Name) }
        if (-not (Test-Path $outPath)) { Fail-Stage ('RSPRecomp wrote nothing for {0} (expected {1})' -f $f.Name, $outPath) }
        if ((Get-Item $outPath).LastWriteTimeUtc -le $before) { Fail-Stage ('RSPRecomp left {0} untouched' -f $outPath) }
        $names += $f.BaseName
    }
    # A cart can need BOTH: a shipped graphics config AND its own audio microcode, which no
    # recipe carries because it is found in the cartridge. If nothing above produced aspMain,
    # find it now - the same call the blind path makes.
    if (-not (Test-Path (Join-Path $rspDir 'aspMain.cpp'))) {
        $rspx2 = ''
        foreach ($cand in @((Join-Path $toolchain 'n64recomp/RSPRecomp.exe'),
                            (Join-Path $root 'engine/runtime/N64Recomp/build/Release/RSPRecomp.exe'))) {
            if ($cand -and (Test-Path $cand)) { $rspx2 = $cand; break }
        }
        $py2 = if ($tcPython) { $tcPython } else { $pyExe }
        $e2 = Invoke-Native $py2 (@(
            ('"' + (Join-Path $PSScriptRoot 'find_ucode.py') + '"'),
            '--rom',  ('"' + (Join-Path $gameDir 'baserom.z64') + '"'),
            '--tree', ('"' + $gameDir + '"'),
            '--app',  ('"' + $pcDir + '"'),
            '--rspx', ('"' + $rspx2 + '"'),
            '--emit') -join ' ') $gameDir 'rsp_audio'
        $l2 = ($e2.Output -split "`n" | Where-Object { $_.Trim() -and $_ -notmatch '^\[ucode\]' } | Select-Object -Last 1)
        if ($l2) { $names += 'aspMain' }
    }
    $rspNote = ('{0} microcode(s) recompiled here from the cart: {1}' -f $names.Count, ($names -join ', '))
} else {
    # A PRESENT .cpp IS NOT A BUILT MICROCODE. When find_ucode cannot locate the microcode it
    # writes a small no-op stub that says so and returns Broke - the game builds and plays silent
    # rather than failing to link. Counting that stub as an 'emitted source already present' made
    # the failure STICKY: once a cart got the stub, every later build skipped this stage and said
    # OK, so no fix downstream could ever reach it. Six carts in the 09-08 playtest were silent
    # for exactly this reason (Killer Instinct Gold, SOTE, Turok, StarCraft 64, Zelda JP), and
    # rebuilding them changed nothing. Judge the CONTENT, not the presence.
    $have = 0
    if (Test-Path $rspDir) {
        foreach ($c in (Get-ChildItem -Path $rspDir -Filter '*.cpp' -File -ErrorAction SilentlyContinue)) {
            $body0 = Get-Content -Path $c.FullName -Raw -ErrorAction SilentlyContinue
            if ($body0 -and ($body0 -notmatch 'No audio microcode was recognised')) { $have++ }
        }
    }
    if ($have) { $rspNote = ('no ucode config in the tree; {0} emitted source(s) already present' -f $have) }
    else {
        # NO CONFIG AND NO SOURCE: FIND IT IN THE CART, exactly as the blind path does.
        # Until 2026-09-07 every tree was handed one shared recompiled microcode; that file was
        # cartridge-derived and stopped shipping, and the blind path learned to find each cart's
        # own. This path did not, so a recipe carrying no ucode config linked against nothing and
        # died on `undefined symbol: aspMain` (Ocarina of Time, AeroGauge). One implementation,
        # both callers: tools/find_ucode.py --emit.
        $rspx = ''
        foreach ($cand in @((Join-Path $toolchain 'n64recomp/RSPRecomp.exe'),
                            (Join-Path $root 'engine/runtime/N64Recomp/build/Release/RSPRecomp.exe'))) {
            if ($cand -and (Test-Path $cand)) { $rspx = $cand; break }
        }
        $ucodePy = if ($tcPython) { $tcPython } else { $pyExe }
        $emit = Invoke-Native $ucodePy (@(
            ('"' + (Join-Path $PSScriptRoot 'find_ucode.py') + '"'),
            '--rom',  ('"' + (Join-Path $gameDir 'baserom.z64') + '"'),
            '--tree', ('"' + $gameDir + '"'),
            '--app',  ('"' + $pcDir + '"'),
            '--rspx', ('"' + $rspx + '"'),
            '--emit') -join ' ') $gameDir 'rsp_find_ucode'
        $line = ($emit.Output -split "`n" | Where-Object { $_.Trim() -and $_ -notmatch '^\[ucode\]' } | Select-Object -Last 1)
        if (-not $line) { $line = 'audio microcode step produced no report' }
        $rspNote = $line.Trim()
    }
}
Pass-Stage $rspNote

# ================================================================= 5 COMPILE =
Start-Stage 'COMPILE'
# THE BUNDLED-CLANG PATH (2026-09-06, UI step 3). When the toolchain beside the program carries a
# clang (llvm-mingw), COMPILE builds the GAME MODULE <game>pc/module/<game>.dll with it -- no cmake,
# no MSBuild, no Visual Studio, no Windows SDK -- and that dll is what the RESULT names and what the
# launcher's PLAY loads. The MSBuild path below stays as the fallback for a machine that has Visual
# Studio and no bundled clang, and it is still the ONLY way <game>pc.exe gets built, which is why it
# is kept rather than replaced: the sweep runs on those exes.
$artifactItem = $null
$artifactHow = ''
$clangExe = ''
if ($toolchain) {
    $c = Join-Path $toolchain ('clang' + [char]92 + 'bin' + [char]92 + 'clang.exe')
    if (Test-Path $c) { $clangExe = $c }
}
if ($clangExe) {
    $moduleScript = Join-Path $PSScriptRoot 'build_module.ps1'
    if (-not (Test-Path $moduleScript)) { Fail-Stage "bundled clang is present but tools/build_module.ps1 is missing" }
    Log ("bundled clang: {0}" -f $clangExe)
    # The module's FACE is generated, never hand-written (2026-09-07): scaffold_app.py --module
    # renders <game>pc/module/module_main.cpp from this tree's own src/main.cpp, src/rsp.cpp,
    # src/patches/ and RecompiledFuncs* sets, cross-checked against catalog/<game>/entry.json. It
    # runs here, immediately before the module build, so the face can never drift from the tree it
    # describes. It refuses loudly rather than emitting a wrong face.
    $faceArgs = $pyPre + '"' + (Join-Path $root 'recompilator\scaffold_app.py') + '" --game ' + $Game + ' --module'
    $rFace = Invoke-Native $pyExe $faceArgs $root 'modface'
    $face = Join-Path $pcDir ('module' + [char]92 + 'module_main.cpp')
    # Judged on evidence, not on an exit code (the -PassThru trap): the file must exist AND the
    # child must have said it rendered it -- otherwise a STALE face from a previous build would
    # sail through a failed render.
    if ((-not (Test-Path $face)) -or (-not ($rFace.Output -match '\[module\] rendered'))) {
        $why = ''
        foreach ($line in ($rFace.Output -split "`n")) { if ($line -match '^ERROR:') { $why = $line.Trim(); break } }
        if (-not $why) { $why = "scaffold_app.py --module produced no module/module_main.cpp" }
        Fail-Stage $why
    }
    Log ("module face: {0}" -f $face)
    $modT0 = Get-Date
    Start-Sleep -Milliseconds 1100          # the dll's mtime must be strictly after this mark
    $modArgs = '-NoProfile -ExecutionPolicy Bypass -File "' + $moduleScript + '" ' + $Game +
               ' -Jobs ' + [string]([Math]::Max(2, $Jobs * 4)) + ' -Toolchain "' + $toolchain + '"'
    $r = Invoke-Native 'powershell.exe' $modArgs $root 'module'
    $dll = Join-Path $pcDir ('module' + [char]92 + $Game + '.dll')
    # Judged on EVIDENCE, not on an exit code: PowerShell's Start-Process -PassThru hands back a
    # Process whose ExitCode reads as $null often enough that trusting it made this stage report
    # FAIL over a dll it had just watched being linked. The dll must exist, be newer than the mark
    # above, and the child must have said so.
    $dllOk = (Test-Path $dll)
    if ($dllOk) { $dllOk = ((Get-Item $dll).LastWriteTime -gt $modT0) }
    if ($dllOk) { $dllOk = ($r.Output -match 'MODULE OK') }
    if (-not $dllOk) {
        $why = ''
        foreach ($line in ($r.Output -split "`n")) {
            if ($line -match 'error:|LINK FAILED|COMPILE FAILED|no bundled clang|no game tree') { $why = $line.Trim(); break }
        }
        if (-not $why) { $why = "build_module.ps1 produced no fresh $Game.dll" }
        Fail-Stage $why
    }
    $artifactItem = Get-Item $dll
    $artifactHow = 'bundled clang'
    Pass-Stage ("{0} {1} bytes, linked {2} (bundled clang, no Visual Studio)" -f
                $artifactItem.Name, $artifactItem.Length, $artifactItem.LastWriteTime.ToString('HH:mm:ss'))
}

if (-not $artifactItem) {
    $candidates = @()
    if ($BuildDir) { $candidates += $BuildDir }
    if ($env:RECOMPILATOR_BUILD_DIR) { $candidates += $env:RECOMPILATOR_BUILD_DIR }
    $candidates += (Join-Path $root '_masterbuild\build')
    $candidates += (Join-Path $root 'sweep\build')
    $candidates += (Join-Path $root 'sweep\build-corpus')
    $candidates += (Join-Path $root 'recompilator\launcher\build\master')

    $withProject = @()
    foreach ($c in $candidates) {
        if (-not $c) { continue }
        if (-not (Test-Path $c)) { continue }
        foreach ($sub in @("app_$Game", "${Game}pc")) {
            $vc = Join-Path $c (Join-Path $sub "${Game}pc.vcxproj")
            if (Test-Path $vc) { $withProject += $c; break }
        }
    }
    if ($withProject.Count -eq 0) {
        Fail-Stage ("no configured master build dir carries the target ${Game}pc; pass -BuildDir, or configure one with -DN64PC_GAMES=""$Game""")
    }
    # Prefer a WARM dir (one that has already linked this exe) so COMPILE is a relink, not a cold build.
    $chosen = $withProject[0]
    foreach ($c in $withProject) {
        $hit = Get-ChildItem -Path $c -Filter "${Game}pc.exe" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($hit) { $chosen = $c; break }
    }
    Log ("build dir: {0}  (candidates with the target: {1})" -f $chosen, ($withProject -join ', '))

    $cmake = 'cmake'
    $cache = Join-Path $chosen 'CMakeCache.txt'
    if (Test-Path $cache) {
        $cl = Select-String -Path $cache -Pattern '^CMAKE_COMMAND:INTERNAL=' | Select-Object -First 1
        if ($cl) { $cmake = ($cl.Line -split '=', 2)[1] }
    }
    Log ("cmake: {0}" -f $cmake)

    $compileT0 = Get-Date
    Start-Sleep -Milliseconds 1100          # the exe's mtime must be strictly after this mark
    if (Test-Path $canonExe) { [IO.File]::Delete($canonExe) }
    $inTree = Get-ChildItem -Path $chosen -Filter "${Game}pc.exe" -Recurse -ErrorAction SilentlyContinue
    foreach ($f in $inTree) { [IO.File]::Delete($f.FullName) }

    # /nodeReuse:false as well as /m:<jobs>: an idle MSBuild worker node left behind on the desktop
    # for fifteen minutes after every build is not neighbourly, and it is what made the first hand run
    # of this driver report a 17-minute COMPILE for a 3-minute build.
    $buildArgs = '--build "' + $chosen + '" --config Release --target "' + $Game + 'pc" -- /m:' + $Jobs + ' /nodeReuse:false'
    $r = Invoke-Native $cmake $buildArgs $root 'compile'

    $exe = ''
    if (Test-Path $canonExe) {
        $exe = $canonExe
    } else {
        # A master that does not redirect its runtime output (the sweep master) leaves the exe in its
        # own tree; put it where every tool in this project looks, with the DLLs its POST_BUILD copied.
        $hit = Get-ChildItem -Path $chosen -Filter "${Game}pc.exe" -Recurse -ErrorAction SilentlyContinue |
               Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($hit) {
            $dest = Split-Path -Parent $canonExe
            if (-not (Test-Path $dest)) { New-Item -ItemType Directory -Path $dest -Force | Out-Null }
            Copy-Item $hit.FullName $canonExe -Force
            foreach ($dll in @('SDL2.dll', 'dxcompiler.dll', 'dxil.dll')) {
                $src = Join-Path $hit.DirectoryName $dll
                if (Test-Path $src) { Copy-Item $src (Join-Path $dest $dll) -Force }
            }
            Log ("copied {0} -> {1}" -f $hit.FullName, $canonExe)
            $exe = $canonExe
        }
    }
    if (-not $exe -or -not (Test-Path $exe)) {
        $why = ''
        foreach ($line in ($r.Output -split "`n")) {
            if ($line -match 'error C\d|error LNK|fatal error|error MSB') { $why = $line.Trim(); break }
        }
        if (-not $why) { $why = "cmake exit $($r.ExitCode); no ${Game}pc.exe produced" }
        Fail-Stage $why
    }
    $exeItem = Get-Item $exe
    if ($exeItem.LastWriteTime -le $compileT0) {
        Fail-Stage ("{0}pc.exe was not relinked (mtime {1} is not after the stage start)" -f $Game, $exeItem.LastWriteTime.ToString('HH:mm:ss'))
    }
    # Name the build dir by its last two segments: "build" alone does not say WHICH master was used.
    $chosenShort = Split-Path -Leaf $chosen
    $chosenParent = Split-Path -Parent $chosen
    if ($chosenParent) { $chosenShort = (Split-Path -Leaf $chosenParent) + '\' + $chosenShort }
    Pass-Stage ("{0} {1} bytes, linked {2} (build dir {3})" -f $exeItem.Name, $exeItem.Length, $exeItem.LastWriteTime.ToString('HH:mm:ss'), $chosenShort)
    $artifactItem = $exeItem
    $artifactHow = 'MSBuild'
}

# ================================================================== 6 RESULT =
Start-Stage 'RESULT'
$total = ((Get-Date) - $script:runT0).TotalSeconds.ToString('F1', $inv)
# SAY HOW MUCH OF THE CART WAS ACTUALLY RECOMPILED, ON THE LINE THAT SAYS "ready to play".
# The rule since 2026-08-29: CHECK THIS UP FRONT instead of finding out after hours on every
# game. The tool that
# answers it (tools/recomp_coverage.py) has existed since that day and the pipeline never called it,
# so a cart whose code is compressed - Turok 1 - reported a clean success with a 97 KB module and a
# black screen. Coverage is static and costs milliseconds. It NEVER fails the build: a low number is
# a fact about the cartridge, not an error, and the user still gets whatever was built.
$covLine = ''
try {
    $covTool = Join-Path $PSScriptRoot 'recomp_coverage.py'
    if (Test-Path $covTool) {
        $rc = Invoke-Native $pyExe ($pyPre + '"' + $covTool + '" --blind "' + $gameDir + '"') $root 'coverage'
        foreach ($ln in ($rc.Output -split "`n")) {
            if ($ln -match '^BLIND-COVERAGE ') { $covLine = $ln.Trim(); break }
        }
    }
} catch { $covLine = '' }
if ($covLine) { Log $covLine }
Pass-Stage ("{0} ready to play, {1} bytes, {2} s total ({3}){4}" -f $artifactItem.FullName, $artifactItem.Length, $total, $artifactHow, $(if ($covLine) { ' | ' + ($covLine -replace '^BLIND-COVERAGE ', '') } else { '' }))
Emit ("RESULT OK {0} {1} {2}" -f $artifactItem.FullName, $artifactItem.Length, $total)
Log ("DONE {0}  total {1} s" -f (Get-Date).ToString('HH:mm:ss'), $total)
exit 0
