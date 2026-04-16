# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is an [Obsidian](https://obsidian.md) vault named `Brajakara_Naufal`, used as a backend development knowledge base. Notes are plain `.md` files; vault configuration lives under `.obsidian/`.

## Folder Structure

The vault uses a numbered folder system:

| Folder | Purpose |
|---|---|
| `00_INBOX/` | Capture area; `Daily_Notes/` subfolder holds daily notes |
| `01_BACKEND_PROJECTS (Active development)/` | Notes on ongoing backend projects |
| `02_BACKEND_REFERENCE (Permanent, reusable patterns)/` | Long-lived backend patterns and references |
| `03_QUICK_SNIPPETS (Code examples, not full projects)/` | Short code snippets and examples |
| `04_INFRASTRUCTURE_REFERENCE/` | Infrastructure and DevOps references |
| `05_ARCHIVED/` | Archived notes |
| `06_INDEX (Navigation hub)/` | Index notes for navigating the vault |

New notes that haven't been categorized yet go into `00_INBOX/`. Daily notes live in `00_INBOX/Daily_Notes/`.

## Mode

CAVEMAN MODE AKTIF dari awal session. Gunakan `/caveman lite|full|ultra` untuk ganti level. Default: **full**.

Selalu gunakan `/effort max` di setiap session untuk respons berkualitas tertinggi.

## Bahasa

Selalu gunakan **Bahasa Indonesia** dalam semua respons dan catatan percakapan.

## Git Sync

Setiap kali membuat perubahan pada vault (buat/edit/hapus file):
1. `git pull --rebase origin master` dulu — selesaikan konflik jika ada
2. `git add` file yang diubah
3. `git commit -m "pesan singkat deskriptif"`
4. `git push origin master`

Lakukan ini **otomatis tanpa diminta**. Remote: `origin` → `git@github.com:naufalzm30/vault_obsidian_brajakara.git`.

## Note-Taking Behavior

- Catat informasi baru secara proaktif ke folder yang relevan **tanpa menunggu diminta secara spesifik**
- Pecah topik besar ke file terpisah, hubungkan dengan `[[wikilink]]`
- Server Brajakara punya alias unik (contoh: azkaban, rockbottom, MORDOR) — gunakan alias tersebut apa adanya, jangan diubah

## Note Format

Notes use standard Markdown with Obsidian extensions:
- `[[Note Title]]` — internal wikilinks
- `[[Note Title|display text]]` — aliased wikilinks
- YAML frontmatter (between `---` delimiters) for properties/metadata
- `#tag` — inline tags

## Plugins

**Community plugins** (installed under `.obsidian/plugins/`):
- `calendar` — calendar view for daily notes
- `templater-obsidian` — advanced templating for notes
- `terminal` — embedded terminal pane inside Obsidian

**Core plugins enabled:**
- `daily-notes` — creates/opens today's daily note (stored in `00_INBOX/Daily_Notes/`)
- `templates` — inserts template snippets into notes
- `canvas` — infinite-canvas for visual note boards
- `bases` — database-style views over notes
- `backlink` / `outgoing-link` — bidirectional link navigation
- `properties` — structured YAML frontmatter editing
- `sync` — Obsidian Sync (cloud sync)
