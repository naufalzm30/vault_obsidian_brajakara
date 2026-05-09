---
type: index
category: infrastructure
hop: 1
tags: [infrastructure, index, servers, vm, network]
up: "[[06_INDEX (Navigation hub)/Navigation_Map]]"
down:
  - "[[04_INFRASTRUCTURE_REFERENCE/Brajakara_Infrastructure_Overview]]"
  - "[[04_INFRASTRUCTURE_REFERENCE/Proxmox_MORDOR]]"
  - "[[04_INFRASTRUCTURE_REFERENCE/WireGuard_Azkaban]]"
---

# Infrastructure Reference — Brajakara

Dokumentasi lengkap infrastruktur Brajakara: server fisik, VM, network, dan deployment setup.

## Physical Servers (Produksi)

- **[[04_INFRASTRUCTURE_REFERENCE/Brajakara_Infrastructure_Overview|Infrastructure Overview]]** — Master catalog semua server Brajakara (rockbottom, azkaban, riverstyx, FOEWS, MORDOR, ServerFlowMeter-no-JH)
  - **rockbottom** (`103.150.227.16`) — MQTT broker (Mosquitto)
  - **azkaban** (`103.103.23.233`) — VPN (WireGuard) + CCTV restreamer + Plane + Nginx RP
  - **riverstyx** (`103.94.239.32`) — Backbone Brajakara — backend weather app + services
  - **FOEWS** (`213.210.21.73`) — Aplikasi FOEWS + legacy services (migrasi bertahap)
  - **MORDOR** (`10.20.0.18`) — Proxmox host — semua VM Brajakara
  - **ServerFlowMeter-no-JH** — Prod BRAJA_PDAMSBY

## Virtual Machines (MORDOR Proxmox)

- **[[04_INFRASTRUCTURE_REFERENCE/Proxmox_MORDOR|Proxmox MORDOR]]** — VM management & detail (DungeonTower, lumbungpadi, spakborsupra, ABURAYA)
  - **DungeonTower** (alias: **tower**) (`10.20.0.11`) — user: `tower`, Testing & staging codebase
  - **lumbungpadi** (`10.20.0.13`) — user: `lumbungpadi`, Database storage (PostgreSQL, MySQL, MinIO)
  - **spakborsupra** (`10.20.0.16`) — user: `spakborsupra`, CCTV services
  - **ABURAYA** (`10.20.0.14`) — Windows VM, GPU passthrough, ML training sandbox

## Dev Machines (Client)

- **salazar** — Dev laptop (vault + Claude Code, **no project lokal**)
- **tower** → VM **DungeonTower** (alias, see Virtual Machines section above)

## Network & VPN

- **[[04_INFRASTRUCTURE_REFERENCE/WireGuard_Azkaban|WireGuard Azkaban]]** — WireGuard VPN config & subnet management (10.20.0.x, 10.20.1.x)
  - Subnet admin/human: `10.20.0.x`
  - Subnet Raspberry Pi CCTV: `10.20.1.x`

## Tools & Services

- **[[04_INFRASTRUCTURE_REFERENCE/Authentik_SSO|Authentik SSO]]** — Identity provider Brajakara (`https://auth.blitztechnology.tech`), SSO + Google OAuth, monitoring user activity
- **[[04_INFRASTRUCTURE_REFERENCE/Docker_Registry|Docker Registry]]** — Container registry Brajakara (`https://registry-ui.blitztechnology.tech/`), tempat push/pull image Docker hasil build

## Notes

Semua alias server (rockbottom, azkaban, dll) adalah nama unik Brajakara — gunakan apa adanya, jangan diubah.
