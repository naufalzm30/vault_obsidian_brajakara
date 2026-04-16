---
name: User Profile — Brajakara
description: Profil user, stack infra, mesin lokal, preferensi komunikasi
type: user
originSessionId: a3a7fb23-fce1-4545-8801-5683083eb8b4
---
User bekerja di **Brajakara**, fokus **backend development dan infrastruktur**.

**Stack yang dikelola:**
- VPS di Biznet dan Hostinger
- Proxmox on-premise
- WireGuard VPN
- Service backend: MQTT, weather app, CCTV, database

**Komunikasi:** Bahasa Indonesia. Suka nama server kreatif (MORDOR, azkaban, rockbottom, DungeonTower, lumbungpadi) — gunakan alias apa adanya.

**Mesin lokal:**

| Hostname | IP WireGuard | Interface | Tipe Tunnel |
|---|---|---|---|
| `salazar` | `10.20.0.5/32` | `adm0010` | Split tunnel |
| `tower` | — | — | — |

**SSH:** Mesin `tower` pakai key `devbrajakara` (akun GitHub devbrajakara). Repo vault pakai SSH config `github-naufalzm30` dengan key `~/.ssh/id_ed25519_naufalzm30` → akun `naufalzm30`.
