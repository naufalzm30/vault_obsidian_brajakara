# GEMINI.md - Panduan Konteks Vault Brajakara

File ini memberikan panduan instruksional bagi Gemini CLI saat berinteraksi dengan vault Obsidian `Brajakara_Naufal`. Vault ini berfungsi sebagai *knowledge base* teknis untuk pengembangan backend dan manajemen infrastruktur di Brajakara Teknologi Media.

## Ikhtisar Direktori

Vault ini menggunakan sistem folder bernomor untuk mengelola siklus hidup pengembangan, dokumentasi infrastruktur, dan identitas profesional. Fokus utamanya adalah proyek backend berbasis Python (Django), sistem IoT (MQTT), dan manajemen server (Proxmox, WireGuard).

### Folder Utama
- `00_INBOX/`: Area penangkapan ide dan `Daily_Notes/` (catatan aktivitas harian).
- `01_BACKEND_PROJECTS/`: Dokumentasi proyek aktif (misal: [[BE_WEATHERAPP]], [[PDAM_SBY]]).
- `02_BACKEND_REFERENCE/`: Pola arsitektur dan referensi teknis yang dapat digunakan kembali.
- `03_QUICK_SNIPPETS/`: Contoh kode pendek dan *boilerplate*.
- `04_INFRASTRUCTURE_REFERENCE/`: Panduan server, VPN, dan *deployment* (misal: [[Brajakara_Infrastructure_Overview]]).
- `06_INDEX/`: Pusat navigasi ([[Navigation_Map]]) dan mirror memori AI.
- `07_PROFIL/`: Rekam jejak profesional dan *skills stack* user.

## File Kunci
- `CLAUDE.md`: Sumber kebenaran utama untuk instruksi agen, pemetaan proyek, dan protokol interaksi.
- `06_INDEX (Navigation hub)/Navigation_Map.md`: Peta navigasi visual untuk Obsidian.
- `07_PROFIL (Professional Identity)/rekam_jejak.md`: Log aktivitas longitudinal untuk kebutuhan karir.
- `04_INFRASTRUCTURE_REFERENCE/Brajakara_Infrastructure_Overview.md`: Katalog lengkap server dan aliasnya.

## Protokol Interaksi (WAJIB)

### 1. Bahasa & Gaya
- **Bahasa:** Selalu gunakan **Bahasa Indonesia**.
- **Caveman Mode:** Gunakan gaya bicara minimalis, fragmen, hilangkan pengisi (*filler*), dan langsung ke poin teknis.
- **RTK (Rust Token Killer):** Gunakan prefix `rtk` untuk semua perintah shell yang menghasilkan output banyak (misal: `rtk git status`, `rtk ls`, `rtk docker ps`) guna menghemat token.

### 2. Otomasi Aktivitas
Setiap kali ada perubahan atau aktivitas baru, lakukan hal berikut secara otomatis:
- **Git Sync:** Jalankan `rtk git pull --rebase`, `add`, `commit`, dan `push` ke GitHub.
- **Daily Note:** Update catatan hari ini di `00_INBOX/Daily_Notes/YYYY-MM-DD.md` menggunakan `[[wikilink]]` untuk kata kunci penting.
- **Rekam Jejak:** Jika aktivitas signifikan, catat ke `07_PROFIL/rekam_jejak.md`.
- **Memory Sync:** Sinkronkan perubahan memori di `.claude/memory/` ke `06_INDEX/claude_memory/`.

### 3. Penanganan Proyek Eksternal
Jika user bekerja di folder proyek di luar vault (misal: `~/BRAJA_PDAMSBY`):
- Akses langsung kodenya untuk riset.
- Catat temuan kritis, *bug*, atau keputusan arsitektur ke note proyek yang relevan di dalam vault (bagian `## Temuan / Catatan Penting`).

## Cara Penggunaan
Gunakan vault ini untuk memahami konteks proyek Brajakara sebelum melakukan modifikasi kode pada repositori terkait. Selalu periksa `Daily_Notes` terbaru untuk mengetahui *state* terakhir pekerjaan.
