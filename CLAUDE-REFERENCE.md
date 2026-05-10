# CLAUDE-REFERENCE.md — Detail Reference

> On-demand reference. Baca bagian yang relevan saja. Jangan load semuanya sekaligus.

---

## Overview

**Vault:** `Brajakara_Naufal` — Obsidian knowledge base (meta-layer, bukan code repo).
**Code projects** ada di `~/` di tower, tidak ada di salazar.

**Multi-AI:** `CLAUDE.md` (primary) + `GEMINI.md` (ringkas). Perubahan major CLAUDE.md → reflect ke GEMINI.md.

---

## Folder Structure

| Folder | Purpose |
|---|---|
| `00_INBOX/` | Capture area + `Daily_Notes/` subfolder |
| `01_BACKEND_PROJECTS (Active development)/` | Notes project backend aktif |
| `02_BACKEND_REFERENCE (Permanent, reusable patterns)/` | Pattern backend long-lived |
| `03_QUICK_SNIPPETS (Code examples, not full projects)/` | Short code snippets |
| `04_INFRASTRUCTURE_REFERENCE/` | Infra & DevOps references |
| `05_ARCHIVED/` | Archived notes |
| `06_INDEX (Navigation hub)/` | Index notes + Navigation_Map |
| `07_PROFIL (Professional Identity)/` | Identitas, skills_stack, rekam_jejak |
| `08_HERMES_AGENT/` | Multi-AI agent system docs |

---

## Metadata Schema (YAML Frontmatter)

```yaml
---
type: index | detail | catalog | reference | daily-note | memory
category: infrastructure | project | profile | agent | inbox | index-hub
hop: 0 | 1 | 2 | 3
tags: [hierarchical/tags]
---
```

**Hop:** 0 = Navigation_Map, 1 = folder index, 2 = detail/catalog, 3 = sub-detail (reserved)

**Tag hierarchy:**
- `infrastructure/servers`, `infrastructure/vm`, `infrastructure/network`
- `project/backend`, `project/frontend`
- `profile/identity`, `profile/career`
- `agent/hermes`, `index`, `memory`, `daily-note`

**Wikilink standar:** `[[folder/file|Display Alias]] — short context description`

---

## Vault File Index

### Project Notes (`01_BACKEND_PROJECTS (Active development)/`)
- `index.md` — folder index (keyword mapping)
- `BE_WEATHERAPP.md`
- `weatherapp_mqtt_parser.md`
- `PDAM_SBY.md`
- `FE_BRAJA_PDAMSBY.md` 🟡 skeleton
- `FE_weatherapp_palembang.md` 🟡 skeleton
- `GO_WHATSAPP_API.md` 🟡 skeleton
- `wa_notif.md` 🟡 skeleton
- `webhook_receiver.md` 🟡 skeleton

### Infrastructure (`04_INFRASTRUCTURE_REFERENCE/`)
- `index.md` — folder index (keyword mapping)
- `Brajakara_Infrastructure_Overview.md` — master server catalog
- `Proxmox_MORDOR.md`
- `WireGuard_Azkaban.md`

### Profil Professional (`07_PROFIL (Professional Identity)/`)
- `index.md` — folder index
- `identitas.md`
- `skills_stack.md`
- `rekam_jejak.md` — auto-update
- `pengalaman_brajakara.md`

### Index & Memory (`06_INDEX (Navigation hub)/`)
- `Navigation_Map.md` — top-level routing hub
- `Claude_Memory.md`
- `Claude_Memory_Projects.md`
- `Claude_Memory_UserProfile.md`
- `Claude_Memory_Feedback.md`
- `claude_memory/` — folder vault mirror

### Daily Notes (`00_INBOX/`)
- `Daily_Notes/YYYY-MM-DD.md` — active daily notes
- `Daily_Notes/YYYY/MM/` — auto-archive lama (>30 hari)

---

## Global Gotchas

- **MQTT creds lama `vius/vius`** → sekarang `B-Tech/B-Tech` (weatherapp ecosystem)
- **DB `weather_app`** → `127.0.0.1:4307` (bukan `10.20.0.11` lama) + wajib `network_mode: host`
- **Year bug logger** — logger kirim `current_year + 41/42/43`, ada koreksi hardcoded di parser
- **Path stale `/home/viusp/...`** di `.service` file & `views.py` BE_WEATHERAPP — update per mesin
- **Telegram bot BE_WEATHERAPP**: 2 config — `TELEGRAM_MALANG` + `TELEGRAM_PALU`
- **Telegram bot PDAM**: `@suryasembadabot` → 4 channel: MISSING, THRESHOLD, VOLTASE_TURUN, KUBIKASI_MINUS
- **BE_WEATHERAPP `DEBUG = True`** + Django 3.2 — belum production-ready
- **PDAM dead tables** di `dbflowmeter`: `checker_data`, `sensor_data`, `station` (belum di-drop)
- **PDAM `taksasi.py` vs `taksasi_old.py` vs `taksasi_backup.py`** — hati-hati salah edit file
- **PDAM Supercronic stagger trick**: dua job `*/5` + `sleep 150` = efektif tiap 2.5 menit
- **Inovastek Ayana Resort** — offset sensor hardcoded (+3, -20, +3.1) + timezone +1 jam

---

## Domain Glossary

| Istilah | Arti |
|---|---|
| **kubikasi** | Volume air (m³) terakumulasi dari flow meter PDAM |
| **voltased** | Status voltase turun (<11V) — indikasi battery lemah |
| **taksasi** | Estimasi/prediksi data — job rutin PDAM isi data hilang |
| **anomali** | Data sensor out-of-range atau tidak konsisten |
| **balai** | Unit organisasi (BWS — Balai Wilayah Sungai) user BE_WEATHERAPP |
| **station** | Stasiun monitoring (sensor + koordinat + topic MQTT) |
| **logger** | Alat IoT lapangan kirim data via MQTT (CSV format) |
| **stagger trick** | Dua cronjob `*/5` offset `sleep 150` → efektif tiap 2.5 menit |
| **FOEWS** | Flood Operation & Early Warning System — aplikasi legacy |
| **threshold** | Ambang batas sensor per station untuk trigger alert |
| **missing/threshold/voltased/minus** | 4 kategori check_data PDAM |

---

## Env / Secrets Matrix

| Project | File Config | Secrets |
|---|---|---|
| BE_WEATHERAPP | `weather_project/.env` | DB MySQL, Django SECRET_KEY, Telegram (MALANG+PALU) |
| weatherapp_mqtt_parser | `Config.ini` + `dockerize/Config.ini` (plaintext) | MQTT broker/user/pass, DB MySQL |
| BRAJA_PDAMSBY | `pdam_project/pdam_project/.env` | PostgreSQL creds, Django SECRET_KEY, `TELEGRAM_BOT_TOKEN` |
| BRAJA_PDAMSBY prod | `/home/usflowmeter/pdam-daas-project/src/DOCKER_BRAJA_PDAMSBY/.env` | Sama dev + **belum ada `TELEGRAM_BOT_TOKEN`** per 2026-04-21 |
| MQTT broker rockbottom | `/etc/mosquitto/...` | User auth — creds di password_file |

⚠️ **Jangan commit `.env` ke repo**. Secret leak di git history → flag ke user.

---

## Plugins

**Community plugins:**
- `calendar` — calendar view for daily notes
- `templater-obsidian` — advanced templating
- `terminal` — embedded terminal pane

**Core plugins:**
- `daily-notes`, `templates`, `canvas`, `bases`
- `backlink`, `outgoing-link`, `properties`, `sync`

---

## MCP Integrations

### Plane Project Management

Workspace: `brajakara` di `https://plane.blitztechnology.tech`

**Projects aktif:**
- WEBAP — Web App
- SOFTW — SOFTWARE
- HARDW — HARDWARE
- PALEM — PALEMBANG
- GIZPR — GIZ Project
- BSNS — Business Development
- BKS — BEKASI PROJECT

**Known issue:** MCP sempat gagal 404. Workaround kalau error:
```bash
rtk proxy curl -H "X-Api-Key: <key>" "https://plane.blitztechnology.tech/api/v1/workspaces/brajakara/projects/" | jq
```

Config: `~/.claude/settings.json` → `mcpServers.plane`

### Outline Documentation Wiki

**URL:** `https://wiki.blitztechnology.tech`

**Role:** Single source of truth untuk dokumentasi teknis (pengganti Plane Pages).

**Struktur content:**
- Arsitektur sistem (design decision, flow diagram)
- Setup guides (deployment, development environment)
- API specifications (endpoint list, auth flow)
- Troubleshooting runbooks (known issues, workarounds)

**Naming convention:**
- Collection: nama project/domain (e.g., "DEX Session Manager", "PDAM System")
- Page: spesifik topik (e.g., "Auth Flow", "Database Schema", "API Reference")

**Integration pattern:**
```
Pi (execution) → Plane (task tracking) → Outline (documentation)
  ↓                ↓                        ↓
  Code           Issue + link            Detail spec
```

### Plane Sync Rules

Setiap mencatat/update detail project di vault → **tambah/update juga work item Plane**:
1. Catat di vault note project
2. Cari work item Plane yang match (SOFTW, WEBAP, dll)
3. Ada → update description | Tidak ada → buat work item baru
4. **Kalau butuh dokumentasi panjang** → bikin/update Outline page, link di Plane description
5. Sync vault ke GitHub

**Description guidelines:**
- DO: what, why, how — actionable + link ke Outline kalau ada
- DON'T: deployment noise, environment detail yang tidak affect task
- Format link Outline: `📖 Doc: https://wiki.blitztechnology.tech/doc/...`

---

## Dev Machines

| Hostname | OS | WireGuard IP | Interface |
|---|---|---|---|
| `salazar` | EndeavourOS (Arch-based) | `10.20.0.5/32` | `adm0010` |
| `tower` (DungeonTower) | — | `10.20.0.11` | — |

**SSH ke tower:** `ssh tower@10.20.0.11` (tanpa flag key eksplisit)

**Vault git remote:** SSH config `github-naufalzm30` → key `~/.ssh/id_ed25519_naufalzm30` → `git@github.com:naufalzm30/vault_obsidian_brajakara.git`
