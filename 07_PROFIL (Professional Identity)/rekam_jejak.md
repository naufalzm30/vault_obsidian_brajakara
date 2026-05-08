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

### 2026-05-08 — SSO Migration: Dex → Authentik (Outline Wiki)
**Kategori:** Infrastructure / Auth
**Daily note:** [[2026-05-08]]
**Effort:** 🟡 Medium (setup Dex + decision migrate + Authentik install)
**Team:** Solo
**Sebelum:** Pakai Dex untuk SSO — kompleks, kurang pas untuk kebutuhan.
**Sesudah:** Migrasi ke Authentik sebagai IdP. Instance Authentik sudah terpasang. SSO Google (OIDC) belum di-hook ke aplikasi target (Outline Wiki).
**Next:** Implementasi Google OAuth di Authentik → connect ke Outline Wiki untuk bypass Gmail domain restriction.
**Artifact:** Authentik instance running, Outline Wiki pending auth migration.

### 2026-05-08 — Outline Wiki Deployment + Authentik Setup
**Kategori:** Infrastructure / Auth
**Daily note:** [[2026-05-08]]
**Effort:** 🟡 Medium (3 jam — setup Outline, debug proxy, riset Authentik)
**Team:** Solo
**Sebelum:** Outline Wiki blocked domain Gmail personal, auth manual.
**Sesudah:** Outline running (port 3101), fix proxy SSL via azkaban, roadmap migrasi SSO Authentik sebagai IdP untuk bypass domain restriction.
**Artifact:** Outline running, SRS PDAM (updated via daily note).

### 2026-05-08 — Software Engineering Documentation Reference + SRS BRAJA_PDAMSBY
**Kategori:** Documentation / Backend
**Daily note:** [[2026-05-08]]
**Effort:** 🟡 Medium (3 jam — SE doc ref + SRS full write dari reverse-engineer codebase)
**Team:** Solo

#### Part 1: SE Doc Types Reference
**Sebelum:** Sering dengar BRD/PRD/SRS/API Ref tapi tidak jelas kapan pakai, tujuan, isi apa, sebelum/sesudah code
**Sesudah:** Referensi lengkap 8 doc type dengan tabel ringkas + detail + contoh Brajakara workflow
**Artifact:** `02_BACKEND_REFERENCE/Software_Engineering_Documentation.md`
- 8 doc type: BRD (stakeholder), PRD (PM+Eng), SRS (Eng), TDD (QA), Architecture (Tech Lead), API Ref (Eng), User Manual (operator), Deployment (DevOps)
- Per doc: audience, kapan buat (sebelum/sesudah code), isi lengkap, contoh Brajakara
- Brajakara workflow recommended: kickoff → sprint → coding → review → release → prod

#### Part 2: SRS BRAJA_PDAMSBY (Production Project)
**Sebelum:** Tidak ada formal SRS untuk codebase production PDAM_SBY yang sudah jalan
**Sesudah:** SRS komprehensif (43KB, 11 section) dari reverse-engineer kodebase production
**Skill:** Technical writing, requirement extraction, Django/PostgreSQL architecture analysis
**Challenge:** Extract dari 6800+ lines views.py, 30+ tabel, 50+ cron command — organize jadi SRS clean
**Artifact:** `~/BRAJA_PDAMSBY/SRS_BRAJA_PDAMSBY.md`
- Functional req: MQTT ingestion (2-min interval), anomaly detection (MISSING/THRESHOLD/VOLTASE/KUBIKASI), alert system (stateful, Telegram, quiet hour), taksasi ARIMA/ML, REST API (dashboard, data query, download, taksasi approval, bulk upload)
- Non-functional: performance (API <500ms p95), scalability (100+ station future), security (JWT/RBAC), reliability (SLA 99.5%, backup daily)
- Data model: 10+ tabel PostgreSQL documented (station, sensor_data, threshold, telegram_notification, raw_message, maintenance_record, dll)
- API spec: OpenAPI 3.0 format (auth, dashboard, data query+export, taksasi approval, bulk upload)
- Error handling: error code mapping, retry policy (MQTT/DB/Telegram), fallback strategy
- Deployment: env var list, cron jobs (4 job: message2sensordata 2min, check 5min, taksasi daily 06:00, telegram 1min)
- Testing: unit >60%, integration E2E (data flow, alert, taksasi), load test 50 concurrent user
- Known limitation + roadmap: Redis HA, ML anomaly detection, mobile app, WebSocket, microservice, Kubernetes
- Glossary: kubikasi, taksasi, totalizer, flow meter, voltase, lagging, MQTT, ARIMA, calibration
- Project: [[01_BACKEND_PROJECTS (Active development)/PDAM_SBY|PDAM_SBY]]

---

### 2026-05-06 — Tier 1+2 Fast Context Loading — Memory Optimization
**Kategori:** Infrastructure / Integration
**Daily note:** [[2026-05-06]]
**Effort:** 🟡 Medium (1.5 jam — 2 hooks + doc)
**Team:** Solo
**Sebelum:** Claude scan 62 files setiap session, context window 30+ KB, startup 3-5 detik, neural network "ga jalan" karena ga indexed
**Sesudah:** Tier 1 aggressive memory load (user profile + active projects + recent work + task pending) + Tier 2 auto-generated MEMORY_SUMMARY.md. Context window 10KB (~70% savings), startup <1s, index smart (hotspots, quick routes, recent activity)
**Skill:** Bash scripting, Hook optimization, Memory management
**Challenge:** Git log shorthand path (07_PROFIL tanpa full path) — accepted itu OK buat context
**Artifact:** 
- `session-start-v2.sh` — Tier 1 aggressive load
- `memory-chunk.sh` — Tier 2 auto-generate summary (daily refresh)
- `CLAUDE-NEURAL-NETWORK.md` — dokumentasi + roadmap Tier 3
- Hook chain di `.claude/settings.json`: memory-chunk.sh && session-start-v2.sh
- Backup: `settings.json.backup` (rollback aman)

---

### 2026-05-06 — Audit & Refactor Vault Brajakara — CLAUDE.md Rules + Support Files
**Kategori:** Documentation
**Daily note:** [[2026-05-06]]
**Effort:** 🟡 Medium (3 jam — analisis komprehensif + 7 fixes)
**Team:** Collab with claude-code-kit perspective
**Sebelum:** Vault setup solid tapi ada 5 issues (duplikasi memory folder, agents.md overlap, dev-db-plan orphan, GEMINI.md stale, RTK table duplikat) + 4 peluang optimize yang tidak tertangkap
**Sesudah:** Semua 7 issue + optimize fix applied. Memory files ter-load di session, agents.md jadi redirect, dev-db-plan discoverable + registered, GEMINI.md up-to-date, CLAUDE.md lean. Cloud sync ke GitHub.
**Skill:** Obsidian vault architecture, configuration management, documentation system design, Git workflow
**Challenge:** Duplikasi project folder dash vs underscore — subtle tapi break memory loading seluruhnya
**Artifact:** commit 9bd7eae — 7 files modified, 6 memory files synced, +1 TSV entry

---

### 2026-05-03 — Build Plane pi Extension
**Kategori:** Infrastructure / Integration
**Daily note:** [[2026-05-03]]
- MCP npm plane-mcp-server tidak kompatibel dengan pi (pi tidak support MCP protocol)
- Rebuild sebagai pi Extension TypeScript native: `~/.pi/agent/extensions/plane/index.ts`
- 5 tools: `plane_list_projects`, `plane_list_issues`, `plane_get_issue`, `plane_create_issue`, `plane_update_issue`
- Resolve project by identifier (WEBAP, SOFTW, dll), resolve state by name, cache in-memory
- Test API verified: 7 projects, issues WEBAP, states fetch semua OK

---

### 2026-04-30 — Export Schema PostgreSQL [[PDAM_SBY|BRAJA_PDAMSBY]]
**Kategori:** Backend / Data Engineering
**Daily note:** [[2026-04-30]]
- Export schema DB `pdamsby` (dev `192.168.1.41:2800`) ke `~/BRAJA_PDAMSBY/schema_pdamsby.sql` (1943 baris, 30 tabel)
- Bersihkan injeksi `\restrict`/`\unrestrict` dari proxy yang break syntax psql
- Schema portable — restore: `psql -U <user> -h <host> -d <db> -f schema_pdamsby.sql`

---

### 2026-04-17 — Setup Folder Profil Professional
**Kategori:** Dokumentasi
**Daily note:** 2026-04-17
- Membuat folder `07_PROFIL` di vault sebagai referensi [[identitas|identitas profesional]] dan resume

---

### 2026-04-18 — Otomasi Provisioning WireGuard VPN
**Kategori:** Infrastructure / Networking
**Daily note:** [[2026-04-18]]
**Effort:** 🔴 High (3 hari — analisa + script + cleanup + docs)
**Team:** Solo
**Sebelum:** Provisioning VPN manual, error-prone, tidak ada validasi IP duplikat, entry peer tidak konsisten format
**Sesudah:** Script auto-provision (`generate_new_profile.sh`) dengan validasi subnet, auto-increment, hot-reload tanpa restart interface — provisioning dari ~1 jam → 2 menit
**Skill:** WireGuard, Bash scripting, Subnet planning, Linux sysadmin
**Challenge:** `server_peers.conf` ternyata bukan include aktif WireGuard (hanya referensi manual) — stuck 1 hari cari why not loading, akhirnya discover via testing direct include
**Artifact:**
- Script: `/etc/wireguard/generate_new_profile.sh`
- Docs: [[04_INFRASTRUCTURE_REFERENCE/WireGuard_Azkaban|WireGuard_Azkaban]]
- README: `/etc/wireguard/README.md`
- Analisa struktur konfigurasi WireGuard di [[04_INFRASTRUCTURE_REFERENCE/Brajakara_Infrastructure_Overview|azkaban]] (103.103.23.233): pola naming, subnet, perbedaan config tipe `adm` vs `sta`
- Cleanup entry `adm0121` (bang vius) → rename ke `adm0026` (urutan iterasi), comment konsisten
- Nama pemilik profil sebagai comment di semua file (`keys/`, `client_configs/`, `wg0.conf`, `server_peers.conf`)

---

### 2026-04-20 — Module check_data PDAM_SBY
**Kategori:** Backend
**Daily note:** [[2026-04-20]]
**Effort:** 🟡 Medium (4 jam — analisa + module structure + guard script)
**Team:** Solo
**Sebelum:** Tidak ada sistem deteksi anomali otomatis — data validation manual atau missing sama sekali
**Sesudah:** Module `core_logic/check_data/` dengan 4 kategori check (missing, threshold, voltased, kubikasi), ready untuk wire ke Telegram alert
**Skill:** Python, Django, Architecture design, Bash scripting
**Artifact:**
- Module: `core_logic/check_data/` (4 file: check_missing.py, check_threshold.py, check_voltased.py, run_checks.py)
- Guard script: `docker_compose_guard.sh` (fix shebang, auto-detect path)
- Timezone bug discovery: `CheckMissingDataCount` di views.py (`astimezone` vs `localize` mismatch)
- Next: [[2026-04-21]] Stateful Alert System

---

### 2026-04-21 — Stateful Alert System + Telegram Integration PDAM_SBY
**Kategori:** Backend / DevOps
**Daily note:** [[2026-04-21]]
**Effort:** 🔴 High (2 hari — state machine design + Telegram integration + Redis fallback)
**Team:** Solo
**Sebelum:** Tidak ada sistem alerting otomatis — operator harus manual cek dashboard setiap hari untuk deteksi anomali sensor
**Sesudah:** Alert real-time via Telegram, MTTR berkurang dari ~2 jam → 15 menit (est.), 4 kategori alert (MISSING/THRESHOLD/VOLTASE_TURUN/KUBIKASI_MINUS), avg ~50 alerts/hari
**Skill:** Python, Redis, State machine design, Telegram Bot API, Distributed systems
**Artifact:**
- Code: `core_logic/check_data/run_checks.py`
- Related: [[01_BACKEND_PROJECTS (Active development)/PDAM_SBY|PDAM_SBY]]
- Implementasi `run_checks.py` + integrasi Telegram bot `@suryasembadabot`
- Stateful alert via Redis: state machine OK→SUSPECT→MISSING→CRITICAL, 2-cycle confirm, escalate >2 jam, graceful fallback kalau Redis down
- Tier routing: WARNING real-time, CRITICAL always, INFO digest, ≥5 station = OUTAGE 1 notif
- Quiet hours 22:00–06:00: WARNING buffered, CRITICAL tetap real-time
- Lagging window: lag=20 mnt, window=60 mnt → alert ~45 mnt setelah data stop

---

### 2026-04-29 — Graph View Optimization — Breadcrumbs + Routing Cleanup
**Kategori:** Documentation
**Daily note:** [[2026-04-29]]
**Effort:** 🟡 Medium (4 jam — Breadcrumbs setup + metadata retrofit + docs)
**Team:** Solo
**Sebelum:** Vault graph view flat — semua file terlihat sama level, tidak ada hierarki visual, Claude sering salah routing (cari "tower" tidak connect ke Proxmox_MORDOR)
**Sesudah:** Graph view hierarchical via Breadcrumbs plugin, routing konsisten 3-hop (CLAUDE.md → Navigation_Map → folder index → detail), metadata `up`/`down` di 20+ files
**Skill:** Obsidian plugins, YAML frontmatter, Knowledge graph design
**Artifact:**
- Navigation_Map: [[06_INDEX (Navigation hub)/Navigation_Map|Navigation_Map]]
- Breadcrumbs config: `.obsidian/plugins/breadcrumbs/`
- Setup Breadcrumbs plugin Obsidian untuk hierarchical graph view vault
- Implementasi `up`/`down` metadata di semua files (Navigation_Map → 5 folder indexes → detail files → 11 daily notes)
- Document exception rule: Breadcrumbs metadata boleh cross-folder, content wikilinks strict same-folder
- CLAUDE.md cleanup: remove 30+ wikilinks spam, cuma 1 ke Navigation_Map
- Create INBOX index + Daily Notes index untuk routing daily notes + keyword mapping
- Memory files routing: Navigation_Map → Claude_Memory.md → summary files (UserProfile, Feedback, Projects)
- Fix feedback_behavior.md: escape wikilinks dalam contoh untuk avoid graph links

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
**Daily note:** [[2026-04-24]]
**Effort:** 🟢 Low (2 jam — crosscheck + analysis)
**Team:** Solo
**Sebelum:** Unknown — tidak tahu apakah Django models semuanya ada di DB atau ada yang orphan/dead
**Sesudah:** Audit selesai: 19 tabel Django OK semua, 3 dead tables identified (nama lama pre-rename ke prefix `pdam_`)
**Skill:** PostgreSQL, Django ORM, Database schema audit
**Artifact:**
- Crosscheck Django models vs `\dt` PostgreSQL `dbflowmeter`
- Findings: 3 dead tables: `checker_data`, `sensor_data`, `station`
- Action pending: Drop dead tables (safe, tidak dipakai di code)

---

### 2026-04-25 — Cross-Link Daily Note ↔ Rekam Jejak
**Kategori:** Documentation
**Daily note:** [[2026-04-25]]
**Effort:** 🟢 Low (1 jam — retrofit + docs)
**Team:** Solo
**Sebelum:** Daily note dan rekam_jejak tidak bidirectional link — sulit trace "aktivitas X ada di daily note tanggal berapa" atau "daily note ini promote ke rekam_jejak mana"
**Sesudah:** Backlink bidireksional — daily note footer `↗ Masuk [[rekam_jejak]]`, rekam_jejak field `**Daily note:** [[YYYY-MM-DD]]`, Obsidian graph view terhubung 2 arah
**Skill:** Obsidian wikilinks, Backlink graph, Documentation patterns
**Artifact:**
- Rule: CLAUDE.md cross-link section
- Retrofit footer `↗ Masuk [[rekam_jejak]]` di 5 daily note (6 section)
- Retrofit [[07_PROFIL (Professional Identity)/rekam_jejak|rekam_jejak]]: tambah `**Daily note:** [[YYYY-MM-DD]]` + wikilink keyword per entry

---

### 2026-04-24 — Optimasi CLAUDE.md Navigation Vault
**Kategori:** Documentation
**Daily note:** [[2026-04-24]]
**Effort:** 🟡 Medium (3 jam — analisa + restructure CLAUDE.md + backfill)
**Team:** Solo
**Sebelum:** CLAUDE.md flat, Claude sering salah routing (tebak path, baca file 1-per-1), tidak ada triage table, tidak ada Navigation_Map
**Sesudah:** CLAUDE.md dengan 9 section navigasi (triage, glossary, env matrix, startup ritual), Navigation_Map master hub, routing efficient — Claude hit rate +70% (est.)
**Skill:** Technical documentation, Information architecture, CLAUDE.md patterns
**Artifact:**
- Navigation_Map: [[06_INDEX (Navigation hub)/Navigation_Map|Navigation_Map]]
- CLAUDE.md: vault root
- Tambah 9 section: Navigation Map, Server Alias Quick Ref, Machine Profiles, Persona Shortcuts, Triage, Global Gotchas, Domain Glossary, Env/Secrets Matrix, Startup Ritual
- Backfill 5 note skeleton: FE_BRAJA_PDAMSBY, FE_weatherapp_palembang, GO_WHATSAPP_API, wa_notif, webhook_receiver
- Rewrite tabel pakai `[[wikilink]]` + absolute vault path, section `## Vault File Index`
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
**Kategori:** Documentation
**Daily note:** [[2026-04-28]]
**Effort:** 🟡 Medium (2 jam — audit links + fix + standardize metadata)
**Team:** Solo
**Sebelum:** Wikilinks tidak konsisten (cross-folder links di index files), CLAUDE.md overload wikilinks (58 links), metadata tidak standar, routing pattern flat
**Sesudah:** 3-hop routing enforced (CLAUDE.md → Navigation_Map → folder index → detail), same-folder wikilink rule, CLAUDE.md lean (33 links), YAML metadata standardized di 20+ files
**Skill:** Information architecture, Knowledge graph optimization, YAML frontmatter
**Challenge:** Root cause analysis — Claude gagal find "tower" info karena flat routing (tidak connect tower = VM = MORDOR), took 1 jam troubleshoot before discover pattern issue
**Artifact:**
- Navigation_Map: [[06_INDEX (Navigation hub)/Navigation_Map|Navigation_Map]]
- Audit report: 4 index files, fix 1 cross-folder link di `08_HERMES_AGENT/index.md`
- Enforce strict hierarchical linking: CLAUDE.md → Navigation_Map → folder indexes → detail files
- Same-folder wikilink rule: index hanya link ke file dalam folder itu
- CLAUDE.md lean: hapus 25 wikilinks (58 → 33), plain text keywords, wikilink only ke indexes
- Index files heavy: comprehensive keyword mapping full wikilink ke detail
- YAML frontmatter standardized: `type`, `category`, `hop`, `tags`

---

---

## Ongoing Streams — Dated Snapshots

**Format: Snapshot update per bulan saat ada milestone baru**

### 2026-04 — Data Engineering WEATHERAPP (Ongoing Snapshot)
**Kategori:** Data Engineering
**Progress:** Month 2 — Riset NetCDF/Weatherlink format, pipeline data mining for precipitation accuracy
**Milestone terakhir:** [[2026-04-20]] Module check_data (anomali detection)
- Ekstraksi data dari format saintifik kompleks: **NetCDF** (cuaca satelit), **Weatherlink** (AWS station data)
- Processing pipeline: raw data → presipitasi volume m³ → input prediksi cuaca
- Project: [[01_BACKEND_PROJECTS (Active development)/BE_WEATHERAPP|BE_WEATHERAPP]]

**Update next milestone:** setiap ada progress baru (ETL script baru, accuracy improvement, new data source)

### 2026-04 — PDAM Backend Full Ownership (Ongoing Snapshot)
**Kategori:** Backend
**Progress:** Month 3 — Alert system deployed (prod UAT), taksasi automated, installer portable dev DB ready
**Milestone terakhir:** [[2026-05-04]] DB_UAT Portable Dev Database + E2E installer
- Full ownership backend API + business logic [[01_BACKEND_PROJECTS (Active development)/PDAM_SBY|BRAJA_PDAMSBY]]
- Sistem taksasi otomatis per balai (handle missing data via ARIMA/ML)
- Alert system real-time (Redis stateful, Telegram 4 kategori, ~50 alerts/hari)
- Environment UAT + prod paralel (192.168.1.41:2800 vs 128.46.8.224)

**Update next milestone:** setiap ada feature baru atau prod deployment

### 2026-04 — Infrastructure Virtualization Proxmox (Ongoing Snapshot)
**Kategori:** Infrastructure / Virtualization
**Progress:** Month 1 — Sandbox running, 4 VMs active (DungeonTower, lumbungpadi, spakborsupra, ABURAYA)
**Milestone terakhir:** [[2026-04-17]] Initial documentation setup
- Operasi + manajemen [[04_INFRASTRUCTURE_REFERENCE/Proxmox_MORDOR|Proxmox MORDOR]] on-premise
- Sandbox terisolasi untuk feature testing (development VM cluster, separate network)
- 4 VMs: DungeonTower (102), lumbungpadi, spakborsupra, ABURAYA

**Update next milestone:** setiap ada VM baru atau Proxmox upgrade

### 2026-04 — Jaringan VPN Multi-Node (Ongoing Snapshot)
**Kategori:** Infrastructure / Networking
**Progress:** Month 2 — Provisioning automation deployed, 30+ client profiles active
**Milestone terakhir:** [[2026-04-18]] WireGuard auto-provisioning script + cleanup
- WireGuard VPN antar server: VPS Biznet (prod), Hostinger (secondary), on-premise Proxmox
- Subnet: 10.20.0.x (admin), 10.20.1.x (station), routing via [[04_INFRASTRUCTURE_REFERENCE/WireGuard_Azkaban|azkaban]] endpoint
- Auto-provision script (`generate_new_profile.sh`), hot-reload, validasi duplikat IP

**Update next milestone:** setiap ada network scale/optimization atau new VPN user tier

### 2026-05-04 — DB_UAT Portable Dev Database — Final Debugging & Testing
**Kategori:** Backend / Data Engineering
**Daily note:** [[2026-05-04]]
**Effort:** 🟡 Medium (1 hari — debugging multi-issue + E2E test)
**Team:** Solo
**Sebelum:** Dev onboarding [[01_BACKEND_PROJECTS (Active development)/PDAM_SBY|BRAJA_PDAMSBY]] butuh 2-3 jam manual setup (schema import, static data, Docker build) — error-prone, tidak repeatable
**Sesudah:** Installer TUI interaktif dengan E2E test — onboarding dari 2-3 jam → 15 menit (automated), schema 30 tabel + static data portable, installer robust (zero manual step)
**Skill:** PostgreSQL, Bash scripting, Docker Compose, TUI design, E2E testing
**Challenge:** Script exit 137 (SIGKILL) pas stream output — root cause: `set -e` conflict dengan `tee` pipe, fixed dengan direct file redirect `/tmp/db_install.log`
**Artifact:**
- Installer: `install.sh` (TUI menu-driven, box UI, colored output)
- Test: `test_install.sh` (E2E automated verification)
- Schema: `schema_pdamsby.sql` (1943 baris, 30 tabel)
- Fixed schema import errors (dead table FK references ke `sensor_data`, `checker_data`, `station`)
- Fixed static data import collision dengan `TRUNCATE CASCADE` sebelum import
- Reverted `fzf` arrow key menu ke numeric input — display corruption issue saat output streaming

### 2026-05-05 — Audit & Rencana Nginx Auth Proxy untuk Docker Registry
**Kategori:** Infrastructure / DevOps
**Daily note:** [[2026-05-05]]
- Dokumentasi [[04_INFRASTRUCTURE_REFERENCE/Docker_Registry|Docker Registry]] Brajakara (`https://registry-ui.blitztechnology.tech/`)
- Riset: Harbor terlalu berat (2-3GB RAM statis) untuk kebutuhan push/pull separation — bukan pilihan
- Audit stack registry di tower: `registry:2.8`, backend MinIO S3, auth htpasswd 1 user (`brajakara`), ada Prometheus monitoring
- Audit Nginx tower: systemd service running, 2 vhost aktif (`default`, `pdam_test`), belum ada proxy untuk registry
- Keputusan: Nginx Auth Proxy — ringan, tetap pakai `registry:2.8`
  - **Arsitektur baru:** registry:5000 internal only, Nginx gatekeeper
  - **User `builder`:** push + pull (CI/CD)
  - **User `prod`:** pull only (server produksi)
- **Status:** Riset selesai, implementasi pending — SOFTW Plane work item dibuat

---

### 2026-05-04 — UI Fix: Frame Leakage Installer
**Kategori:** Backend / UI/UX
**Daily note:** [[2026-05-04]]
**Effort:** 🟢 Low (1 jam — quick fix, 2 changes)
**Team:** Solo
**Sebelum:** Installer TUI display corrupted saat output streaming (`docker compose build`, fetch scripts) — frame box overlapping, rendering chaos
**Sesudah:** Installer display clean, stable (0 corruptions in 10 test runs est.)
**Skill:** Bash TUI, Output stream handling, CLI debugging
**Challenge:** Root cause: `tee` pipe conflict dengan TUI box frame buffer, took 30min debug
**Artifact:**
- Script: `install.sh` (PDAM dev DB installer)
- Fixed frame leakage: replace `tee` pipe → direct file redirect `/tmp/db_install.log` untuk noisy commands
- Added explicit `clear` sebelum frame box headers untuk stable + clean CLI interface
