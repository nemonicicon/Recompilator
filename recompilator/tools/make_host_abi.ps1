# make_host_abi.ps1 -- derive THE HOST ABI: the C symbols Recompilator.exe exports to game modules.
#
# A game module (<game>.dll, built by the bundled llvm-mingw clang) calls back into the host for
# every libultra HLE entry and every recomp runtime primitive. That set is NOT per-game -- it is
# the HLE surface librecomp/ultramodern implement -- so this tool reads it out of the built engine
# libraries with the bundled llvm-nm and writes one line per symbol to
#
#     recompilator/launcher/recomp_host_abi.txt
#
# which the launcher's CMakeLists turns into /EXPORT: options and build_module.ps1 turns into the
# .def that llvm-dlltool makes the module's import library from. ONE source of truth, no hand list.
#
# A line is either "name" or "name=internal_name". The second form exists because MSVC mangles
# C++-linkage GLOBAL VARIABLES (dmem is declared `extern uint8_t dmem[]` in librecomp/rsp.hpp with
# no extern "C", so MSVC calls it ?dmem@@3PAEA) while the Itanium ABI clang uses does not mangle
# globals at all. /EXPORT:dmem=?dmem@@3PAEA reconciles the two without touching the engine.
#
# Usage:  powershell -NoProfile -ExecutionPolicy Bypass -File recompilator\tools\make_host_abi.ps1
#         [-BuildDir <a build tree holding librecomp.lib>] [-Out <path>]

[CmdletBinding()]
param(
    [string]$BuildDir = "",
    [string]$Out = ""
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
if (-not $root) { Write-Error "N64PC root not found from $PSCommandPath"; exit 1 }

$nm = Join-Path $root "_toolchain\clang\bin\llvm-nm.exe"
if (-not (Test-Path $nm)) {
    $tc = $env:RECOMPILATOR_TOOLCHAIN
    if ($tc) { $nm = Join-Path $tc "clang\bin\llvm-nm.exe" }
}
if (-not (Test-Path $nm)) { Write-Error "llvm-nm not found (looked in _toolchain/clang/bin)"; exit 1 }

# THE NEWEST build tree wins, not a named one. There are two under launcher/build (master and
# windows-x64) and on 2026-09-07 the ABI was being derived from the STALE one while the SHIPPED exe
# was linked from the other - an ABI that describes a binary nobody runs, failing silently.
if (-not $BuildDir) { $BuildDir = Join-Path $root "recompilator\launcher\build" }
if (-not $Out) { $Out = Join-Path $root "recompilator\launcher\recomp_host_abi.txt" }

$libs = @()
foreach ($n in @("librecomp.lib", "ultramodern.lib", "rt64.lib")) {
    $hit = Get-ChildItem -Path $BuildDir -Filter $n -Recurse -ErrorAction SilentlyContinue |
           Where-Object { $_.FullName -match "\\Release\\" } |
           Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($hit) { $libs += $hit.FullName } else { Write-Host "  (no $n under $BuildDir)" }
}
if ($libs.Count -eq 0) { Write-Error "no engine libraries under $BuildDir -- build the launcher first"; exit 1 }
foreach ($l in $libs) { Write-Host "reading $l" }

# Every defined symbol in the engine libraries, as "<type> <name>".
$defined = New-Object 'System.Collections.Generic.HashSet[string]'
$mangledOf = @{}
$typeOf = @{}
foreach ($l in $libs) {
    $lines = & $nm --defined-only $l 2>$null
    foreach ($ln in $lines) {
        $t = $ln.Trim()
        if (-not $t) { continue }
        $parts = $t -split '\s+'
        $name = $parts[$parts.Length - 1]
        if ($name -match '^\$') { continue }            # $chain$/$pdata$/$unwind$ helper symbols
        [void]$defined.Add($name)
        if ($parts.Length -ge 2 -and -not $typeOf.ContainsKey($name)) { $typeOf[$name] = $parts[$parts.Length - 2] }
        # MSVC mangling: ?<name>@@3<type> for a global VARIABLE and ?<name>@@YA... for a
        # FUNCTION with C++ linkage. Only the variable form was recognised, so every C++
        # linkage function in the RSP runtime looked absent - which is why a recompiled
        # graphics microcode could not link against rsp_process_rdp_commands, the DPC
        # registers or the reciprocal tables (AeroGauge, 2026-09-07).
        if ($name -match '^\?([A-Za-z_][A-Za-z0-9_]*)@@(3|YA)') {
            if (-not $mangledOf.ContainsKey($Matches[1])) { $mangledOf[$Matches[1]] = $name }
        }
    }
}
Write-Host ("defined symbols: {0}" -f $defined.Count)

# 1. The libultra HLE surface: every plain C symbol ending in _recomp.
$hle = @()
foreach ($s in $defined) { if ($s -match '^[A-Za-z_][A-Za-z0-9_]*_recomp$') { $hle += $s } }
$hle = $hle | Sort-Object

# 2. The recomp runtime primitives the emitted C and the recompiled RSP microcode reach for.
#    Measured 2026-09-06 by linking cv64blind's module with no import library at all
#    (_sweep/dispatch/module_abi_undefined_20260906.txt); kept as a named list because it is small,
#    stable, and not derivable by a name pattern.
$primitives = @(
    "cop0_status_read", "cop0_status_write", "dmem", "get_function",
    "pause_self", "recomp_baremetal_peek_pending", "recomp_cache_op",
    "recomp_cop0_tlb_read", "recomp_cop0_tlb_write", "recomp_coswitch", "recomp_eret",
    "recomp_mmio_load_w", "recomp_mmio_store_w", "recomp_tlb_map", "recomp_tlb_translate",
    "recomp_tlbp", "recomp_tlbr", "recomp_tlbwi", "switch_error",
    "yield_self_1ms", "yield_self_poll",
    # Not reached by cv64blind, but part of the same surface and cheap to carry:
    "g_lle_z_consume_idx", "recomp_register_static_data", "load_overlays", "unload_overlays",
    # 2026-09-07, added for the SECOND module (legendofzeldatheoc): the C face of
    # recomp::overlays::register_pinned_function, which every RAM-shadow tree's generated
    # ram_shadow_pins.inl calls. Not per-game: ~40 trees in the corpus carry that .inl.
    "recomp_register_pinned_function",
    # 2026-09-07, likewise: the RELOCATABLE-OVERLAY class's one data symbol. N64Recomp's recomp.h
    # defines RELOC_HI16/RELOC_LO16 as section_addresses[section_index] + offset, so every emitted
    # function that lives in a relocatable section reads this array. cv64blind has no relocatable
    # section and never named it; Ocarina of Time has 432 and names it from 189 objects. Also
    # per-class, not per-game -- it is how every overlay cart's emitted C resolves an address.
    "section_addresses",
    # 2026-09-07, found by Saikyou Habu Shougi (Japan): the LIVE-GAP class. N64Recomp emits
    # a weak trampoline for any function it could not fully recompile, and that trampoline calls
    # these two - so a cart with a single such gap fails to link against a host that does not offer
    # them. Neither Castlevania nor Ocarina had one. Per-class, not per-game.
    "recomp_live_gap_set_target", "recomp_live_gap_trampoline",
    # 2026-09-07, found on Saikyou Habu Shougi (Japan) again, further along: a cart that
    # executes the MIPS `syscall` instruction. cgenerator emits a direct call to this for every one
    # of them, and librecomp defines it (recomp.cpp), so the only thing missing was the export -
    # the module link failed with a single undefined symbol. Per-class, not per-game: any cart whose
    # kernel raises a syscall needs it, and neither Castlevania, Mario nor Ocarina has one.
    "recomp_syscall_handler"
)

# 2b. DERIVED, NOT REMEMBERED (2026-09-07). The hand list above was measured from ONE cart, so it
#     only ever held what that cart happened to reach for, and every cart that reached for anything
#     else died at SEGMENTATION on a single undefined symbol with no way for the user to know why:
#     Saikyou Habu Shougi wanted recomp_syscall_handler, then 40 Winks and Army Men wanted do_break.
#     Both were declared in the header the emitted C includes and defined in librecomp all along.
#     So take the WHOLE surface: every function recomp.h declares that the built engine actually
#     defines. That is by construction everything the recompiler's output can call. Exporting a
#     symbol no module imports costs nothing; missing one costs a cartridge.
#     TWO headers, because the emitted code includes two: recomp.h for the game itself, and
#     librecomp/rsp.hpp for a recompiled MICROCODE, which reaches for the RSP runtime - the RDP
#     command processor, the DPC registers, the reciprocal tables. No cart shipped with a
#     recompiled graphics microcode before 2026-09-07, so that whole surface was absent and
#     AeroGauge could not link. Variables count too, not only functions.
$headers = @((Join-Path $PSScriptRoot "../../engine/runtime/N64Recomp/include/recomp.h"),
             (Join-Path $PSScriptRoot "../../engine/runtime/librecomp/include/librecomp/rsp.hpp"))
$hdr = $headers[0]
if (Test-Path $hdr) {
    $rx  = [regex]'(?m)^[A-Za-z_][A-Za-z0-9_ \*&:<>,]*?\b([A-Za-z_][A-Za-z0-9_]*)\s*\([^;{]*\)\s*;'
    $rxv = [regex]'(?m)^\s*extern\s+[A-Za-z_][A-Za-z0-9_ \*&:<>,]*?\b([A-Za-z_][A-Za-z0-9_]*)\s*(\[[^\]]*\])?\s*;'
    $declared = @{}
    foreach ($h in $headers) {
        if (-not (Test-Path $h)) { continue }
        $txt = Get-Content -Raw $h
        foreach ($m in $rx.Matches($txt))  { $declared[$m.Groups[1].Value] = $true }
        foreach ($m in $rxv.Matches($txt)) { $declared[$m.Groups[1].Value] = $true }
    }
    # Collect first, concatenate after: growing $primitives inside the very loop whose test reads
    # it made the membership check see a moving target, and the derivation silently produced
    # nothing at all (2026-09-07).
    $have = @{}
    foreach ($x in $primitives) { $have[$x] = $true }
    foreach ($x in $hle)        { $have[$x] = $true }
    $added = @()
    foreach ($n in @($declared.Keys)) {
        if ($have.ContainsKey($n)) { continue }
        if ($defined.Contains($n) -or $mangledOf.ContainsKey($n)) { $added += $n; $have[$n] = $true }
    }
    if ($added.Count -gt 0) { $primitives = @($primitives) + $added }
    if ($added.Count -gt 0) {
        Write-Host ("derived from recomp.h: {0} further primitive(s) the engine defines: {1}" -f `
                    $added.Count, (($added | Sort-Object) -join ", "))
    }
} else {
    Write-Host "WARNING: no recomp.h at $hdr - falling back to the hand list alone"
}

$lines_out = New-Object System.Collections.Generic.List[string]
$lines_out.Add("# recomp_host_abi.txt -- THE HOST ABI. Generated by recompilator/tools/make_host_abi.ps1.")
$lines_out.Add("# One line per symbol Recompilator.exe exports for game modules to import.")
$lines_out.Add("# 'name' exports it as itself; 'name=internal' exports the mangled internal symbol under")
$lines_out.Add("# the plain C name the module asks for.")
$lines_out.Add(("# HLE entries: {0}   runtime primitives offered: {1}" -f $hle.Count, $primitives.Count))

$missing = @()
foreach ($p in $primitives) {
    $internal = ""
    if ($defined.Contains($p)) { $internal = $p }
    elseif ($mangledOf.ContainsKey($p)) { $internal = $mangledOf[$p] }
    else { $missing += $p; continue }
    # nm type letter: B/D/R = data (the module must import it as DATA, not through a call thunk).
    $isData = $false
    if ($typeOf.ContainsKey($internal)) { $isData = ("BDR" -match [regex]::Escape($typeOf[$internal])) -and ($typeOf[$internal].Length -eq 1) }
    $line = $p
    if ($internal -ne $p) { $line = "$p=$internal" }
    if ($isData) { $line = "$line DATA" }
    $lines_out.Add($line)
    if ($internal -ne $p) {
        # ALSO export the mangled name as itself. A C++-linkage FUNCTION is referenced by its
        # mangled name from the module as well, because the module includes the same header
        # (librecomp/rsp.hpp) and so compiles the same C++ declaration. The plain alias above still
        # serves anything that declares the symbol extern "C"; both names point at one definition.
        # Found 2026-09-07: AeroGauge resolved every other RSP symbol and died on
        # rsp_process_rdp_commands, the only one the module CALLS rather than reads.
        $ml = $internal
        if ($isData) { $ml = "$ml DATA" }
        $lines_out.Add($ml)
    }
}
foreach ($h in $hle) { $lines_out.Add($h) }

Set-Content -Path $Out -Value $lines_out -Encoding ASCII
$n = ($lines_out | Where-Object { -not $_.StartsWith("#") }).Count
Write-Host ("wrote {0}: {1} exported symbols ({2} HLE + {3} primitives)" -f $Out, $n, $hle.Count, ($n - $hle.Count))
if ($missing.Count -gt 0) {
    Write-Host ("NOT FOUND in the engine libraries (dropped): {0}" -f ($missing -join ", "))
}
