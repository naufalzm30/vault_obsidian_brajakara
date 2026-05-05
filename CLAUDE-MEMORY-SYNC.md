# CLAUDE-MEMORY-SYNC.md — Memory & Ritual Protocol

> Baca kalau lagi kerja dengan memory files, daily notes, rekam_jejak, atau cross-link.

---

## Memory File Locations

### Live Memory (Claude aktif — salazar)
```
~/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory/
├── MEMORY.md (index)
├── user_profile.md
├── feedback_behavior.md
├── feedback_notes.md
├── project_brajakara_backends.md
└── project_active.md
```

### Vault Mirror (sync antar mesin)
```
~/vault_obsidian_brajakara/06_INDEX (Navigation hub)/claude_memory/
├── (sama seperti live memory, copy-paste)
```

**Sumber kebenaran:** Live memory di `~/.claude/.../memory/` (Claude baca)
**Vault mirror:** Untuk sync ke GitHub, dibaca mesin lain (salazar, tower)

---

## Memory Sync Protocol

**Setiap update file memory live** → **langsung copy ke vault mirror** + git sync:

```bash
# Update live memory
vim ~/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory/feedback_behavior.md

# Copy ke vault mirror
cp ~/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory/feedback_behavior.md \
   ~/vault_obsidian_brajakara/06_INDEX\ \(Navigation\ hub\)/claude_memory/

# Git sync
cd ~/vault_obsidian_brajakara
git pull --rebase origin master
git add 06_INDEX\ \(Navigation\ hub\)/claude_memory/feedback_behavior.md
git commit -m "sync memory: feedback_behavior update"
git push origin master
```

**Auto-apply:** Lakukan otomatis tanpa diminta.

---

## Daily Note Protocol

**File:** `00_INBOX/Daily_Notes/YYYY-MM-DD.md`

### Rules
1. **Setiap edit file vault** → update daily note hari ini (otomatis, tanpa diminta)
2. **Format:**
   ```markdown
   ### [Judul Singkat Aktivitas]
   - poin ringkas apa yang dikerjakan
   ```
3. **Auto-wikilink keyword** → wrap keyword vault jadi `[[wikilink]]`
   - Mapping: lihat `00_INBOX/Daily_Notes/index.md` (keyword → wikilink target)
   - Contoh: "ssh ke tower" → "ssh ke [[04_INFRASTRUCTURE_REFERENCE/Brajakara_Infrastructure_Overview|tower]]"

### Frontmatter (kalau daily note belum ada)
```yaml
---
date: YYYY-MM-DD
tags: [daily-note]
---

# Daily Note — YYYY-MM-DD

## Recap Hari Ini
```

### Auto-archive
- Daily notes >30 hari → move ke `00_INBOX/Daily_Notes/YYYY/MM/`
- Script: `~/.claude/hooks/daily-housekeeping.sh` (1x per bulan atau manual)

---

## Rekam Jejak Pekerjaan

**File:** `07_PROFIL (Professional Identity)/rekam_jejak.md`

### Rules

1. **User sebut pekerjaan Brajakara** (fitur baru, bug fix, migrasi, riset, dll) → **catat langsung** tanpa diminta
2. **Entry teknis Brajakara** dan **entry meta vault** (dokumentasi vault, maintenance Obsidian) → **PISAH KATEGORI**, jangan campur
3. **Format wajib** (lihat di bawah)
4. **Kategori harus standardized** — pakai dari daftar approved di bawah

### Format Entry

```markdown
### YYYY-MM-DD — [Judul Singkat]
**Kategori:** [dari daftar approved]
**Daily note:** [[YYYY-MM-DD]]
**Effort:** 🟢 Low / 🟡 Medium / 🔴 High
**Team:** Solo / Collab with [nama]
**Sebelum:** kondisi/masalah sebelum dikerjakan (1 kalimat)
**Sesudah:** hasil/impact ke sistem — sertakan metric kalau ada (1-2 kalimat)
**Skill:** Python, Redis, Docker, dll (comma-separated)
**Challenge:** (optional — blocker/difficulty signifikan)
**Artifact:** (optional — link ke script/config/vault note/PR)
- detail teknis poin-poin
- pakai `[[wikilink]]` untuk project/server/persona
```

**Fields wajib:** Kategori, Daily note, Effort, Sebelum, Sesudah, Skill
**Fields optional:** Team (default: Solo), Challenge, Artifact

### Kategori Approved (standardized)

```
Backend
Backend / API
Backend / Data Engineering
Backend / DevOps
Backend / UI/UX
Data Engineering
DevOps
DevOps / Infrastructure
Infrastructure / Networking
Infrastructure / Virtualization
Infrastructure / Integration
Documentation  ← HANYA untuk meta vault (Obsidian maintenance, CLAUDE.md, dll)
```

**Jangan buat kategori baru** di luar list ini. Kalau tidak cocok → pakai yang paling dekat + tambahkan note ke user.

### Effort Scale

| Marker | Definisi |
|---|---|
| 🟢 Low | < 2 jam, straightforward, tidak ada blocker |
| 🟡 Medium | 2 jam - 1 hari, ada beberapa iterasi atau debugging |
| 🔴 High | > 1 hari, blocker signifikan, multi-layer complexity |

### Ongoing Entries — Gunakan Dated Snapshots

**Jangan pakai `(Ongoing)` sebagai judul** — tidak ada anchor waktu, tidak bisa dijadiin milestone.

**Gunakan dated snapshot per bulan:**

```markdown
### YYYY-MM — [Nama Stream] (Ongoing Snapshot)
**Kategori:** [kategori]
**Progress:** Month N — deskripsi singkat status sekarang
**Milestone terakhir:** [[YYYY-MM-DD]] [entry terkait]
- stream description
- responsibility scope
```

**Update snapshot:** Setiap ada milestone baru di stream tersebut → update field `Progress` + `Milestone terakhir`, tambah entry baru di rekam_jejak untuk milestone-nya.

### Impact Metrics — Sertakan Kalau Ada

Field **Sesudah** harus kuantitatif kalau ada metric:

```
✅ "Alert real-time deployed, MTTR berkurang dari ~2 jam → 15 menit"
✅ "Schema export 1943 baris, 30 tabel — portable, restore 1 command"
❌ "Sistem sekarang lebih baik"
❌ "Berhasil dibuat"
```

Kalau metric tidak diketahui → estimasi OK, mark dengan `(est.)`

### Cross-Link Daily Note ↔ Rekam Jejak (WAJIB)

**Dari rekam_jejak → daily note:**
```markdown
**Daily note:** [[YYYY-MM-DD]]
```

**Dari daily note → rekam_jejak** (aktivitas yang masuk rekam jejak):
```markdown
### [Aktivitas]
- detail...

↗ Masuk [[rekam_jejak]]
```

**Aktivitas minor** (setup kosmetik, tweak config sepele, 1-liner fix) → tidak perlu promote ke rekam_jejak.

### Auto-compact
- Bikin `rekam_jejak-INDEX.md` (20-30 entry terakhir saja)
- Archive lama → `07_PROFIL (Professional Identity)/rekam_jejak_archive/YYYY/`
- Script: `~/.claude/hooks/daily-housekeeping.sh`

---

## Note-Taking Behavior

- **Catat proaktif** info baru ke folder relevan (tanpa diminta)
- **Pecah topik besar** ke file terpisah, hubungkan `[[wikilink]]`
- **Server alias** (azkaban, rockbottom, MORDOR, tower) → gunakan apa adanya, jangan ubah
- **External project tracking:** user sebut kerja di project luar vault → baca kode/git log langsung, catat **temuan penting** ke vault note (bukan full doc)
  - Contoh: bug baru, quirk, perubahan kritis, keputusan arsitektur tidak obvious
  - Section: `## Temuan / Catatan Penting` di note project

**Wajib catat otomatis** setiap akses project eksternal:
- Branch aktif
- Repo URL
- Status container
- Commit terakhir

---

## Multi-Mesin Sync

Vault dipakai dari banyak mesin (salazar, tower, dll).

**Setiap user tanya** "apa yang baru", aktivitas terbaru, info vault:
1. `git fetch && git pull --rebase origin master` dulu
2. Baru baca daily note + rekam_jejak
3. Jawab berdasarkan state terbaru

**Jangan jawab dari cache lama** — mesin lain mungkin punya update.

---

## Note Format

- **Markdown** with Obsidian extensions
- **Wikilinks:** `[[Note Title]]` atau `[[Note Title|display text]]`
- **YAML frontmatter:** between `---` delimiters (lihat CLAUDE-REFERENCE.md untuk schema)
- **Tags:** `#tag` inline

---

## Update Multi-Lokasi (Rule/Instruksi)

**Setiap update rule/instruksi** → sinkronkan ke **semua** tempat sekaligus:
1. `CLAUDE.md`
2. `06_INDEX (Navigation hub)/claude_memory/feedback_behavior.md`
3. `06_INDEX (Navigation hub)/Claude_Memory_Feedback.md`
4. `~/.claude/projects/.../memory/feedback_notes.md`

Lalu push vault ke GitHub. Jangan tunggu ditegur.

---

## Startup Ritual

Auto-check di setiap session baru (hook `~/.claude/hooks/session-start.sh`):
1. `rtk git fetch && rtk git pull --rebase origin master`
2. Baca daily note hari ini
3. Baca 10 entry terakhir rekam_jejak
4. Cek `project_active.md` — task pending
5. Ready

---

## Commit Message Standards

### Vault (repo ini)
- Pesan singkat deskriptif: "update rekam_jejak: PDAM audit dead tables"
- Tidak perlu tanya user, otomatis

### Project Code (selain vault — BRAJA_PDAMSBY, dll)
- **Meaningful + representatif** — bukan generic "update views.py"
- Ringkas apa yang berubah + kenapa
- Tidak perlu tanya user

### Display Progress
- Satu baris: **"syncing to github..."**
- Jangan tampilkan raw git output
