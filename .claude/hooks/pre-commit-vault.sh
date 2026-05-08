#!/bin/bash
# Pre-commit checklist — validate quality sebelum git commit
# Prevent: secret leaks, low-quality commits, missing daily note

set -e

VAULT_ROOT="$HOME/vault_obsidian_brajakara"
DAILY_NOTE="$VAULT_ROOT/00_INBOX/Daily_Notes/$(date +%Y-%m-%d).md"

echo ""
echo "🔍 Pre-commit checklist..."
echo ""

# ============ CHECK 1: SECRET LEAK ============
echo "[1/5] Checking for secrets in staged files..."

SECRETS_FOUND=0

# Check for common secret patterns in staged files
git diff --cached --name-only | while read file; do
    if [ -f "$file" ]; then
        # Check for .env files
        if [[ "$file" == *.env* ]]; then
            echo "  ❌ BLOCKED: .env file in staging: $file"
            SECRETS_FOUND=$((SECRETS_FOUND + 1))
        fi
        
        # Check for API keys / tokens (basic patterns)
        if git diff --cached "$file" | grep -iE "(api[_-]?key|secret[_-]?key|password|token|sk-[a-zA-Z0-9]{20,})" > /dev/null; then
            echo "  ⚠️  WARNING: Possible secret in $file (review manually)"
        fi
    fi
done

if [ $SECRETS_FOUND -gt 0 ]; then
    echo ""
    echo "❌ Pre-commit BLOCKED — remove secrets from staging"
    exit 1
fi

echo "  ✓ No obvious secrets detected"

# ============ CHECK 2: LARGE FILE CHANGES ============
echo ""
echo "[2/5] Checking for large file changes..."

LARGE_CHANGES=0

git diff --cached --numstat | while read added removed file; do
    # Skip binary files (shown as - -)
    if [ "$added" != "-" ] && [ "$removed" != "-" ]; then
        total=$((added + removed))
        if [ $total -gt 500 ]; then
            echo "  ⚠️  WARNING: Large change in $file (+$added -$removed lines)"
            echo "     Consider: split into smaller commits or add comment in commit message"
            LARGE_CHANGES=$((LARGE_CHANGES + 1))
        fi
    fi
done

if [ $LARGE_CHANGES -eq 0 ]; then
    echo "  ✓ No large changes detected"
fi

# ============ CHECK 3: COMMIT MESSAGE QUALITY ============
echo ""
echo "[3/5] Checking commit message (if available)..."

# This check will be enforced via Git's prepare-commit-msg hook
# For now, just print reminder
echo "  ℹ️  Reminder: commit message should be descriptive"
echo "     BAD: 'wip', 'fix', 'update'"
echo "     GOOD: 'sync memory: feedback_behavior update', 'add PDAM alert doc'"

# ============ CHECK 4: DAILY NOTE UPDATE ============
echo ""
echo "[4/5] Checking daily note update..."

if [ ! -f "$DAILY_NOTE" ]; then
    echo "  ⚠️  WARNING: Daily note belum ada untuk hari ini"
    echo "     Create: $DAILY_NOTE"
    echo ""
    echo "  Create daily note sekarang? (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        # Create daily note with frontmatter
        cat > "$DAILY_NOTE" << EOF
---
date: $(date +%Y-%m-%d)
tags: [daily-note]
---

# Daily Note — $(date +%Y-%m-%d)

## Recap Hari Ini

### Commit pre-check
- Auto-created by pre-commit hook
EOF
        echo "  ✓ Daily note created: $DAILY_NOTE"
        git add "$DAILY_NOTE"
    else
        echo "  ⚠️  Skipped — remember to update daily note manually"
    fi
else
    # Check if daily note was modified today
    last_modified=$(stat -c %Y "$DAILY_NOTE" 2>/dev/null || stat -f %m "$DAILY_NOTE" 2>/dev/null)
    today_start=$(date -d "today 00:00:00" +%s 2>/dev/null || date -j -f "%Y-%m-%d %H:%M:%S" "$(date +%Y-%m-%d) 00:00:00" +%s 2>/dev/null)
    
    if [ $last_modified -lt $today_start ]; then
        echo "  ⚠️  WARNING: Daily note belum di-update hari ini"
        echo "     File: $DAILY_NOTE"
    else
        echo "  ✓ Daily note up-to-date"
    fi
fi

# ============ CHECK 5: VAULT STRUCTURE VALIDATION (basic) ============
echo ""
echo "[5/5] Validating vault structure..."

# Check if critical files exist
CRITICAL_FILES=(
    "CLAUDE.md"
    "CLAUDE-REFERENCE.md"
    "CLAUDE-MEMORY-SYNC.md"
    "06_INDEX (Navigation hub)/Navigation_Map.md"
)

MISSING=0
for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$VAULT_ROOT/$file" ]; then
        echo "  ❌ MISSING: $file"
        MISSING=$((MISSING + 1))
    fi
done

if [ $MISSING -eq 0 ]; then
    echo "  ✓ Critical files present"
fi

# ============ SUMMARY ============
echo ""
echo "════════════════════════════════════════════"
echo "  ✅ Pre-commit checks complete"
echo "════════════════════════════════════════════"
echo ""
echo "Next: git commit + git push (manual, per Ruby's holding-wide rule)"
echo ""

exit 0
