---
name: Instruksi Perilaku Claude
description: Aturan perilaku Claude di vault ini — catat proaktif, git sync otomatis
type: feedback
originSessionId: a3a7fb23-fce1-4545-8801-5683083eb8b4
---
## Catat Proaktif

Catat informasi baru ke folder relevan tanpa menunggu diminta.

**Why:** User sering lupa minta Claude mencatat secara spesifik. User marah kalau Claude nanya dulu sebelum catat — langsung catat saja.

**How to apply:** Setiap ada info baru (infra, project, snippet, dll) → langsung tulis ke folder sesuai tanpa nanya. Pecah topik besar ke file terpisah, hubungkan `[[wikilink]]`. Jangan tunggu konfirmasi.

## Statusline Caveman

Statusline Claude Code harus tampilkan indikator `[CAVEMAN]`. Kalau session baru dan statusline belum setup, langsung setup — jangan tunggu user lapor dulu.

**Why:** User pernah harus lapor sendiri bahwa statusline caveman ga muncul. Harusnya Claude cek/setup proaktif.

**How to apply:** Awal session, kalau caveman mode aktif, verifikasi statusline sudah configured. Kalau belum → invoke `statusline-setup` agent langsung.

## Pull Dulu Sebelum Jawab (Multi-Mesin)

Vault dipakai dari banyak mesin (salazar, tower, dll). Kalau user tanya "apa yang baru", aktivitas terbaru, atau info apapun tentang vault → `git fetch` + `git pull` dulu baru jawab.

**Why:** Mesin lain mungkin punya catatan terbaru yang belum ada di mesin ini. Tanpa pull, jawaban bisa stale.

**How to apply:** Terapkan di semua mesin, semua session. Jangan jawab dulu sebelum pull.

## Commit Message — Project Code

Untuk repo selain vault (BRAJA_PDAMSBY, dll): buat commit message yang **meaningful dan representatif**. Tidak perlu tanya user.

**Why:** User tidak mau diganggu tanya-tanya, tapi commit message harus deskriptif — bukan generic seperti "update views.py".
**How to apply:** Ringkas apa yang berubah dan kenapa, bukan cuma nama file.

## Git Sync Otomatis

Setiap Write/Edit file di vault → langsung jalankan:
```bash
git pull --rebase origin master
git add <file>
git commit -m "pesan singkat"
git push origin master
```

**Why:** User sudah instruksikan di CLAUDE.md tapi Claude tidak konsisten menjalankan.

**How to apply:** Tidak perlu tunggu perintah user. Lakukan setiap ada perubahan file vault — termasuk file config/script di dalam repo vault seperti `.claude/plugins/`.

**Why (tambahan):** User pernah marah karena Claude lupa push script statusline caveman. File apapun di dalam repo vault = harus di-push.

## External Project Tracking

Kalau user sebut lagi kerja di folder project di luar vault → langsung baca kode/git log di sana, catat temuan penting ke vault note-nya. Tidak perlu minta izin, tidak perlu full doc.

**Why:** User ingin hal penting (bug, quirk, perubahan kritis) ter-capture otomatis ke vault tanpa harus minta Claude secara eksplisit.

**How to apply:** Catat ke bagian `## Temuan / Catatan Penting` di note project relevan. Fokus: apa yang bakal bikin pusing saat debug nanti, bukan deskripsi ulang kode.

**Wajib catat otomatis** setiap akses project eksternal (tanpa diminta):
- Branch aktif
- Repo URL
- Status container (`docker compose ps`)
- Commit terakhir (`git log --oneline -3`)

Catat ke frontmatter + `## Temuan / Catatan Penting` di note vault project tersebut.

## Rekam Jejak Pekerjaan

Setiap user menyebut sesuatu yang dikerjakan di Brajakara → **langsung catat ke `07_PROFIL (Professional Identity)/rekam_jejak.md`** tanpa menunggu diminta.

**Why:** User ingin bisa tracking "aku sudah ngapain aja di Brajakara" untuk kebutuhan resume dan referensi karir.

**How to apply:** Format entry: `### YYYY-MM-DD — [Judul]`, dengan kategori dan deskripsi dampak singkat. Terapkan di semua session, semua mesin.

## Memory Sync

Setiap update rule/instruksi → langsung sinkronkan ke **semua** tempat sekaligus tanpa menunggu ditegur:
1. `CLAUDE.md`
2. `06_INDEX (Navigation hub)/claude_memory/feedback_behavior.md`
3. `06_INDEX (Navigation hub)/Claude_Memory_Feedback.md`
4. `~/.claude/projects/.../memory/feedback_notes.md`

**Why:** Claude berkali-kali update satu tempat dan lupa sisanya.

**How to apply:** Update 4 tempat sekaligus → push vault ke GitHub.

## Git Sync — Output Ringkas

Saat git sync vault, jangan tampilkan output git mentah. Cukup tulis satu baris: **"syncing to github..."** (atau sejenisnya yang singkat).

**Why:** Output panjang git pull/commit/push memenuhi layar dan tidak informatif bagi user.

**How to apply:** Setiap selesai git sync vault, ringkas jadi satu baris pendek saja.
