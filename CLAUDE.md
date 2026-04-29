@RTK.md

# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an [Obsidian](https://obsidian.md) vault named `Brajakara_Naufal`, used as a backend development knowledge base. Notes are plain `.md` files; vault configuration lives under `.obsidian/`.

**Vault scope:** Vault ini adalah **meta-layer** untuk Brajakara projects — bukan code projects itu sendiri. Code projects (BE_WEATHERAPP, BRAJA_PDAMSBY, dll) ada di folder terpisah (`~/` di tower, tidak ada di salazar). Vault track aktivitas, dokumentasi, dan temuan dari projects tersebut.

## Multi-AI Support

Vault mendukung multiple AI assistants:
- **`CLAUDE.md`** — comprehensive guide untuk Claude Code (primary, file ini)
- **`GEMINI.md`** — ringkas untuk Gemini CLI (summarized version)

Kedua file sync ke GitHub via git. Perubahan major di CLAUDE.md perlu reflect ke GEMINI.md juga.

## Metadata Schema (YAML Frontmatter)

**Semua file di vault menggunakan YAML frontmatter standar** untuk fast routing tanpa perlu read full content.

```yaml
---
type: index | detail | catalog | reference | daily-note | memory
category: infrastructure | project | profile | agent | inbox | index-hub
hop: 0 | 1 | 2 | 3  # depth dari Navigation_Map (0 = Navigation_Map itself)
tags: [hierarchical/tags]  # hierarchical untuk Obsidian graph view
---
```

**Type definitions:**
- `index` — Folder index / MOC (Map of Content), route ke detail files
- `detail` — Single-topic deep dive (Proxmox_MORDOR, BE_WEATHERAPP, dll)
- `catalog` — Multi-entry list (Brajakara_Infrastructure_Overview)
- `reference` — Reference doc (skills_stack, identitas)
- `daily-note` — Daily notes (00_INBOX/Daily_Notes/)
- `memory` — Claude memory files (06_INDEX/claude_memory/)

**Hop definitions:**
- `0` — Navigation_Map (top-level hub)
- `1` — Folder index (04_INFRASTRUCTURE_REFERENCE/index.md, 01_BACKEND_PROJECTS/index.md)
- `2` — Detail/catalog files (Proxmox_MORDOR, BE_WEATHERAPP, Brajakara_Infrastructure_Overview)
- `3` — Sub-detail (belum ada, reserved untuk nesting lebih dalam)

**Tag hierarchy:**
- `infrastructure/servers` — Physical servers
- `infrastructure/vm` — Virtual machines
- `infrastructure/network` — Network & VPN
- `project/backend` — Backend projects
- `project/frontend` — Frontend projects
- `profile/identity` — identitas, skills_stack
- `profile/career` — rekam_jejak, pengalaman_brajakara
- `agent/hermes` — Hermes Agent related
- `index` — Index/MOC files
- `memory` — Claude memory files
- `daily-note` — Daily notes

**Wikilink format standar:**
```markdown
[[folder/file|Display Alias]] — short context description
```

Full path wikilink menghindari ambiguitas, alias untuk readability, context description untuk routing decision tanpa read file.

## Folder Structure

The vault uses a numbered folder system:

| Folder | Purpose |
|---|---|
| `00_INBOX/` | Capture area; `Daily_Notes/` subfolder holds daily notes |
| `01_BACKEND_PROJECTS (Active development)/` | Notes on ongoing backend projects |
| `02_BACKEND_REFERENCE (Permanent, reusable patterns)/` | Long-lived backend patterns and references |
| `03_QUICK_SNIPPETS (Code examples, not full projects)/` | Short code snippets and examples |
| `04_INFRASTRUCTURE_REFERENCE/` | Infrastructure and DevOps references |
| `05_ARCHIVED/` | Archived notes |
| `06_INDEX (Navigation hub)/` | Index notes for navigating the vault |

New notes that haven't been categorized yet go into `00_INBOX/`. Daily notes live in `00_INBOX/Daily_Notes/`.

## Quick Reference

**All routing** → Navigation_Map (`06_INDEX (Navigation hub)/Navigation_Map.md`) → folder index → detail file.

**Keywords:**
- **Servers:** rockbottom, azkaban, riverstyx, FOEWS, MORDOR, ServerFlowMeter-no-JH
- **VMs:** DungeonTower (tower), lumbungpadi, spakborsupra, ABURAYA
- **Projects:** BE_WEATHERAPP, PDAM_SBY, weatherapp_mqtt_parser, FE_BRAJA_PDAMSBY, FE_weatherapp_palembang, GO_WHATSAPP_API, wa_notif, webhook_receiver
- **Persona:** identitas, skills_stack, rekam_jejak, pengalaman_brajakara
- **Dev machines:** salazar (laptop, no project lokal), tower (PC, semua project di `~/`)

Detail: Navigation_Map route ke folder index. Folder index punya keyword mapping dengan full wikilink.

## Triage — Where to Look First

**Routing:** Baca Navigation_Map (`06_INDEX (Navigation hub)/Navigation_Map.md`) → folder index → detail file.

| User bilang / tanya... | Action |
|---|---|
| **Apapun** keyword vault (servers, VM, projects, persona) | Baca Navigation_Map |
| Infra keyword (rockbottom, azkaban, MORDOR, tower, lumbungpadi, dll) | Navigation_Map → Infrastructure Index (`04_INFRASTRUCTURE_REFERENCE/index.md`) |
| Project keyword (BE_WEATHERAPP, PDAM_SBY, weatherapp_mqtt_parser, dll) | Navigation_Map → Projects Index (`01_BACKEND_PROJECTS (Active development)/index.md`) |
| Persona keyword (identitas, skills_stack, rekam_jejak, pengalaman_brajakara) | Navigation_Map → Profile Index (`07_PROFIL (Professional Identity)/index.md`) |
| Aktivitas terbaru / apa yang baru / kemarin | `rtk git fetch && rtk git pull` → daily note `00_INBOX/Daily_Notes/YYYY-MM-DD.md` + rekam_jejak |
| Bug / quirk existing | Section `## Temuan / Catatan Penting` di note project |
| Memory Claude / context lama | `06_INDEX (Navigation hub)/claude_memory/` (vault mirror) atau `~/.claude/.../memory/` (live) |

## Global Gotchas

Hal lintas-project yang sering bikin salah langkah:

- **MQTT creds lama `vius/vius`** — sekarang `B-Tech/B-Tech` (weatherapp ecosystem)
- **DB `weather_app` pindah** ke `127.0.0.1:4307` (bukan `10.20.0.11` lama) → wajib `network_mode: host` di docker-compose
- **Year bug logger** — logger kadang kirim `current_year + 41/42/43`, ada koreksi hardcoded di parser
- **Path stale `/home/viusp/...`** di `.service` file & `views.py` BE_WEATHERAPP — perlu update per mesin saat deploy ulang
- **Telegram bot BE_WEATHERAPP**: 2 config — `TELEGRAM_MALANG` + `TELEGRAM_PALU`
- **Telegram bot PDAM**: `@suryasembadabot` (`7699190789:...`) → 4 channel: MISSING, THRESHOLD, VOLTASE_TURUN, KUBIKASI_MINUS
- **BE_WEATHERAPP `DEBUG = True`** + Django 3.2 — belum production-ready
- **PDAM dead tables** di `dbflowmeter`: `checker_data`, `sensor_data`, `station` (nama lama, belum di-drop)
- **PDAM `taksasi.py` vs `taksasi_old.py` vs `taksasi_backup.py`** — hati-hati salah edit file
- **PDAM Supercronic stagger trick**: dua job `*/5` + `sleep 150` = efektif tiap 2.5 menit
- **Inovastek Ayana Resort** — offset sensor hardcoded (+3, -20, +3.1) + timezone +1 jam

## Domain Glossary

Istilah khusus ekosistem Brajakara:

| Istilah | Arti |
|---|---|
| **kubikasi** | Volume air (m³) terakumulasi dari flow meter PDAM |
| **voltased** | Status voltase turun (< 11V) di sensor — indikasi battery lemah |
| **taksasi** | Estimasi/prediksi data — job rutin PDAM isi data yang hilang berdasarkan pola historis |
| **anomali** | Data sensor yang out-of-range atau tidak konsisten dengan pola |
| **balai** | Unit organisasi (BWS — Balai Wilayah Sungai) user BE_WEATHERAPP |
| **station** | Stasiun monitoring (sensor + koordinat + topic MQTT) |
| **logger** | Alat IoT di lapangan yang kirim data via MQTT (CSV format) |
| **stagger trick** | Dua cronjob `*/5` dengan offset `sleep 150` untuk efektif jalan tiap 2.5 menit |
| **FOEWS** | Flood Operation & Early Warning System — aplikasi legacy Brajakara |
| **threshold** | Ambang batas sensor per station untuk trigger alert |
| **missing** / **threshold** / **voltased** / **minus** | 4 kategori check_data PDAM untuk trigger notif Telegram |

## Env / Secrets Matrix

| Project | File Config | Secrets Penting |
|---|---|---|
| BE_WEATHERAPP | `weather_project/.env` | DB creds MySQL, Django SECRET_KEY, Telegram tokens (MALANG + PALU) |
| weatherapp_mqtt_parser | `Config.ini` + `dockerize/Config.ini` (plaintext, bukan `.env`!) | MQTT broker/user/pass, DB MySQL creds |
| BRAJA_PDAMSBY | `pdam_project/pdam_project/.env` | PostgreSQL creds (`usflowmeter@128.46.8.224`), Django SECRET_KEY, `TELEGRAM_BOT_TOKEN` (perlu ditambah di prod) |
| BRAJA_PDAMSBY (prod `ServerFlowMeter-no-JH`) | `/home/usflowmeter/pdam-daas-project/src/DOCKER_BRAJA_PDAMSBY/.env` | Sama seperti dev + **belum ada `TELEGRAM_BOT_TOKEN`** per 2026-04-21 |
| MQTT broker (`rockbottom`) | `/etc/mosquitto/...` | User auth — creds di password_file |

⚠️ **Jangan commit `.env` ke repo**. Kalau nemu secret leak di git history, flag ke user.

## Startup Ritual

Auto-check tanpa diminta di setiap session baru di vault:

1. `rtk git fetch && rtk git pull --rebase origin master` — sync update dari mesin lain
2. Baca daily note hari ini (`00_INBOX/Daily_Notes/YYYY-MM-DD.md`) — state aktif
3. Baca 10 entry terakhir `07_PROFIL (Professional Identity)/rekam_jejak.md` — konteks longitudinal
4. Cek `project_active.md` di `~/.claude/.../memory/` — task pending
5. Ready

## Vault File Index

Master index absolute path — pakai langsung untuk `Read` tool tanpa perlu `find`/`grep`. **No wikilink** — cuma absolute path reference. Untuk keyword mapping pakai folder index files.

### Project Notes (`01_BACKEND_PROJECTS (Active development)/`)
- `01_BACKEND_PROJECTS (Active development)/index.md` — folder index (keyword mapping)
- `01_BACKEND_PROJECTS (Active development)/BE_WEATHERAPP.md`
- `01_BACKEND_PROJECTS (Active development)/weatherapp_mqtt_parser.md`
- `01_BACKEND_PROJECTS (Active development)/PDAM_SBY.md`
- `01_BACKEND_PROJECTS (Active development)/FE_BRAJA_PDAMSBY.md` 🟡 skeleton
- `01_BACKEND_PROJECTS (Active development)/FE_weatherapp_palembang.md` 🟡 skeleton
- `01_BACKEND_PROJECTS (Active development)/GO_WHATSAPP_API.md` 🟡 skeleton
- `01_BACKEND_PROJECTS (Active development)/wa_notif.md` 🟡 skeleton
- `01_BACKEND_PROJECTS (Active development)/webhook_receiver.md` 🟡 skeleton

### Infrastructure (`04_INFRASTRUCTURE_REFERENCE/`)
- `04_INFRASTRUCTURE_REFERENCE/index.md` — folder index (keyword mapping)
- `04_INFRASTRUCTURE_REFERENCE/Brajakara_Infrastructure_Overview.md` — master server catalog
- `04_INFRASTRUCTURE_REFERENCE/Proxmox_MORDOR.md`
- `04_INFRASTRUCTURE_REFERENCE/WireGuard_Azkaban.md`

### Profil Professional (`07_PROFIL (Professional Identity)/`)
- `07_PROFIL (Professional Identity)/index.md` — folder index (keyword mapping)
- `07_PROFIL (Professional Identity)/identitas.md`
- `07_PROFIL (Professional Identity)/skills_stack.md`
- `07_PROFIL (Professional Identity)/rekam_jejak.md` — auto-update
- `07_PROFIL (Professional Identity)/pengalaman_brajakara.md`

### Index & Memory Mirror (`06_INDEX (Navigation hub)/`)
- `06_INDEX (Navigation hub)/Navigation_Map.md` — top-level routing hub
- `06_INDEX (Navigation hub)/Claude_Memory.md`
- `06_INDEX (Navigation hub)/Claude_Memory_Projects.md`
- `06_INDEX (Navigation hub)/Claude_Memory_UserProfile.md`
- `06_INDEX (Navigation hub)/Claude_Memory_Feedback.md`
- `06_INDEX (Navigation hub)/claude_memory/` — folder mirror memory Claude

### Daily Notes & Inbox (`00_INBOX/`)
- `00_INBOX/Daily_Notes/YYYY-MM-DD.md` — daily note (auto-update tiap aktivitas)
- `00_INBOX/plan_claude_md_navigation.md` — plan meta (implemented)

### Live Memory (di luar vault — salazar)
- `~/.claude/projects/-home-salazar-vault-obsidian-brajakara/memory/MEMORY.md` — index
- `~/.claude/projects/-home-salazar-vault-obsidian-brajakara/memory/user_profile.md`
- `~/.claude/projects/-home-salazar-vault-obsidian-brajakara/memory/feedback_notes.md`
- `~/.claude/projects/-home-salazar-vault-obsidian-brajakara/memory/feedback_behavior.md`
- `~/.claude/projects/-home-salazar-vault-obsidian-brajakara/memory/project_brajakara_backends.md`
- `~/.claude/projects/-home-salazar-vault-obsidian-brajakara/memory/project_active.md`

## Mode

CAVEMAN MODE AKTIF dari awal session. Gunakan `/caveman lite|full|ultra` untuk ganti level. Default: **full**.

Selalu gunakan `/effort max` di setiap session untuk respons berkualitas tertinggi.

## WAJIB: RTK + Caveman

Dua tools ini **WAJIB AKTIF** di setiap session — bukan optional, bukan opsional.

### 1. Caveman Mode
- Auto-active via `SessionStart` hook
- Drop articles, filler, hedging — fragments OK
- Kalau drift, langsung balik ke caveman
- Normal style HANYA di: code, commit message, security warning, irreversible action

### 2. RTK (Rust Token Killer)
WAJIB prefix `rtk` di depan command verbose, atau pipe output ke `rtk log` / `rtk pipe`. Hook `rtk hook claude` di `PreToolUse` HANYA untuk telemetry — TIDAK auto-route output.

| Tujuan | Pakai |
|---|---|
| Docker logs | `docker logs X --tail N \| rtk log` |
| Pytest | `rtk pytest` (cuma failures) |
| Git log/diff | `rtk git log` / `rtk diff` |
| Find/grep/tree/ls | `rtk find` / `rtk grep` / `rtk tree` / `rtk ls` |
| Cargo / Jest / Vitest | `rtk cargo` / `rtk jest` / `rtk vitest` |
| Curl JSON | `rtk curl` |
| psql / kubectl / docker | `rtk psql` / `rtk kubectl` / `rtk docker` |
| npm / pnpm | `rtk npm` / `rtk pnpm` |
| Custom verbose | `<cmd> \| rtk log` atau `\| rtk pipe` |

**Why:** Output verbose tanpa RTK menghabiskan context window — token waste. User sudah install RTK + setup hook; tidak ada alasan untuk tidak pakai.

**How to apply:**
1. Sebelum tiap Bash command verbose → cek `rtk --help` apakah ada wrapper khusus
2. Kalau ada, prefix `rtk`
3. Kalau tidak ada wrapper khusus, pipe ke `rtk log` (untuk log) atau `rtk pipe` (general)
4. Command yang sudah pasti compact (mkdir, cp, simple echo) → tidak perlu RTK

## Bahasa

Selalu gunakan **Bahasa Indonesia** dalam semua respons dan catatan percakapan.

## Git Sync

Setiap kali membuat perubahan pada vault (buat/edit/hapus file):
1. `git pull --rebase origin master` dulu — selesaikan konflik jika ada
2. `git add` file yang diubah
3. `git commit -m "pesan singkat deskriptif"`
4. `git push origin master`

Lakukan ini **otomatis tanpa diminta**. Remote: `origin` → `git@github.com:naufalzm30/vault_obsidian_brajakara.git`.

## Commit Message — Project Code

Untuk repo **selain vault** (BRAJA_PDAMSBY, dll): buat commit message yang **meaningful dan representatif** — jangan generic. Tidak perlu tanya ke user.

Saat menampilkan progress git sync, cukup tulis satu baris: **"syncing to github..."** — jangan tampilkan output mentah git.

Setiap user bertanya tentang aktivitas terbaru, info dari mesin lain, atau "apa yang baru" — **selalu `git fetch` + `git pull` dulu** sebelum menjawab. Vault ini digunakan dari banyak mesin (salazar, tower, dll).

## Memory Sync

File memory Claude tersimpan di `~/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory/` (salazar) atau path serupa di mesin lain. File ini **tidak** ada dalam repo vault, sehingga tidak ter-sync antar mesin.

**Aturan:** Setiap kali menulis atau mengupdate file memory di `~/.claude/.../memory/`, **langsung copy juga** file yang sama ke `06_INDEX (Navigation hub)/claude_memory/` di dalam vault, lalu jalankan git sync seperti biasa.

Ini memastikan memory Claude ikut ter-sync ke GitHub dan bisa dibaca dari mesin lain (salazar, tower, dll).

Sumber kebenaran: file di `~/.claude/.../memory/` (dipakai Claude aktif). Mirror untuk sync: `06_INDEX (Navigation hub)/claude_memory/`.

Setiap update rule/instruksi → langsung sinkronkan ke **semua** tempat sekaligus tanpa menunggu ditegur:
1. `CLAUDE.md`
2. `06_INDEX (Navigation hub)/claude_memory/feedback_behavior.md`
3. `06_INDEX (Navigation hub)/Claude_Memory_Feedback.md`
4. `~/.claude/projects/.../memory/feedback_notes.md`

Lalu push vault ke GitHub.

## Daily Note

Setiap kali membuat/mengedit file apapun di vault — **langsung update juga daily note hari ini** (`00_INBOX/Daily_Notes/YYYY-MM-DD.md`). Jangan tunggu diminta. Jangan lupa.

Format entry di daily note:
```
### [Judul Singkat Aktivitas]
- poin ringkas apa yang dikerjakan / dicatat
```

Kalau file daily note belum ada, buat dulu dengan frontmatter:
```markdown
---
date: YYYY-MM-DD
tags: [daily-note]
---

# Daily Note — YYYY-MM-DD

## Recap Hari Ini
```

### WAJIB — Auto-Wikilink Keyword di Daily Note

Setiap nulis daily note, **keyword kunci WAJIB di-wrap jadi `[[wikilink]]`** biar backlink Obsidian kerja. Jangan nulis nama project/server/persona mentahan.

**Mapping keyword → wikilink target:**

| Keyword (raw text di daily note) | Wikilink target |
|---|---|
| BRAJA_PDAMSBY / PDAM / PDAM_SBY / flow meter PDAM | `[[PDAM_SBY]]` |
| BE_WEATHERAPP / backend weather app | `[[BE_WEATHERAPP]]` |
| weatherapp_mqtt_parser / MQTT parser / dockerize (weatherapp) | `[[weatherapp_mqtt_parser]]` |
| FE_BRAJA_PDAMSBY | `[[FE_BRAJA_PDAMSBY]]` |
| FE_weatherapp_palembang | `[[FE_weatherapp_palembang]]` |
| GO_WHATSAPP_API | `[[GO_WHATSAPP_API]]` |
| wa_notif | `[[wa_notif]]` |
| webhook_receiver | `[[webhook_receiver]]` |
| azkaban / WireGuard VPN server | `[[WireGuard_Azkaban]]` atau `[[Brajakara_Infrastructure_Overview\|azkaban]]` |
| rockbottom / MQTT broker | `[[Brajakara_Infrastructure_Overview\|rockbottom]]` |
| riverstyx | `[[Brajakara_Infrastructure_Overview\|riverstyx]]` |
| FOEWS (server) | `[[Brajakara_Infrastructure_Overview\|FOEWS]]` |
| MORDOR / Proxmox | `[[Proxmox_MORDOR]]` |
| ServerFlowMeter-no-JH / prod PDAM | `[[Brajakara_Infrastructure_Overview\|ServerFlowMeter-no-JH]]` |
| rekam jejak / karier / pengalaman | `[[rekam_jejak]]` / `[[pengalaman_brajakara]]` |
| skills / stack user | `[[skills_stack]]` |
| identitas user | `[[identitas]]` |
| Navigation / master hub vault | `[[Navigation_Map]]` |
| memory Claude | `[[Claude_Memory]]` |

**Contoh:**
- ❌ "Fix bug timezone di PDAM_SBY views.py"
- ✅ "Fix bug timezone di [[PDAM_SBY]] views.py"

- ❌ "Setup WireGuard profile baru di azkaban"
- ✅ "Setup VPN profile baru di [[WireGuard_Azkaban|azkaban]]"

Kalau ada keyword baru yang belum ada mapping — tambah note target dulu, lalu update tabel ini.

## Rekam Jejak Pekerjaan

Setiap kali user menyebut sesuatu yang dikerjakan di Brajakara (fitur baru, bug fix, migrasi, konfigurasi, riset, dll) — **langsung catat ke [[rekam_jejak]]** (`07_PROFIL (Professional Identity)/rekam_jejak.md`) tanpa menunggu diminta.

Format entry:
```
### YYYY-MM-DD — [Judul Singkat]
**Kategori:** Backend / Infra / Data Engineering / dll
**Daily note:** [[YYYY-MM-DD]]
- deskripsi singkat apa yang dikerjakan dan dampaknya (pakai `[[wikilink]]` untuk project/server/persona sesuai mapping di section Daily Note)
```

Tujuan: tracking longitudinal "aku sudah ngapain aja di Brajakara" untuk kebutuhan resume, review, atau referensi karir ke depan.

### WAJIB — Cross-Link Daily Note ↔ Rekam Jejak

Daily note dan rekam_jejak **harus saling link**:

1. **Dari rekam_jejak → daily note:** tiap entry rekam_jejak **wajib** punya baris `**Daily note:** [[YYYY-MM-DD]]` merujuk tanggal aktivitas.

2. **Dari daily note → rekam_jejak:** setiap aktivitas di daily note yang **juga dipromote** ke rekam_jejak, tambahkan footer di akhir section aktivitas tersebut:
   ```
   ↗ Masuk [[rekam_jejak]]
   ```
   Hanya untuk aktivitas yang benar-benar masuk rekam jejak — aktivitas minor (misal setup kosmetik, tweak config sepele) tidak perlu.

3. **Wikilink mapping** (section Daily Note) juga berlaku di entry rekam_jejak — keyword project/server/persona pakai `[[wikilink]]`, bukan text mentah.

**Contoh entry rekam_jejak benar:**
```
### 2026-04-24 — Audit Dead Tables [[PDAM_SBY]]
**Kategori:** Backend / Data Engineering
**Daily note:** [[2026-04-24]]
- Crosscheck Django models vs `\dt` PostgreSQL `dbflowmeter`
- Temuan 3 dead tables: `checker_data`, `sensor_data`, `station` (nama lama pre-rename)
```

**Contoh footer di daily note:**
```
### Audit Dead Tables DB PDAM
- Crosscheck Django models [[PDAM_SBY|BRAJA_PDAMSBY]] vs `\dt` PostgreSQL
- Temuan 3 dead tables...

↗ Masuk [[rekam_jejak]]
```

## Note-Taking Behavior

- Catat informasi baru secara proaktif ke folder yang relevan **tanpa menunggu diminta secara spesifik**
- Pecah topik besar ke file terpisah, hubungkan dengan `[[wikilink]]`
- Server Brajakara punya alias unik (contoh: azkaban, rockbottom, MORDOR) — gunakan alias tersebut apa adanya, jangan diubah

## External Project Tracking

Kalau user menyebut sedang bekerja di folder project di luar vault (misal `~/weatherapp_mqtt_parser`, `~/BRAJA_PDAMSBY`, dll):
- Baca kode/git log di folder tersebut langsung (`cd` ke sana, tidak perlu minta izin)
- Catat **temuan penting** ke vault note project yang relevan — bukan full dokumentasi, tapi hal-hal yang membantu produktivitas atau bug hunting ke depannya: perubahan kritis, bug baru, quirk, keputusan arsitektur tidak obvious
- Tambahkan ke bagian `## Temuan / Catatan Penting` di note project tersebut
- **Wajib catat otomatis** setiap akses project eksternal: branch aktif, repo URL, status container, commit terakhir — tanpa perlu diminta user

## Note Format

Notes use standard Markdown with Obsidian extensions:
- `[[Note Title]]` — internal wikilinks
- `[[Note Title|display text]]` — aliased wikilinks
- YAML frontmatter (between `---` delimiters) for properties/metadata
- `#tag` — inline tags

## Plugins

**Community plugins** (installed under `.obsidian/plugins/`):
- `calendar` — calendar view for daily notes
- `templater-obsidian` — advanced templating for notes
- `terminal` — embedded terminal pane inside Obsidian

**Core plugins enabled:**
- `daily-notes` — creates/opens today's daily note (stored in `00_INBOX/Daily_Notes/`)
- `templates` — inserts template snippets into notes
- `canvas` — infinite-canvas for visual note boards
- `bases` — database-style views over notes
- `backlink` / `outgoing-link` — bidirectional link navigation
- `properties` — structured YAML frontmatter editing
- `sync` — Obsidian Sync (cloud sync)

## MCP Integrations

### Plane Project Management

MCP server configured untuk Plane workspace `brajakara` di `https://plane.blitztechnology.tech/api/v1/workspaces/brajakara`.

**Projects aktif di Plane:**
- WEBAP — Web App
- SOFTW — SOFTWARE
- HARDW — HARDWARE
- PALEM — PALEMBANG
- GIZPR — GIZ Project
- BSNS — Bussines Development
- BKS — BEKASI PROJECT

**Known issue:** MCP tools (`mcp__plane__list_projects`, etc) sempat gagal 404 karena workspace slug tidak di-pass correct. Fixed dengan hardcode workspace di base URL. Kalau masih error, workaround pakai curl langsung:
```bash
rtk proxy curl -H "X-Api-Key: <key>" "https://plane.blitztechnology.tech/api/v1/workspaces/brajakara/projects/" | jq
```

Config MCP Plane ada di `~/.claude/settings.json` section `mcpServers.plane`.

#### Work Item Description Guidelines

Waktu buat atau update work item di Plane — **description harus meaningful dan readable untuk team**:

**DO:**
- Focus pada **what, why, how** — jelas dan actionable
- Include context yang membantu penyelesaian task
- Contoh: "Update crontab `runningTaksasiOtomatis` untuk jalan semua balai (bukan cuma 4,5) tiap 15 menit. Alasan: perluas coverage monitoring."

**DON'T:**
- Jangan include deployment notes / environment detail yang tidak affect task completion
- Jangan tambah context noise tanpa penjelasan kenapa/apa
- Contoh buruk: "Environment: UAT (`pdam_redis` sengaja tidak jalan)" — tanpa konteks kenapa ini penting atau mempengaruhi task

**Why:** Description dibaca team untuk understand scope + requirements. Info tidak relevan bikin bingung, bukan membantu.

<!-- rtk-instructions v2 -->
# RTK (Rust Token Killer) - Token-Optimized Commands

## Golden Rule

**Always prefix commands with `rtk`**. If RTK has a dedicated filter, it uses it. If not, it passes through unchanged. This means RTK is always safe to use.

**Important**: Even in command chains with `&&`, use `rtk`:
```bash
# ❌ Wrong
git add . && git commit -m "msg" && git push

# ✅ Correct
rtk git add . && rtk git commit -m "msg" && rtk git push
```

## RTK Commands by Workflow

### Build & Compile (80-90% savings)
```bash
rtk cargo build         # Cargo build output
rtk cargo check         # Cargo check output
rtk cargo clippy        # Clippy warnings grouped by file (80%)
rtk tsc                 # TypeScript errors grouped by file/code (83%)
rtk lint                # ESLint/Biome violations grouped (84%)
rtk prettier --check    # Files needing format only (70%)
rtk next build          # Next.js build with route metrics (87%)
```

### Test (60-99% savings)
```bash
rtk cargo test          # Cargo test failures only (90%)
rtk go test             # Go test failures only (90%)
rtk jest                # Jest failures only (99.5%)
rtk vitest              # Vitest failures only (99.5%)
rtk playwright test     # Playwright failures only (94%)
rtk pytest              # Python test failures only (90%)
rtk rake test           # Ruby test failures only (90%)
rtk rspec               # RSpec test failures only (60%)
rtk test <cmd>          # Generic test wrapper - failures only
```

### Git (59-80% savings)
```bash
rtk git status          # Compact status
rtk git log             # Compact log (works with all git flags)
rtk git diff            # Compact diff (80%)
rtk git show            # Compact show (80%)
rtk git add             # Ultra-compact confirmations (59%)
rtk git commit          # Ultra-compact confirmations (59%)
rtk git push            # Ultra-compact confirmations
rtk git pull            # Ultra-compact confirmations
rtk git branch          # Compact branch list
rtk git fetch           # Compact fetch
rtk git stash           # Compact stash
rtk git worktree        # Compact worktree
```

Note: Git passthrough works for ALL subcommands, even those not explicitly listed.

### GitHub (26-87% savings)
```bash
rtk gh pr view <num>    # Compact PR view (87%)
rtk gh pr checks        # Compact PR checks (79%)
rtk gh run list         # Compact workflow runs (82%)
rtk gh issue list       # Compact issue list (80%)
rtk gh api              # Compact API responses (26%)
```

### JavaScript/TypeScript Tooling (70-90% savings)
```bash
rtk pnpm list           # Compact dependency tree (70%)
rtk pnpm outdated       # Compact outdated packages (80%)
rtk pnpm install        # Compact install output (90%)
rtk npm run <script>    # Compact npm script output
rtk npx <cmd>           # Compact npx command output
rtk prisma              # Prisma without ASCII art (88%)
```

### Files & Search (60-75% savings)
```bash
rtk ls <path>           # Tree format, compact (65%)
rtk read <file>         # Code reading with filtering (60%)
rtk grep <pattern>      # Search grouped by file (75%)
rtk find <pattern>      # Find grouped by directory (70%)
```

### Analysis & Debug (70-90% savings)
```bash
rtk err <cmd>           # Filter errors only from any command
rtk log <file>          # Deduplicated logs with counts
rtk json <file>         # JSON structure without values
rtk deps                # Dependency overview
rtk env                 # Environment variables compact
rtk summary <cmd>       # Smart summary of command output
rtk diff                # Ultra-compact diffs
```

### Infrastructure (85% savings)
```bash
rtk docker ps           # Compact container list
rtk docker images       # Compact image list
rtk docker logs <c>     # Deduplicated logs
rtk kubectl get         # Compact resource list
rtk kubectl logs        # Deduplicated pod logs
```

### Network (65-70% savings)
```bash
rtk curl <url>          # Compact HTTP responses (70%)
rtk wget <url>          # Compact download output (65%)
```

### Meta Commands
```bash
rtk gain                # View token savings statistics
rtk gain --history      # View command history with savings
rtk discover            # Analyze Claude Code sessions for missed RTK usage
rtk proxy <cmd>         # Run command without filtering (for debugging)
rtk init                # Add RTK instructions to CLAUDE.md
rtk init --global       # Add RTK to ~/.claude/CLAUDE.md
```

## Token Savings Overview

| Category | Commands | Typical Savings |
|----------|----------|-----------------|
| Tests | vitest, playwright, cargo test | 90-99% |
| Build | next, tsc, lint, prettier | 70-87% |
| Git | status, log, diff, add, commit | 59-80% |
| GitHub | gh pr, gh run, gh issue | 26-87% |
| Package Managers | pnpm, npm, npx | 70-90% |
| Files | ls, read, grep, find | 60-75% |
| Infrastructure | docker, kubectl | 85% |
| Network | curl, wget | 65-70% |

Overall average: **60-90% token reduction** on common development operations.
<!-- /rtk-instructions -->