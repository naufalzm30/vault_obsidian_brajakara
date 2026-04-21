---
date: 2026-04-17
tags: [profil, rekam-jejak]
---

# Rekam Jejak Pekerjaan — Brajakara Teknologi

Tracking longitudinal aktivitas pekerjaan di Brajakara untuk referensi resume, review karir, dan dokumentasi pribadi.

---

### 2026-04-18 — Otomasi Provisioning WireGuard VPN
**Kategori:** Infrastructure / DevOps
- Analisa struktur konfigurasi WireGuard di server `azkaban` (103.103.23.233): pola naming, subnet, perbedaan config tipe `adm` vs `sta`
- Menemukan bahwa `server_peers.conf` bukan include aktif WireGuard — hanya referensi manual yang out-of-sync, bukan bagian dari protokol
- Membuat script `generate_new_profile.sh` di `/etc/wireguard/` untuk otomasi pembuatan profil VPN baru: auto-increment nama profil, validasi subnet, cek duplikasi IP, generate keypair, distribusi file ke folder yang tepat, hot-reload peer tanpa restart interface
- Menambahkan nama pemilik profil sebagai comment konsisten di semua file (`keys/`, `client_configs/`, `wg0.conf`, `server_peers.conf`)
- Merapikan entry `adm0121` (bang vius) yang formatnya tidak konsisten — di-rename ke `adm0026` sesuai urutan iterasi, comment digabung jadi satu baris
- Membuat `README.md` di `/etc/wireguard/` sebagai dokumentasi operator
- Mendokumentasikan seluruh setup ke vault (`WireGuard_Azkaban.md`)

---

### 2026-04-17 — Setup Folder Profil Professional
**Kategori:** Dokumentasi
- Membuat folder `07_PROFIL` di vault sebagai referensi identitas profesional dan resume

---

### 2026-04-21 — Integrasi Notif Telegram BRAJA_PDAMSBY check_data
**Kategori:** Backend
- Lanjut implementasi `run_checks.py` di `core_logic/check_data/`
- Integrasi notifikasi Telegram otomatis untuk alert station: missing data, threshold invalid, battery lemah (< 11V)

---

### (Ongoing) — Data Engineering WEATHERAPP
**Kategori:** Data Engineering
- Melakukan ekstraksi data (data mining) dari format saintifik kompleks **NetCDF** dan **Weatherlink**
- Pengolahan data presipitasi (curah hujan) yang akurat untuk input pipeline prediksi

### (Ongoing) — Backend PDAM Surabaya (Full Ownership)
**Kategori:** Backend
- Bertanggung jawab penuh atas seluruh backend PDAM SBY — semua fitur API dan function logic yang bersifat domain-spesifik PDAM dikerjakan sendiri
- Termasuk: sistem taksasi otomatis per balai, taksasi manual, dan seluruh business logic lainnya
- Pengelolaan environment UAT dan produksi paralel

### (Ongoing) — Infrastruktur Virtualisasi
**Kategori:** Infrastructure
- Operasi dan manajemen **Proxmox VE** sebagai sandbox terisolasi untuk pengujian fitur baru

### (Ongoing) — Jaringan VPN Multi-Node
**Kategori:** Infrastructure / Networking
- Membangun dan memelihara jaringan **WireGuard VPN** antar server (VPS Biznet, Hostinger, on-premise)

---

> Entri bertanggal "Ongoing" akan diperbarui dengan tanggal aktual saat detail diketahui.
