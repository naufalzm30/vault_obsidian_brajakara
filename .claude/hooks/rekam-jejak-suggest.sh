#!/bin/bash
# Rekam Jejak Auto-Categorize Skill
# Suggest category + detect tech vs meta entries
# Usage: bash ~/.claude/hooks/rekam-jejak-suggest.sh [entry-title] [description]

# ============ STEP 1: ANALYZE INPUT ============

ENTRY_TITLE="${1:-}"
ENTRY_DESC="${2:-}"

if [ -z "$ENTRY_TITLE" ]; then
    echo ""
    echo "❌ Usage: rekam-jejak-suggest.sh [title] [description]"
    echo ""
    echo "Example:"
    echo "  rekam-jejak-suggest.sh 'Alert monitoring setup' 'Implement real-time alerts for PDAM sensors'"
    echo ""
    exit 1
fi

echo ""
echo "🤖 Rekam Jejak Auto-Categorize"
echo "════════════════════════════════════════"
echo ""
echo "Entry: $ENTRY_TITLE"
[ -n "$ENTRY_DESC" ] && echo "Description: $ENTRY_DESC"
echo ""

# ============ STEP 2: DETECT TYPE (TECH vs META) ============

echo "---"
echo "Analysis:"
echo ""

ENTRY_COMBINED="$ENTRY_TITLE $ENTRY_DESC"

TECH_SCORE=0
META_SCORE=0

# Tech keywords
if echo "$ENTRY_COMBINED" | grep -iq "api\|backend\|frontend\|database\|devops\|docker\|kubernetes\|mqtt\|redis\|fix\|bug\|optimize\|query\|endpoint\|schema\|migration\|sensor\|alert\|logger"; then
    TECH_SCORE=$((TECH_SCORE + 5))
fi

# Meta keywords
if echo "$ENTRY_COMBINED" | grep -iq "documentation\|claude\|vault\|obsidian\|structure\|template\|memory\|daily note\|handbook\|guide"; then
    META_SCORE=$((META_SCORE + 5))
fi

if [ $META_SCORE -gt $TECH_SCORE ]; then
    ENTRY_TYPE="Meta Vault"
    echo "🏷️  Type: Meta Vault (Documentation)"
    echo "   ✓ This is vault/Obsidian work — use 'Documentation' category"
else
    ENTRY_TYPE="Technical Work"
    echo "🏷️  Type: Technical Work (Code/Infrastructure)"
fi

echo ""

# ============ STEP 3: SUGGEST CATEGORY ============

echo "📊 Category Suggestion:"
echo ""

# Keyword-based category matching (simple, deterministic)

SUGGESTED_CAT=""

# Priority order matters — more specific first
if echo "$ENTRY_COMBINED" | grep -iq "documentation\|doc\|guide\|handbook\|readme\|tutorial\|write"; then
    SUGGESTED_CAT="Documentation"
elif echo "$ENTRY_COMBINED" | grep -iq "wireguard\|vpn\|network\|firewall\|proxmox\|vm\|infrastructure"; then
    SUGGESTED_CAT="Infrastructure / Networking"
elif echo "$ENTRY_COMBINED" | grep -iq "database\|sql\|schema\|query\|migration\|data pipeline"; then
    SUGGESTED_CAT="Backend / Data Engineering"
elif echo "$ENTRY_COMBINED" | grep -iq "api\|endpoint\|rest\|controller\|sensor\|mqtt\|logger\|alert"; then
    SUGGESTED_CAT="Backend / API"
elif echo "$ENTRY_COMBINED" | grep -iq "deploy\|ci/cd\|github action\|jenkins\|container"; then
    SUGGESTED_CAT="Backend / DevOps"
elif echo "$ENTRY_COMBINED" | grep -iq "frontend\|ui\|ux\|react\|vue\|javascript"; then
    SUGGESTED_CAT="Backend / UI/UX"
elif echo "$ENTRY_COMBINED" | grep -iq "docker\|kubernetes\|devops\|automation"; then
    SUGGESTED_CAT="DevOps"
else
    SUGGESTED_CAT="Backend"  # fallback
fi

# List all approved categories for reference
echo "Approved categories:"
echo "  • Backend"
echo "  • Backend / API"
echo "  • Backend / Data Engineering"
echo "  • Backend / DevOps"
echo "  • Backend / UI/UX"
echo "  • DevOps"
echo "  • DevOps / Infrastructure"
echo "  • Infrastructure / Networking"
echo "  • Infrastructure / Virtualization"
echo "  • Infrastructure / Integration"
echo "  • Documentation"
echo ""
echo "🎯 Suggested: **$SUGGESTED_CAT**"
echo ""

# ============ STEP 4: VALIDATION WARNING ============

echo "---"
echo "⚠️  Validation:"
echo ""

if [ "$ENTRY_TYPE" = "Meta Vault" ] && [ "$SUGGESTED_CAT" != "Documentation" ]; then
    echo "⚠️  WARNING: Entry is Meta Vault type, but suggested category is not 'Documentation'"
    echo "   Fix: Use 'Documentation' category instead"
    echo ""
fi

if echo "$ENTRY_TITLE" | grep -iq "ongoing\|work in progress\|wip"; then
    echo "⚠️  STYLE WARNING: Title suggests ongoing work"
    echo "   Recommendation: Use dated snapshots (YYYY-MM) instead of '(Ongoing)' marker"
    echo "   See: CLAUDE-MEMORY-SYNC.md → Ongoing Entries section"
    echo ""
fi

# ============ STEP 5: EFFORT + FIELDS TEMPLATE ============

echo "---"
echo "📋 Suggested Entry Template:"
echo ""

cat << 'EOF'
### YYYY-MM-DD — [Your Title Here]
**Kategori:** [Suggested Category from above]
**Daily note:** [[YYYY-MM-DD]]
**Effort:** 🟢 Low / 🟡 Medium / 🔴 High
**Team:** Solo / Collab with [nama]
**Sebelum:** [kondisi/masalah sebelum — 1 kalimat]
**Sesudah:** [hasil/impact — sertakan metric kalau ada — 1-2 kalimat]
**Skill:** [Python, Docker, DevOps, etc — comma-separated]
**Challenge:** (optional — blocker/difficulty signifikan)
**Artifact:** (optional — link ke script/PR/vault note)
- detail teknis poin-poin
- pakai [[wikilink]] untuk project/server/persona
EOF

echo ""
echo "════════════════════════════════════════"
echo ""
