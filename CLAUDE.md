@RTK.md

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

## Commit Message — Project Code

Untuk repo **selain vault** (BRAJA_PDAMSBY, dll): buat commit message yang **meaningful dan representatif** — jangan generic. Tidak perlu tanya ke user.

Saat menampilkan progress git sync, cukup tulis satu baris: **"syncing to github..."** — jangan tampilkan output mentah git.

Setiap user bertanya tentang aktivitas terbaru, info dari mesin lain, atau "apa yang baru" — **selalu `git fetch` + `git pull` dulu** sebelum menjawab. Vault ini digunakan dari banyak mesin (salazar, tower, dll).

## Memory Sync

File memory Claude tersimpan di `~/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory/` (salazar) atau path serupa di mesin lain. File ini **tidak** ada dalam repo vault, sehingga tidak ter-sync antar mesin.

**Aturan:** Setiap kali menulis atau mengupdate file memory di `~/.claude/.../memory/`, **langsung copy juga** file yang sama ke `06_INDEX (Navigation hub)/claude_memory/` di dalam vault, lalu jalankan git sync seperti biasa.

Ini memastikan memory Claude ikut ter-sync ke GitHub dan bisa dibaca dari mesin lain (salazar, tower, dll).

Sumber kebenaran: file di `~/.claude/.../memory/` (dipakai Claude aktif). Mirror untuk sync: `06_INDEX (Navigation hub)/claude_memory/`.

Setiap update rule/instruksi → langsung sinkronkan ke **semua** tempat sekaligus tanpa menunggu ditegur:
1. `CLAUDE.md`
2. `06_INDEX (Navigation hub)/claude_memory/feedback_behavior.md`
3. `06_INDEX (Navigation hub)/Claude_Memory_Feedback.md`
4. `~/.claude/projects/.../memory/feedback_notes.md`

Lalu push vault ke GitHub.

## Daily Note

Setiap kali membuat/mengedit file apapun di vault — **langsung update juga daily note hari ini** (`00_INBOX/Daily_Notes/YYYY-MM-DD.md`). Jangan tunggu diminta. Jangan lupa.

Format entry di daily note:
```
### [Judul Singkat Aktivitas]
- poin ringkas apa yang dikerjakan / dicatat
```

Kalau file daily note belum ada, buat dulu dengan frontmatter:
```markdown
---
date: YYYY-MM-DD
tags: [daily-note]
---

# Daily Note — YYYY-MM-DD

## Recap Hari Ini
```

## Rekam Jejak Pekerjaan

Setiap kali user menyebut sesuatu yang dikerjakan di Brajakara (fitur baru, bug fix, migrasi, konfigurasi, riset, dll) — **langsung catat ke `07_PROFIL (Professional Identity)/rekam_jejak.md`** tanpa menunggu diminta.

Format entry:
```
### YYYY-MM-DD — [Judul Singkat]
**Kategori:** Backend / Infra / Data Engineering / dll
- deskripsi singkat apa yang dikerjakan dan dampaknya
```

Tujuan: tracking longitudinal "aku sudah ngapain aja di Brajakara" untuk kebutuhan resume, review, atau referensi karir ke depan.

## Note-Taking Behavior

- Catat informasi baru secara proaktif ke folder yang relevan **tanpa menunggu diminta secara spesifik**
- Pecah topik besar ke file terpisah, hubungkan dengan `[[wikilink]]`
- Server Brajakara punya alias unik (contoh: azkaban, rockbottom, MORDOR) — gunakan alias tersebut apa adanya, jangan diubah

## External Project Tracking

Kalau user menyebut sedang bekerja di folder project di luar vault (misal `~/weatherapp_mqtt_parser`, `~/BRAJA_PDAMSBY`, dll):
- Baca kode/git log di folder tersebut langsung (`cd` ke sana, tidak perlu minta izin)
- Catat **temuan penting** ke vault note project yang relevan — bukan full dokumentasi, tapi hal-hal yang membantu produktivitas atau bug hunting ke depannya: perubahan kritis, bug baru, quirk, keputusan arsitektur tidak obvious
- Tambahkan ke bagian `## Temuan / Catatan Penting` di note project tersebut
- **Wajib catat otomatis** setiap akses project eksternal: branch aktif, repo URL, status container, commit terakhir — tanpa perlu diminta user

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

<!-- rtk-instructions v2 -->
# RTK (Rust Token Killer) - Token-Optimized Commands

## Golden Rule

**Always prefix commands with `rtk`**. If RTK has a dedicated filter, it uses it. If not, it passes through unchanged. This means RTK is always safe to use.

**Important**: Even in command chains with `&&`, use `rtk`:
```bash
# ❌ Wrong
git add . && git commit -m "msg" && git push

# ✅ Correct
rtk git add . && rtk git commit -m "msg" && rtk git push
```

## RTK Commands by Workflow

### Build & Compile (80-90% savings)
```bash
rtk cargo build         # Cargo build output
rtk cargo check         # Cargo check output
rtk cargo clippy        # Clippy warnings grouped by file (80%)
rtk tsc                 # TypeScript errors grouped by file/code (83%)
rtk lint                # ESLint/Biome violations grouped (84%)
rtk prettier --check    # Files needing format only (70%)
rtk next build          # Next.js build with route metrics (87%)
```

### Test (60-99% savings)
```bash
rtk cargo test          # Cargo test failures only (90%)
rtk go test             # Go test failures only (90%)
rtk jest                # Jest failures only (99.5%)
rtk vitest              # Vitest failures only (99.5%)
rtk playwright test     # Playwright failures only (94%)
rtk pytest              # Python test failures only (90%)
rtk rake test           # Ruby test failures only (90%)
rtk rspec               # RSpec test failures only (60%)
rtk test <cmd>          # Generic test wrapper - failures only
```

### Git (59-80% savings)
```bash
rtk git status          # Compact status
rtk git log             # Compact log (works with all git flags)
rtk git diff            # Compact diff (80%)
rtk git show            # Compact show (80%)
rtk git add             # Ultra-compact confirmations (59%)
rtk git commit          # Ultra-compact confirmations (59%)
rtk git push            # Ultra-compact confirmations
rtk git pull            # Ultra-compact confirmations
rtk git branch          # Compact branch list
rtk git fetch           # Compact fetch
rtk git stash           # Compact stash
rtk git worktree        # Compact worktree
```

Note: Git passthrough works for ALL subcommands, even those not explicitly listed.

### GitHub (26-87% savings)
```bash
rtk gh pr view <num>    # Compact PR view (87%)
rtk gh pr checks        # Compact PR checks (79%)
rtk gh run list         # Compact workflow runs (82%)
rtk gh issue list       # Compact issue list (80%)
rtk gh api              # Compact API responses (26%)
```

### JavaScript/TypeScript Tooling (70-90% savings)
```bash
rtk pnpm list           # Compact dependency tree (70%)
rtk pnpm outdated       # Compact outdated packages (80%)
rtk pnpm install        # Compact install output (90%)
rtk npm run <script>    # Compact npm script output
rtk npx <cmd>           # Compact npx command output
rtk prisma              # Prisma without ASCII art (88%)
```

### Files & Search (60-75% savings)
```bash
rtk ls <path>           # Tree format, compact (65%)
rtk read <file>         # Code reading with filtering (60%)
rtk grep <pattern>      # Search grouped by file (75%)
rtk find <pattern>      # Find grouped by directory (70%)
```

### Analysis & Debug (70-90% savings)
```bash
rtk err <cmd>           # Filter errors only from any command
rtk log <file>          # Deduplicated logs with counts
rtk json <file>         # JSON structure without values
rtk deps                # Dependency overview
rtk env                 # Environment variables compact
rtk summary <cmd>       # Smart summary of command output
rtk diff                # Ultra-compact diffs
```

### Infrastructure (85% savings)
```bash
rtk docker ps           # Compact container list
rtk docker images       # Compact image list
rtk docker logs <c>     # Deduplicated logs
rtk kubectl get         # Compact resource list
rtk kubectl logs        # Deduplicated pod logs
```

### Network (65-70% savings)
```bash
rtk curl <url>          # Compact HTTP responses (70%)
rtk wget <url>          # Compact download output (65%)
```

### Meta Commands
```bash
rtk gain                # View token savings statistics
rtk gain --history      # View command history with savings
rtk discover            # Analyze Claude Code sessions for missed RTK usage
rtk proxy <cmd>         # Run command without filtering (for debugging)
rtk init                # Add RTK instructions to CLAUDE.md
rtk init --global       # Add RTK to ~/.claude/CLAUDE.md
```

## Token Savings Overview

| Category | Commands | Typical Savings |
|----------|----------|-----------------|
| Tests | vitest, playwright, cargo test | 90-99% |
| Build | next, tsc, lint, prettier | 70-87% |
| Git | status, log, diff, add, commit | 59-80% |
| GitHub | gh pr, gh run, gh issue | 26-87% |
| Package Managers | pnpm, npm, npx | 70-90% |
| Files | ls, read, grep, find | 60-75% |
| Infrastructure | docker, kubectl | 85% |
| Network | curl, wget | 65-70% |

Overall average: **60-90% token reduction** on common development operations.
<!-- /rtk-instructions -->