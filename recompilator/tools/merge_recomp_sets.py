#!/usr/bin/env python3
"""merge_recomp_sets.py — pipeline step 4: link a RAM-image recomp beside the resident set.

Produces <app>/RecompiledFuncsRAM/ containing:
  - the RAM set's funcs_*.c (with the seeded duplicate `recomp_entrypoint` renamed)
  - a merged funcs.h   (resident decls + RAM decls)  — shadows the resident one via include order
  - a merged recomp_overlays.inl (resident sections + RAM code sections) — ditto

The resident RecompiledFuncs/ dir is NEVER modified (it is regen-owned).
CMake must add RecompiledFuncsRAM's sources to the recomp lib and put the dir FIRST in the
include path of both the recomp lib and the app target (so main.cpp's #includes resolve here).

Usage: merge_recomp_sets.py <app_dir> <ram_recomp_dir>   e.g.
       merge_recomp_sets.py banjokazooiepc banjokazooie_ram/RecompiledFuncs
"""
import re
import shutil
import sys
from pathlib import Path

N64PC = Path(__file__).resolve().parents[2]   # <root>/recompilator/tools -> <root>
SEED_RENAME = ("recomp_entrypoint", "ram_seed_entrypoint_unused")


def main():
    app = N64PC / sys.argv[1]
    ram = N64PC / sys.argv[2]
    res = app / "RecompiledFuncs"
    out = app / "RecompiledFuncsRAM"
    out.mkdir(exist_ok=True)

    # 1. RAM sources, seed-entrypoint renamed (textual, collision-free vs resident)
    n = 0
    for c in sorted(ram.glob("funcs_*.c")):
        txt = c.read_text(encoding="utf-8", errors="replace").replace(SEED_RENAME[0], SEED_RENAME[1])
        (out / c.name).write_text(txt, encoding="utf-8", newline="\n")
        n += 1

    # 2. merged funcs.h: splice RAM decls INSIDE the resident file's `extern "C" {`...`}` block,
    #    leaving the include guard and linkage braces intact. Both files carry the same guard +
    #    `extern "C"` wrapper, so we take only the RAM decl LINES (void func_...;) and inject them
    #    just before the resident's closing `}` of the extern-C block.
    res_h = (res / "funcs.h").read_text(encoding="utf-8", errors="replace")
    ram_h = (ram / "funcs.h").read_text(encoding="utf-8", errors="replace").replace(*SEED_RENAME)
    ram_decls = [l for l in ram_h.splitlines() if re.match(r"\s*void\s+\w+\s*\(", l)]
    # closing of extern "C": the `}` immediately before `#ifdef __cplusplus\n}\n#endif` tail, i.e.
    # the last `}` that precedes the final `#endif`. Anchor on the standard N64Recomp tail.
    m = re.search(r"\n#ifdef __cplusplus\n\}\n#endif", res_h)
    if not m:
        print("FATAL: resident funcs.h extern-C tail not found"); return 1
    merged_h = (res_h[:m.start()]
                + "\n// ==== RAM-image set (merge_recomp_sets.py) ====\n"
                + "\n".join(ram_decls)
                + res_h[m.start():])
    (out / "funcs.h").write_text(merged_h, encoding="utf-8", newline="\n")

    # 3. merged recomp_overlays.inl
    res_inl = (res / "recomp_overlays.inl").read_text(encoding="utf-8", errors="replace")
    ram_inl = (ram / "recomp_overlays.inl").read_text(encoding="utf-8", errors="replace").replace(*SEED_RENAME)
    # resident: keep everything, but capture and remove nothing — we splice extra rows into its
    # section_table just before the closing "};" of that array.
    m_res_table = re.search(r"static SectionTableEntry section_table\[\] = \{(.*?)\n\};", res_inl, re.S)
    if not m_res_table:
        print("FATAL: resident section_table not found"); return 1
    # RAM side: take FuncEntry arrays (renamed ram_*), take section_table rows except the seed
    # section (the zeros at 0x80100000), renumber .index high to avoid collisions.
    ram_arrays = re.findall(r"(static FuncEntry (section_\w+)_funcs\[\] = \{.*?\n\};)", ram_inl, re.S)
    ram_rows = re.findall(r"(\{ \.rom_addr = 0x[0-9A-Fa-f]+, \.ram_addr = (0x[0-9A-Fa-f]+),.*?\.index = )(\d+)( \},)", ram_inl)
    arrays_txt, rows_txt = [], []
    # RAM rows need IN-BOUNDS .index values: init_overlays writes section_addresses[.index],
    # an array calloc'd to total_num_sections — the old 1000 base was an OOB heap write at every
    # boot. Use max(resident index)+1.. instead (resident tables are sparse; relocs are the only
    # .index consumer and the RAM set carries none, but stay in bounds regardless).
    res_indices = [int(i) for i in re.findall(r"\.index = (\d+)", m_res_table.group(0))]
    idx = (max(res_indices) + 1) if res_indices else 100
    ram_bases = []   # (array_name, ram_addr) for the pins file
    for full, name in ram_arrays:
        if "80100000" in name:   # seed section: zeros + renamed entrypoint — drop
            continue
        arrays_txt.append(full.replace("static FuncEntry section_", "static FuncEntry ram_section_"))
    import re as _re
    for pre, ram_addr, _oldidx, post in ram_rows:
        if ram_addr.lower() == "0x80100000":
            continue
        # [ram-rebind fix 2026-09-02] A RAM-snapshot section carries runtime-true bytes already in RDRAM; its rom_addr is a
        # worker-repo IMAGE offset, not a real cart ROM offset. If that offset collides with a real cart DMA range (OoT 1.0:
        # the RAM image starts at 0x110AC, exactly where the cart DMAs its code), load_overlays_from_dma's range search REBINDS
        # the section at the DMA's wrong dram base — the shifted table then overwrites correct func_map entries with empty
        # ICF-folded stubs (Setup_Init -> no-op -> boot loops forever, black screen). Give every RAM row a rom_addr BEYOND any
        # cart (>64MB) so no DMA can match it; the engine's appended-overlay post-pass (rom_addr >= rom_size) force-registers it
        # at its true ram_addr at init instead. Unique per section. See ram_snapshot_overlay_recipe.
        pre = _re.sub(r"\.rom_addr = 0x[0-9A-Fa-f]+", ".rom_addr = 0x%08X" % (0x08000000 + idx * 0x00100000), pre, count=1)
        row = (pre + str(idx) + post).replace("section_", "ram_section_")  # both .funcs= and ARRLEN()
        rows_txt.append("    " + row)
        arr = re.search(r"\.funcs = (\w+)", row)
        ram_bases.append((arr.group(1), ram_addr))
        idx += 1
    if not rows_txt:
        print("FATAL: no RAM section rows survived filtering"); return 1
    insert_at = res_inl.find("static SectionTableEntry section_table[] = {")
    merged_inl = (res_inl[:insert_at]
                  + "// ==== RAM-image FuncEntry arrays (merge_recomp_sets.py) ====\n"
                  + "\n".join(arrays_txt) + "\n\n"
                  + res_inl[insert_at:])
    close = merged_inl.find("\n};", merged_inl.find("static SectionTableEntry section_table[] = {"))
    merged_inl = (merged_inl[:close]
                  + "\n    // ==== RAM-image sections ====\n" + "\n".join(rows_txt)
                  + merged_inl[close:])
    (out / "recomp_overlays.inl").write_text(merged_inl, encoding="utf-8", newline="\n")

    # ram_shadow_pins.inl: init_overlays' static registration skips any section whose vram range
    # overlaps another's — a RAM-shadow section overlaps its resident twin BY DESIGN, so its funcs
    # never reach func_map and every dispatch falls to the interpreter net (banjo wall 5: the
    # exception handler ran interpreted; interpreted erets nest drains to the depth cap). Pin every
    # RAM func instead: register_pinned_function survives init_overlays' func_map.clear and is
    # consulted on func_map miss. The app must call register_ram_shadow_pins() BEFORE recomp::start.
    pins = ["// generated by merge_recomp_sets.py — see header comment there.",
            '#include "librecomp/overlays.hpp"',
            "static void register_ram_shadow_pins() {"]
    for arr, base in ram_bases:
        pins.append(f"    for (size_t i = 0; i < ARRLEN({arr}); i++)")
        pins.append(f"        recomp::overlays::register_pinned_function((int32_t)({base}u + {arr}[i].offset), {arr}[i].func);")
    pins.append("}\n")
    (out / "ram_shadow_pins.inl").write_text("\n".join(pins), encoding="utf-8", newline="\n")

    print(f"merged: {n} RAM sources, {len(arrays_txt)} RAM func arrays, {len(rows_txt)} RAM sections -> {out}")
    print("REMINDER: CMake must glob RecompiledFuncsRAM/funcs_*.c and put RecompiledFuncsRAM FIRST "
          "in include dirs of the recomp lib AND the app target.")
    print("REMINDER: main.cpp must #include \"ram_shadow_pins.inl\" AFTER recomp_overlays.inl and "
          "call register_ram_shadow_pins() before recomp::start.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
