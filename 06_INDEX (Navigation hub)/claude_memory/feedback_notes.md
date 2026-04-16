---
name: Note-Taking Preferences
description: Preferensi user soal cara Claude mencatat di vault Obsidian ini
type: feedback
originSessionId: 4bc3873d-a723-4e0b-ac0a-ddbccd7fd09e
---
Catat informasi baru secara proaktif ke folder yang relevan tanpa menunggu diminta.

**Why:** User sering lupa minta Claude untuk mencatat secara spesifik, jadi Claude harus inisiatif sendiri.

**How to apply:** Setiap kali ada informasi baru yang relevan (infra, project, snippet, dll), langsung tulis ke folder yang sesuai. Pecah topik besar ke beberapa file terpisah dan hubungkan dengan `[[wikilink]]` — jangan ditumpuk semua di satu file.

---

Setelah membuat/mengubah file vault, **selalu** jalankan git pull → add → commit → push ke GitHub secara otomatis tanpa menunggu diminta.

**Why:** User sudah instruksikan di CLAUDE.md tapi Claude tidak konsisten menjalankan. Ini wajib dilakukan setiap kali ada perubahan file di vault.

**How to apply:** Setiap Write/Edit file di vault → langsung `git pull --rebase origin master && git add <file> && git commit && git push origin master`. Tidak perlu tunggu perintah dari user.
