#include <cassert>
#include <cstdint>
#include <algorithm>
#include <unordered_map>
#include <vector>

#include "ultramodern/ultramodern.hpp"

// HOST-SIDE THREAD-QUEUE MEMBERSHIP (completes the 94149a3 host-context map; NC level-freeze root).
//
// These queues used to link through the guest TCB's next/queue fields — memory the game may legally
// overwrite (TCBs are game-owned on hardware; Kalisto's Nightmare Creatures repurposes the boot game
// TCB as its own task record at level entry). The engine then made park/wake decisions from scribbled
// data: insert() read t->queue and either no-op'd ("already on this queue") or walked a garbage chain,
// so a parking receiver could fail to actually join blocked_on_recv — do_send then saw no waiter, the
// thread waited on a semaphore nobody signals, and the delivered reply sat in the ring forever (the
// deterministic Chelsea load-complete freeze; queue-ledger-proven, NC RUN 61).
//
// Hardware survives the same scribble: libultra's enqueue rewrites the link fields itself and a sole
// waiter is popped regardless of a garbage priority. Restore that robustness by keeping ALL membership
// state host-side, keyed by guest addresses. Guest TCB fields are neither read nor written for queue
// bookkeeping anymore (priority is still read once at insert for ordering — libultra reads it too).
//
// Invariants preserved from the previous implementation:
//  - single membership: same-queue re-insert is a no-op; joining a different queue leaves the old one
//    (authority is now the host map, immune to TCB scribbles);
//  - ordering: descending priority, new thread placed BEFORE existing equal-priority members (exactly
//    the old `while (cur->priority > toadd->priority)` walk);
//  - remove() unlinks interior nodes (the head-only bug stays fixed structurally).

namespace {
    // queue id = the guest address of the queue head field (OSMesgQueue blocked_on_recv/send) or the
    // ultramodern::running_queue sentinel (-1). Only an identity — never dereferenced.
    std::unordered_map<uint32_t, std::vector<PTR(OSThread)>> g_queue_members; // head first
    std::unordered_map<uint32_t, uint32_t> g_member_of;                       // TCB addr -> queue id
    // HOST-CACHED PRIORITY (NC RUN 63, the pop-starvation root): the TCB priority field is
    // game-writable like the rest of the TCB — Kalisto's level-entry record write zeroes it, and
    // ordering by the live guest field then ranked the woken game thread (0) below its own pri-10
    // idle spinner in the pause_self pump, so run_next_thread never popped it again (deterministic
    // Chelsea freeze). Scheduling decisions use the priority the OS was TOLD — snapshotted at the
    // libultra API surface (osCreateThread / osSetThreadPri) — never the raw TCB field. Games that
    // set priority only through the API (the API contract) see identical ordering.
    std::unordered_map<uint32_t, int32_t> g_cached_pri;                       // TCB addr -> API pri
}

void ultramodern::thread_queue_note_priority(PTR(OSThread) t_, s32 pri) {
    g_cached_pri[(uint32_t)t_] = (int32_t)pri;
}

static int32_t effective_priority(RDRAM_ARG PTR(OSThread) t_) {
    auto it = g_cached_pri.find((uint32_t)t_);
    if (it != g_cached_pri.end()) {
        return it->second;
    }
    // Thread never seen at the API surface (shouldn't happen for HLE threads) — guest field fallback.
    return TO_PTR(OSThread, t_)->priority;
}

s32 ultramodern::thread_queue_priority(RDRAM_ARG PTR(OSThread) t_) {
    return effective_priority(PASS_RDRAM t_);
}

void ultramodern::thread_queue_insert(RDRAM_ARG PTR(PTR(OSThread)) queue_, PTR(OSThread) toadd_) {
    const uint32_t qid = (uint32_t)queue_;
    const uint32_t tid = (uint32_t)toadd_;

    auto cur = g_member_of.find(tid);
    if (cur != g_member_of.end()) {
        if (cur->second == qid) {
            return; // single-membership: same-queue re-insert is a no-op
        }
        thread_queue_remove(PASS_RDRAM (PTR(PTR(OSThread)))cur->second, toadd_);
    }

    OSThread* toadd = TO_PTR(OSThread, toadd_);
    debug_printf("[Thread Queue] Inserting thread %d into queue 0x%08X\n", toadd->id, (uintptr_t)queue_);

    const int32_t toadd_pri = effective_priority(PASS_RDRAM toadd_);
    std::vector<PTR(OSThread)>& members = g_queue_members[qid];
    auto pos = members.begin();
    while (pos != members.end() && effective_priority(PASS_RDRAM *pos) > toadd_pri) {
        ++pos;
    }
    members.insert(pos, toadd_);
    g_member_of[tid] = qid;
}

PTR(OSThread) ultramodern::thread_queue_pop(RDRAM_ARG PTR(PTR(OSThread)) queue_) {
    auto it = g_queue_members.find((uint32_t)queue_);
    if (it == g_queue_members.end() || it->second.empty()) {
        return NULLPTR; // callers gate on thread_queue_empty(); defensive instead of deref'ing null
    }
    PTR(OSThread) ret = it->second.front();
    it->second.erase(it->second.begin());
    g_member_of.erase((uint32_t)ret);
    debug_printf("[Thread Queue] Popped thread %d from queue 0x%08X\n", TO_PTR(OSThread, ret)->id, (uintptr_t)queue_);
    return ret;
}

bool ultramodern::thread_queue_remove(RDRAM_ARG PTR(PTR(OSThread)) queue_, PTR(OSThread) t_) {
    // queue_ is ADVISORY only: legacy callers derive it from the game-writable t->queue field, which
    // is exactly the data this rework stops trusting. The host map is the single authority.
    (void)queue_;
    const uint32_t tid = (uint32_t)t_;
    auto cur = g_member_of.find(tid);
    if (cur == g_member_of.end()) {
        return false; // not on any queue
    }
    auto qit = g_queue_members.find(cur->second);
    if (qit != g_queue_members.end()) {
        std::vector<PTR(OSThread)>& members = qit->second;
        members.erase(std::remove(members.begin(), members.end(), t_), members.end());
    }
    g_member_of.erase(cur);
    return true;
}

bool ultramodern::thread_queue_empty(RDRAM_ARG PTR(PTR(OSThread)) queue_) {
    auto it = g_queue_members.find((uint32_t)queue_);
    return it == g_queue_members.end() || it->second.empty();
}

PTR(OSThread) ultramodern::thread_queue_peek(RDRAM_ARG PTR(PTR(OSThread)) queue_) {
    auto it = g_queue_members.find((uint32_t)queue_);
    if (it == g_queue_members.end() || it->second.empty()) {
        return NULLPTR;
    }
    return it->second.front();
}

PTR(PTR(OSThread)) ultramodern::thread_queue_membership(PTR(OSThread) t_) {
    auto it = g_member_of.find((uint32_t)t_);
    if (it == g_member_of.end()) {
        return NULLPTR;
    }
    return (PTR(PTR(OSThread)))it->second;
}

void ultramodern::thread_queue_clear(RDRAM_ARG PTR(PTR(OSThread)) queue_) {
    // osCreateMesgQueue used to zero the guest head fields, which emptied the lists as a side effect;
    // with host-side state a re-created queue must drop its stale members explicitly (hardware parity:
    // threads parked on a re-initialized queue are orphaned there too).
    auto it = g_queue_members.find((uint32_t)queue_);
    if (it == g_queue_members.end()) {
        return;
    }
    for (PTR(OSThread) t : it->second) {
        g_member_of.erase((uint32_t)t);
    }
    it->second.clear();
}
