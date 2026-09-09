// Structured diagnostics sink — implementation (recompilator roadmap tool #1).
// See include/recompiler/diag_sink.h for the design + per-kind field meanings.
//
// Single thread-safe implementation shared by the recompiler (N64Recomp.exe) and the runtime
// (librecomp/game.exe) via the leaf lib N64RecompDiag. Dependency-free (std only) so it can be a clean
// leaf with no link cycles. No-op until env RECOMP_DIAG is set.

#include "recompiler/diag_sink.h"

#include <cstdlib>
#include <cstdio>
#include <ctime>
#include <map>
#include <mutex>
#include <vector>
#include <string>
#include <fstream>

namespace {

struct Agg {
    uint64_t hit_count = 0;
    std::string func;
    std::string detail;
    uint32_t a = 0, b = 0, c = 0, d = 0;
    uint32_t section_index = UINT32_MAX;
    uint32_t func_index = UINT32_MAX;
    std::vector<uint32_t> words;
};

// Ordered map keyed by (kind, vaddr) → iteration is already sorted (stable diffs across rebuilds).
using Key = std::pair<std::string, uint32_t>;

std::mutex g_mtx;
std::map<Key, Agg> g_events;

void json_escape(std::string& out, std::string_view s) {
    for (char ch : s) {
        switch (ch) {
            case '"':  out += "\\\""; break;
            case '\\': out += "\\\\"; break;
            case '\n': out += "\\n";  break;
            case '\r': out += "\\r";  break;
            case '\t': out += "\\t";  break;
            default:
                if (static_cast<unsigned char>(ch) < 0x20) {
                    char buf[8];
                    std::snprintf(buf, sizeof(buf), "\\u%04x", static_cast<unsigned>(static_cast<unsigned char>(ch)));
                    out += buf;
                } else {
                    out += ch;
                }
        }
    }
}

void append_hex(std::string& out, uint32_t v) {
    char buf[16];
    std::snprintf(buf, sizeof(buf), "0x%08X", v);
    out += buf;
}

} // namespace

namespace N64Recomp::diag {

bool enabled() {
    static const bool g_enabled = (std::getenv("RECOMP_DIAG") != nullptr);
    return g_enabled;
}

void record(const Event& e) {
    if (!enabled()) {
        return;
    }
    std::lock_guard<std::mutex> lock(g_mtx);
    Key key{ std::string(e.kind), e.vaddr };
    auto [it, inserted] = g_events.try_emplace(key);
    Agg& agg = it->second;
    agg.hit_count++;
    if (inserted) {
        // Retain the first sighting's payload (cheap repeats just bump hit_count).
        agg.func.assign(e.func);
        agg.detail.assign(e.detail);
        agg.a = e.a; agg.b = e.b; agg.c = e.c; agg.d = e.d;
        agg.section_index = e.section_index;
        agg.func_index = e.func_index;
        if (e.words != nullptr && e.word_count > 0) {
            agg.words.assign(e.words, e.words + e.word_count);
        }
    }
}

size_t event_count() {
    std::lock_guard<std::mutex> lock(g_mtx);
    return g_events.size();
}

bool flush_to_file(const std::string& path, std::string_view stage, std::string_view extra_top_level_json) {
    std::lock_guard<std::mutex> lock(g_mtx);

    std::string out;
    out.reserve(256 + g_events.size() * 160);
    out += "{\n  \"schema\": \"n64recomp.diag.v1\",\n  \"stage\": \"";
    json_escape(out, stage);
    out += "\",\n  \"total_events\": ";
    out += std::to_string(g_events.size());
    out += ",\n  \"events\": [";

    bool first = true;
    for (const auto& [key, agg] : g_events) {
        out += first ? "\n    {" : ",\n    {";
        first = false;
        out += " \"kind\": \"";
        json_escape(out, key.first);
        out += "\", \"vaddr\": \"";
        append_hex(out, key.second);
        out += "\", \"hit_count\": ";
        out += std::to_string(agg.hit_count);
        if (!agg.func.empty())   { out += ", \"func\": \"";   json_escape(out, agg.func);   out += "\""; }
        if (!agg.detail.empty()) { out += ", \"detail\": \""; json_escape(out, agg.detail); out += "\""; }
        if (agg.section_index != UINT32_MAX) { out += ", \"section_index\": "; out += std::to_string(agg.section_index); }
        if (agg.func_index != UINT32_MAX)    { out += ", \"func_index\": ";    out += std::to_string(agg.func_index); }
        if (agg.a) { out += ", \"a\": "; out += std::to_string(agg.a); }
        if (agg.b) { out += ", \"b\": "; out += std::to_string(agg.b); }
        if (agg.c) { out += ", \"c\": "; out += std::to_string(agg.c); }
        if (agg.d) { out += ", \"d\": "; out += std::to_string(agg.d); }
        if (!agg.words.empty()) {
            out += ", \"rdram_words\": [";
            for (size_t i = 0; i < agg.words.size(); i++) {
                if (i) out += ", ";
                out += "\"";
                append_hex(out, agg.words[i]);
                out += "\"";
            }
            out += "]";
        }
        out += " }";
    }
    out += first ? "]" : "\n  ]";

    if (!extra_top_level_json.empty()) {
        out += extra_top_level_json;
    }
    out += "\n}\n";

    std::ofstream f(path, std::ios::binary | std::ios::trunc);
    if (!f.is_open()) {
        std::fprintf(stderr, "[diag] failed to open %s for the diagnostics report\n", path.c_str());
        return false;
    }
    f.write(out.data(), static_cast<std::streamsize>(out.size()));
    bool ok = f.good();
    f.close();
    if (ok) {
        std::fprintf(stderr, "[diag] wrote %zu event(s) -> %s\n", g_events.size(), path.c_str());
    }
    return ok;
}

} // namespace N64Recomp::diag
