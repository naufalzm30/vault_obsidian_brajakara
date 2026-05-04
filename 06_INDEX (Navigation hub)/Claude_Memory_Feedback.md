---
type: reference
category: index-hub
hop: 2
tags: [claude, memory, feedback]
up: "[[06_INDEX (Navigation hub)/Claude_Memory]]"
---

# Instruksi Perilaku Claude

## Konfirmasi Sebelum Eksekusi

**WAJIB tanya konfirmasi dulu** sebelum menjalankan command yang bersifat destructive atau modifikasi sistem/state.

Yang termasuk wajib konfirmasi:
- **File operations:** `rm`, `truncate`, `shred`
- **System:** `journalctl --vacuum*`, `docker system prune`, `docker volume rm`, `systemctl restart/stop`, `sudo *`
- **Git state-changing:** `git checkout`, `git stash`, `git stash pop`, `git commit`, `git push`, `git branch -d`, `git reset`
- **Development:** Deploy, migrate, schema change
- **Config:** Edit/create file

Yang **tidak perlu** konfirmasi (read-only):
- **File inspection:** `ls`, `cat`, `grep`, `find`, `tree`, `du`, `df`
- **Git read-only:** `git status`, `git log`, `git diff`, `git branch -a`, `git show`
- **SSH read-only:** `ssh <host> "<read-only-command>"`
- **Docker inspect:** `docker ps`, `docker logs`, `docker images`

## Catat Proaktif

Catat informasi baru ke folder relevan **tanpa menunggu diminta**.

**Why:** User sering lupa minta Claude mencatat secara spesifik.

**How to apply:** Setiap ada info baru (infra, project, snippet, dll) → langsung tulis ke folder sesuai. Pecah topik besar ke file terpisah, hubungkan dengan `[[wikilink]]`.

## Commit Message — Project Code

Untuk repo selain vault (BRAJA_PDAMSBY, dll): buat commit message yang **meaningful dan representatif**. Tidak perlu tanya user.

**Why:** User tidak mau diganggu tanya-tanya, tapi commit message harus deskriptif.
**How to apply:** Ringkas apa yang berubah dan kenapa, bukan cuma nama file.

## Git Sync Otomatis

Setiap Write/Edit file di vault → **langsung** jalankan:

```bash
git pull --rebase origin master
git add <file>
git commit -m "pesan singkat"
git push origin master
```

**Why:** User sudah instruksikan di CLAUDE.md tapi Claude tidak konsisten menjalankan.

**How to apply:** Tidak perlu tunggu perintah dari user. Lakukan setiap ada perubahan file vault.

## Pull Dulu Sebelum Jawab (Multi-Mesin)

Kalau user tanya aktivitas terbaru, info dari mesin lain, atau "apa yang baru" → `git fetch` + `git pull` dulu baru jawab.

## External Project Tracking

Setiap akses project eksternal (SSH ke server lain, `cd` ke folder project) → **wajib catat otomatis** ke vault note project:
- Branch aktif
- Repo URL
- Status container (`docker compose ps`)
- Commit terakhir (`git log --oneline -3`)

**Why:** User harus mengingatkan berulang kali — ini harus jadi reflek otomatis tanpa diminta.

## Rekam Jejak Pekerjaan

Setiap user menyebut sesuatu yang dikerjakan di Brajakara → **langsung catat ke `07_PROFIL (Professional Identity)/rekam_jejak.md`** tanpa menunggu diminta.

**Why:** User ingin bisa tracking "aku sudah ngapain aja di Brajakara" untuk resume dan referensi karir.

**How to apply:** Format: `### YYYY-MM-DD — [Judul]`, dengan kategori dan deskripsi dampak singkat.

## Sinkronisasi Memory

Setiap update rule/instruksi → langsung sinkronkan ke **semua** tempat:
1. `CLAUDE.md`
2. `06_INDEX/claude_memory/feedback_behavior.md`
3. `06_INDEX/Claude_Memory_Feedback.md`
4. `~/.claude/projects/.../memory/feedback_notes.md`

## WAJIB Pakai RTK + Caveman

Dua tools ini WAJIB aktif di setiap session — bukan optional.

### Caveman Mode
- Auto-active via `SessionStart` hook
- Drop articles, filler, hedging — fragments OK
- Normal style hanya di: code, commit message, security warning, irreversible action

### RTK (Rust Token Killer)
WAJIB prefix `rtk` di depan command verbose, atau pipe ke `rtk log` / `rtk pipe`. Hook `rtk hook claude` HANYA telemetry — TIDAK auto-route output.

| Tujuan | Pakai |
|---|---|
| Docker logs | `docker logs X --tail N \| rtk log` |
| Pytest | `rtk pytest` |
| Git log/diff | `rtk git log` / `rtk diff` |
| Find/grep/tree/ls | `rtk find` / `rtk grep` / `rtk tree` / `rtk ls` |
| Cargo / Jest / Vitest | `rtk cargo` / `rtk jest` / `rtk vitest` |
| Curl JSON | `rtk curl` |
| psql / kubectl / docker | `rtk psql` / `rtk kubectl` / `rtk docker` |
| npm / pnpm | `rtk npm` / `rtk pnpm` |
| Custom verbose | `<cmd> \| rtk log` atau `\| rtk pipe` |

**Why:** Output verbose tanpa RTK menghabiskan context window. User sudah install RTK + setup hook → tidak ada alasan tidak pakai.

**How to apply:** Sebelum tiap Bash command verbose, cek `rtk --help`. Kalau ada wrapper, pakai. Kalau tidak ada, pipe ke `rtk log`/`rtk pipe`. Command yang sudah compact (mkdir, cp) tidak perlu.

## Plane Work Item Description — Meaningful untuk Team

Waktu buat/update work item di Plane — description harus **meaningful dan readable untuk team**, bukan cuma copy-paste context dari daily note.

**Why:** Info tidak relevan tanpa konteks bikin bingung, tidak membantu penyelesaian task. Team baca description untuk understand scope + requirements.

**How to apply:**
- **DO:** Focus pada what, why, how — jelas dan actionable
- **DON'T:** Jangan include deployment notes / environment detail tanpa penjelasan kenapa penting untuk task
- Contoh buruk: "Environment: UAT (`pdam_redis` sengaja tidak jalan)" — tanpa konteks
- Contoh baik: "Update crontab `runningTaksasiOtomatis` untuk jalan semua balai tiap 15 menit. Alasan: perluas coverage monitoring."
