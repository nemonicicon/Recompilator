# build_module.ps1 -- STAGE 5 WITHOUT VISUAL STUDIO: build <game>.dll, the GAME MODULE.
#
# The product is ONE program. Recompilator.exe is the host (MSVC: window, RT64, SDL audio, SDL
# input, catalog, build driver). A game is a DLL built HERE by the bundled llvm-mingw clang from
# the emitted C, the recompiled RSP microcode and the game's own module face -- and nothing else.
# The two talk across the pure-C boundary of recompilator/include/recomp_module.h.
#
# NO cmake, NO MSBuild, NO Visual Studio, NO Windows SDK. The only tools are
# <toolchain>/clang/bin/{clang.exe, clang++.exe, llvm-dlltool.exe}.
#
# Linking shape: OPTION A of toolchain_20260906.md 4.3 -- an import library made by llvm-dlltool
# from a .def of the host's exported C symbols (recompilator/launcher/recomp_host_abi.txt, itself
# derived by tools/make_host_abi.ps1 from the built engine libraries). The exporting module is the
# host EXE rather than a separate recomp_host.dll, because splitting librecomp/ultramodern/rt64
# into a shared library would mean dllexport-annotating a C++ engine -- a change out of all
# proportion to the problem. The Windows loader resolves an import whose DLL name is an already
# loaded EXE, so this costs only the host's file name, which this script reads rather than assumes.
#
# NO PER-GAME CODE. Every path below is a glob or a Test-Path; nothing is keyed to a game name.
#
# Usage:
#   powershell -NoProfile -ExecutionPolicy Bypass -File recompilator\tools\build_module.ps1 <game>
#             [-Jobs 8] [-HostExe <path to recompilator.exe>] [-Toolchain <dir>]

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Game,
    [int]$Jobs = 8,
    [int]$CapMinutes = 15,     # one translation unit past this is killed and the build FAILS, saying so
    [string]$HostExe = "",
    [string]$Toolchain = ""
)

$ErrorActionPreference = "Stop"

function Find-Root {
    $d = Split-Path -Parent $PSCommandPath
    while ($d -and -not (Test-Path (Join-Path $d "engine\runtime\librecomp"))) {
        $p = Split-Path -Parent $d
        if ($p -eq $d) { return "" }
        $d = $p
    }
    return $d
}

$root = Find-Root
if (-not $root) { Write-Error "N64PC root not found"; exit 1 }

# ---- toolchain -------------------------------------------------------------------------------
if (-not $Toolchain) { $Toolchain = $env:RECOMPILATOR_TOOLCHAIN }
if (-not $Toolchain) {
    foreach ($c in @((Join-Path $root "_toolchain"), (Join-Path $root "toolchain"))) {
        if (Test-Path (Join-Path $c "clang\bin\clang.exe")) { $Toolchain = $c; break }
    }
}
if (-not $Toolchain -or -not (Test-Path (Join-Path $Toolchain "clang\bin\clang.exe"))) {
    Write-Error "no bundled clang: looked for <toolchain>\clang\bin\clang.exe"
    exit 2
}
$clang    = Join-Path $Toolchain "clang\bin\clang.exe"
$clangxx  = Join-Path $Toolchain "clang\bin\clang++.exe"
$dlltool  = Join-Path $Toolchain "clang\bin\llvm-dlltool.exe"
foreach ($t in @($clangxx, $dlltool)) {
    if (-not (Test-Path $t)) { Write-Error "missing tool: $t"; exit 2 }
}

# ---- the tree --------------------------------------------------------------------------------
# A game tree is <root>/archive/<game>pc now; trees made before that are still at
# <root>/<game>pc and must keep building where they are (2026-09-07).
$tree = Join-Path $root ("{0}pc" -f $Game)
if (-not (Test-Path (Join-Path $tree "CMakeLists.txt"))) {
    $inArchive = Join-Path (Join-Path $root "archive") ("{0}pc" -f $Game)
    if (Test-Path (Join-Path $inArchive "CMakeLists.txt")) { $tree = $inArchive }
}
if (-not (Test-Path $tree)) { Write-Error "no game tree at $tree"; exit 3 }
$moduleDir = Join-Path $tree "module"
$objDir    = Join-Path $moduleDir "obj"
New-Item -ItemType Directory -Force -Path $objDir | Out-Null
# A stale object or a stale compiler log from a previous run is exactly the class of artifact that
# makes a build lie about itself, so the object directory starts empty every time.
# ...but a file we cannot delete must not END THE BUILD. Windows keeps a handle open briefly after
# the writing process exits - build_module itself redirects each compiler's stdout/stderr into this
# directory - so a locked .o or .log here is a timing artifact, not a fault, and every one of these
# files is about to be overwritten anyway. Space Invaders died at SEGMENTATION round 6 on exactly
# this, reproducibly and with nothing else running, and it read as a segmentation failure
# (2026-09-08). Try, wait once, then carry on regardless.
foreach ($f in @(Get-ChildItem $objDir -File -ErrorAction SilentlyContinue)) {
    try { [IO.File]::Delete($f.FullName) }
    catch {
        Start-Sleep -Milliseconds 250
        try { [IO.File]::Delete($f.FullName) } catch { Write-Host ("note: could not remove stale " + $f.Name + " (in use); it will be overwritten") }
    }
}

$dllPath = Join-Path $moduleDir ("{0}.dll" -f $Game)

# ---- the host's file name (the import library's DLL name) ------------------------------------
if (-not $HostExe) {
    # The lab's built launcher first, then the RELEASE layout (the program sits at the top of its
    # own tree). Decided by a file test, never by an assumption about where this is running.
    foreach ($cand in @((Join-Path $root "recompilator\launcher\build\windows-x64\Release\recompilator.exe"),
                        (Join-Path $root "Recompilator.exe"),
                        (Join-Path $root "recompilator.exe"))) {
        if (Test-Path $cand) { $HostExe = $cand; break }
    }
}
$hostName = if ($HostExe) { Split-Path -Leaf $HostExe } else { "recompilator.exe" }

# ---- the .def, from the ONE source of truth ---------------------------------------------------
$abiFile = Join-Path $root "recompilator\launcher\recomp_host_abi.txt"
if (-not (Test-Path $abiFile)) { Write-Error "missing $abiFile (run tools/make_host_abi.ps1)"; exit 4 }

$defLines = New-Object System.Collections.Generic.List[string]
$defLines.Add("LIBRARY $hostName")
$defLines.Add("EXPORTS")
$abiCount = 0
foreach ($ln in (Get-Content $abiFile)) {
    $t = $ln.Trim()
    if (-not $t -or $t.StartsWith("#")) { continue }
    # "name", "name=internal", either optionally followed by " DATA". The module imports by the
    # PLAIN name; the internal name is the host's business (it is in the host's /EXPORT: option).
    $isData = $false
    if ($t.EndsWith(" DATA")) { $isData = $true; $t = $t.Substring(0, $t.Length - 5).Trim() }
    $name = ($t -split "=")[0]
    if ($isData) { $defLines.Add("$name DATA") } else { $defLines.Add($name) }
    $abiCount++
}
$defPath = Join-Path $moduleDir "recomp_host.def"
Set-Content -Path $defPath -Value $defLines -Encoding ASCII

$implib = Join-Path $moduleDir "librecomp_host.a"
& $dlltool -m i386:x86-64 -d $defPath -l $implib -D $hostName
if ($LASTEXITCODE -ne 0) { Write-Error "llvm-dlltool failed"; exit 5 }
Write-Host ("import library: {0} ({1} host symbols, imports from {2})" -f $implib, $abiCount, $hostName)

# ---- the sources -------------------------------------------------------------------------------
$engine = Join-Path $root "engine"

# A tree can carry MORE THAN ONE recompiled set. The /ram-snapshot class (about 40 trees) has a
# RAM-image set beside the cart-image one -- RecompiledFuncsRAM, written by merge_recomp_sets.py --
# and its funcs.h / recomp_overlays.inl / ram_shadow_pins.inl SHADOW the plain set's. <game>pc's
# own CMakeLists.txt encodes that by listing the suffixed directory FIRST on the include path and
# compiling both directories' funcs_*.c; this reproduces exactly that, by the same name rule.
# Backups (RecompiledFuncs.bak_*, RecompiledFuncs.prev) carry a dot and are excluded.
$recompDirs = @(Get-ChildItem $tree -Directory -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -match '^RecompiledFuncs[A-Za-z0-9]*$' } |
                Sort-Object @{ Expression = { if ($_.Name -eq 'RecompiledFuncs') { 1 } else { 0 } } }, Name |
                ForEach-Object { $_.FullName })
if ($recompDirs.Count -eq 0) { Write-Error "no RecompiledFuncs* set under $tree"; exit 6 }
Write-Host ("recompiled sets (include order): {0}" -f (($recompDirs | ForEach-Object { Split-Path -Leaf $_ }) -join ', '))

$incs = @((Join-Path $engine "runtime\N64Recomp\include"))
$incs += $recompDirs
$incs += @(
    (Join-Path $engine "runtime\librecomp\include"),
    (Join-Path $engine "runtime\ultramodern\include"),
    (Join-Path $root   "recompilator\include"),
    (Join-Path $tree   "src")
)
$incArgs = @()
foreach ($i in $incs) { $incArgs += "-I"; $incArgs += $i }

$cSources = @()
$cxxSources = @()

# 1. the emitted C (the recompiled game) -- every set the tree carries, cart image and RAM image
foreach ($rd in $recompDirs) {
    $cSources += (Get-ChildItem $rd -Filter "funcs_*.c" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
}
# 2. the recompiled RSP microcode
$rspDir = Join-Path $tree "rsp"
if (Test-Path $rspDir) {
    $cxxSources += (Get-ChildItem $rspDir -Filter "*.cpp" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
}
# 3. the game's per-entry natives. engine_shims.c is EXCLUDED BY DESIGN: it exists only to satisfy
#    the exe link against librecomp's cv64-shaped symbols; a module carries those in its descriptor.
$patchDir = Join-Path $tree "src\patches"
if (Test-Path $patchDir) {
    $cSources += (Get-ChildItem $patchDir -Filter "*.c" -ErrorAction SilentlyContinue |
                  Where-Object { $_.Name -ne "engine_shims.c" } | ForEach-Object { $_.FullName })
}
# 4. generated static data (gen_ni_data.py output), when the entry has it
$niData = Join-Path $tree "src\ni_section_data.c"
if (Test-Path $niData) { $cSources += $niData }
# 5. the game's module face (the descriptor; recomp_overlays.inl is included from here)
$cSources   += (Get-ChildItem $moduleDir -Filter "*.c"   -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })
$cxxSources += (Get-ChildItem $moduleDir -Filter "*.cpp" -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName })

# ---- THE CART OUTRANKS THE PATCH LAYER --------------------------------------------------------
# src/patches/os_stubs.c and math_patches.c are lab-era stand-ins: hand-written bodies for libultra
# routines that the recompiler used to leave out. It now translates the cart's OWN copy of some of
# them, so both define <name>_recomp and ld.lld stops on a duplicate weak symbol. Legend of the
# Dragoon and Wave Race both failed this way on the 2026-09-08 playtest (LINK FAILED, three
# collisions each in lod's case: __f_to_ull, osUnmapTLB, __osContAddressCrc).
#
# The cart's version is the RIGHT one - it is the game's actual code, with the game's actual
# behaviour - so it wins, and the hand-written stand-in is renamed out of the way rather than
# deleted (these files are shared by ~300 trees and editing them is not this build's business).
# A forced -include of one generated header does it, with no edit to any patch file.
$patchFiles = @()
if (Test-Path $patchDir) {
    $patchFiles = @(Get-ChildItem $patchDir -Filter "*.c" -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -ne "engine_shims.c" } | ForEach-Object { $_.FullName })
}
$supersedeHdr = ''
if ($patchFiles.Count -gt 0) {
    $rx = [regex]'(?m)^RECOMP_FUNC\s+void\s+([A-Za-z_][A-Za-z0-9_]*)\s*\('
    $fromCart = New-Object 'System.Collections.Generic.HashSet[string]'
    foreach ($rd in $recompDirs) {
        foreach ($f in (Get-ChildItem $rd -Filter "funcs_*.c" -ErrorAction SilentlyContinue)) {
            foreach ($m in $rx.Matches([IO.File]::ReadAllText($f.FullName))) { $null = $fromCart.Add($m.Groups[1].Value) }
        }
    }
    $clash = @()
    foreach ($f in $patchFiles) {
        foreach ($m in $rx.Matches([IO.File]::ReadAllText($f))) {
            if ($fromCart.Contains($m.Groups[1].Value)) { $clash += $m.Groups[1].Value }
        }
    }
    $clash = @($clash | Sort-Object -Unique)
    if ($clash.Count -gt 0) {
        $lines = @('// generated by build_module.ps1 - the cart provides these, so the hand-written',
                   '// stand-in in src/patches is renamed out of the link. Do not edit.')
        foreach ($n in $clash) { $lines += ('#define {0} {0}__superseded_by_cart' -f $n) }
        $supersedeHdr = Join-Path $moduleDir '_patch_supersede.h'
        [IO.File]::WriteAllText($supersedeHdr, ($lines -join [Environment]::NewLine) + [Environment]::NewLine)
        Write-Host ("patch layer superseded by the cart for {0}: {1}" -f $clash.Count, ($clash -join ', '))
    }
}

if ($cSources.Count -eq 0) { Write-Error "no emitted C under $tree\RecompiledFuncs"; exit 6 }
Write-Host ("sources: {0} C + {1} C++" -f $cSources.Count, $cxxSources.Count)

# ---- compile ------------------------------------------------------------------------------------
# A SHIPPED GAME MUST NOT CARRY DEBUG ASSERTIONS. The emitted C contains assertions from the
# recompiler - e.g. `assert(ctx->f1.fl == ctx->f1.fl)`, a self-comparison that fails only on NaN,
# there to catch floating-point register aliasing. Built without NDEBUG they are LIVE, so a NaN in
# a register stops the game with a Visual C++ assertion dialog on the user's machine. That happened
# on Turok 2 (funcs_3.c:9814) after it reached its "Expansion Pak found" screen,
# 2026-09-09. -O2 alone does not define NDEBUG; only saying so does.
$cFlags   = @("-target", "x86_64-w64-mingw32", "-c", "-O2", "-DNDEBUG", "-std=c17",   "-DNOMINMAX", "-fno-strict-aliasing")
# -msse4.1: the recompiled RSP vector unit (rsp_vu_impl.hpp) uses SSE4.1 intrinsics that MSVC
# enables implicitly and clang does not.
$cxxFlags = @("-target", "x86_64-w64-mingw32", "-c", "-O2", "-DNDEBUG", "-std=c++20", "-DNOMINMAX", "-fno-strict-aliasing", "-msse4.1")

$t0 = Get-Date
$objs = @()
$running = @()
$failed = @()

# Start-Process -PassThru hands back a Process whose ExitCode can read back as $null, so success is
# judged the way a build should judge it anyway: the object file exists and its log holds no error.
# A TRANSLATION UNIT THAT RUNS PAST THE CAP IS KILLED, AND THE BUILD FAILS SAYING WHY.
# 2026-09-08: the byte-exact fallback made splat treat Space Invaders' whole image as code, and one
# clang chewed the result for 23 minutes at 9.4 GB on a 32 GB machine while it was in use.
# corpus_sweep.ps1 caps a whole build, but THIS script is what the launcher's BUILD button and
# segment_refine's per-round compile both run, so the cap has to live here to protect a user's
# machine. Every compiler this script starts is in $script:running; overdue ones are reaped from
# the same loop that hands out slots, so nothing extra runs and nothing older is ever touched.
$script:capped = @()
function Reap-Overdue {
    foreach ($proc in @($script:running)) {
        if ($proc.HasExited) { continue }
        $age = 0.0
        try { $age = ((Get-Date) - $proc.StartTime).TotalMinutes } catch { continue }
        if ($age -gt $CapMinutes) {
            $mb = 0; try { $mb = [int]($proc.WorkingSet64 / 1MB) } catch {}
            try { $proc.Kill() } catch {}
            $script:capped += ('pid {0} after {1:F0} min at {2} MB' -f $proc.Id, $age, $mb)
            Write-Host ('CAPPED: compiler pid {0} exceeded {1} min ({2} MB working set) - killed' -f $proc.Id, $CapMinutes, $mb)
        }
    }
}
function Wait-Slot([int]$limit) {
    while ($script:running.Count -ge $limit) {
        Reap-Overdue
        $script:running = @($script:running | Where-Object { -not $_.HasExited })
        if ($script:running.Count -ge $limit) { Start-Sleep -Milliseconds 25 }
    }
}

$idx = 0
foreach ($pair in @(@{ src = $cSources; tool = $clang; flags = $cFlags },
                    @{ src = $cxxSources; tool = $clangxx; flags = $cxxFlags })) {
    foreach ($s in $pair.src) {
        $idx++
        $obj = Join-Path $objDir ("{0}_{1}.o" -f ([IO.Path]::GetFileNameWithoutExtension($s)), $idx)
        $objs += $obj
        $log = "$obj.log"
        $argList = @()
        $argList += $pair.flags
        $argList += $incArgs
        if ($supersedeHdr -and ($patchFiles -contains $s)) { $argList += @("-include", $supersedeHdr) }
        $argList += @($s, "-o", $obj)
        Wait-Slot $Jobs
        $p = Start-Process -FilePath $pair.tool -ArgumentList $argList -NoNewWindow -PassThru `
                           -RedirectStandardError $log -RedirectStandardOutput "$log.out"
        $running += $p
    }
}
Wait-Slot 1

foreach ($o in $objs) {
    $log = "$o.log"
    $bad = -not (Test-Path $o)
    if (-not $bad -and (Test-Path $log)) {
        $c = Get-Content $log -Raw
        if ($c -and ($c -match "error:")) { $bad = $true }
    }
    if ($bad) {
        $failed += $o
        Write-Host ("--- {0}" -f (Split-Path -Leaf $o))
        if (Test-Path $log) { Get-Content $log | Select-Object -First 25 | ForEach-Object { Write-Host $_ } }
    }
}
if ($failed.Count -gt 0) {
    if ($script:capped.Count -gt 0) {
        # THE CAP IS WHY. Say so on the line build_entry reads, or a killed compiler reads as a
        # plain compile failure and the next person hunts for a syntax error that is not there.
        Write-Host ("COMPILE FAILED: {0} translation unit(s); {1} exceeded the {2}-minute cap ({3}) - this cart's emitted C is pathological; see the byte-exact fallback in segment_refine.py" -f $failed.Count, $script:capped.Count, $CapMinutes, ($script:capped -join '; '))
    } else {
        Write-Host ("COMPILE FAILED: {0} translation unit(s)" -f $failed.Count)
    }
    exit 7
}
$compileSecs = ((Get-Date) - $t0).TotalSeconds
Write-Host ("compiled {0} objects in {1:F1}s" -f $objs.Count, $compileSecs)

# ---- link ---------------------------------------------------------------------------------------
$t1 = Get-Date
if (Test-Path $dllPath) { [IO.File]::Delete($dllPath) }
$linkLog = Join-Path $moduleDir "link.log"
$linkArgs = @("-target", "x86_64-w64-mingw32", "-shared", "-o", $dllPath)
$linkArgs += $objs
$linkArgs += @($implib, "-Wl,--error-limit=0", "-static", "-Wl,--no-undefined")
$p = Start-Process -FilePath $clangxx -ArgumentList $linkArgs -NoNewWindow -PassThru `
                   -RedirectStandardError $linkLog -RedirectStandardOutput "$linkLog.out"
if (-not $p.WaitForExit($CapMinutes * 60 * 1000)) {
    try { $p.Kill() } catch {}
    Write-Host ("LINK FAILED: the linker exceeded the {0}-minute cap and was killed" -f $CapMinutes)
    exit 8
}
$linkText = ""
if (Test-Path $linkLog) { $linkText = (Get-Content $linkLog -Raw) }
if (-not (Test-Path $dllPath) -or ($linkText -and ($linkText -match "error:"))) {
    Write-Host "LINK FAILED"
    if (Test-Path $linkLog) { Get-Content $linkLog | Select-Object -First 60 | ForEach-Object { Write-Host $_ } }
    exit 8
}
$linkSecs = ((Get-Date) - $t1).TotalSeconds
$size = (Get-Item $dllPath).Length
Write-Host ("MODULE OK {0} {1} bytes, compile {2:F1}s link {3:F1}s" -f $dllPath, $size, $compileSecs, $linkSecs)
exit 0
