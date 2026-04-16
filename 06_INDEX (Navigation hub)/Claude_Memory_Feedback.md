---
tags: claude, memory, feedback
---

# Instruksi Perilaku Claude

## Catat Proaktif

Catat informasi baru ke folder relevan **tanpa menunggu diminta**.

**Why:** User sering lupa minta Claude mencatat secara spesifik.

**How to apply:** Setiap ada info baru (infra, project, snippet, dll) → langsung tulis ke folder sesuai. Pecah topik besar ke file terpisah, hubungkan dengan `[[wikilink]]`.

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
