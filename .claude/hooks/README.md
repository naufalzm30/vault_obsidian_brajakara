# Claude Code Kit — Skill & Hook Registry

> Infrastructure layer untuk vault Brajakara. Auto-executed atau on-demand.

---

## 🚀 Quick Start

**Session start automatically loads:**
```bash
bash ~/.claude/hooks/memory-chunk.sh          # Tier 2: generate MEMORY_SUMMARY
bash ~/.claude/hooks/session-start-v2.sh      # Tier 1: aggressive memory load
bash ~/.claude/hooks/context-fingerprint.sh   # NEW: detect stale context
bash ~/.claude/hooks/token-budget.sh session  # NEW: budget snapshot
```

**Manual audit (weekly):**
```bash
bash ~/.claude/hooks/vault-health-check.sh    # NEW: audit vault structure
```

**Before commit:**
```bash
bash ~/.claude/hooks/pre-commit-vault.sh      # NEW: validate + prevent leaks
# (auto-triggered by git pre-commit hook)
```

---

## 📋 Hook Registry

### 1. **pre-commit-vault.sh** ⭐ CRITICAL
**What:** Guard rail sebelum git commit — prevent leaks, enforce daily note.  
**When:** Auto-triggered sebelum `git commit`  
**Also:** Manual trigger `bash ~/.claude/hooks/pre-commit-vault.sh`

**Checks:**
- ❌ `.env` files staged?
- ❌ Secret tokens/keys in diff?
- ⚠️  Large changes (>500 lines) → recommend split
- ⚠️  Daily note belum updated hari ini?
- ✓ Critical vault files present?

**Impact:**
- Prevent secret leaks to GitHub
- Enforce daily note discipline
- Catch unfinished changes

**Exit codes:**
- `0` — all checks pass, safe to commit
- `1` — secrets detected, BLOCKED

---

### 2. **context-fingerprint.sh** 🆕 ANTI-DRIFT
**What:** Hash context files — detect changes between sessions.  
**When:** Auto-triggered di session start (via `session-start-v2.sh`)  
**Also:** Manual `bash ~/.claude/hooks/context-fingerprint.sh`

**Tracks:**
- `CAVEMAN_RULES.md` — behavior enforcement
- `feedback_behavior.md` — tone + voice rules
- `vault-keyword-map.tsv` — keyword routing
- `CLAUDE.md` — major updates

**Result:**
- Session 1: baseline fingerprints saved
- Session 2: compare → detect drift
- If drift: auto-reload context via `session-start-v2.sh` + warn

**Why:** Tier 1+2 fast, tapi ga auto-detect kalau lo edit rules di session lain.

---

### 3. **vault-health-check.sh** 🆕 AUDIT
**What:** Weekly/monthly vault audit — detect chaos creep.  
**When:** Manual trigger `bash ~/.claude/hooks/vault-health-check.sh`  
**Schedule:** Recommended 1x per week or 1x per month

**Checks:**
- 🔗 Broken wikilinks (target file not found)
- 📝 Missing/incomplete frontmatter
- 🏝️ Orphan files (no incoming links)
- 📊 Rekam jejak size (warn if >100KB, critical >200KB)
- 🗺️ Unmapped keywords (project files not in keyword map)

**Output:**
- Report: `00_INBOX/vault_health_YYYY-MM-DD.md`
- Summary printed to console
- Actionable issue count

**Why:** Vault grow → entropy increase. Detect bloat, staleness, broken links.

---

### 4. **rekam-jejak-suggest.sh** 🆕 QUALITY
**What:** Auto-suggest category + detect tech vs meta entries.  
**When:** Manual before creating entry `bash ~/.claude/hooks/rekam-jejak-suggest.sh [title] [desc]`  
**Also:** Claude Code skill (future) — suggest when you type entry

**Usage:**
```bash
bash ~/.claude/hooks/rekam-jejak-suggest.sh "Alert monitoring setup" "Implement real-time alerts for PDAM"

# Output:
# 🤖 Rekam Jejak Auto-Categorize
# Entry: Alert monitoring setup
# Analysis:
# 🏷️  Type: Technical Work (Code/Infrastructure)
# 📊 Category Suggestion:
#   1. Backend / DevOps
#   2. DevOps / Infrastructure
#   3. Infrastructure / Integration
# ...
```

**Features:**
- Semantic analysis → top 3 category suggestions
- Type detection: Tech work vs Meta vault
- ⚠️ Warn if entry is Meta but category is not "Documentation"
- Warn if title suggests "Ongoing" (anti-pattern)
- Generate entry template

**Why:** Enforce standardized categories + prevent meta/tech mixing.

---

### 5. **token-budget.sh** 🆕 COST CONTROL
**What:** Track token usage per session/day + warn if approaching limit.  
**When:** Auto-logged during session (requires Claude Code integration)  
**Manual:** `bash ~/.claude/hooks/token-budget.sh [report|warn|log|session]`

**Usage:**
```bash
# Log usage (called from Claude Code)
bash ~/.claude/hooks/token-budget.sh log 5000 12000 session-123

# Show today's report
bash ~/.claude/hooks/token-budget.sh report

# Check if over threshold
bash ~/.claude/hooks/token-budget.sh warn 150000

# Session snapshot
bash ~/.claude/hooks/token-budget.sh session
```

**Output:**
```
📊 Token Budget Report — 2026-05-06
════════════════════════════════════
  Today:
    Input:  45000 tokens
    Output: 23000 tokens
    Total:  68000 / 200000 (34.0%)
  Budget: [███████░░░░░░░░░░░░] 34%

  Last 7 days:
    2026-05-06: 68000 tokens
    2026-05-05: 142000 tokens
    2026-05-04: 98000 tokens
```

**Files:**
- `~/.claude/usage_log.jsonl` — append-only log (JSONL format)
- Env: `TOKEN_DAILY_LIMIT=200000`, `TOKEN_WARN_THRESHOLD=150000`

**Why:** RTK already saves 60-90% output tokens, tapi input baca vault ga terlihat. Visibility layer.

---

### 6. **plane-vault-sync.sh** 🆕 GAME CHANGER (Manual for now)
**What:** Scaffold untuk bidirectional sync Plane ↔ vault notes.  
**When:** Manual trigger (full auto requires webhook listener — not implemented)  
**Status:** Scaffold only — requires Claude Code MCP integration to execute

**Usage:**
```bash
# Sync vault note → Plane (create/update work item)
bash ~/.claude/hooks/plane-vault-sync.sh vault-to-plane ~/vault_obsidian_brajakara/01_BACKEND_PROJECTS/PDAM_SBY.md HARDW

# Sync Plane issue → vault (create/update note)
bash ~/.claude/hooks/plane-vault-sync.sh plane-to-vault WEBAP 22

# Auto-detect + suggest
bash ~/.claude/hooks/plane-vault-sync.sh auto ~/vault_obsidian_brajakara/01_BACKEND_PROJECTS/BE_WEATHERAPP.md
```

**Features:**
- Auto-detect project from file path (PDAM → HARDW, WeatherApp → WEBAP)
- Extract title + description dari vault note
- Check if work item already exists (prevent dupes)
- Print Claude Code MCP command flow

**Next steps (requires 1-2 hari):**
- Webhook listener: Plane → fire event → trigger sync
- Claude Code skill: call MCP Plane + update vault
- Bidirectional auto-sync + link management

**Why:** Manual sync tedious. PDAM + WeatherApp > 10 ongoing tasks. Auto-sync save time + enforce sync discipline.

---

## 🔧 Integration Points

### Git Hook
**File:** `$VAULT_ROOT/.git/hooks/pre-commit`  
**Calls:** `bash ~/.claude/hooks/pre-commit-vault.sh`  
**Trigger:** Automatically before `git commit`

### Session Start Hook
**File:** `~/.claude/settings.json` → `SessionStart` hook  
**Sequence:**
1. `memory-chunk.sh` — generate Tier 2
2. `session-start-v2.sh` — load Tier 1
3. (within `session-start-v2.sh`):
   - `context-fingerprint.sh` — check drift
   - `token-budget.sh session` — budget snapshot

### Claude Code MCP Integration (Future)
**File:** `~/.claude/settings.json` → `mcpServers.plane`  
**Call from skills:** `plane_list_issues_ide()`, `plane_create_issue_ide()`, etc  
**Dependencies:**
- `uvx plane-mcp-server` installed
- `PLANE_API_KEY` env var (already in settings)

---

## 📊 Execution Order

### Session Start (Automatic)
```
context-fingerprint.sh → detect drift
   ↓
session-start-v2.sh → load memory Tier 1+2
   ├─ print user profile
   ├─ print active projects
   ├─ print recent work
   ├─ print task pending
   ├─ load MEMORY_SUMMARY
   └─ print rules + behavior
   ↓
token-budget.sh session → show budget snapshot
```

### Before Commit (Automatic via git hook)
```
git commit → .git/hooks/pre-commit
   ↓
pre-commit-vault.sh
   ├─ check secrets
   ├─ check large changes
   ├─ check daily note
   ├─ check vault structure
   └─ exit 0 (pass) or 1 (blocked)
   ↓
[if pass] git commit continues
```

### Manual Audit (On-demand)
```
vault-health-check.sh
   ├─ scan broken wikilinks
   ├─ scan frontmatter issues
   ├─ scan orphan files
   ├─ check rekam_jejak size
   ├─ check keyword coverage
   └─ generate report → 00_INBOX/vault_health_*.md
```

### Before Creating Entry (On-demand)
```
rekam-jejak-suggest.sh "title" "description"
   ├─ analyze keywords
   ├─ suggest top 3 categories
   ├─ detect tech vs meta
   ├─ validate + warn
   └─ print template
```

---

## 🔐 Environment Variables

```bash
# Token budget
export TOKEN_DAILY_LIMIT=200000          # default
export TOKEN_WARN_THRESHOLD=150000       # default

# Vault paths
export VAULT_ROOT=$HOME/vault_obsidian_brajakara
export MEMORY_DIR=$HOME/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory

# Plane
export PLANE_WORKSPACE=brajakara         # from settings.json
export PLANE_API_KEY=...                 # from settings.json
export PLANE_BASE_URL=https://plane.blitztechnology.tech
```

---

## 📈 Maintenance Schedule

| Task | Frequency | Command |
|---|---|---|
| Session start | Every session | Auto (hook) |
| Pre-commit check | Every commit | Auto (git hook) |
| Vault health audit | Weekly | `bash ~/.claude/hooks/vault-health-check.sh` |
| Rekam jejak compact | Monthly | `bash ~/.claude/hooks/daily-housekeeping.sh` |
| Memory summary refresh | Daily | `bash ~/.claude/hooks/memory-chunk.sh` |
| Token budget review | Daily | `bash ~/.claude/hooks/token-budget.sh report` |
| Context fingerprint | Session | Auto (hook) |

---

## 🐛 Troubleshooting

### Pre-commit hook fires but blocks legitimate commit

**Symptom:** `pre-commit-vault.sh` report false positive (secret detected)

**Fix:**
1. Review staged files: `git diff --cached`
2. If false positive (e.g., `API_KEY` as docstring): edit file, remove from staging, re-add just the necessary parts
3. Or: skip hook (not recommended): `git commit --no-verify`

### Context fingerprint shows endless drift

**Symptom:** `context-fingerprint.sh` keeps detecting changes, reload loop

**Fix:**
1. Check if `CAVEMAN_RULES.md` or `feedback_behavior.md` actually changed: `git diff`
2. If no changes, clear fingerprint: `rm ~/.claude/projects/...memory/.context.fingerprint`
3. Next session will re-baseline

### Token budget showing wrong totals

**Symptom:** `token-budget.sh report` shows strange numbers

**Fix:**
1. Check log file: `tail ~/.claude/usage_log.jsonl`
2. If corrupted JSON: `jq . ~/.claude/usage_log.jsonl` (will show error line)
3. Remove bad lines or reset: `cp ~/.claude/usage_log.jsonl ~/.claude/usage_log.jsonl.backup && > ~/.claude/usage_log.jsonl`

### Vault health check finds too many issues

**Symptom:** `vault-health-check.sh` report >50 issues

**Fix:**
1. Run once per week, fix high-priority issues first (broken links, orphan files)
2. Frontmatter issues can batch-fix with Claude Code skill (future)
3. For historical accumulated issues: archive to `05_ARCHIVED/` if >30 days old

---

## 📚 Related Docs

- `CLAUDE.md` — primary rules (caveman, RTK, keyword trace)
- `CLAUDE-MEMORY-SYNC.md` — memory + daily note + rekam jejak protocol
- `CLAUDE-NEURAL-NETWORK.md` — Tier 1+2 architecture + optimization
- `CLAUDE-REFERENCE.md` — glossary, secrets matrix, MCP integrations

---

## 🎯 Next Steps (Priority)

### 🔴 Implement Soon
1. **Plane webhook listener** — auto-trigger sync on work item change
2. **Claude Code MCP Plane skill** — execute plane-to-vault/vault-to-plane with full API calls
3. **Token logging integration** — log token usage from Claude Code session

### 🟡 Nice to Have
1. **Rekam jejak auto-categorize skill** — Claude Code integration (hint during entry creation)
2. **Daily housekeeping cron** — schedule auto-archive + compact (vs manual trigger)
3. **Vault embedding + Tier 3** — semantic search (if vault grows >200 files)

### 🟢 Done
- ✅ Pre-commit hook
- ✅ Context fingerprint
- ✅ Vault health check
- ✅ Token budget tracking
- ✅ Plane sync scaffold

---

**Last updated:** 2026-05-06  
**Maintained by:** Claude Code Kit  
**Status:** Production-ready (scaffold level for Plane sync)
