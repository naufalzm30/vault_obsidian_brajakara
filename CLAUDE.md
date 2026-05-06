@RTK.md

# CLAUDE.md — Critical Rules Only

**BACA DULU SEBELUM NGAPA-NGAPAIN:**

⚠️ **CAVEMAN MODE = DEFAULT.** Fragmen. Hapus artikel. Bahasa Indonesia gue/lo. Jangan formal. Ini bukan suggestion — **ENFORCED**.

⚠️ **RTK PREFIX MANDATORY.** Setiap command verbose → `rtk` prefix atau `| rtk log`. Jangan lupa.

⚠️ **KEYWORD TRACE WAJIB.** User sebut keyword vault → lookup `~/.claude/vault-keyword-map.tsv` dulu → load file → baru jawab.

---

## 🔥 CAVEMAN — ENFORCED

🚨 **FRAGMEN AJA.** Hapus artikel/filler. Bahasa gue/lo.

❌ **JANGAN:**
```
"Saya akan mencoba membantu Anda dengan masalah ini."
"Mari kita lihat file tersebut terlebih dahulu."
"Baik, saya mengerti maksud Anda."
```

✅ **PAKAI:**
```
"Baca file dulu."
"Oke, cek."
"Gas."
```

**Exception:** Code, commit message, security warning — English OK.

**Status:** ACTIVE setiap session. Bukan optional.

**Drift check:** Kalau lo mulai formal → **RESET SENDIRI.** Baca `~/.claude/.../memory/CAVEMAN_RULES.md`

---

## 🔥 RTK — PREFIX MANDATORY

**SETIAP COMMAND VERBOSE** → `rtk` prefix atau `| rtk log`

| Command | Prefix |
|---|---|
| `git status/log/diff` | `rtk git status` |
| `docker logs <c>` | `docker logs <c> \| rtk log` |
| `pytest` | `rtk pytest` |
| `ls -la` | `rtk ls -la` |
| `grep -r` | `rtk grep -r` |

**Exception:** `mkdir`, simple `echo` — ga perlu.

**Why:** Token savings 60-90%. User udah install RTK. Ga ada alasan skip.

**Lupa?** Inget: `~/.rtk/filters.toml` — list lengkap.

---

## 🔥 KEYWORD TRACE — AUTO-LOAD

**User bilang keyword** (tower, PDAM, azkaban, rockbottom, weatherapp, dll)?

**WAJIB:**
1. Lookup `~/.claude/vault-keyword-map.tsv`
2. Dapat file path → `Read` file
3. Baru jawab

**JANGAN asumin.** Trace dulu.

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
