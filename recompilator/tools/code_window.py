#!/usr/bin/env python3
"""code_window.py — does this cartridge run its code from a MAPPED window?

WHY THIS EXISTS (2026-09-08). Turok 2 built two ways, same cart, same offsets:

    recipe build   4125 functions at 0x00200500..0x002DD0D0   USER SEGMENT
    blind build    2323 functions at 0x80200500..0x802FC9D4   KSEG0

The cartridge programs ONE TLB entry in its boot stub and runs its body from the user segment at
0x00200000. The blind path assumed direct-mapped memory and filed every function 0x80000000 too
high, at an address the game never jumps to, so the first jump into its own body found nothing and
the build froze having executed almost nothing. The recipe build gets far only because someone had
hand-written the right addresses into a seed file back in August.

So read it out of the cart, the way the pipeline already reads a detached code module or a packed
audio microcode out of a cart: the boot stub is plain MIPS at a known ROM offset, and the mapping it
installs is right there in the instructions.

HOW. Walk the entry stub tracking lui/ori/addiu into registers, watch for `mtc0 rt, EntryHi` and
`mtc0 rt, PageMask`, and at each `tlbwi`/`tlbwr` take whatever value is live in EntryHi. A base in
the USER SEGMENT (non-zero, below 0x80000000) is a code window. A KSEG0 base is the ordinary
identity entry every libultra boot writes and is not a window — Turok 2 writes one of each, in that
order, and taking the first would give the wrong answer.

MEASURED 2026-09-08, and it separates the class exactly:
    Turok 2 (US)        base 0x00200000, 2048 KB
    Turok 2 (rev 1)     base 0x00200000, 2048 KB
    Turok 2 (Japan)     base 0x00200000, 2048 KB
    Turok 3             base 0x00200000, 2048 KB
    Turok: Rage Wars    base 0x00200000, 2048 KB
    Turok 1             none
    Super Mario 64      none
    Wave Race 64        none

A WINDOW IS NOT WHY TUROK 2 IS BLACK. Its recipe build already carries the mapped addresses and
still submits no display list. Fixing the address space brings a blind build up to parity with the
recipe build; whatever stops the recipe build stops both.

usage:  code_window.py <rom.z64 | rom.zip> [...]
"""
import os
import sys
import zipfile

BOOT_ROM_OFF = 0x1000          # the entry stub: ROM header 0x0..0x40, IPL3 0x40..0x1000
DEFAULT_SPAN = 0x800           # 512 instructions is well past every stub measured

COP0_ENTRYHI = 10
COP0_PAGEMASK = 5


def load_rom(path):
    """A cart as bytes, from a .z64 or from the .zip a user's library actually holds."""
    if path.lower().endswith(".zip"):
        with zipfile.ZipFile(path) as z:
            names = [n for n in z.namelist() if n.lower().endswith((".z64", ".n64", ".v64"))]
            if not names:
                raise ValueError("no cartridge image inside %s" % path)
            return z.read(names[0])
    with open(path, "rb") as f:
        return f.read()


def find_windows(rom, boot_rom_off=BOOT_ROM_OFF, span=DEFAULT_SPAN):
    """[(virtual_base, size_bytes), ...] for every mapped code window the boot stub installs."""
    word = lambda o: int.from_bytes(rom[o:o + 4], "big")
    regs = {}
    entry_hi = None
    page_mask = None
    out = []
    end = min(boot_rom_off + span, len(rom) - 4)
    for off in range(boot_rom_off, end, 4):
        w = word(off)
        op = w >> 26
        rs = (w >> 21) & 31
        rt = (w >> 16) & 31
        rd = (w >> 11) & 31
        fn = w & 0x3F
        if op == 0x0F:                                   # lui rt, imm
            regs[rt] = (w & 0xFFFF) << 16
        elif op == 0x0D and rs in regs:                  # ori rt, rs, imm
            regs[rt] = regs[rs] | (w & 0xFFFF)
        elif op == 0x09 and rs in regs:                  # addiu rt, rs, imm
            imm = w & 0xFFFF
            imm -= 0x10000 if imm & 0x8000 else 0
            regs[rt] = (regs[rs] + imm) & 0xFFFFFFFF
        elif op == 0x10:                                 # COP0
            if rs == 4:                                  # mtc0 rt, rd
                if rd == COP0_ENTRYHI:
                    entry_hi = regs.get(rt)
                elif rd == COP0_PAGEMASK:
                    page_mask = regs.get(rt)
            elif fn in (0x02, 0x06) and entry_hi is not None:   # tlbwi / tlbwr
                # KSEG0 here is the identity entry a libultra boot installs, not a code window.
                if 0 < entry_hi < 0x80000000:
                    pages = ((page_mask or 0) >> 13) + 1
                    base = entry_hi & ~0x1FFF               # VPN2
                    size = pages * 0x1000 * 2               # EntryLo0 + EntryLo1
                    if (base, size) not in out:
                        out.append((base, size))
    return out


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("-")]
    if not args:
        print(__doc__.strip().splitlines()[-1])
        return 2
    rc = 1
    for path in args:
        name = os.path.basename(path)
        if not os.path.exists(path):
            print("%-44s (not found)" % name)
            continue
        try:
            wins = find_windows(load_rom(path))
        except Exception as exc:                          # a bad dump is not a crash
            print("%-44s unreadable: %s" % (name, exc))
            continue
        if wins:
            rc = 0
            for base, size in wins:
                print("%-44s WINDOW base 0x%08X size %d KB" % (name, base, size // 1024))
        else:
            print("%-44s no mapped code window" % name)
    return rc


if __name__ == "__main__":
    sys.exit(main())
