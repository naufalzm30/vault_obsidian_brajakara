@RTK.md

# CLAUDE.md — Critical Rules Only

**BACA DULU SEBELUM NGAPA-NGAPAIN:**

⚠️ **CAVEMAN MODE = DEFAULT.** Fragmen. Hapus artikel. Bahasa Indonesia gue/lo. Jangan formal. Ini bukan suggestion — **ENFORCED**.

⚠️ **RTK PREFIX MANDATORY.** Setiap command verbose → `rtk` prefix atau `| rtk log`. Jangan lupa.

⚠️ **KEYWORD TRACE WAJIB.** User sebut keyword vault → lookup `~/.claude/vault-keyword-map.tsv` dulu → load file → baru jawab.

---

## 🔥 TOP 3 RULES — TIDAK BOLEH DILUPAKAN

### 1. CAVEMAN MODE — MANDATORY
- Fragmen saja, hapus artikel/filler
- Bahasa Indonesia casual (gue/lo OK)
- Jangan formal kecuali code/commit/security warning
- Default status: **ACTIVE**

### 2. RTK (Rust Token Killer) — MANDATORY
- PREFIX: `rtk <cmd>` atau pipe `| rtk log`
- Exceptions: `mkdir`, simple `echo`, bukan verbose output
- **Why:** Token savings 60-90% per command
- Reference: `~/.rtk/filters.toml` (full documentation)

### 3. KEYWORD TRACE — AUTO-LOAD DOC
- User bilang keyword (tower, PDAM, weatherapp, azkaban, rockbottom, dll)?
- AUTO → baca `06_INDEX (Navigation hub)/Navigation_Map.md`
- Cari file relevan, pre-load ke context
- **Jangan asumin lo paham — tracing dulu, baru jawab**

---

## Quick Triage Table

| User bilang | Action | File |
|---|---|---|
| Keyword **server/VM** (tower, azkaban, rockbottom, MORDOR, etc) | Baca infra note + wikilink terkait | `04_INFRASTRUCTURE_REFERENCE/index.md` → detail file |
| Keyword **project** (PDAM_SBY, BE_WEATHERAPP, weatherapp_mqtt_parser, etc) | Baca project note + temuan penting | `01_BACKEND_PROJECTS (Active development)/index.md` → detail file |
| Keyword **profile** (identitas, skills_stack, rekam_jejak, pengalaman_brajakara) | Baca profile doc | `07_PROFIL (Professional Identity)/index.md` → detail file |
| "Apa yang baru" / aktivitas terbaru | `git fetch && git pull` dulu, terus baca daily note + rekam_jejak | `00_INBOX/Daily_Notes/` + `rekam_jejak.md` |
| Apapun — ragu routing | Baca Navigation_Map dulu | `06_INDEX (Navigation hub)/Navigation_Map.md` |

---

## Rituals (Automatic, tanpa diminta)

### 1. Git Sync (Setiap edit vault file)
```bash
git pull --rebase origin master
git add <file>
git commit -m "pesan singkat deskriptif"
git push origin master
```
Summary display: **"syncing to github..."** (satu baris, tidak tampilkan raw output)

### 2. Daily Note Update (Setiap edit file vault)
File: `00_INBOX/Daily_Notes/YYYY-MM-DD.md`
Format:
```markdown
### [Judul Singkat Aktivitas]
- poin ringkas apa yang dikerjakan
- auto-wrap keyword `[[wikilink]]` (lihat Daily_Notes/index.md untuk mapping)
```

### 3. Konfirmasi Sebelum Eksekusi (Destructive commands)
**WAJIB tanya dulu** sebelum jalankan:
- File operations: `rm`, `truncate`, `shred`
- System: `journalctl --vacuum*`, `docker system prune`, `systemctl restart/stop`, `sudo *`
- Git state-changing: `git checkout`, `git stash`, `git reset`, `git push` (kalau tidak routine)
- Config: edit/create file yang critical

**Tidak perlu tanya** (read-only):
- `ls`, `cat`, `grep`, `find`, `git status`, `git log`, `docker ps`, `docker logs`, etc

---

## Language

- **Always:** Bahasa Indonesia dalam respons + catatan
- **Exception:** Code, commit messages, security warnings — pakai English

---

## Bahasa Reference & Details

Lihat **[CLAUDE-REFERENCE.md](./CLAUDE-REFERENCE.md)** untuk:
- Domain Glossary (kubikasi, voltased, taksasi, balai, station, logger, etc)
- Env/Secrets Matrix (project config, creds location, jangan commit `.env`)
- Server aliases mapping (azkaban, rockbottom, FOEWS, MORDOR, tower, etc)
- Folder structure detail
- Plugins list
- MCP Plane integration

Lihat **[CLAUDE-MEMORY-SYNC.md](./CLAUDE-MEMORY-SYNC.md)** untuk:
- Memory file locations + sync protocol
- Cross-link daily note ↔ rekam_jejak
- Rekam jejak pekerjaan (auto-update)
- Note-taking behavior

---

## Session Start

Hook `~/.claude/hooks/session-start.sh` auto-run setiap session baru:
- Print reminder: Caveman + RTK + Keyword trace aktif
- Pre-load active tasks + behavior rules ke context
- Ready untuk bekerja

---

## RTK Quick Reference

| Workflow | Prefix | Savings |
|----------|--------|---------|
| Test | `rtk pytest/jest/vitest` | 90-99% |
| Build | `rtk cargo/tsc/prettier` | 70-87% |
| Git | `rtk git status/log/diff/push` | 59-80% |
| Files | `rtk ls/grep/find` | 60-75% |
| Docker/Infra | `rtk docker/kubectl` | 85% |
| Network | `rtk curl` | 70% |

**Default:** prefix `rtk` atau `| rtk log`. Kalau tidak ada filter khusus, RTK pass through (safe).

**Full reference:** `~/.claude/.rtk/filters.toml` atau `rtk --help`

---

## Lokasi Files Penting

```
~/vault_obsidian_brajakara/
├── CLAUDE.md (ini — critical rules)
├── CLAUDE-REFERENCE.md (detail reference)
├── CLAUDE-MEMORY-SYNC.md (memory protocol)
├── 06_INDEX (Navigation hub)/
│   ├── Navigation_Map.md (routing hub)
│   ├── Claude_Memory.md (vault mirror)
│   └── claude_memory/ (vault mirror folder)
├── 00_INBOX/
│   └── Daily_Notes/ (daily note auto-archive)
├── 01_BACKEND_PROJECTS (Active development)/
├── 04_INFRASTRUCTURE_REFERENCE/
└── 07_PROFIL (Professional Identity)/

~/.claude/
├── hooks/
│   └── session-start.sh (pre-load context)
├── .rtk/
│   └── filters.toml (RTK command list)
└── projects/-home-salazar-vault-obsidian-brajakara/memory/
    ├── project_active.md (active tasks)
    ├── feedback_behavior.md (behavior rules)
    └── user_profile.md (user info)
```

---

## Status

✅ File structure: refactored v2 (2026-05-05)
✅ Hook: updated session-start.sh
⏳ Keyword router: in progress (step 2/5)
⏳ Auto-compact history: in progress (step 3/5)

Last updated: 2026-05-05
