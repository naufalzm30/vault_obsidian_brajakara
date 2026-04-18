---
date: 2026-04-18
tags: [infrastructure, wireguard, vpn, azkaban]
---

# WireGuard — Azkaban (103.103.23.233)

Server WireGuard utama Brajakara, berjalan di `azkaban@103.103.23.233:51820`.

## Struktur Folder

```
/etc/wireguard/
├── wg0.conf              # Konfigurasi server aktif (interface + semua peer)
├── server_peers.conf     # Referensi manual daftar peer (tidak dipakai WG secara aktif)
├── new_server_peers.conf # Fragmentasi lama, tidak relevan
├── README.md             # Dokumentasi folder ini
├── generate_new_profile.sh  # Script otomasi pembuatan profil baru
├── client_configs/       # File .conf untuk didistribusikan ke client
│   └── {name}.conf
└── keys/                 # Keypair tiap client
    ├── {name}_priv
    └── {name}_pub
```

## Pola Naming & Subnet

| Prefix | Subnet | Jenis Tunnel | Address Client | AllowedIPs |
|--------|--------|--------------|----------------|------------|
| `adm`  | `10.20.0.x` | Split tunnel | `/24` | `10.20.0.0/24, 10.20.1.0/24` |
| `sta`  | `10.20.1.x` | Full tunnel  | `/32` | `0.0.0.0/0` |

- `adm` = admin/internal devices, hanya routing ke subnet VPN
- `sta` = staff/remote devices, semua traffic dilewatkan VPN + DNS `8.8.8.8`

Server IP di jaringan VPN: `10.20.0.1/24`

## Cara Buat Profil Baru

```bash
ssh azkaban@103.103.23.233
sudo bash /etc/wireguard/generate_new_profile.sh
```

Script akan:
1. Pilih tipe `adm`/`sta` via menu select
2. Nama profil di-generate otomatis (iterasi dari nomor terakhir)
3. Input IP address + nama pemilik profil
4. Validasi subnet dan duplikasi IP
5. Generate keypair → simpan ke `keys/`
6. Buat client `.conf` → simpan ke `client_configs/`
7. Append `[Peer]` block ke `wg0.conf` dan `server_peers.conf`
8. Hot-reload via `wg set` tanpa restart interface

## Catatan Penting

- `server_peers.conf` adalah referensi manual, **bukan include aktif** — WireGuard tidak support native include. File ini out-of-sync dengan `wg0.conf` sebelum script ini dibuat.
- `adm0014` di `wg0.conf` di-comment (disabled) — ada entry ganda, hati-hati saat assign IP baru di range `.0.x`.
- `sta0037` punya `AllowedIPs = 10.20.1.12/24` (typo, seharusnya `/32`) — anomali, jangan ditiru.
- Ada beberapa file legacy di root `/etc/wireguard/`: `adm0020`, `adm0020_pbk`, `adm0014_pbk_baru`, `adm0014_pk_baru` — format lama sebelum folder `keys/` dibuat.
