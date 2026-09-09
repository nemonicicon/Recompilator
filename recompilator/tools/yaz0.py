#!/usr/bin/env python3
"""yaz0.py — THE RECOMPILATOR generic Yaz0 decompressor (SINGLE SOURCE).

Yaz0 is Nintendo's stock run-length/back-reference codec: it is what libultra-era first-party
carts (both Zeldas, Doubutsu no Mori, Mario Party, ...) use to store their DMA file table's
files, and it is the ONE format that stood between this pipeline and every Yaz0 cart's real
instruction bytes (the pipeline previously owned only a gzip/raw-deflate inflater,
tools/decompress_overlays.py).

FORMAT (self-describing; the whole of it):
    +0x00  char[4]  "Yaz0"                     magic
    +0x04  u32 BE   decompressed size          the file declares its own output length
    +0x08  u32 BE   reserved (alignment hint on some carts; ignored)
    +0x0C  u32 BE   reserved
    +0x10  ...      the code stream
  The code stream is groups of 8 operations preceded by ONE code byte, read MSB first:
    bit 1 -> emit the next input byte verbatim.
    bit 0 -> back-reference, 2 or 3 bytes:  b0 b1 [b2]
             dist  = ((b0 & 0x0F) << 8) | b1      ; distance-1 back from the write head
             count = b0 >> 4
             count == 0 -> count = b2 + 0x12      (the 3-byte long form)
             count != 0 -> count += 2
             copy `count` bytes from (out_len - dist - 1) FORWARD, one byte at a time, so an
             overlapping run (dist+1 < count) legally repeats itself — that is the RLE case.
  Decoding stops when `decompressed size` bytes have been produced; trailing padding to the
  next 16-byte boundary is not part of the stream.

Usage
    yaz0.py decompress <in.yaz0> <out.bin>        decompress one file
    yaz0.py info <file> [offset]                  print magic / declared size at a ROM offset
    yaz0.py verify <rom> <off> <declared_size>    decompress in place, check the length
As a module
    yaz0.is_yaz0(buf, off=0) -> bool
    yaz0.declared_size(buf, off=0) -> int
    yaz0.decompress(buf, off=0, limit=None) -> bytes
    yaz0.decompress_checked(buf, off, expected) -> bytes   (raises on a length mismatch)
"""
import struct
import sys

MAGIC = b"Yaz0"
HEADER_SIZE = 0x10


def is_yaz0(buf, off=0):
    """True when the buffer holds the Yaz0 magic at `off`."""
    return bytes(buf[off:off + 4]) == MAGIC


def declared_size(buf, off=0):
    """The decompressed length the file declares in its own header."""
    if not is_yaz0(buf, off):
        raise ValueError(f"no Yaz0 magic at offset 0x{off:X}")
    return struct.unpack_from(">I", buf, off + 4)[0]


def decompress(buf, off=0, limit=None):
    """Decompress the Yaz0 file starting at `off` in `buf`.

    `limit` bounds how far the code stream may read (the end of the compressed file when known);
    it is a safety rail only — the declared size is what terminates the loop.
    """
    if not is_yaz0(buf, off):
        raise ValueError(f"no Yaz0 magic at offset 0x{off:X}")
    out_size = struct.unpack_from(">I", buf, off + 4)[0]
    src = off + HEADER_SIZE
    end = len(buf) if limit is None else min(len(buf), off + limit)
    out = bytearray(out_size)
    dst = 0
    code = 0
    code_bits = 0
    while dst < out_size:
        if code_bits == 0:
            if src >= end:
                raise ValueError(f"Yaz0 stream at 0x{off:X} ran out of input "
                                 f"(produced {dst} of {out_size} B)")
            code = buf[src]
            src += 1
            code_bits = 8
        if code & 0x80:
            # literal
            if src >= end:
                raise ValueError(f"Yaz0 stream at 0x{off:X} truncated in a literal")
            out[dst] = buf[src]
            src += 1
            dst += 1
        else:
            # back-reference
            if src + 1 >= end:
                raise ValueError(f"Yaz0 stream at 0x{off:X} truncated in a back-reference")
            b0 = buf[src]
            b1 = buf[src + 1]
            src += 2
            dist = ((b0 & 0x0F) << 8) | b1
            count = b0 >> 4
            if count == 0:
                if src >= end:
                    raise ValueError(f"Yaz0 stream at 0x{off:X} truncated in a long run")
                count = buf[src] + 0x12
                src += 1
            else:
                count += 2
            copy_from = dst - dist - 1
            if copy_from < 0:
                raise ValueError(f"Yaz0 stream at 0x{off:X} back-references before the output start")
            if dst + count > out_size:
                count = out_size - dst           # a final run may overrun the declared size
            for _ in range(count):               # byte-at-a-time: overlapping runs are legal (RLE)
                out[dst] = out[copy_from]
                dst += 1
                copy_from += 1
        code = (code << 1) & 0xFF
        code_bits -= 1
    return bytes(out), src - off                 # decompressed bytes, consumed input length


def decompress_checked(buf, off, expected):
    """Decompress and HARD-assert the declared/produced length against `expected`."""
    dec, _used = decompress(buf, off)
    if len(dec) != expected:
        raise ValueError(f"Yaz0 at 0x{off:X}: decompressed {len(dec)} B, expected {expected} B")
    return dec


def main(argv):
    if len(argv) < 2:
        print(__doc__)
        return 2
    cmd = argv[1]
    if cmd == "decompress" and len(argv) >= 4:
        data = open(argv[2], "rb").read()
        dec, used = decompress(data)
        open(argv[3], "wb").write(dec)
        print(f"[yaz0] {argv[2]}: {used} B compressed -> {len(dec)} B -> {argv[3]}")
        return 0
    if cmd == "info" and len(argv) >= 3:
        off = int(argv[3], 0) if len(argv) >= 4 else 0
        data = open(argv[2], "rb").read()
        if not is_yaz0(data, off):
            print(f"[yaz0] 0x{off:X}: NOT Yaz0 (magic {bytes(data[off:off+4])!r})")
            return 1
        print(f"[yaz0] 0x{off:X}: Yaz0, declared decompressed size {declared_size(data, off)} B")
        return 0
    if cmd == "verify" and len(argv) >= 5:
        data = open(argv[2], "rb").read()
        off = int(argv[3], 0)
        exp = int(argv[4], 0)
        dec = decompress_checked(data, off, exp)
        print(f"[yaz0] 0x{off:X}: OK, {len(dec)} B")
        return 0
    print(__doc__)
    return 2


if __name__ == "__main__":
    sys.exit(main(sys.argv))
