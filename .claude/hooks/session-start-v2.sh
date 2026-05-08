#!/bin/bash
# Session startup v2 — aggressive memory load, minimal scan

VAULT_ROOT="$HOME/vault_obsidian_brajakara"
MEMORY_DIR="$HOME/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory"
MEMORY_SUMMARY="$MEMORY_DIR/MEMORY_SUMMARY.md"

# ============ PRE-CHECKS: FINGERPRINT + TOKEN BUDGET ============

# Run context fingerprint check
bash ~/.claude/hooks/context-fingerprint.sh

# Show token budget snapshot
bash ~/.claude/hooks/token-budget.sh session 2>/dev/null

# ============ TIER 1: AGGRESSIVE MEMORY LOAD ============

echo ""
echo "════════════════════════════════════════════"
echo "  🧠 MEMORY LOAD (Tier 1 — Fast Context)"
echo "════════════════════════════════════════════"
echo ""

# ---- USER PROFILE (WHO) ----
echo "👤 USER:"
if [ -f "$MEMORY_DIR/user_profile.md" ]; then
    # Skip frontmatter, ambil first 15 lines konten
    tail -n +7 "$MEMORY_DIR/user_profile.md" | head -15
fi
echo ""

# ---- ACTIVE PROJECTS (WHAT NOW) ----
echo "📌 ACTIVE PROJECTS:"
if [ -f "$MEMORY_DIR/project_active.md" ]; then
    # Skip frontmatter, ambil table + task pending
    tail -n +7 "$MEMORY_DIR/project_active.md" | head -25
fi
echo ""

# ---- RECENT WORK (WHAT RECENTLY) ----
echo "📊 RECENT WORK (top 3 entries):"
if [ -f "$VAULT_ROOT/07_PROFIL (Professional Identity)/rekam_jejak.md" ]; then
    # Ambil 3 entry terakhir (### YYYY-MM-DD)
    grep -A 8 "^### 202" "$VAULT_ROOT/07_PROFIL (Professional Identity)/rekam_jejak.md" | head -30
fi
echo ""

# ---- TASK PENDING (BLOCKER) ----
echo "⚠️  TASK PENDING:"
if [ -f "$MEMORY_DIR/project_active.md" ]; then
    grep -A 5 "## ⚠️ Task Pending" "$MEMORY_DIR/project_active.md" | head -20
fi
echo ""

# ============ TIER 2: MEMORY SUMMARY (if exists) ============

if [ -f "$MEMORY_SUMMARY" ]; then
    echo "📝 MEMORY SUMMARY (auto-generated):"
    cat "$MEMORY_SUMMARY"
    echo ""
fi

# ============ CAVEMAN + RTK + KEYWORD TRACE ============

echo "════════════════════════════════════════════"
echo "  🔥 CAVEMAN MODE — ENFORCED"
echo "════════════════════════════════════════════"
echo ""
echo "  FRAGMEN AJA. Hapus artikel/filler. Bahasa gue/lo."
echo ""
echo "  ❌ JANGAN:"
echo "     \"Saya akan mencoba membantu Anda...\""
echo "     \"Mari kita lihat file tersebut...\""
echo ""
echo "  ✅ PAKAI:"
echo "     \"Baca file.\""
echo "     \"Oke cek.\""
echo "     \"Gas.\""
echo ""
echo "  EXCEPTION: Code, commit, security warning — OK English."
echo ""
echo "════════════════════════════════════════════"
echo "  🔥 RTK — MANDATORY PREFIX"
echo "════════════════════════════════════════════"
echo ""
echo "  PREFIX: rtk <cmd> atau | rtk log"
echo "  ALL verbose commands. No excuse."
echo ""
echo "════════════════════════════════════════════"
echo "  🔥 KEYWORD TRACE — AUTO-LOAD"
echo "════════════════════════════════════════════"
echo ""
echo "  User bilang keyword vault?"
echo "  → lookup ~/.claude/vault-keyword-map.tsv"
echo "  → baca file langsung"
echo "  → baru jawab"
echo ""
echo "  Quick routes:"
awk -F'\t' 'NR<=10 {printf "    %-25s → %s\n", $1, $2}' ~/.claude/vault-keyword-map.tsv 2>/dev/null
echo ""
echo "════════════════════════════════════════════"

# ============ BEHAVIOR RULES — COMPACT ============
echo ""
echo "📌 BEHAVIOR RULES:"
if [ -f "$MEMORY_DIR/feedback_behavior.md" ]; then
    grep -E "^## " "$MEMORY_DIR/feedback_behavior.md" | sed 's/^## /  - /'
fi
echo ""

echo "════════════════════════════════════════════"
echo "  ✅ Ready. CAVEMAN AKTIF. GAS."
echo "════════════════════════════════════════════"
echo ""
