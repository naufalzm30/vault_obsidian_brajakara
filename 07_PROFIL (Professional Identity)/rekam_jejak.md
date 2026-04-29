---
type: reference
category: profile
hop: 2
tags: [profile/career]
up: "[[07_PROFIL (Professional Identity)/index]]"
date: 2026-04-17
---

# Rekam Jejak Pekerjaan — Brajakara Teknologi

Tracking longitudinal aktivitas pekerjaan di Brajakara untuk referensi resume, review karir, dan dokumentasi pribadi.

---

### 2026-04-17 — Setup Folder Profil Professional
**Kategori:** Dokumentasi
**Daily note:** 2026-04-17
- Membuat folder `07_PROFIL` di vault sebagai referensi [[identitas|identitas profesional]] dan resume

---

### 2026-04-18 — Otomasi Provisioning WireGuard VPN
**Kategori:** Infrastructure / DevOps
**Daily note:** 2026-04-18
- Analisa struktur konfigurasi WireGuard di server azkaban (103.103.23.233): pola naming, subnet, perbedaan config tipe `adm` vs `sta`
- Menemukan bahwa `server_peers.conf` bukan include aktif WireGuard — hanya referensi manual yang out-of-sync, bukan bagian dari protokol
- Membuat script `generate_new_profile.sh` di `/etc/wireguard/` untuk otomasi pembuatan profil VPN baru: auto-increment nama profil, validasi subnet, cek duplikasi IP, generate keypair, distribusi file ke folder yang tepat, hot-reload peer tanpa restart interface
- Menambahkan nama pemilik profil sebagai comment konsisten di semua file (`keys/`, `client_configs/`, `wg0.conf`, `server_peers.conf`)
- Merapikan entry `adm0121` (bang vius) yang formatnya tidak konsisten — di-rename ke `adm0026` sesuai urutan iterasi, comment digabung jadi satu baris
- Membuat `README.md` di `/etc/wireguard/` sebagai dokumentasi operator
- Mendokumentasikan seluruh setup ke vault (WireGuard_Azkaban)

---

### 2026-04-20 — Module check_data PDAM_SBY
**Kategori:** Backend
**Daily note:** 2026-04-20
- Analisis `CheckMissingDataCount` di `views.py` — temuan timezone bug (`astimezone` vs `localize`)
- Buat module `core_logic/check_data/` dengan 4 file: `check_missing.py`, `check_threshold.py`, `check_voltased.py`, `run_checks.py`
- `docker_compose_guard.sh` dibuat + fix shebang + auto-detect path

---

### 2026-04-21 — Stateful Alert System + Telegram Integration PDAM_SBY
**Kategori:** Backend
**Daily note:** 2026-04-21
- Lanjut implementasi `run_checks.py` + integrasi Telegram bot `@suryasembadabot`, 4 channel (MISSING/THRESHOLD/VOLTASE_TURUN/KUBIKASI_MINUS)
- Stateful alert via Redis: state machine OK→SUSPECT→MISSING→CRITICAL, 2-cycle confirm, escalate >2 jam, graceful fallback kalau Redis down
- Tier routing: WARNING real-time, CRITICAL always, INFO digest, ≥5 station = OUTAGE 1 notif

---

### 2026-04-29 — Graph View Optimization — Breadcrumbs + Routing Cleanup
**Kategori:** Dokumentasi / Knowledge Management
**Daily note:** 2026-04-29
- Setup Breadcrumbs plugin Obsidian untuk hierarchical graph view vault
- Implementasi `up`/`down` metadata di semua files (Navigation_Map → 5 folder indexes → detail files → 11 daily notes)
- Document exception rule: Breadcrumbs metadata boleh cross-folder, content wikilinks strict same-folder
- CLAUDE.md cleanup: remove 30+ wikilinks spam, cuma 1 ke Navigation_Map
- Create INBOX index + Daily Notes index untuk routing daily notes + keyword mapping
- Memory files routing: Navigation_Map → Claude_Memory.md → summary files (UserProfile, Feedback, Projects)
- Fix feedback_behavior.md: escape wikilinks dalam contoh untuk avoid graph links
- Graph view clean + hierarchical — no file lepas
- Quiet hours 22:00–06:00: WARNING buffered, CRITICAL tetap real-time
- Lagging window lag=20 mnt, window=60 mnt → alert ~45 mnt setelah data stop
- Deploy pending ke prod ServerFlowMeter-no-JH — perlu tambah `TELEGRAM_BOT_TOKEN` ke `.env` prod
- Plus fix hook `SessionStart`/`UserPromptSubmit` error node not found — buat `.claude/find-node.sh` wrapper portabel (nvm/volta/fnm/PATH)

---

### 2026-04-28 — MCP Plane Integration Debug
**Kategori:** Infrastructure / Integration
**Daily note:** 2026-04-28
- Troubleshoot MCP Plane tools return HTTP 404 untuk self-hosted instance `https://plane.blitztechnology.tech`
- Verify direct API call work: `/api/v1/workspaces/brajakara/projects/` return 7 projects (WEBAP, SOFTW, HARDW, PALEM, GIZPR, BSNS, BKS)
- Clone repo `makeplane/plane-mcp-server`, install `plane-sdk==0.2.10`, test SDK behavior dengan self-hosted config
- **Confirmed SDK work proper** — test script `/tmp/test_plane_sdk.py` berhasil fetch projects via `PlaneClient`
- Root cause: bukan bug SDK atau base URL, kemungkinan MCP server instance di Claude Code cached/tidak reload env vars
- Pending: test ulang setelah restart Claude Code session
- Setup BRAJA_PDAMSBY di tower: install RTK 0.37.2 + register repo ke code-review-graph MCP (1183 nodes)

---

### 2026-04-24 — Audit Dead Tables PDAM_SBY
**Kategori:** Backend / Data Engineering
**Daily note:** 2026-04-24
- Crosscheck Django models vs `\dt` PostgreSQL `dbflowmeter`
- Temuan 3 dead tables: `checker_data`, `sensor_data`, `station` (nama lama pre-rename ke prefix `pdam_`)
- 19 custom tabel Django hadir semua — tidak ada yang hilang

---

### 2026-04-25 — Cross-Link Daily Note ↔ Rekam Jejak
**Kategori:** Dokumentasi / Meta
**Daily note:** 2026-04-25
- Retrofit footer `↗ Masuk [[rekam_jejak]]` di semua entry daily note yang dipromote ke rekam_jejak (5 daily note, 6 section)
- Retrofit [[rekam_jejak]]: tambah `**Daily note:** [[YYYY-MM-DD]]` + wikilink keyword per entry
- Tambah rule cross-link di `CLAUDE.md` — format standar + contoh eksplisit
- Backlink Obsidian sekarang bidireksional: daily note → rekam_jejak via footer, rekam_jejak → daily note via field

---

### 2026-04-24 — Optimasi CLAUDE.md Navigation Vault
**Kategori:** Dokumentasi / Meta
**Daily note:** 2026-04-24
- Identifikasi masalah: navigasi dari `CLAUDE.md` ke notes/project/persona tidak efisien — Claude sering tebak path, baca satu-per-satu
- Tambah 9 section ke `CLAUDE.md`: Navigation Map, Server Alias Quick Ref, Machine Profiles, Persona Shortcuts, Triage, Global Gotchas, Domain Glossary, Env/Secrets Matrix, Startup Ritual
- Backfill 5 note skeleton: FE_BRAJA_PDAMSBY, FE_weatherapp_palembang, GO_WHATSAPP_API, wa_notif, webhook_receiver
- Rewrite tabel di `CLAUDE.md` pakai `[[wikilink]]` + absolute vault path, tambah section `## Vault File Index`
- Bikin Navigation_Map master hub navigable di `06_INDEX/`
- Tambah rule auto-wikilink keyword di daily note + cross-link daily note ↔ rekam_jejak

---

### 2026-04-26 — Dokumentasi Docker Compose MinIO
**Kategori:** Infrastruktur
**Daily note:** 2026-04-26
- Setup dokumentasi Docker Compose MinIO baru untuk rencana migrasi dari baremetal.

---

### 2026-04-27 — MCP Plane Integration + CLAUDE.md Documentation Improvements
**Kategori:** Infrastruktur / Dokumentasi
**Daily note:** 2026-04-27
- Troubleshoot MCP Plane tool `mcp__plane__list_projects` gagal 404 — workspace slug dari env var tidak di-construct correct ke API endpoint
- Fix config MCP di `~/.claude/settings.json`: hardcode workspace `brajakara` di base URL (workaround bug MCP server package)
- Test via `rtk proxy curl`: detect 7 projects aktif di Plane (WEBAP, SOFTW, HARDW, PALEM, GIZPR, BSNS, BKS)
- Improve CLAUDE.md: tambah vault scope clarification (meta-layer vs code projects), Multi-AI Support section (mention GEMINI.md), MCP Integrations section dengan known issues + workaround
- Document troubleshooting workflow untuk future MCP integration issues

---

### 2026-04-28 — Strict Hierarchical Linking Structure — Vault Navigation Optimization
**Kategori:** Dokumentasi / Knowledge Management
**Daily note:** 2026-04-28
- Enforce strict hierarchical linking di vault: CLAUDE.md → Navigation_Map → folder indexes → detail files (3-hop routing)
- **Same-folder wikilink rule**: folder index hanya boleh link ke file dalam folder itu sendiri (audit 4 index files, fix 1 cross-folder link di `08_HERMES_AGENT/index.md`)
- **CLAUDE.md lean approach**: hapus 25 wikilinks (58 → 33), plain text mention keywords, wikilink only ke indexes
- **Index files heavy approach**: comprehensive keyword mapping dengan full wikilink ke detail files
- **YAML frontmatter metadata**: standardize `type`, `category`, `hop`, `tags` di semua files untuk fast routing tanpa read full content
- **Benefit**: routing konsisten, scalable (tambah entry = update folder index saja), context optimization, nearest path optimal
- Root cause optimization: Claude gagal find info "tower" padahal ada di Proxmox_MORDOR — tidak connect tower = VM = MORDOR karena flat routing pattern

---

### (Ongoing) — Data Engineering WEATHERAPP
**Kategori:** Data Engineering
- Melakukan ekstraksi data (data mining) dari format saintifik kompleks **NetCDF** dan **Weatherlink**
- Pengolahan data presipitasi (curah hujan) yang akurat untuk input pipeline prediksi

### (Ongoing) — Backend PDAM Surabaya (Full Ownership)
**Kategori:** Backend
- Bertanggung jawab penuh atas seluruh backend PDAM SBY — semua fitur API dan function logic yang bersifat domain-spesifik PDAM dikerjakan sendiri
- Termasuk: sistem taksasi otomatis per balai, taksasi manual, dan seluruh business logic lainnya
- Pengelolaan environment UAT dan produksi paralel

### (Ongoing) — Infrastruktur Virtualisasi
**Kategori:** Infrastructure
- Operasi dan manajemen **Proxmox VE** sebagai sandbox terisolasi untuk pengujian fitur baru

### (Ongoing) — Jaringan VPN Multi-Node
**Kategori:** Infrastructure / Networking
- Membangun dan memelihara jaringan **WireGuard VPN** antar server (VPS Biznet, Hostinger, on-premise)

---

> Entri bertanggal "Ongoing" akan diperbarui dengan tanggal aktual saat detail diketahui.
