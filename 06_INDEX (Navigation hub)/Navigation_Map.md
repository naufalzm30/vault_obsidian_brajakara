# Navigation Map

> **Single entry point untuk routing semua queries.** Tree structure dengan koneksi explicit — traverse seperti neural network.

---

## Infrastructure

### Physical Servers (Produksi)
- **rockbottom** (`103.150.227.16`) — MQTT broker (Mosquitto) → [[Brajakara_Infrastructure_Overview]]
- **azkaban** (`103.103.23.233`) — VPN (WireGuard) + CCTV restreamer + Plane + Nginx RP → [[WireGuard_Azkaban]] | [[Brajakara_Infrastructure_Overview]]
- **riverstyx** (`103.94.239.32`) — **Backbone Brajakara** — backend weather app + services → [[Brajakara_Infrastructure_Overview]]
- **FOEWS** (`213.210.21.73`) — Aplikasi FOEWS + legacy services (migrasi bertahap) → [[Brajakara_Infrastructure_Overview]]
- **MORDOR** (`10.20.0.18`) — Proxmox host — semua VM Brajakara → [[Proxmox_MORDOR]] | [[Brajakara_Infrastructure_Overview]]
- **ServerFlowMeter-no-JH** — Prod BRAJA_PDAMSBY (`/home/usflowmeter/pdam-daas-project/src/DOCKER_BRAJA_PDAMSBY`) → [[Brajakara_Infrastructure_Overview]]

### Virtual Machines (on MORDOR Proxmox)
- **DungeonTower** (`10.20.0.11`) — VM 102
  - User: `tower`
  - Fungsi: Testing & staging codebase Brajakara
  - Detail: [[Proxmox_MORDOR]]
- **lumbungpadi** (`10.20.0.13`) — VM 103
  - User: `lumbungpadi`
  - Fungsi: Database storage (PostgreSQL, MySQL, MinIO)
  - Detail: [[Proxmox_MORDOR]]
- **spakborsupra** (`10.20.0.16`) — VM 105
  - User: `spakborsupra`
  - Fungsi: CCTV services (recording, storage)
  - Detail: [[Proxmox_MORDOR]]
- **ABURAYA** (`10.20.0.14`) — VM 101
  - OS: Windows (WSL untuk WireGuard)
  - Fungsi: ML training sandbox, GPU passthrough
  - Detail: [[Proxmox_MORDOR]]

### Network & VPN
- **WireGuard VPN** (hosted on azkaban)
  - Subnet admin/human: `10.20.0.x`
  - Subnet Raspberry Pi CCTV: `10.20.1.x`
  - Detail: [[WireGuard_Azkaban]]

### Dev Machines (Client)
- **salazar** — Dev laptop user (vault + Claude Code, **TIDAK ada project lokal**)
- **tower** — Dev PC user (primary — **semua project di `~/` langsung**)

---

## Projects

### Active Development — Backend
- **BE_WEATHERAPP** — Backend Django weather monitoring → [[BE_WEATHERAPP]]
  - Path (tower): `~/BE_WEATHERAPP`
  - Repo: `Brajakara-Teknologi-Media/BE_WEATHERAPP`
- **weatherapp_mqtt_parser** — MQTT parser + dockerize → [[weatherapp_mqtt_parser]]
  - Path (tower): `~/weatherapp_mqtt_parser`
  - Repo: local only
- **BRAJA_PDAMSBY** (PDAM_SBY) — PDAM flow meter monitoring → [[PDAM_SBY]]
  - Path (tower): `~/BRAJA_PDAMSBY`
  - Repo: `Brajakara-Teknologi-Media/BRAJA_PDAMSBY`
- **GO_WHATSAPP_API** — WhatsApp API service → [[GO_WHATSAPP_API]] 🟡 skeleton
  - Path (tower): `~/GO_WHATSAPP_API`
- **wa_notif** — WhatsApp notification service → [[wa_notif]] 🟡 skeleton
  - Path (tower): `~/wa_notif`
- **webhook_receiver** — Generic webhook receiver → [[webhook_receiver]] 🟡 skeleton
  - Path (tower): `~/webhook_receiver`

### Active Development — Frontend
- **FE_BRAJA_PDAMSBY** — Frontend PDAM → [[FE_BRAJA_PDAMSBY]] 🟡 skeleton
  - Path (tower): `~/FE_BRAJA_PDAMSBY`
- **FE_weatherapp_palembang** — Frontend weather Palembang → [[FE_weatherapp_palembang]] 🟡 skeleton
  - Path (tower): `~/FE_weatherapp_palembang`

---

## Profile (Professional Identity)

- **Identitas** — Info dasar user → [[identitas]]
- **Skills / Stack** — Tech stack & competencies → [[skills_stack]]
- **Rekam Jejak** — Longitudinal career tracking (auto-update) → [[rekam_jejak]]
- **Pengalaman Brajakara** — Brajakara-specific experience → [[pengalaman_brajakara]]

---

## Agents

- **Hermes Agent Hub** — Multi-AI agent system → [[08_HERMES_AGENT/index|Hermes Agent Hub]]

---

## Memory Mirror (Claude Context)

- **Memory Index** → [[Claude_Memory]]
- **Projects Memory** → [[Claude_Memory_Projects]]
- **User Profile Memory** → [[Claude_Memory_UserProfile]]
- **Feedback Memory** → [[Claude_Memory_Feedback]]
- **Live Memory Dir** → `~/.claude/projects/-home-salazar-vault-obsidian-brajakara/memory/`
- **Vault Mirror Dir** → `06_INDEX (Navigation hub)/claude_memory/`
