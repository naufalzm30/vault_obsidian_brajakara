#!/bin/bash
# Context fingerprint — detect stale context between sessions
# Hash critical files → warn if changed unexpectedly

MEMORY_DIR="$HOME/.claude/projects/-home-salazar-vault_obsidian_brajakara/memory"
VAULT_ROOT="$HOME/vault_obsidian_brajakara"
FINGERPRINT_FILE="$MEMORY_DIR/.context.fingerprint"

echo ""
echo "🔐 Context Fingerprint Check..."
echo ""

# ============ STEP 1: GENERATE FINGERPRINTS ============

# Function: generate hash for a file (portable across macOS/Linux)
hash_file() {
    local file=$1
    if [ -f "$file" ]; then
        if command -v md5sum &> /dev/null; then
            md5sum "$file" | awk '{print $1}'
        elif command -v md5 &> /dev/null; then
            md5 -q "$file"
        else
            echo "0000000000000000"  # fallback
        fi
    else
        echo "MISSING"
    fi
}

# Generate current fingerprints
echo "Generating current fingerprints..."

FP_CAVEMAN=$(hash_file "$MEMORY_DIR/CAVEMAN_RULES.md")
FP_BEHAVIOR=$(hash_file "$MEMORY_DIR/feedback_behavior.md")
FP_KEYWORD=$(hash_file "$HOME/.claude/vault-keyword-map.tsv")
FP_CLAUDE=$(hash_file "$VAULT_ROOT/CLAUDE.md")
FP_VERSION=$(grep -E "Last updated|version" "$VAULT_ROOT/CLAUDE.md" 2>/dev/null | head -1 | md5sum 2>/dev/null | awk '{print $1}' || echo "unknown")

# ============ STEP 2: COMPARE WITH PREVIOUS ============

if [ -f "$FINGERPRINT_FILE" ]; then
    echo "Comparing with previous session..."
    echo ""
    
    source "$FINGERPRINT_FILE"
    
    DRIFT_DETECTED=0
    
    # Check each file
    if [ "$FP_CAVEMAN" != "${PREV_FP_CAVEMAN:-}" ] && [ "${PREV_FP_CAVEMAN:-}" != "MISSING" ]; then
        echo "⚠️  DRIFT: CAVEMAN_RULES.md changed"
        echo "   Previous: ${PREV_FP_CAVEMAN:0:8}..."
        echo "   Current:  ${FP_CAVEMAN:0:8}..."
        DRIFT_DETECTED=$((DRIFT_DETECTED + 1))
    fi
    
    if [ "$FP_BEHAVIOR" != "${PREV_FP_BEHAVIOR:-}" ] && [ "${PREV_FP_BEHAVIOR:-}" != "MISSING" ]; then
        echo "⚠️  DRIFT: feedback_behavior.md changed"
        echo "   Previous: ${PREV_FP_BEHAVIOR:0:8}..."
        echo "   Current:  ${FP_BEHAVIOR:0:8}..."
        DRIFT_DETECTED=$((DRIFT_DETECTED + 1))
    fi
    
    if [ "$FP_KEYWORD" != "${PREV_FP_KEYWORD:-}" ] && [ "${PREV_FP_KEYWORD:-}" != "MISSING" ]; then
        echo "⚠️  DRIFT: vault-keyword-map.tsv changed"
        echo "   Previous: ${PREV_FP_KEYWORD:0:8}..."
        echo "   Current:  ${FP_KEYWORD:0:8}..."
        echo "   → Running keyword trace reload..."
        DRIFT_DETECTED=$((DRIFT_DETECTED + 1))
    fi
    
    if [ "$FP_CLAUDE" != "${PREV_FP_CLAUDE:-}" ] && [ "${PREV_FP_CLAUDE:-}" != "MISSING" ]; then
        echo "⚠️  DRIFT: CLAUDE.md changed (major update)"
        echo "   Previous: ${PREV_FP_CLAUDE:0:8}..."
        echo "   Current:  ${FP_CLAUDE:0:8}..."
        echo "   → Recommend: re-read CLAUDE.md section start"
        DRIFT_DETECTED=$((DRIFT_DETECTED + 1))
    fi
    
    if [ $DRIFT_DETECTED -gt 0 ]; then
        echo ""
        echo "🔄 $DRIFT_DETECTED context files changed — re-loading..."
        echo ""
        # Force re-load by calling session-start again
        bash ~/.claude/hooks/session-start-v2.sh
        echo ""
    else
        echo "✓ No drift detected"
    fi
else
    echo "First session — fingerprint baseline created"
fi

echo ""

# ============ STEP 3: SAVE CURRENT FINGERPRINTS ============

cat > "$FINGERPRINT_FILE" << EOF
# Context Fingerprint — Auto-generated
# Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)

export PREV_FP_CAVEMAN="$FP_CAVEMAN"
export PREV_FP_BEHAVIOR="$FP_BEHAVIOR"
export PREV_FP_KEYWORD="$FP_KEYWORD"
export PREV_FP_CLAUDE="$FP_CLAUDE"
export PREV_VERSION="$FP_VERSION"

# Tracked files:
# - CAVEMAN_RULES.md
# - feedback_behavior.md
# - vault-keyword-map.tsv
# - CLAUDE.md (major updates)
EOF

echo "✅ Fingerprint saved for next session"
echo "   File: $FINGERPRINT_FILE"
echo ""
