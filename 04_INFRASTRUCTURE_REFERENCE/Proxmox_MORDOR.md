---
type: detail
category: infrastructure
hop: 2
tags: [infrastructure/vm, proxmox, virtualization, vm-management]
up: "[[04_INFRASTRUCTURE_REFERENCE/index]]"
---

# Proxmox — MORDOR

> Host Proxmox utama Brajakara. Nama "MORDOR" karena sifatnya sebagai "all-seeing eye" — semua VM ada di bawahnya.

- **IP (WireGuard):** `10.20.0.18`
- **Subnet:** `10.20.0.x` — lihat [[Brajakara_Infrastructure_Overview]]

---

## Virtual Machines

| VM ID | Alias | WireGuard IP | User | Fungsi Utama |
|---|---|---|---|---|
| 101 | ABURAYA | `10.20.0.14`* | — | Windows VM, GPU passthrough, ML training |
| 102 | DungeonTower | `10.20.0.11` | `tower` | Testing & staging codebase |
| 103 | lumbungpadi | `10.20.0.13` | `lumbungpadi` | Database storage |
| 105 | spakborsupra | `10.20.0.16` | `spakborsupra` | CCTV services |

*\*ABURAYA: WireGuard dipasang di WSL-nya, bukan langsung di Windows VM.*

---

## Detail VM

### DungeonTower — `10.20.0.11` (VM 102)
- **User:** `tower`
- **Fungsi:** Dungeon — tempat testing code, staging codebase Brajakara. Kalau ada yang mau dicoba atau dikembangkan dulu sebelum naik ke production, ditaruh di sini.

---

### spakborsupra — `10.20.0.16` (VM 105)
- **User:** `spakborsupra`
- **Fungsi:** Semua service yang berkaitan dengan CCTV — recording, penyimpanan rekaman, dan service pendukung lainnya.

---

### lumbungpadi — `10.20.0.13` (VM 103)
- **User:** `lumbungpadi`
- **Fungsi:** Storage & database terpusat. Sengaja dipisah dari VM lain.
- **Services:**
  - PostgreSQL
  - MySQL
  - MinIO

---

### ABURAYA — `10.20.0.14` (VM 101)
- **OS:** Windows (dengan WSL)
- **GPU:** Passthrough ke VM ini
- **Fungsi:** Sandbox untuk running & training model machine learning. Biasanya aktif hanya saat training berlangsung.
- **Catatan:** WireGuard dipasang di dalam WSL, bukan di Windows langsung — sehingga IP `10.20.0.14` berasal dari WSL.
