#!/usr/bin/env python3
"""
recon.py — single-ROM identity for THE RECOMPILATOR's ingest pipeline.

Emits the identity scaffold_app.py / the front-end need: XXH3_64 (the app rom_hash),
entrypoint VRAM, internal name, SHA1, CIC family, size, byte order. Big-endian (.z64)
is the canonical form: .n64/.v64 are byteswapped first so the hash matches what
librecomp computes at load.

  python recon.py "<rom path>" [--game spaceinv] [--json out.json]

XXH3: uses the `xxhash` package if importable; otherwise the hash field is null and a
note is printed (read it from the first-boot diag log, which prints the actual hash, or
`pip install xxhash`). Everything else is stdlib-only.
"""
import sys
import argparse, hashlib, json, struct, sys
from pathlib import Path

# A CARTRIDGE TITLE CAN CONTAIN ANY CHARACTER, AND PRINTING IT MUST NEVER KILL THE TOOL.
# Python picks the console codepage for stdout on Windows (cp1252 here), so the moment a
# Japanese title reached a print() this whole bring-up died with UnicodeEncodeError
# (2026-09-07, Saikyou Habu Shougi). Say it in UTF-8 and replace what cannot be shown;
# files are written with an explicit encoding elsewhere and are unaffected.
try:
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")
except Exception:
    pass

try:
    import xxhash  # optional
    _HAVE_XXH = True
except Exception:
    _HAVE_XXH = False


# THE CARTRIDGE'S INTERNAL NAME IS NOT ALWAYS ASCII (Saikyou Habu Shougi (Japan), 2026-09-07).
# A Japanese cart writes its title at 0x20..0x34 in Shift-JIS (half-width katakana lives at 0xA1..0xDF),
# and reading those bytes as ASCII gives a row of question marks while latin1 gives mojibake. Try the
# encodings in the order that cannot lie: strict ASCII first (every US/EU cart), then cp932 (the Windows
# superset of Shift-JIS), then latin1 as a last resort so this never raises.
def decode_internal_name(raw: bytes) -> str:
    raw = raw.split(b"\x00")[0]
    for enc in ("ascii", "cp932", "latin1"):
        try:
            return raw.decode(enc).strip()
        except UnicodeDecodeError:
            continue
    return raw.decode("latin1", "replace").strip()

def to_z64(data: bytes) -> bytes:
    """Normalize any byte order to big-endian z64 by sniffing the magic at offset 0."""
    if len(data) < 4:
        return data
    b0, b1, b2, b3 = data[0], data[1], data[2], data[3]
    if (b0, b1, b2, b3) == (0x80, 0x37, 0x12, 0x40):       # z64 big-endian
        return data
    if (b0, b1, b2, b3) == (0x37, 0x80, 0x40, 0x12):       # v64 byteswapped (16-bit)
        ba = bytearray(data)
        ba[0::2], ba[1::2] = data[1::2], data[0::2]
        return bytes(ba)
    if (b0, b1, b2, b3) == (0x40, 0x12, 0x37, 0x80):       # n64 little-endian (32-bit)
        ba = bytearray(len(data))
        for i in range(0, len(data) - 3, 4):
            ba[i:i+4] = data[i:i+4][::-1]
        return bytes(ba)
    return data  # unknown; assume already z64


CIC = {  # crc of bytes 0x40..0x1000 -> CIC family (the common ones)
    0x6170A4A1: "6101", 0x90BB6CB5: "6102", 0x0B050EE0: "6103",
    0x98BC2C86: "6105", 0xACC8580A: "6106",
}


def boot_crc(head_and_bootcode: bytes) -> int:
    """IPL3 CRC32 over the 4032-byte bootcode (0x40..0x1000) — the canonical CIC fingerprint. (A plain 32-bit
    word-sum does NOT match the dict's CRC32 values, which is why this returned 'unknown' before — and the CIC
    entry-bias for 6103/6106 needs this correct.)"""
    import zlib
    return zlib.crc32(head_and_bootcode[0x40:0x1000]) & 0xFFFFFFFF


def recon(rom_path: Path) -> dict:
    raw = rom_path.read_bytes()
    data = to_z64(raw)
    head = data[:0x40]
    if head[:4] != b"\x80\x37\x12\x40":
        print("WARNING: not a recognizable N64 ROM header after normalization", file=sys.stderr)
    entry = struct.unpack(">I", head[0x08:0x0C])[0]
    clock = struct.unpack(">I", head[0x04:0x08])[0]
    crc1  = struct.unpack(">I", head[0x10:0x14])[0]
    crc2  = struct.unpack(">I", head[0x14:0x18])[0]
    name  = decode_internal_name(head[0x20:0x34])
    serial = head[0x3B:0x3F].decode("latin1", "replace")
    cic = CIC.get(boot_crc(data), "unknown")
    info = {
        "rom": str(rom_path),
        "internal_name": name,
        "serial": serial,
        "entrypoint": f"0x{entry:08X}",
        "cic": cic,
        "crc1": f"0x{crc1:08X}",
        "crc2": f"0x{crc2:08X}",
        "size": len(data),
        "byteorder_in": {0x80: "z64", 0x37: "v64", 0x40: "n64"}.get(raw[0], "?"),
        "sha1": hashlib.sha1(data).hexdigest(),
        "xxh3_64": (f"0x{xxhash.xxh3_64_intdigest(data):016X}" if _HAVE_XXH else None),
    }
    return info


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("rom")
    ap.add_argument("--game", default=None, help="game id (recorded for the pipeline)")
    ap.add_argument("--json", default=None, help="write recon.json here")
    a = ap.parse_args()
    p = Path(a.rom)
    if not p.is_file():
        sys.exit(f"ERROR: ROM not found: {p}")
    info = recon(p)
    if a.game:
        info["game"] = a.game

    print("== RECON ==")
    for k in ("game", "internal_name", "serial", "entrypoint", "cic", "crc1", "crc2",
              "size", "byteorder_in", "sha1", "xxh3_64"):
        if k in info:
            print(f"  {k:14} {info[k]}")
    if not _HAVE_XXH:
        print("  NOTE: xxh3_64 is null (no `xxhash` package). The app's rom_hash comes from")
        print("        the first-boot diag log (it prints the computed hash) or `pip install xxhash`.")

    out = Path(a.json) if a.json else None
    if out:
        out.write_text(json.dumps(info, indent=2), encoding="utf-8")
        print(f"  -> wrote {out}")


if __name__ == "__main__":
    main()
