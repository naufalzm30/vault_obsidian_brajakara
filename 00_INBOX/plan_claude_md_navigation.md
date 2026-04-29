---
date: 2026-04-24
tags: [plan, claude-md, meta, implemented]
status: implemented-salazar
mesin: tower → dilanjutkan dan di-implement di salazar
implementasi_salazar: 2026-04-24
---

> **Status update 2026-04-24 (salazar):** Plan di-implement di salazar. CLAUDE.md sudah ditambahi 9 section (6 dari plan asli + 3 tambahan: Machine Profiles, Domain Glossary, Env/Secrets Matrix). Skeleton 5 project note sudah dibuat (FE_BRAJA_PDAMSBY, FE_weatherapp_palembang, GO_WHATSAPP_API, wa_notif, webhook_receiver). Pending: verify path + repo URL + isi detail tiap skeleton saat akses di tower.

# Plan — Optimasi CLAUDE.md untuk Navigasi Cepat

## Konteks Masalah

User merasa cara Claude baca catatan + CLAUDE.md + persona + project tidak efisien:
- Path project sering tebak salah dulu (contoh: weatherapp_mqtt_parser dikira di `~/`, ternyata memang di `~/weatherapp_mqtt_parser` tapi awalnya nebak `~/BackEnd/`)
- Notes vault dibaca satu-satu → lambat
- Tidak ada korelasi singkat dari CLAUDE.md ke notes, persona, project, rangkuman
- Memory index (`MEMORY.md`) sudah ada tapi tidak nembak project paths / server aliases

## Solusi yang Disepakati: Tambah Section "Navigation Map" ke CLAUDE.md

User setuju: "gas coba dulu, dan ga cuman itu ajah, kalau ada lagi yang kamu kira 'a good idea to add so it could optimized' gaz ajah"

## Rencana Tambahan ke CLAUDE.md

### 1. Navigation Map — Project Active
Tabel `Project | Local Path | Vault Note | Repo URL`:

| Project | Local Path (tower) | Vault Note | Repo |
|---|---|---|---|
| weatherapp_mqtt_parser | `~/weatherapp_mqtt_parser` | `01_BACKEND.../weatherapp_mqtt_parser.md` | local only |
| BE_WEATHERAPP | `~/BE_WEATHERAPP` | `01_BACKEND.../BE_WEATHERAPP.md` | Brajakara-Teknologi-Media/BE_WEATHERAPP |
| BRAJA_PDAMSBY | `~/BRAJA_PDAMSBY` | `01_BACKEND.../PDAM_SBY.md` | (cek) |
| FE_BRAJA_PDAMSBY | `~/FE_BRAJA_PDAMSBY` | (belum ada note) | (cek) |
| FE_weatherapp_palembang | `~/FE_weatherapp_palembang` | (belum ada note) | (cek) |
| GO_WHATSAPP_API | `~/GO_WHATSAPP_API` | (belum ada note) | (cek) |
| wa_notif | `~/wa_notif` | (belum ada note) | (cek) |
| webhook_receiver | `~/webhook_receiver` | (belum ada note) | (cek) |

Catatan: path di atas untuk **mesin tower**. Di salazar/mesin lain, path bisa beda — tiap mesin override di section tersendiri atau pakai placeholder `~/` + cek di runtime.

### 2. Server Alias Quick Ref
Map singkat alias → fungsi → public IP, biar Claude tidak perlu buka Brajakara_Infrastructure_Overview tiap kali user nyebut nama server:

| Alias | IP | Fungsi Utama |
|---|---|---|
| rockbottom | 103.150.227.16 | MQTT broker (Mosquitto) |
| azkaban | 103.103.23.233 | VPN server, CCTV restream, Plane, Nginx RP |
| riverstyx | 103.94.239.32 | (cek fungsi) |
| FOEWS | 213.210.21.73 | (cek fungsi) |
| MORDOR | (local/Proxmox) | Proxmox VE — sandbox |
| salazar | (laptop) | Dev machine user |
| tower | (PC) | Dev machine user |

Full detail → `Brajakara_Infrastructure_Overview`

### 3. Persona Shortcuts
```
Identitas   → 07_PROFIL/identitas.md
Skills      → 07_PROFIL/skills_stack.md
Rekam jejak → 07_PROFIL/rekam_jejak.md  (auto-update tiap kerjaan baru)
Pengalaman  → 07_PROFIL/pengalaman_brajakara.md
```

### 4. Triage — "Kalau User Bilang X, Buka Y Dulu"
| User ngomongin... | Buka dulu |
|---|---|
| Nama project | Vault note di `01_BACKEND_PROJECTS/` |
| Nama server/alias | Section di Infrastructure Overview |
| "aktivitas terbaru" / "apa yang baru" | `git fetch && git pull` → daily note terbaru + rekam jejak |
| Bug / quirk existing | Section `## Temuan / Catatan Penting` di note project |
| Infra / VPN / deployment | `04_INFRASTRUCTURE_REFERENCE/` |
| Pattern reusable | `02_BACKEND_REFERENCE/` (saat ini kosong — baru `.gitkeep`) |

### 5. Global Gotchas (Cross-Project)
Hal yang sering bikin salah langkah:
- **MQTT creds lama `vius/vius`** — sekarang `B-Tech/B-Tech` (weatherapp)
- **DB weather_app port 4307 di localhost** (bukan 10.20.0.11 lama) — wajib `network_mode: host`
- **Year bug logger** — kirim `current_year + 41/42/43`, ada koreksi di parser
- **Path stale `/home/viusp/...`** di service file & views.py — perlu update per mesin
- **Telegram bot 2 config:** MALANG + PALU (di BE_WEATHERAPP)
- **Django 3.2 + DEBUG=True** di BE_WEATHERAPP — belum prod-ready

### 6. Startup Ritual (tambahkan di CLAUDE.md)
Setiap session baru, auto-check tanpa diminta:
1. `git fetch` di vault — cek update dari mesin lain
2. Baca daily note hari ini — cek state aktif
3. Baca `rekam_jejak.md` 10 entry terakhir — konteks kerjaan
4. Ready

### 7. Backfill Note yang Belum Ada
- `FE_BRAJA_PDAMSBY.md` → belum ada, buat
- `FE_weatherapp_palembang.md` → belum ada, buat
- `GO_WHATSAPP_API.md` → belum ada, buat
- `wa_notif.md` → belum ada, buat
- `webhook_receiver.md` → belum ada, buat
- `riverstyx`, `FOEWS` functions → belum lengkap di Infra Overview

## Step Implementasi

1. [ ] Update CLAUDE.md — tambah section:
   - `## Navigation Map — Project & Paths`
   - `## Server Alias Quick Ref`
   - `## Persona Shortcuts`
   - `## Triage — Where to Look First`
   - `## Global Gotchas`
   - `## Startup Ritual`
2. [ ] Bikin note backfill untuk project yang belum ada note-nya (cukup skeleton)
3. [ ] Update `06_INDEX/MEMORY.md` kalau perlu tambah pointer
4. [ ] Sync ke memory mirror (`~/.claude/.../memory/` + `06_INDEX/claude_memory/`)
5. [ ] Commit + push vault
6. [ ] Test: di mesin lain, baca CLAUDE.md → lihat apakah cukup buat lompat langsung tanpa tebak-tebakan

## Catatan untuk Mesin Selanjutnya

- Path-path di tabel di atas **spesifik tower**. Cek dulu di mesin target apakah layout sama (biasanya user konsisten, tapi verify).
- Setelah update CLAUDE.md, jangan lupa sync memory file juga (aturan di section "Memory Sync" CLAUDE.md).
- Pending: verify repo URL + fungsi riverstyx/FOEWS sebelum commit final.

## Originating Task (Yang Di-pause)

Sebelum detour ini, user minta kerja di `weatherapp_mqtt_parser/dockerize/`. Pilihan bug yang disodorkan:
1. Bug dedup logic — `check[0] != date_time_obj` tapi `execute_sql` return `fetchone()` tuple → compare bisa salah
2. Connection per-message — `Database.__init__` + tiap `execute_sql` buka koneksi baru → boros
3. Docker fix — `env_file: Config.ini` format salah (INI bukan KEY=VALUE), Dockerfile belum ada di `dockerize/`
4. User-specific bug

Setelah CLAUDE.md optimization selesai, kembali ke pilihan di atas.
