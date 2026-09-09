/**
 * launcher_hash.cpp — "is this ROM in the catalog?"
 *
 * The catalog stores rom.sha1 of the .z64 (big-endian) image. The user's file may be:
 *   - a bare .z64                       -> hash it
 *   - a .n64 / .v64 (swapped orders)    -> byte-swap into z64 order, then hash
 *   - a .zip carrying any of the above  -> extract the member in memory (miniz, bundled in RT64)
 *
 * SHA-1 is implemented here rather than pulled in: the engine has no SHA-1 (it identifies ROMs by
 * XXH3), and the launcher must not change the engine.
 */

#include "launcher_app.hpp"

#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <vector>

#include <miniz/miniz.h>

namespace fs = std::filesystem;

namespace launcher {

// ── SHA-1 (FIPS 180-1), streaming ─────────────────────────────────────────────
namespace {

struct Sha1 {
    uint32_t h[5]  = { 0x67452301u, 0xEFCDAB89u, 0x98BADCFEu, 0x10325476u, 0xC3D2E1F0u };
    uint64_t total = 0;
    uint8_t  buf[64] = {};
    size_t   have = 0;

    static uint32_t rol(uint32_t v, int n) { return (v << n) | (v >> (32 - n)); }

    void block(const uint8_t* p) {
        uint32_t w[80];
        for (int i = 0; i < 16; i++) {
            w[i] = ((uint32_t)p[i * 4 + 0] << 24) | ((uint32_t)p[i * 4 + 1] << 16) |
                   ((uint32_t)p[i * 4 + 2] << 8)  |  (uint32_t)p[i * 4 + 3];
        }
        for (int i = 16; i < 80; i++) w[i] = rol(w[i - 3] ^ w[i - 8] ^ w[i - 14] ^ w[i - 16], 1);

        uint32_t a = h[0], b = h[1], c = h[2], d = h[3], e = h[4];
        for (int i = 0; i < 80; i++) {
            uint32_t f, k;
            if (i < 20)      { f = (b & c) | (~b & d);                k = 0x5A827999u; }
            else if (i < 40) { f = b ^ c ^ d;                         k = 0x6ED9EBA1u; }
            else if (i < 60) { f = (b & c) | (b & d) | (c & d);       k = 0x8F1BBCDCu; }
            else             { f = b ^ c ^ d;                         k = 0xCA62C1D6u; }
            uint32_t t = rol(a, 5) + f + e + k + w[i];
            e = d; d = c; c = rol(b, 30); b = a; a = t;
        }
        h[0] += a; h[1] += b; h[2] += c; h[3] += d; h[4] += e;
    }

    void update(const uint8_t* p, size_t n) {
        total += n;
        while (n > 0) {
            size_t take = std::min(n, size_t(64) - have);
            std::memcpy(buf + have, p, take);
            have += take; p += take; n -= take;
            if (have == 64) { block(buf); have = 0; }
        }
    }

    std::string hex() {
        uint64_t bits = total * 8;
        uint8_t pad = 0x80;
        update(&pad, 1);
        uint8_t zero = 0;
        while (have != 56) update(&zero, 1);
        uint8_t len[8];
        for (int i = 0; i < 8; i++) len[i] = (uint8_t)(bits >> (56 - i * 8));
        update(len, 8);

        char out[41];
        for (int i = 0; i < 5; i++) std::snprintf(out + i * 8, 9, "%08x", h[i]);
        return std::string(out, 40);
    }
};

std::string lower_ext(const std::string& name) {
    auto dot = name.find_last_of('.');
    if (dot == std::string::npos) return std::string();
    std::string e = name.substr(dot);
    for (char& c : e) c = (char)std::tolower((unsigned char)c);
    return e;
}

bool is_rom_ext(const std::string& e) { return e == ".z64" || e == ".n64" || e == ".v64"; }

// Normalise a whole ROM image into z64 (big-endian) order in place, from its magic word.
void to_z64_order(std::vector<uint8_t>& d) {
    if (d.size() < 4) return;
    const uint32_t magic = ((uint32_t)d[0] << 24) | ((uint32_t)d[1] << 16) |
                           ((uint32_t)d[2] << 8)  |  (uint32_t)d[3];
    if (magic == 0x80371240u) return;                        // already z64
    if (magic == 0x37804012u) {                              // v64: byte-swapped halfwords
        for (size_t i = 0; i + 1 < d.size(); i += 2) std::swap(d[i], d[i + 1]);
    } else if (magic == 0x40123780u) {                       // n64: little-endian words
        for (size_t i = 0; i + 3 < d.size(); i += 4) {
            std::swap(d[i], d[i + 3]);
            std::swap(d[i + 1], d[i + 2]);
        }
    }
}

std::string hash_bytes(std::vector<uint8_t>& d) {
    to_z64_order(d);
    Sha1 s;
    s.update(d.data(), d.size());
    return s.hex();
}

} // namespace

// The ROM header's own fields, read after the image is in z64 order. Nothing here is a guess and
// nothing is per-game: this is the cartridge describing itself.
static void fill_header(const std::vector<uint8_t>& d, RomIdentity& id) {
    id.size = (uint64_t)d.size();
    if (d.size() < 0x40) return;
    char name[21] = {};
    size_t n = 0;
    for (size_t i = 0x20; i < 0x34; i++) {
        if (d[i] == 0) continue;
        name[n++] = (char)d[i];
    }
    id.internal_name = name;
    while (!id.internal_name.empty() && id.internal_name.back() == ' ') id.internal_name.pop_back();
    while (!id.internal_name.empty() && id.internal_name.front() == ' ') id.internal_name.erase(0, 1);
    std::string serial;
    for (size_t i = 0x3B; i < 0x3F; i++) if (d[i] > 32) serial += (char)d[i];
    id.serial = serial;
    const uint32_t entry = ((uint32_t)d[8] << 24) | ((uint32_t)d[9] << 16) |
                           ((uint32_t)d[10] << 8) |  (uint32_t)d[11];
    char buf[16] = {};
    std::snprintf(buf, sizeof(buf), "0x%08X", entry);
    id.entrypoint = buf;
}

bool rom_identity(const std::string& path, RomIdentity& out, std::string& error_out) {
    out = RomIdentity{};
    std::string member;
    std::string err;
    std::vector<uint8_t> data;

    std::error_code ec;
    if (!fs::exists(path, ec)) { error_out = "no such file"; return false; }

    if (lower_ext(path) == ".zip") {
        mz_zip_archive zip{};
        if (!mz_zip_reader_init_file(&zip, path.c_str(), 0)) {
            error_out = "could not open the zip";
            return false;
        }
        const mz_uint count = mz_zip_reader_get_num_files(&zip);
        for (mz_uint i = 0; i < count; i++) {
            mz_zip_archive_file_stat st{};
            if (!mz_zip_reader_file_stat(&zip, i, &st)) continue;
            if (st.m_is_directory) continue;
            const std::string name = st.m_filename;
            if (!is_rom_ext(lower_ext(name))) continue;
            size_t size = 0;
            void* mem = mz_zip_reader_extract_to_heap(&zip, i, &size, 0);
            if (mem == nullptr) { err = "could not inflate " + name; break; }
            data.assign((uint8_t*)mem, (uint8_t*)mem + size);
            mz_free(mem);
            member = name;
            break;
        }
        mz_zip_reader_end(&zip);
        if (data.empty()) {
            error_out = err.empty() ? "no .z64/.n64/.v64 member in the zip" : err;
            return false;
        }
    } else {
        std::ifstream f(path, std::ios::binary);
        if (!f) { error_out = "could not read the file"; return false; }
        data.assign((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
        if (data.empty()) { error_out = "the file is empty"; return false; }
    }

    to_z64_order(data);
    Sha1 s;
    s.update(data.data(), data.size());
    out.sha1 = s.hex();
    out.member = member;
    fill_header(data, out);
    return true;
}

std::string rom_sha1(const std::string& path, std::string& member_out, std::string& error_out) {
    member_out.clear();
    error_out.clear();

    std::error_code ec;
    if (!fs::exists(path, ec)) { error_out = "no such file"; return std::string(); }

    const std::string ext = lower_ext(path);

    if (ext == ".zip") {
        mz_zip_archive zip{};
        if (!mz_zip_reader_init_file(&zip, path.c_str(), 0)) {
            error_out = "could not open the zip";
            return std::string();
        }
        const mz_uint count = mz_zip_reader_get_num_files(&zip);
        std::string hash;
        for (mz_uint i = 0; i < count; i++) {
            mz_zip_archive_file_stat st{};
            if (!mz_zip_reader_file_stat(&zip, i, &st)) continue;
            if (st.m_is_directory) continue;
            const std::string name = st.m_filename;
            if (!is_rom_ext(lower_ext(name))) continue;

            size_t size = 0;
            void* mem = mz_zip_reader_extract_to_heap(&zip, i, &size, 0);
            if (mem == nullptr) { error_out = "could not inflate " + name; break; }
            std::vector<uint8_t> data((uint8_t*)mem, (uint8_t*)mem + size);
            mz_free(mem);
            hash = hash_bytes(data);
            member_out = name;
            break;
        }
        mz_zip_reader_end(&zip);
        if (hash.empty() && error_out.empty()) error_out = "no .z64/.n64/.v64 member in the zip";
        return hash;
    }

    std::ifstream f(path, std::ios::binary);
    if (!f) { error_out = "could not read the file"; return std::string(); }
    std::vector<uint8_t> data((std::istreambuf_iterator<char>(f)), std::istreambuf_iterator<char>());
    if (data.empty()) { error_out = "the file is empty"; return std::string(); }
    return hash_bytes(data);
}

} // namespace launcher
