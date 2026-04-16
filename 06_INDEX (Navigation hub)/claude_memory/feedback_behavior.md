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

## Git Sync — Output Ringkas

Saat git sync vault, jangan tampilkan output git mentah. Cukup tulis satu baris: **"syncing to github..."** (atau sejenisnya yang singkat).

**Why:** Output panjang git pull/commit/push memenuhi layar dan tidak informatif bagi user.

**How to apply:** Setiap selesai git sync vault, ringkas jadi satu baris pendek saja.
