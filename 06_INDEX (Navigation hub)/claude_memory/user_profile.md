---
name: User Profile — Brajakara
description: Profil user, stack infra, mesin lokal, preferensi komunikasi
type: user
originSessionId: a3a7fb23-fce1-4545-8801-5683083eb8b4
---
User bekerja di **Brajakara**, **versatile backend developer**: nulis kode backend, deployment, testing, dan maintain infra kantor sekaligus — bukan spesialisasi sempit.

**Stack yang dikelola:**
- VPS di Biznet dan Hostinger
- Proxmox on-premise
- WireGuard VPN
- Service backend: MQTT, weather app, CCTV, database

**Komunikasi:** Bahasa Indonesia. Suka nama server kreatif (MORDOR, azkaban, rockbottom, DungeonTower, lumbungpadi) — gunakan alias apa adanya.

**Mesin lokal:**

| Hostname | OS | IP WireGuard | Interface | Tipe Tunnel |
|---|---|---|---|---|
| `salazar` | EndeavourOS (Arch-based) | `10.20.0.5/32` | `adm0010` | Split tunnel |
| `tower` (DungeonTower) | — | `10.20.0.11` | — | — |

**Catatan salazar:** Pindah ke EndeavourOS (Arch). Package manager: `pacman`/`yay`. Perintah systemd, path config, dll mungkin berbeda dari distro sebelumnya.

**SSH:** Mesin `tower` = VM 102 di Proxmox MORDOR, IP WireGuard `10.20.0.11`, user `tower`. SSH: `ssh tower@10.20.0.11` (tanpa flag key eksplisit — bisa connect langsung). Key `devbrajakara` (akun GitHub devbrajakara) tercatat tapi tidak wajib di-flag. Repo vault pakai SSH config `github-naufalzm30` dengan key `~/.ssh/id_ed25519_naufalzm30` → akun `naufalzm30`.
