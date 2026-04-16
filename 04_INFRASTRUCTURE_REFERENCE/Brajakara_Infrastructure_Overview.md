# Brajakara Infrastructure Overview

> Catatan referensi infrastruktur Brajakara. Diperbarui secara bertahap.

---

## VPS Providers

### BIZNET

| Alias | Public IP | Spec | OS |
|---|---|---|---|
| rockbottom | 103.150.227.16 | Neo Lite SS 2.2 — 2 vCPU, 2 GB RAM, 60 GB Disk | Debian 11 |
| azkaban | 103.103.23.233 | Neo Lite MM 8.8 — 8 vCPU, 8 GB RAM, 60 GB Disk | Ubuntu 22.04 |
| riverstyx | 103.94.239.32 | Neo Lite Pro MM.4.4 — 4 vCPU, 4 GB RAM, 60 GB Disk | Ubuntu 24.04 |

### HOSTINGER

| Alias | Public IP | Spec | OS | Region |
|---|---|---|---|---|
| FOEWS | 213.210.21.73 | KVM 4 — 4 core, 16 GB RAM, 200 GB Disk | Ubuntu 22.04 LTS | India - Mumbai |

---

## Server Detail

### rockbottom — `103.150.227.16`
- **Fungsi:** MQTT broker utama (Mosquitto)
- **Provider:** Biznet

---

### azkaban — `103.103.23.233`
- **Fungsi utama:**
  - WireGuard VPN server
  - CCTV restreamer
  - Plane (project management, self-hosted)
  - Nginx reverse proxy — semua routing dari VPN di-handle di sini karena VPN servernya di sini
- **Provider:** Biznet

#### WireGuard Subnets
| Subnet | Digunakan untuk |
|---|---|
| `10.20.0.x` | Admin / human VPN clients, komputer |
| `10.20.1.x` | Raspberry Pi CCTV di lapangan |

---

### riverstyx — `103.94.239.32`
- **Fungsi utama:**
  - Backend weather app (aplikasi utama & backbone Brajakara)
  - Service-service pendukung weather app
- **Catatan:** Migrasi dari server lama yang sudah tidak aktif
- **Provider:** Biznet

---

### FOEWS — `213.210.21.73`
- **Fungsi utama:**
  - Aplikasi FOEWS
  - Beberapa service lama yang belum sepenuhnya dimigrasikan
- **Catatan:** Sebagian besar service sudah dimigrasikan ke server lain
- **Provider:** Hostinger
- **Region:** India - Mumbai

---

## Proxmox & On-Premise

Detail lengkap ada di [[Proxmox_MORDOR]].

- **MORDOR** (`10.20.0.18`) — Proxmox host, semua VM Brajakara jalan di sini
- VM menggunakan subnet WireGuard `10.20.0.x` (kecuali ABURAYA yang via WSL)

---

## Catatan Arsitektur

- Semua routing nginx untuk koneksi VPN dipusatkan di **azkaban** karena WireGuard server ada di sana.
- **riverstyx** adalah backbone utama Brajakara saat ini.
- **FOEWS** sedang dalam proses migrasi bertahap.
