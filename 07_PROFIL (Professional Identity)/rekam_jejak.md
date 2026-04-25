---
date: 2026-04-17
tags: [profil, rekam-jejak]
---

# Rekam Jejak Pekerjaan — Brajakara Teknologi

Tracking longitudinal aktivitas pekerjaan di Brajakara untuk referensi resume, review karir, dan dokumentasi pribadi.

---

### 2026-04-17 — Setup Folder Profil Professional
**Kategori:** Dokumentasi
**Daily note:** [[2026-04-17]]
- Membuat folder `07_PROFIL` di vault sebagai referensi [[identitas|identitas profesional]] dan resume

---

### 2026-04-18 — Otomasi Provisioning WireGuard VPN
**Kategori:** Infrastructure / DevOps
**Daily note:** [[2026-04-18]]
- Analisa struktur konfigurasi WireGuard di server [[WireGuard_Azkaban|azkaban]] (103.103.23.233): pola naming, subnet, perbedaan config tipe `adm` vs `sta`
- Menemukan bahwa `server_peers.conf` bukan include aktif WireGuard — hanya referensi manual yang out-of-sync, bukan bagian dari protokol
- Membuat script `generate_new_profile.sh` di `/etc/wireguard/` untuk otomasi pembuatan profil VPN baru: auto-increment nama profil, validasi subnet, cek duplikasi IP, generate keypair, distribusi file ke folder yang tepat, hot-reload peer tanpa restart interface
- Menambahkan nama pemilik profil sebagai comment konsisten di semua file (`keys/`, `client_configs/`, `wg0.conf`, `server_peers.conf`)
- Merapikan entry `adm0121` (bang vius) yang formatnya tidak konsisten — di-rename ke `adm0026` sesuai urutan iterasi, comment digabung jadi satu baris
- Membuat `README.md` di `/etc/wireguard/` sebagai dokumentasi operator
- Mendokumentasikan seluruh setup ke vault ([[WireGuard_Azkaban]])

---

### 2026-04-20 — Module check_data [[PDAM_SBY]]
**Kategori:** Backend
**Daily note:** [[2026-04-20]]
- Analisis `CheckMissingDataCount` di `views.py` — temuan timezone bug (`astimezone` vs `localize`)
- Buat module `core_logic/check_data/` dengan 4 file: `check_missing.py`, `check_threshold.py`, `check_voltased.py`, `run_checks.py`
- `docker_compose_guard.sh` dibuat + fix shebang + auto-detect path

---

### 2026-04-21 — Stateful Alert System + Telegram Integration [[PDAM_SBY]]
**Kategori:** Backend
**Daily note:** [[2026-04-21]]
- Lanjut implementasi `run_checks.py` + integrasi Telegram bot `@suryasembadabot`, 4 channel (MISSING/THRESHOLD/VOLTASE_TURUN/KUBIKASI_MINUS)
- Stateful alert via Redis: state machine OK→SUSPECT→MISSING→CRITICAL, 2-cycle confirm, escalate >2 jam, graceful fallback kalau Redis down
- Tier routing: WARNING real-time, CRITICAL always, INFO digest, ≥5 station = OUTAGE 1 notif
- Quiet hours 22:00–06:00: WARNING buffered, CRITICAL tetap real-time
- Lagging window lag=20 mnt, window=60 mnt → alert ~45 mnt setelah data stop
- Deploy pending ke prod [[Brajakara_Infrastructure_Overview|ServerFlowMeter-no-JH]] — perlu tambah `TELEGRAM_BOT_TOKEN` ke `.env` prod
- Plus fix hook `SessionStart`/`UserPromptSubmit` error node not found — buat `.claude/find-node.sh` wrapper portabel (nvm/volta/fnm/PATH)
- Setup [[PDAM_SBY|BRAJA_PDAMSBY]] di tower: install RTK 0.37.2 + register repo ke code-review-graph MCP (1183 nodes)

---

### 2026-04-24 — Audit Dead Tables [[PDAM_SBY]]
**Kategori:** Backend / Data Engineering
**Daily note:** [[2026-04-24]]
- Crosscheck Django models vs `\dt` PostgreSQL `dbflowmeter`
- Temuan 3 dead tables: `checker_data`, `sensor_data`, `station` (nama lama pre-rename ke prefix `pdam_`)
- 19 custom tabel Django hadir semua — tidak ada yang hilang

---

### 2026-04-25 — Cross-Link Daily Note ↔ Rekam Jejak
**Kategori:** Dokumentasi / Meta
**Daily note:** [[2026-04-25]]
- Retrofit footer `↗ Masuk [[rekam_jejak]]` di semua entry daily note yang dipromote ke rekam_jejak (5 daily note, 6 section)
- Retrofit [[rekam_jejak]]: tambah `**Daily note:** [[YYYY-MM-DD]]` + wikilink keyword per entry
- Tambah rule cross-link di `CLAUDE.md` — format standar + contoh eksplisit
- Backlink Obsidian sekarang bidireksional: daily note → rekam_jejak via footer, rekam_jejak → daily note via field

---

### 2026-04-24 — Optimasi CLAUDE.md Navigation Vault
**Kategori:** Dokumentasi / Meta
**Daily note:** [[2026-04-24]]
- Identifikasi masalah: navigasi dari `CLAUDE.md` ke notes/project/persona tidak efisien — Claude sering tebak path, baca satu-per-satu
- Tambah 9 section ke `CLAUDE.md`: Navigation Map, Server Alias Quick Ref, Machine Profiles, Persona Shortcuts, Triage, Global Gotchas, Domain Glossary, Env/Secrets Matrix, Startup Ritual
- Backfill 5 note skeleton: [[FE_BRAJA_PDAMSBY]], [[FE_weatherapp_palembang]], [[GO_WHATSAPP_API]], [[wa_notif]], [[webhook_receiver]]
- Rewrite tabel di `CLAUDE.md` pakai `[[wikilink]]` + absolute vault path, tambah section `## Vault File Index`
- Bikin [[Navigation_Map]] master hub navigable di `06_INDEX/`
- Tambah rule auto-wikilink keyword di daily note + cross-link daily note ↔ rekam_jejak

---

### (Ongoing) — Data Engineering [[BE_WEATHERAPP|WEATHERAPP]]
**Kategori:** Data Engineering
- Melakukan ekstraksi data (data mining) dari format saintifik kompleks **NetCDF** dan **Weatherlink**
- Pengolahan data presipitasi (curah hujan) yang akurat untuk input pipeline prediksi

### (Ongoing) — Backend [[PDAM_SBY|PDAM Surabaya]] (Full Ownership)
**Kategori:** Backend
- Bertanggung jawab penuh atas seluruh backend [[PDAM_SBY|PDAM SBY]] — semua fitur API dan function logic yang bersifat domain-spesifik PDAM dikerjakan sendiri
- Termasuk: sistem taksasi otomatis per balai, taksasi manual, dan seluruh business logic lainnya
- Pengelolaan environment UAT dan produksi paralel

### (Ongoing) — Infrastruktur Virtualisasi
**Kategori:** Infrastructure
- Operasi dan manajemen **[[Proxmox_MORDOR|Proxmox VE]]** sebagai sandbox terisolasi untuk pengujian fitur baru

### (Ongoing) — Jaringan VPN Multi-Node
**Kategori:** Infrastructure / Networking
- Membangun dan memelihara jaringan **[[WireGuard_Azkaban|WireGuard VPN]]** antar server (VPS Biznet, Hostinger, on-premise)

---

> Entri bertanggal "Ongoing" akan diperbarui dengan tanggal aktual saat detail diketahui.
