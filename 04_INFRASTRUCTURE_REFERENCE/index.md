---
type: index
category: infrastructure
hop: 1
tags: [infrastructure, index, servers, vm, network]
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
  - **DungeonTower** (`10.20.0.11`) — user: `tower`, Testing & staging codebase
  - **lumbungpadi** (`10.20.0.13`) — user: `lumbungpadi`, Database storage (PostgreSQL, MySQL, MinIO)
  - **spakborsupra** (`10.20.0.16`) — user: `spakborsupra`, CCTV services
  - **ABURAYA** (`10.20.0.14`) — Windows VM, GPU passthrough, ML training sandbox

## Network & VPN

- **[[04_INFRASTRUCTURE_REFERENCE/WireGuard_Azkaban|WireGuard Azkaban]]** — WireGuard VPN config & subnet management (10.20.0.x, 10.20.1.x)
  - Subnet admin/human: `10.20.0.x`
  - Subnet Raspberry Pi CCTV: `10.20.1.x`

## Notes

Semua alias server (rockbottom, azkaban, dll) adalah nama unik Brajakara — gunakan apa adanya, jangan diubah.
