---
name: Instruksi Perilaku Claude
description: Aturan perilaku Claude di vault ini — catat proaktif, git sync otomatis
type: feedback
originSessionId: a3a7fb23-fce1-4545-8801-5683083eb8b4
---
## Catat Proaktif

Catat informasi baru ke folder relevan tanpa menunggu diminta.

**Why:** User sering lupa minta Claude mencatat secara spesifik. User marah kalau Claude nanya dulu sebelum catat — langsung catat saja.

**How to apply:** Setiap ada info baru (infra, project, snippet, dll) → langsung tulis ke folder sesuai tanpa nanya. Pecah topik besar ke file terpisah, hubungkan `[[wikilink]]`. Jangan tunggu konfirmasi.

## Statusline Caveman

Statusline Claude Code harus tampilkan indikator `[CAVEMAN]`. Kalau session baru dan statusline belum setup, langsung setup — jangan tunggu user lapor dulu.

**Why:** User pernah harus lapor sendiri bahwa statusline caveman ga muncul. Harusnya Claude cek/setup proaktif.

**How to apply:** Awal session, kalau caveman mode aktif, verifikasi statusline sudah configured. Kalau belum → invoke `statusline-setup` agent langsung.

## Pull Dulu Sebelum Jawab (Multi-Mesin)

Vault dipakai dari banyak mesin (salazar, tower, dll). Kalau user tanya "apa yang baru", aktivitas terbaru, atau info apapun tentang vault → `git fetch` + `git pull` dulu baru jawab.

**Why:** Mesin lain mungkin punya catatan terbaru yang belum ada di mesin ini. Tanpa pull, jawaban bisa stale.

**How to apply:** Terapkan di semua mesin, semua session. Jangan jawab dulu sebelum pull.

## Commit Message — Project Code

Untuk repo selain vault (BRAJA_PDAMSBY, dll): buat commit message yang **meaningful dan representatif**. Tidak perlu tanya user.

**Why:** User tidak mau diganggu tanya-tanya, tapi commit message harus deskriptif — bukan generic seperti "update views.py".
**How to apply:** Ringkas apa yang berubah dan kenapa, bukan cuma nama file.

## Git Sync Otomatis

Setiap Write/Edit file di vault → langsung jalankan:
```bash
git pull --rebase origin master
git add <file>
git commit -m "pesan singkat"
git push origin master
```

**Why:** User sudah instruksikan di CLAUDE.md tapi Claude tidak konsisten menjalankan.

**How to apply:** Tidak perlu tunggu perintah user. Lakukan setiap ada perubahan file vault — termasuk file config/script di dalam repo vault seperti `.claude/plugins/`.

**Why (tambahan):** User pernah marah karena Claude lupa push script statusline caveman. File apapun di dalam repo vault = harus di-push.

## External Project Tracking

Kalau user sebut lagi kerja di folder project di luar vault → langsung baca kode/git log di sana, catat temuan penting ke vault note-nya. Tidak perlu minta izin, tidak perlu full doc.

**Why:** User ingin hal penting (bug, quirk, perubahan kritis) ter-capture otomatis ke vault tanpa harus minta Claude secara eksplisit.

**How to apply:** Catat ke bagian `## Temuan / Catatan Penting` di note project relevan. Fokus: apa yang bakal bikin pusing saat debug nanti, bukan deskripsi ulang kode.

**Wajib catat otomatis** setiap akses project eksternal (tanpa diminta):
- Branch aktif
- Repo URL
- Status container (`docker compose ps`)
- Commit terakhir (`git log --oneline -3`)

Catat ke frontmatter + `## Temuan / Catatan Penting` di note vault project tersebut.

## Rekam Jejak Pekerjaan

Setiap user menyebut sesuatu yang dikerjakan di Brajakara → **langsung catat ke `07_PROFIL (Professional Identity)/rekam_jejak.md`** tanpa menunggu diminta.

**Why:** User ingin bisa tracking "aku sudah ngapain aja di Brajakara" untuk kebutuhan resume dan referensi karir.

**How to apply:** Format entry: `### YYYY-MM-DD — [Judul]`, dengan kategori dan deskripsi dampak singkat. Terapkan di semua session, semua mesin.

## Memory Sync

Setiap update rule/instruksi → langsung sinkronkan ke **semua** tempat sekaligus tanpa menunggu ditegur:
1. `CLAUDE.md`
2. `06_INDEX (Navigation hub)/claude_memory/feedback_behavior.md`
3. `06_INDEX (Navigation hub)/Claude_Memory_Feedback.md`
4. `~/.claude/projects/.../memory/feedback_notes.md`

**Why:** Claude berkali-kali update satu tempat dan lupa sisanya.

**How to apply:** Update 4 tempat sekaligus → push vault ke GitHub.

## Git Sync — Output Ringkas

Saat git sync vault, jangan tampilkan output git mentah. Cukup tulis satu baris: **"syncing to github..."** (atau sejenisnya yang singkat).

**Why:** Output panjang git pull/commit/push memenuhi layar dan tidak informatif bagi user.

**How to apply:** Setiap selesai git sync vault, ringkas jadi satu baris pendek saja.

## WAJIB Pakai RTK + Caveman

Dua tools ini WAJIB aktif di setiap session — bukan optional.

### Caveman Mode
- Auto-active via `SessionStart` hook
- Drop articles, filler, hedging — fragments OK
- Kalau drift, langsung balik
- Normal style hanya di: code, commit message, security warning, irreversible action

### RTK (Rust Token Killer)
WAJIB prefix `rtk` di depan command verbose, atau pipe ke `rtk log` / `rtk pipe`. Hook `rtk hook claude` di `PreToolUse` HANYA untuk telemetry — TIDAK auto-route output.

| Tujuan | Pakai |
|---|---|
| Docker logs | `docker logs X --tail N \| rtk log` |
| Pytest | `rtk pytest` (cuma failures) |
| Git log/diff | `rtk git log` / `rtk diff` |
| Cari file | `rtk find` |
| Grep | `rtk grep` |
| Cargo build/test | `rtk cargo build` |
| Jest/Vitest | `rtk jest` / `rtk vitest` |
| Curl JSON | `rtk curl` |
| Tree/ls | `rtk tree` / `rtk ls` |
| psql | `rtk psql` |
| kubectl | `rtk kubectl` |
| docker | `rtk docker` |
| npm/pnpm | `rtk npm` / `rtk pnpm` |
| Custom verbose | `<cmd> \| rtk log` atau `\| rtk pipe` |

**Why:** Output verbose (logs, test, build) tanpa RTK menghabiskan context window — token waste. User SUDAH install RTK + setup hook, jadi tidak ada alasan untuk tidak pakai.

**How to apply:**
1. Sebelum tiap Bash command verbose → cek `rtk --help` apakah ada wrapper khusus
2. Kalau ada, prefix `rtk`
3. Kalau tidak ada wrapper khusus, pipe output ke `rtk log` (untuk log) atau `rtk pipe` (general filter)
4. Untuk command yang sudah pasti compact (mkdir, cp, simple echo) → tidak perlu RTK

## Plane Work Item Description — Meaningful untuk Team

Waktu buat/update work item di Plane — description harus **meaningful dan readable untuk team**, bukan cuma copy-paste context dari daily note.

**Why:** Info tidak relevan tanpa konteks bikin bingung, tidak membantu penyelesaian task. Team baca description untuk understand scope + requirements.

**How to apply:**
- **DO:** Focus pada what, why, how — jelas dan actionable. Include context yang membantu solve task.
- **DON'T:** Jangan include deployment notes / environment detail yang tidak affect task completion atau tidak ada penjelasan kenapa penting.
- Contoh buruk: "Environment: UAT (`pdam_redis` sengaja tidak jalan)" — tanpa konteks kenapa ini penting
- Contoh baik: "Update crontab `runningTaksasiOtomatis` untuk jalan semua balai (bukan cuma 4,5) tiap 15 menit. Alasan: perluas coverage monitoring."

## Navigation_Map — Neural Network Routing Hub (Strict 3-Hop)

**Routing workflow:** [[Navigation_Map]] → **folder index** → detail file. **No bypass** — Navigation_Map cuma link folder index, tidak ada direct link ke detail files.

**Why:** Claude berkali-kali gagal menemukan info yang sudah ada di docs karena tidak tau file mana yang perlu dibaca. Contoh: user tanya "SSH ke tower" → Claude tidak connect bahwa tower = VM di MORDOR → tidak baca Proxmox_MORDOR.md.

**Strict 3-hop rule:**
1. **Navigation_Map (hop 0)** — cuma link ke folder index (hop 1), tidak boleh ada direct link ke detail files (hop 2)
2. **Folder index (hop 1)** — route ke detail files (hop 2) dengan full path wikilink + context description
3. **Detail files (hop 2)** — endpoint, tidak route lagi

**Why strict (no bypass):**
- Konsisten — semua routing workflow sama
- Scalable — tambah file baru = update folder index saja, Navigation_Map tidak perlu touch
- Frontmatter metadata — aku cek YAML block tanpa read full content, hop tetap cepat

**How to apply:**
1. **Setiap user tanya apapun** tentang infra/server/VM/project/persona → **baca [[Navigation_Map]] dulu**
2. Navigation_Map route ke **folder index**:
   - Infra → `04_INFRASTRUCTURE_REFERENCE/index.md`
   - Projects → `01_BACKEND_PROJECTS (Active development)/index.md`
   - Profile → `07_PROFIL (Professional Identity)/index.md`
   - Agents → `08_HERMES_AGENT/index.md`
3. **Folder index** route ke detail file dengan full path wikilink + context
4. **Jangan skip hop** — tidak boleh Navigation_Map → detail file direct

**Pattern (strict 3-hop):**
- User sebut "tower" → Navigation_Map (hop 0) → `04_INFRASTRUCTURE_REFERENCE/index.md` (hop 1) → [[Proxmox_MORDOR]] (hop 2)
- User tanya "identitas" → Navigation_Map (hop 0) → `07_PROFIL/index.md` (hop 1) → [[identitas]] (hop 2)
- User tanya "PDAM" → Navigation_Map (hop 0) → `01_BACKEND_PROJECTS/index.md` (hop 1) → [[PDAM_SBY]] (hop 2)

**Scalability:** Tambah server/project/persona baru = update folder index saja. Navigation_Map stay simple, tidak perlu edit.

## Folder Index — Same-Folder Wikilink Only

**Rule:** Folder index **hanya boleh link ke file di folder itu sendiri** (same-folder wikilinks). Cross-folder link hanya diperbolehkan di detail files untuk show hubungan dokumen.

**Why:** Menjaga hierarki routing tetap strict dan scalable. Folder index tugasnya mapping keyword ke detail files dalam satu folder — bukan jadi "super index" yang nge-route ke mana-mana.

**How to apply:**
1. **Index files** (`04_INFRASTRUCTURE_REFERENCE/index.md`, `01_BACKEND_PROJECTS/index.md`, dll) — wikilink format `[[folder_name/file_name|alias]]` hanya untuk file di folder yang sama
2. **Kalau perlu mention keyword dari folder lain** → plain text mention tanpa wikilink, atau refer ke Navigation_Map untuk routing
3. **Cross-folder wikilink** → diperbolehkan di detail files (BE_WEATHERAPP.md bisa link ke [[Proxmox_MORDOR]], dll) karena itu show document relationship

**Example (correct):**
```markdown
# 04_INFRASTRUCTURE_REFERENCE/index.md
- **[[04_INFRASTRUCTURE_REFERENCE/Proxmox_MORDOR|Proxmox MORDOR]]** ✓ same-folder
- **[[04_INFRASTRUCTURE_REFERENCE/WireGuard_Azkaban|WireGuard]]** ✓ same-folder
```

**Example (wrong):**
```markdown
# 08_HERMES_AGENT/index.md
- Daily Note: [[00_INBOX/Daily_Notes/YYYY-MM-DD.md]] ❌ cross-folder
```
Fix → plain text: `00_INBOX/Daily_Notes/YYYY-MM-DD.md` (no wikilink)

**Enforcement:**
- CLAUDE.md → link cuma Navigation_Map
- Navigation_Map → link cuma folder indexes
- **Folder indexes → link cuma files dalam folder itu**
- Detail files → cross-folder link OK (document relationships)

## CLAUDE.md Lean — Index Files Heavy (Keyword Mapping)

**Approach:** CLAUDE.md cuma plain text mention keywords + wikilink ke index. Index files = keyword mapper dengan full wikilink ke detail files.

**Why:** CLAUDE.md wikilink-heavy = context overload + banyak wikilink tidak terpakai. User suggest: lean CLAUDE.md, heavy index files.

**How to apply:**
1. **CLAUDE.md:** plain text mention keywords (rockbottom, BE_WEATHERAPP, identitas, dll) + wikilink **only** ke index files
2. **Index files:** comprehensive keyword mapping — semua keyword mention dengan full wikilink + context description
3. **Workflow:** User tanya "BE_WEATHERAPP" → aku baca CLAUDE.md → lihat mention "BE_WEATHERAPP" di Projects section → follow wikilink ke `01_BACKEND_PROJECTS/index.md` → search keyword "BE_WEATHERAPP" → ketemu full wikilink → read detail file

**Example CLAUDE.md (lean):**
```markdown
| Projects | [[01_BACKEND_PROJECTS/index]] (BE_WEATHERAPP, PDAM_SBY, weatherapp_mqtt_parser, dll) |
```
Plain text mention, wikilink cuma index.

**Example Index file (heavy keyword mapping):**
```markdown
- **[[01_BACKEND_PROJECTS/BE_WEATHERAPP|BE_WEATHERAPP]]** — Backend Django weather monitoring (riverstyx prod)
- **[[01_BACKEND_PROJECTS/PDAM_SBY|PDAM_SBY]]** (alias: PDAM, BRAJA_PDAMSBY) — PDAM flow meter monitoring
```
Full wikilink + alias + context.

**Benefit:**
- CLAUDE.md lean — no context overload
- Index files = single source of truth untuk keyword mapping
- Nearest path optimal — aku tau "keyword X mention di CLAUDE.md section Y → refer to index Z → search keyword → ketemu wikilink"
- Scalable — tambah keyword = update index, CLAUDE.md stay clean
