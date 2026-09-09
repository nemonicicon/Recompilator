#!/usr/bin/env python3
"""libultra_shapes.py - the shape of a library function, without its code.

match_libultra.py names the operating-system layer of a cartridge by comparing the cartridge's
code against reference builds of the N64 library. The references themselves are not something
a release can carry. What the matcher actually needs from a reference function is much less
than its code, and this module defines exactly that much:

  * one-way hashes of the function's MASKED instruction prefixes, one per length, where the
    mask hides every immediate, load/store offset and jump target (the same mask the matcher
    has always compared under);
  * the positions of its calls and the NAMES of the functions called there;
  * the immediates the matcher scores when two names claim one address, each XOR-ed with a
    key derived from the masked prefix in front of it - readable only by code that already
    has a byte-for-byte matching body in front of it.

Nothing in a shape can be turned back into an instruction. The hashes are keyed BLAKE2b digests
of a polynomial hash of the masked words, so no prefix length reveals the word that extends it.
The polynomial hash exists only so that a cartridge can be scanned in linear time: every window
of the cartridge is hashed once, and a shape is looked up by its digest.

The same shape is built from a reference on the machine that has one (tools/make_libultra_sigdb.py)
and read back from recompilator/data/libultra_sigdb.json everywhere else, so the matcher runs one
code path in both places.
"""
import base64
import hashlib
import re
import struct
from collections import defaultdict

P = (1 << 61) - 1
B1 = 0x1D3F5B7A9C2E4F61 % P
B2 = 0x2F1C7E5A3D9B8C47 % P
KEY_F = b"recompilator/libultra-shape/3"
KEY_I = b"recompilator/libultra-imm/3"
DIGEST = 8
MIN_W = 4          # the shortest prefix any pass asks about (pass 4 verifies bodies of 4+ words)
WINDOW_MIN = 16    # pass 1 never reads fewer words than this

GENERIC_NAME = re.compile(r"(func|D|B|jtbl|jpt)_[0-9A-Fa-f]{6,}")
RMON_NOISE = frozenset({"send", "send_mesg", "send_packet", "kdebugserver", "string_to_u32", "handle_CpU"})
IMM_OPS = frozenset([0x08, 0x09, 0x0A, 0x0C, 0x0D, 0x0E]) | frozenset(range(0x20, 0x40))

_pow1 = [1]
_pow2 = [1]


def _pows(L):
    while len(_pow1) <= L:
        _pow1.append(_pow1[-1] * B1 % P)
        _pow2.append(_pow2[-1] * B2 % P)


def mask_for(word):
    """The compare mask for one instruction word: immediates, offsets and jump targets are hidden."""
    op = word >> 26
    if op in (2, 3):                      # j / jal - keep opcode only
        return 0xFC000000
    if op == 0x0F:                        # lui - keep op/rt
        return 0xFFFF0000
    if op in (0x08, 0x09, 0x0C, 0x0D, 0x0E):  # addi/addiu/andi/ori/xori
        return 0xFFFF0000
    if 0x20 <= op <= 0x3F:                # all loads/stores (incl. lwc/swc/ldc/sdc/ll/sc)
        return 0xFFFF0000
    return 0xFFFFFFFF


class PrefixHash:
    """Polynomial prefix hashes of a word sequence under the mask, so any window hashes in O(1)."""
    __slots__ = ("h1", "h2", "n")

    def __init__(self, words):
        h1 = [0]
        h2 = [0]
        a = b = 0
        for w in words:
            m = w & mask_for(w)
            a = (a * B1 + m) % P
            b = (b * B2 + m) % P
            h1.append(a)
            h2.append(b)
        self.h1, self.h2, self.n = h1, h2, len(words)
        _pows(len(words))

    def window(self, p, L):
        return ((self.h1[p + L] - self.h1[p] * _pow1[L]) % P,
                (self.h2[p + L] - self.h2[p] * _pow2[L]) % P)


def digest(r):
    return hashlib.blake2b(struct.pack(">QQ", r[0], r[1]), digest_size=DIGEST, key=KEY_F).digest()


def imm_key(r, k):
    return int.from_bytes(hashlib.blake2b(struct.pack(">QQI", r[0], r[1], k), digest_size=2, key=KEY_I).digest(), "big")


class Shape:
    """One reference function: what the matcher may ask about it, and nothing it could rebuild."""
    __slots__ = ("name", "vram", "size", "n", "L1", "L3", "wmax", "f", "calls", "imms")

    def __init__(self, name, vram, size, L3, f, calls, imms):
        self.name = name
        self.vram = vram
        self.size = size
        self.n = size // 4
        self.L1 = max(self.n, WINDOW_MIN)
        self.L3 = L3                 # the body with its trailing zero words trimmed; None if unknown
        self.f = f                   # digests for W = MIN_W .. wmax
        self.wmax = len(f) + MIN_W - 1
        self.calls = calls           # [(k, op, [names at the target])]  k < wmax
        self.imms = imms             # [(k, enc16)]                       k < wmax, ascending k

    def F(self, W):
        if MIN_W <= W <= self.wmax:
            return self.f[W - MIN_W]
        return None


def build_shape(name, vram, size, words, names_at):
    """words = the reference's instruction words from the function's start, as many as the passes
    read (max(size/4, 16)) or as many as the reference has; names_at(addr) -> names in symbol order."""
    n = size // 4
    L1 = max(n, WINDOW_MIN)
    words = list(words[:L1])
    ph = PrefixHash(words)
    L3 = None
    if n <= len(words):
        t = n
        while t > 0 and words[t - 1] == 0:
            t -= 1
        L3 = t
    f = [digest(ph.window(0, W)) for W in range(MIN_W, len(words) + 1)]
    calls = []
    imms = []
    for k, w in enumerate(words):
        op = w >> 26
        if op in (2, 3):
            names = names_at(0x80000000 | ((w & 0x03FFFFFF) << 2))
            if names:
                calls.append((k, op, list(names)))
        if op in IMM_OPS and (w & 0xFFFF):
            imms.append((k, (w & 0xFFFF) ^ imm_key(ph.window(0, k + 1), k)))
    return Shape(name, vram, size, L3, f, calls, imms)


def shape_to_json(sh):
    flat = []
    for k, e in sh.imms:
        flat += [k, e]
    return {"v": sh.vram, "s": sh.size, "t": -1 if sh.L3 is None else sh.L3,
            "f": base64.b64encode(b"".join(sh.f)).decode("ascii"),
            "c": [[k, op, names] for k, op, names in sh.calls],
            "i": base64.b64encode(struct.pack(">%dH" % len(flat), *flat)).decode("ascii")}


def shape_from_json(name, j):
    fb = base64.b64decode(j["f"])
    f = [fb[i:i + DIGEST] for i in range(0, len(fb), DIGEST)]
    ib = base64.b64decode(j["i"])
    flat = struct.unpack(">%dH" % (len(ib) // 2), ib)
    imms = [(flat[i], flat[i + 1]) for i in range(0, len(flat), 2)]
    calls = [(c[0], c[1], list(c[2])) for c in j["c"]]
    L3 = None if j["t"] < 0 else j["t"]
    return Shape(name, j["v"], j["s"], L3, f, calls, imms)


class GameIndex:
    """The cartridge side: every region's masked words hashed once, looked up by digest."""

    def __init__(self, regions):
        # regions = [(rom_start, vram, words)] exactly as match_libultra builds them
        self.regions = regions
        self.ph = [PrefixHash(words) for (_, _, words) in regions]
        self._idx = {}

    def index(self, K):
        d = self._idx.get(K)
        if d is None:
            d = defaultdict(list)
            for ri, (_, _, words) in enumerate(self.regions):
                ph = self.ph[ri]
                for p in range(len(words) - K + 1):
                    d[digest(ph.window(p, K))].append((ri, p))
            self._idx[K] = d
        return d

    def region_of(self, vram):
        for rom_start, base, words in self.regions:
            if base <= vram < base + len(words) * 4:
                return base, words
        return None, None

    def _locate(self, vram):
        for ri, (rom_start, base, words) in enumerate(self.regions):
            if base <= vram < base + len(words) * 4:
                return ri, (vram - base) // 4
        return None, None

    def search(self, shape, W):
        """Every address whose masked W-word window equals the shape's masked W-word prefix."""
        f = shape.F(W)
        if f is None:
            return []
        K = 16 if W >= 16 else (8 if W >= 8 else MIN_W)
        hits = set()
        for ri, p in self.index(K).get(shape.F(K), ()):
            rom_start, vram, words = self.regions[ri]
            if p + W > len(words):
                continue
            if digest(self.ph[ri].window(p, W)) == f:
                hits.add(vram + p * 4)
        return sorted(hits)

    def matches_at(self, shape, W, vram):
        f = shape.F(W)
        if f is None:
            return False
        ri, p = self._locate(vram)
        if ri is None or p + W > len(self.regions[ri][2]):
            return False
        return digest(self.ph[ri].window(p, W)) == f

    def imm_score(self, shape, L, vram):
        """(mismatches, checked) of the shape's immediates against the cartridge at vram, over the
        first L words - the words that matched there. Fewer mismatches wins; more checked breaks ties."""
        ri, p = self._locate(vram)
        if ri is None:
            return (1 << 30, 0)
        words = self.regions[ri][2]
        ph = self.ph[ri]
        mism = checked = 0
        for k, enc in shape.imms:
            if k >= L or p + k >= len(words):
                break
            g = words[p + k]
            if (g >> 26) not in IMM_OPS:
                continue
            checked += 1
            if (g & 0xFFFF) != (enc ^ imm_key(ph.window(p, k + 1), k)):
                mism += 1
        return (mism, checked)
