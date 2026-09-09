<#
make_toolchain.ps1 - assemble the BUNDLED TOOLCHAIN from what is already on this machine.

    powershell -NoProfile -ExecutionPolicy Bypass -File recompilator\tools\make_toolchain.ps1 [-Dest <dir>]

The end user of the Recompilator installs NOTHING. Everything the BUILD screen needs at stage 2
(byte-exact ELF) and stage 3 (recompiler) is copied into ONE relocatable directory:

    <dest>/
      mips/bin/    mips64-elf-{as,ld,objcopy,nm,objdump,readelf}.exe   GNU binutils 2.19, GPL
      python/      python.exe + the stdlib + ONLY the packages splat needs
      n64recomp/   N64Recomp.exe, RSPRecomp.exe                       (built here, MIT)
      clang/       EMPTY until a self-contained clang is downloaded (stage 5; see the report)
      TOOLCHAIN.txt  what each piece is, where it came from, its licence

Nothing here is ROM-derived. Nothing is downloaded: every source path is a file already on disk.
Default dest: <N64PC>\_toolchain
#>

[CmdletBinding()]
param(
    [string]$Dest = ''
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)   # tools -> recompilator -> N64PC
if (-not $Dest) { $Dest = Join-Path $root '_toolchain' }

function Say([string]$s) { [Console]::Out.WriteLine($s) }

function Copy-One([string]$src, [string]$dst) {
    $d = Split-Path -Parent $dst
    if (-not (Test-Path $d)) { New-Item -ItemType Directory -Path $d -Force | Out-Null }
    Copy-Item -LiteralPath $src -Destination $dst -Force
}

function Copy-Tree([string]$src, [string]$dst, [string[]]$skipDirs) {
    if (-not (Test-Path $src)) { return }
    if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst -Force | Out-Null }
    foreach ($item in (Get-ChildItem -LiteralPath $src -Force)) {
        if ($item.PSIsContainer) {
            if ($skipDirs -and ($skipDirs -contains $item.Name)) { continue }
            Copy-Tree $item.FullName (Join-Path $dst $item.Name) $skipDirs
        } else {
            Copy-Item -LiteralPath $item.FullName -Destination (Join-Path $dst $item.Name) -Force
        }
    }
}

function SizeMb([string]$p) {
    if (-not (Test-Path $p)) { return 0.0 }
    $s = (Get-ChildItem -LiteralPath $p -Recurse -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    if (-not $s) { return 0.0 }
    return [math]::Round($s / 1MB, 1)
}

Say "dest: $Dest"
if (-not (Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest -Force | Out-Null }

# ---------------------------------------------------------------- 1 MIPS ----
# GNU binutils 2.19 for mips64-elf, Windows-native, from the harvested n64dev kit on disk.
$mipsSrc = Join-Path $root 'engine\references\sdk\_harvest\n64dev\n64dev\bin'
$mipsDst = Join-Path $Dest 'mips\bin'
if (-not (Test-Path (Join-Path $mipsSrc 'mips64-elf-as.exe'))) {
    throw "no mips64-elf-as.exe under $mipsSrc"
}
$want = @('as', 'ld', 'objcopy', 'nm', 'objdump', 'readelf')
foreach ($w in $want) {
    Copy-One (Join-Path $mipsSrc ("mips64-elf-{0}.exe" -f $w)) (Join-Path $mipsDst ("mips64-elf-{0}.exe" -f $w))
}
Say ("mips:      {0} tools, {1} MB" -f $want.Count, (SizeMb $mipsDst))

# -------------------------------------------------------------- 2 PYTHON ----
# A relocatable copy of the pythoncore runtime + ONLY what splat imports.
$pySrc = Split-Path -Parent (& py -3 -c "import sys; print(sys.executable)")
$pyDst = Join-Path $Dest 'python'
foreach ($f in @('python.exe', 'pythonw.exe', 'python3.dll', 'python314.dll', 'python313.dll',
                 'python312.dll', 'vcruntime140.dll', 'vcruntime140_1.dll', 'LICENSE.txt')) {
    $s = Join-Path $pySrc $f
    if (Test-Path $s) { Copy-One $s (Join-Path $pyDst $f) }
}
Copy-Tree (Join-Path $pySrc 'DLLs') (Join-Path $pyDst 'DLLs') @('__pycache__')
Copy-Tree (Join-Path $pySrc 'Lib')  (Join-Path $pyDst 'Lib') @(
    '__pycache__', 'site-packages', 'test', 'tests', 'idlelib', 'tkinter', 'turtledemo',
    'lib2to3', 'pydoc_data', 'ensurepip', 'distutils', 'venv', 'sqlite3', 'unittest')

# splat's own import closure, copied package by package (never a whole site-packages).
$spSrc = Join-Path $pySrc 'Lib\site-packages'
$spDst = Join-Path $pyDst 'Lib\site-packages'
# xxhash is NOT splat's: recon.py/rom_identity.py hash the user's cart with it, so a toolchain
# without it stops every blind bring-up at IDENTITY - the first stage of the only path a
# release has (found 2026-09-07 when the ADD-ROM path had to copy it in by hand).
$pkgs = @('splat', 'spimdisasm', 'rabbitizer', 'elftools', 'yaml', '_yaml', 'pylibyaml',
          'tqdm', 'colorama', 'intervaltree', 'sortedcontainers', 'n64img', 'crunch64',
          'cffi', 'pycparser', 'png', 'pypng', 'xxhash')
$got = @()
foreach ($p in $pkgs) {
    $s = Join-Path $spSrc $p
    if (Test-Path $s) {
        if ((Get-Item $s).PSIsContainer) { Copy-Tree $s (Join-Path $spDst $p) @('__pycache__') }
        else { Copy-One $s (Join-Path $spDst $p) }
        $got += $p
    }
}
# Loose single-file modules and compiled extensions that sit BESIDE the packages. rabbitizer is
# the one that matters: rabbitizer.pyd at the site-packages root is the real module and the
# rabbitizer/ directory next to it holds only .pyi stubs - copy the directory alone and every
# import of spimdisasm dies on "module 'rabbitizer' has no attribute 'AccessType'".
foreach ($item in (Get-ChildItem -LiteralPath $spSrc -File -ErrorAction SilentlyContinue)) {
    if ($item.Name -match '^(rabbitizer|pylibyaml|_yaml|_cffi_backend|png|pygfxd|libgfxd)\b.*\.(py|pyd|so|dll)$') {
        Copy-One $item.FullName (Join-Path $spDst $item.Name)
    }
}
# the dist-info directories keep importlib.metadata (and splat's version check) honest
foreach ($item in (Get-ChildItem -LiteralPath $spSrc -Directory -ErrorAction SilentlyContinue)) {
    if ($item.Name -match '^(splat64|spimdisasm|rabbitizer|pyelftools|PyYAML|pylibyaml|tqdm|colorama|intervaltree|sortedcontainers|n64img|crunch64)-.*\.dist-info$') {
        Copy-Tree $item.FullName (Join-Path $spDst $item.Name) @()
    }
}
Say ("python:    {0} packages, {1} MB" -f $got.Count, (SizeMb $pyDst))

# ----------------------------------------------------------- 3 N64RECOMP ----
$nrDst = Join-Path $Dest 'n64recomp'
foreach ($n in @('N64Recomp.exe', 'RSPRecomp.exe')) {
    $s = Join-Path $root ("engine\runtime\N64Recomp\build_cli\Release\{0}" -f $n)
    if (Test-Path $s) { Copy-One $s (Join-Path $nrDst $n) }
}
Say ("n64recomp: {0} MB" -f (SizeMb $nrDst))

# --------------------------------------------------------------- 4 CLANG ----
$clDst = Join-Path $Dest 'clang'
if (-not (Test-Path $clDst)) { New-Item -ItemType Directory -Path $clDst -Force | Out-Null }
$note = Join-Path $clDst 'PUT-CLANG-HERE.txt'
if (-not (Test-Path $note)) {
    Set-Content -Path $note -Encoding Ascii -Value @(
        'Stage 5 (COMPILE) still needs Visual Studio on this machine.',
        'The self-contained toolchain for it is llvm-mingw (clang + lld + a complete mingw-w64',
        'sysroot, no Visual Studio and no Windows SDK needed). Unpack it here so that',
        '   toolchain\clang\bin\clang.exe',
        'exists. Nothing on this machine carries a clang that can do it: the clang inside',
        'Visual Studio 18 is MSVC-hosted (it needs the VC headers and libs) and has no MIPS',
        'target either.')
}

# -------------------------------------------------------------- MANIFEST ----
$lines = @()
$lines += 'THE RECOMPILATOR - BUNDLED TOOLCHAIN'
$lines += ('assembled ' + (Get-Date).ToString('yyyy-MM-dd HH:mm') + ' by recompilator/tools/make_toolchain.ps1')
$lines += ''
$lines += 'mips/bin      GNU binutils 2.19 for mips64-elf, Windows-native (elf32ebmip).'
$lines += ('              from ' + $mipsSrc)
$lines += '              licence GPL-3.0-or-later (binutils). Source offer required on release.'
$lines += '              used by recompilator/tools/build_elf.py: as -> ld -> objcopy.'
$lines += ''
$lines += 'python        CPython ' + (& py -3 -c "import sys;print('.'.join(map(str,sys.version_info[:3])))") + ', relocatable, stdlib trimmed.'
$lines += ('              from ' + $pySrc)
$lines += '              licence PSF. site-packages holds ONLY splat64 and its import closure:'
$lines += ('              ' + ($got -join ', '))
$lines += ''
$lines += 'n64recomp     N64Recomp.exe / RSPRecomp.exe, built from engine/runtime/N64Recomp (MIT).'
$lines += ''
$lines += 'clang         EMPTY. See clang/PUT-CLANG-HERE.txt.'
$lines += ''
$lines += 'NOTHING HERE IS ROM-DERIVED. Nothing was downloaded to assemble it.'
Set-Content -Path (Join-Path $Dest 'TOOLCHAIN.txt') -Encoding Ascii -Value $lines

Say ('TOTAL:     {0} MB at {1}' -f (SizeMb $Dest), $Dest)

