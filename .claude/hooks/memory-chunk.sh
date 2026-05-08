#!/bin/bash
# Memory chunk generator — Tier 2
# Auto-generate MEMORY_SUMMARY.md dari git + rekam_jejak
# Run: bash ~/.claude/hooks/memory-chunk.sh (recommended: daily, via cron atau manual)

set -e

VAULT_ROOT="$HOME/vault_obsidian_brajakara"
MEMORY_DIR="$HOME/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory"
OUTPUT="$MEMORY_DIR/MEMORY_SUMMARY.md"

echo "[memory-chunk] Generating MEMORY_SUMMARY.md..."

GENERATED=$(date -u +%Y-%m-%dT%H:%M:%SZ)

cat > "$OUTPUT" << EOF
---
type: memory-summary
category: memory
hop: 0
generated: ${GENERATED}
---

# Memory Summary — Vault Context

> Auto-generated chunk untuk fast context load di session start. Refresh: daily.

---

## 🎯 Active Context (Now)

EOF

# ---- ACTIVE PROJECTS ----
echo "" >> "$OUTPUT"
echo "### Working On:" >> "$OUTPUT"
if [ -f "$MEMORY_DIR/project_active.md" ]; then
    grep -A 2 "| Project" "$MEMORY_DIR/project_active.md" | head -10 >> "$OUTPUT" || true
fi

# ---- TASK PENDING (BLOCKER) ----
echo "" >> "$OUTPUT"
echo "### Task Pending:" >> "$OUTPUT"
if [ -f "$MEMORY_DIR/project_active.md" ]; then
    grep "## ⚠️ Task Pending" "$MEMORY_DIR/project_active.md" | head -5 >> "$OUTPUT" || true
fi

# ---- RECENT COMMITS (Last 7 days) ----
echo "" >> "$OUTPUT"
echo "## 📈 Recent Activity (Last 7 Days)" >> "$OUTPUT"
echo "" >> "$OUTPUT"

cd "$VAULT_ROOT" 2>/dev/null || exit 1

echo "### Modified Files (top 5):" >> "$OUTPUT"
echo '```' >> "$OUTPUT"
git log --name-only --pretty=format: --since="7 days ago" 2>/dev/null | \
    grep -v "^$" | grep "\.[a-z]" | sort | uniq -c | sort -rn | head -5 | \
    awk '{printf "  %2d  %s\n", $1, $2}' >> "$OUTPUT" || echo "  (no recent changes)" >> "$OUTPUT"
echo '```' >> "$OUTPUT"

echo "" >> "$OUTPUT"
echo "### Recent Commits:" >> "$OUTPUT"
echo '```' >> "$OUTPUT"
git log --oneline --since="7 days ago" 2>/dev/null | head -5 >> "$OUTPUT" || echo "(no commits)" >> "$OUTPUT"
echo '```' >> "$OUTPUT"

# ---- RECENT WORK (TOP 3 from rekam_jejak) ----
echo "" >> "$OUTPUT"
echo "## 🏆 Recent Work (Top 3 Entries)" >> "$OUTPUT"
echo "" >> "$OUTPUT"

if [ -f "$VAULT_ROOT/07_PROFIL (Professional Identity)/rekam_jejak.md" ]; then
    # Extract first 3 entries (### 202...)
    grep -A 7 "^### 202" "$VAULT_ROOT/07_PROFIL (Professional Identity)/rekam_jejak.md" | \
        head -30 >> "$OUTPUT" || true
fi

# ---- HOTSPOTS (Most accessed) ----
echo "" >> "$OUTPUT"
echo "## 🔥 Hotspots (Most Accessed Files)" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "### In Last 7 Days:" >> "$OUTPUT"
echo '| File | Count |' >> "$OUTPUT"
echo '|---|---|' >> "$OUTPUT"

git log --name-only --pretty=format: --since="7 days ago" 2>/dev/null | \
    grep "\.md$" | sort | uniq -c | sort -rn | head -5 | \
    awk '{printf "| `%s` | %d |\n", $2, $1}' >> "$OUTPUT" || true

# ---- QUICK ROUTES ----
echo "" >> "$OUTPUT"
echo "## 🗺️ Quick Routes (Keywords → Files)" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "Top 10 keywords dari keyword map:" >> "$OUTPUT"
echo '```tsv' >> "$OUTPUT"
head -10 ~/.claude/vault-keyword-map.tsv | awk -F'\t' '{printf "%-20s → %s\n", $1, $2}' >> "$OUTPUT" 2>/dev/null || echo "(keyword map not found)" >> "$OUTPUT"
echo '```' >> "$OUTPUT"

# ---- META ----
echo "" >> "$OUTPUT"
echo "---" >> "$OUTPUT"
echo "" >> "$OUTPUT"
echo "**Generated:** ${GENERATED}" >> "$OUTPUT"
echo "**Interval:** Daily (recommended)" >> "$OUTPUT"
echo "**Next:** Auto-loaded di \`session-start-v2.sh\`" >> "$OUTPUT"

echo "[memory-chunk] ✅ MEMORY_SUMMARY.md generated"
echo "[memory-chunk] Size: $(wc -c < "$OUTPUT") bytes"
echo "[memory-chunk] Next: update session-start.sh hook di ~/.claude/settings.json"
