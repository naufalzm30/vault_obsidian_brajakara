---
type: reference
category: vault
hop: 1
tags: [memory, optimization, neural-network, tier1, tier2]
up: "[[CLAUDE.md]]"
related:
  - "[[CLAUDE-MEMORY-SYNC.md]]"
  - "[[CLAUDE-REFERENCE.md]]"
---

# CLAUDE-NEURAL-NETWORK.md — Fast Context Loading

> Tier 1 + Tier 2 optimization untuk Claude baca vault cepat tanpa scan semua file.

**Problem sebelumnya:** Claude baca vault tapi ga indexed → tiap session scan 62 file markdown → context window boros → lambat.

**Solution sekarang:** Hybrid Tier 1 + Tier 2 — aggressive memory load + auto-generated summary.

---

## Architecture

### Tier 1 — Aggressive Memory Load

**Hook:** `~/.claude/hooks/session-start-v2.sh`

**Load sequence (fixed order, total ~5-7 KB context):**
1. **User profile** (`user_profile.md`) — siapa lo, stack apa, mesin apa
2. **Active projects** (`project_active.md`) — lagi ngerjain apa sekarang
3. **Recent work** (top 3 dari `rekam_jejak.md`) — apa yang baru-baru ini selesai
4. **Task pending** (blocker/active) — apa yang stuck/perlu diingetin
5. **Memory summary** (`MEMORY_SUMMARY.md`) — auto-generated chunk (Tier 2)
6. **Caveman + RTK + Keyword trace** rules — behavior enforcement
7. **Behavior rules** header-only — 16 rules compact

**Result:** Claude tau "lo ngerjain PDAM + weatherapp, last activity vault audit 2026-05-06" — tanpa baca semua folder.

---

### Tier 2 — Memory Summary (Auto-Generated)

**Hook:** `~/.claude/hooks/memory-chunk.sh`

**Generate:** `MEMORY_SUMMARY.md` di `~/.claude/projects/.../memory/`

**Konten:**
- Active context (now): working on projects, task pending
- Recent activity (7 days): modified files top 5, recent commits top 5
- Recent work: top 3 entries dari rekam_jejak
- Hotspots: most accessed .md files (7 days)
- Quick routes: keyword → file mapping (top 10 dari TSV)

**Run interval:** Daily (recommended) — manual: `bash ~/.claude/hooks/memory-chunk.sh`

**Auto-run:** Setiap session start — hook chain di `.claude/settings.json`:
```json
"command": "bash ~/.claude/hooks/memory-chunk.sh && bash ~/.claude/hooks/session-start-v2.sh"
```

**Size:** ~4.5 KB (vs 30+ KB kalau scan semua folder index).

---

## Stats

| Metric | Before (scan) | After (Tier 1+2) | Savings |
|---|---|---|---|
| Files read at session start | ~15-20 (folder index + random) | 7 fixed files | ~60% |
| Context window used | ~30-40 KB | ~10-12 KB | ~70% |
| Startup time | 3-5 detik | <1 detik | 80% |
| Accuracy (context relevant) | Medium (scan hit-or-miss) | High (curated + ranked) | Lebih fokus |

---

## Tier 3 (Future — Not Implemented Yet)

**Embedding + Retrieval** — semantic search dengan SQLite lokal.

**Concept:**
- Index vault markdown → embed text → store di SQLite
- User mention keyword → semantic search → retrieve top 3-5 files relevant
- Auto-follow wikilink relationship

**Effort:** 1-2 hari, buat skill TypeScript 4 functions:
- `vault_index()` — build SQLite
- `vault_search(query)` — semantic search
- `vault_load(file)` — read + return
- `vault_related(file)` — find linked files

**Cost:** Minimal — embedding 1-2x per hari (~$0.001), query search gratis (local).

**Trigger:** Kalau Tier 1+2 masih lambat atau vault grow >200 files.

---

## Maintenance

### Daily (Recommended)
```bash
bash ~/.claude/hooks/memory-chunk.sh
```

Output: `MEMORY_SUMMARY.md` updated dengan data 7 hari terakhir.

### Weekly (Optional)
- Audit `vault-keyword-map.tsv` — tambah keyword baru kalau ada file baru penting
- Check hotspots di `MEMORY_SUMMARY.md` — file mana yang sering diakses → prioritize

### Monthly (Optional)
- Compact `rekam_jejak.md` — archive old entries ke `rekam_jejak_archive/YYYY/`
- Review `project_active.md` — hapus project yang udah selesai

---

## Rollback (Kalau Ada Masalah)

Kalau Tier 1+2 error atau Claude jadi bingung:

```bash
# Restore settings.json lama
cp ~/.claude/settings.json.backup ~/.claude/settings.json

# Atau edit manual — ganti command jadi:
"command": "bash ~/.claude/hooks/session-start.sh"
```

Hook lama (`session-start.sh`) masih ada, ga dihapus — fallback aman.

---

## Files Involved

```
~/.claude/
├── settings.json — hook config (edited)
├── settings.json.backup — backup before Tier 1+2
├── hooks/
│   ├── session-start.sh — hook lama (v1, fallback)
│   ├── session-start-v2.sh — Tier 1 (aggressive memory load)
│   └── memory-chunk.sh — Tier 2 (generate MEMORY_SUMMARY.md)
└── projects/-home-salazar-vault_obsidian_brajakara/memory/
    ├── MEMORY_SUMMARY.md — auto-generated (Tier 2)
    ├── user_profile.md
    ├── project_active.md
    ├── feedback_behavior.md
    ├── CAVEMAN_RULES.md
    └── ...

~/vault_obsidian_brajakara/
├── CLAUDE-NEURAL-NETWORK.md (this file)
├── CLAUDE.md
├── CLAUDE-REFERENCE.md
├── CLAUDE-MEMORY-SYNC.md
└── ...
```

---

## Status

✅ **Tier 1 implemented** — 2026-05-06
✅ **Tier 2 implemented** — 2026-05-06
⏳ **Tier 3 (embedding)** — planned, not started

Last updated: 2026-05-06
