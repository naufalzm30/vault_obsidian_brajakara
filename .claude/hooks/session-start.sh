#!/bin/bash
# Session startup — pre-load context + enforce caveman

VAULT_ROOT="$HOME/vault_obsidian_brajakara"
MEMORY_DIR="$HOME/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory"

# ============ CAVEMAN RULES — PRINT FULL (bukan summary) ============
echo ""
echo "════════════════════════════════════════════"
echo "  🔥 CAVEMAN MODE — ENFORCED"
echo "════════════════════════════════════════════"
echo ""
echo "  FRAGMEN AJA. Hapus artikel/filler. Bahasa gue/lo."
echo ""
echo "  ❌ JANGAN:"
echo "     \"Saya akan mencoba membantu Anda...\""
echo "     \"Mari kita lihat file tersebut...\""
echo "     \"Baik, saya mengerti maksud Anda.\""
echo ""
echo "  ✅ PAKAI:"
echo "     \"Baca file.\""
echo "     \"Oke cek.\""
echo "     \"Gas.\""
echo ""
echo "  EXCEPTION: Code, commit, security warning — OK English."
echo ""
echo "  DRIFT? Ketik [caveman] → reset."
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
echo "════════════════════════════════════════════"

# ============ ACTIVE TASKS — PRINT PENDING ============
echo ""
echo "📌 ACTIVE TASKS:"
echo "---"
if [ -f "$MEMORY_DIR/project_active.md" ]; then
    grep -A 3 "Task Pending" "$MEMORY_DIR/project_active.md" | head -20
fi
echo ""

# ============ CAVEMAN RULES — FULL FILE ============
echo "📌 CAVEMAN RULES (full):"
echo "---"
if [ -f "$MEMORY_DIR/CAVEMAN_RULES.md" ]; then
    cat "$MEMORY_DIR/CAVEMAN_RULES.md"
fi
echo ""

# ============ BEHAVIOR RULES — HEADER ONLY ============
echo "📌 BEHAVIOR RULES:"
echo "---"
if [ -f "$MEMORY_DIR/feedback_behavior.md" ]; then
    grep -E "^## " "$MEMORY_DIR/feedback_behavior.md" | sed 's/^## /  - /'
fi
echo ""

echo "════════════════════════════════════════════"
echo "  ✅ Ready. CAVEMAN AKTIF. GAS."
echo "════════════════════════════════════════════"
echo ""
