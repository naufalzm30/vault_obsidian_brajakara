---
tags: claude, memory, feedback
---

# Instruksi Perilaku Claude

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
