---
tags: [index, navigation, hub]
date: 2026-04-24
purpose: master hub navigable dari Obsidian — mirror + expansi dari CLAUDE.md Navigation Map
---

# Navigation Map — Master Hub Vault

Hub utama buat navigasi vault `Brajakara_Naufal`. Semua link pakai `[[wikilink]]` biar bisa di-click dari Obsidian. Mirror konten + expansi dari `CLAUDE.md` section Navigation.

> **Sumber kebenaran:** `CLAUDE.md` (untuk Claude Code) + file ini (untuk human/Obsidian). Update keduanya barengan kalau ada perubahan.

---

## 🗂️ Project Aktif

### Backend Projects
- [[BE_WEATHERAPP]] — Backend Django multi-balai (BWS), MySQL, JWT, 2 Telegram bot
- [[weatherapp_mqtt_parser]] — MQTT subscriber/parser, komponen IoT weatherapp
- [[PDAM_SBY]] — Backend monitoring flow meter PDAM Surabaya (Django + PostgreSQL + Supercronic)

### Skeleton (detail TBD — perlu akses tower)
- [[FE_BRAJA_PDAMSBY]] 🟡 — Frontend PDAM
- [[FE_weatherapp_palembang]] 🟡 — Frontend weatherapp Palembang
- [[GO_WHATSAPP_API]] 🟡 — WhatsApp API (Go)
- [[wa_notif]] 🟡 — Service notif WhatsApp
- [[webhook_receiver]] 🟡 — Receiver webhook

---

## 🖥️ Infrastructure

- [[Brajakara_Infrastructure_Overview]] — **Master catalog server** (rockbottom, azkaban, riverstyx, FOEWS, MORDOR)
- [[Proxmox_MORDOR]] — Proxmox host on-premise
- [[WireGuard_Azkaban]] — VPN config + subnet `10.20.0.x` / `10.20.1.x`

### Server Alias Quick Ref
| Alias | IP | Fungsi |
|---|---|---|
| rockbottom | `103.150.227.16` | MQTT broker (Mosquitto) |
| azkaban | `103.103.23.233` | VPN + CCTV restream + Plane + Nginx RP |
| riverstyx | `103.94.239.32` | Backbone Brajakara — backend weather app |
| FOEWS | `213.210.21.73` | Aplikasi FOEWS + legacy |
| MORDOR | `10.20.0.18` | Proxmox host (VM) |
| ServerFlowMeter-no-JH | — | Prod BRAJA_PDAMSBY |

---

## 👤 Persona Professional

- [[identitas]] — Identitas dasar user
- [[skills_stack]] — Stack teknis
- [[rekam_jejak]] — Log longitudinal pekerjaan (auto-update)
- [[pengalaman_brajakara]] — Pengalaman Brajakara

---

## 🧠 Memory Claude

Mirror memory Claude Code — sync dari `~/.claude/projects/-home-salazar-vault-obsidian-brajakara/memory/` ke folder ini:

- [[Claude_Memory]] — index memory
- [[Claude_Memory_UserProfile]] — profil user
- [[Claude_Memory_Projects]] — project aktif
- [[Claude_Memory_Feedback]] — feedback behavior

---

## 📅 Daily Notes & Inbox

- `00_INBOX/Daily_Notes/` — daily note per tanggal (`YYYY-MM-DD.md`)
- `00_INBOX/` — capture area buat note baru yang belum dikategorikan

---

## 🗺️ Folder Structure

| Folder | Isi |
|---|---|
| `00_INBOX/` | Capture + daily notes |
| `01_BACKEND_PROJECTS (Active development)/` | Note project aktif |
| `02_BACKEND_REFERENCE (Permanent, reusable patterns)/` | Pattern reusable (kosong per 2026-04-24) |
| `03_QUICK_SNIPPETS (Code examples, not full projects)/` | Snippet kode |
| `04_INFRASTRUCTURE_REFERENCE/` | Catatan infra / server / VPN |
| `05_ARCHIVED/` | Note lama |
| `06_INDEX (Navigation hub)/` | Index + navigation hub (FILE INI) |
| `07_PROFIL (Professional Identity)/` | Profil profesional user |

---

## 🔎 Triage — Kalau Butuh X, Buka Y

| Butuh | Buka |
|---|---|
| Project detail | Link di Project Aktif ↑ |
| Server info | [[Brajakara_Infrastructure_Overview]] |
| Aktivitas terbaru | Daily note tanggal hari ini |
| Konteks karir / skill | [[rekam_jejak]] / [[skills_stack]] |
| Bug / quirk project | Section `## Temuan / Catatan Penting` di note project |
| Instruksi meta Claude | `CLAUDE.md` (vault root) |
| Memory Claude | Folder `claude_memory/` di sini |

---

## 🔗 Related

- `CLAUDE.md` (vault root) — instruksi Claude Code + Navigation Map + Vault File Index
- [[MEMORY]] — index memory shortlist (file `06_INDEX (Navigation hub)/claude_memory/MEMORY.md`)
