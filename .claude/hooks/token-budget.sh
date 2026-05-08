#!/bin/bash
# Token Budget Skill — track token usage per session/day
# Usage:
#   token-budget.sh log [input] [output]   — log usage
#   token-budget.sh report                 — show today's summary
#   token-budget.sh session [session-id]   — show session usage
#   token-budget.sh warn [threshold]       — warn if over threshold

USAGE_LOG="$HOME/.claude/usage_log.jsonl"
DAILY_LIMIT="${TOKEN_DAILY_LIMIT:-200000}"  # default 200K total/day
WARN_THRESHOLD="${TOKEN_WARN_THRESHOLD:-150000}"

# Ensure log file exists
touch "$USAGE_LOG"

CMD="${1:-report}"

# ============ LOG ============
if [ "$CMD" = "log" ]; then
    INPUT_TOKENS="${2:-0}"
    OUTPUT_TOKENS="${3:-0}"
    SESSION_ID="${4:-unknown}"
    
    ENTRY=$(jq -nc \
        --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        --arg date "$(date +%Y-%m-%d)" \
        --argjson input "$INPUT_TOKENS" \
        --argjson output "$OUTPUT_TOKENS" \
        --arg session "$SESSION_ID" \
        '{timestamp: $ts, date: $date, input_tokens: $input, output_tokens: $output, total: ($input + $output), session: $session}')
    
    echo "$ENTRY" >> "$USAGE_LOG"
    echo "Logged: input=$INPUT_TOKENS output=$OUTPUT_TOKENS"
    exit 0
fi

# ============ REPORT ============
if [ "$CMD" = "report" ]; then
    TODAY=$(date +%Y-%m-%d)
    echo ""
    echo "📊 Token Budget Report — $TODAY"
    echo "════════════════════════════════════"
    echo ""
    
    # Today's total
    if command -v jq &> /dev/null; then
        TODAY_TOTAL=$(grep "\"date\":\"$TODAY\"" "$USAGE_LOG" 2>/dev/null | jq -s '[.[].total] | add // 0' 2>/dev/null || echo "0")
        TODAY_INPUT=$(grep "\"date\":\"$TODAY\"" "$USAGE_LOG" 2>/dev/null | jq -s '[.[].input_tokens] | add // 0' 2>/dev/null || echo "0")
        TODAY_OUTPUT=$(grep "\"date\":\"$TODAY\"" "$USAGE_LOG" 2>/dev/null | jq -s '[.[].output_tokens] | add // 0' 2>/dev/null || echo "0")
        
        # Calculate percentage
        PERCENT=$(echo "scale=1; $TODAY_TOTAL * 100 / $DAILY_LIMIT" | bc 2>/dev/null || echo "?")
        
        echo "  Today:"
        echo "    Input:  $TODAY_INPUT tokens"
        echo "    Output: $TODAY_OUTPUT tokens"
        echo "    Total:  $TODAY_TOTAL / $DAILY_LIMIT ($PERCENT%)"
        echo ""
        
        # Budget bar
        if [ "$TODAY_TOTAL" -gt 0 ] 2>/dev/null; then
            BARS=$(echo "scale=0; $TODAY_TOTAL * 20 / $DAILY_LIMIT" | bc 2>/dev/null || echo "0")
            BAR=""
            for ((i=0; i<BARS && i<20; i++)); do BAR="${BAR}█"; done
            for ((i=BARS; i<20; i++)); do BAR="${BAR}░"; done
            echo "  Budget: [$BAR] $PERCENT%"
            echo ""
        fi
        
        # Warning
        if [ "$TODAY_TOTAL" -gt "$WARN_THRESHOLD" ] 2>/dev/null; then
            echo "  ⚠️  APPROACHING LIMIT: $TODAY_TOTAL > $WARN_THRESHOLD (threshold)"
        fi
        
        # Session breakdown
        echo ""
        echo "  Sessions today:"
        grep "\"date\":\"$TODAY\"" "$USAGE_LOG" 2>/dev/null | \
            jq -r '"\(.session) — \(.total) tokens (\(.input_tokens) in / \(.output_tokens) out)"' 2>/dev/null | \
            sort | uniq -c | awk '{printf "    %s\n", $0}' | head -10
        
        # Last 7 days summary
        echo ""
        echo "  Last 7 days:"
        for i in 1 2 3 4 5 6 7; do
            DAY=$(date -d "-$i days" +%Y-%m-%d 2>/dev/null || date -v -${i}d +%Y-%m-%d 2>/dev/null || continue)
            DAY_TOTAL=$(grep "\"date\":\"$DAY\"" "$USAGE_LOG" 2>/dev/null | jq -s '[.[].total] | add // 0' 2>/dev/null || echo "0")
            if [ "$DAY_TOTAL" -gt 0 ] 2>/dev/null; then
                echo "    $DAY: $DAY_TOTAL tokens"
            fi
        done
        
    else
        echo "  ⚠️  jq not found — install with: sudo pacman -S jq"
        echo ""
        echo "  Raw usage (last 10 entries):"
        tail -10 "$USAGE_LOG"
    fi
    
    echo ""
    echo "════════════════════════════════════"
    echo ""
    exit 0
fi

# ============ WARN ============
if [ "$CMD" = "warn" ]; then
    TODAY=$(date +%Y-%m-%d)
    THRESHOLD="${2:-$WARN_THRESHOLD}"
    
    if command -v jq &> /dev/null; then
        TODAY_TOTAL=$(grep "\"date\":\"$TODAY\"" "$USAGE_LOG" 2>/dev/null | jq -s '[.[].total] | add // 0' 2>/dev/null || echo "0")
        
        if [ "$TODAY_TOTAL" -gt "$THRESHOLD" ] 2>/dev/null; then
            echo ""
            echo "⚠️  TOKEN BUDGET WARNING"
            echo "   Used today: $TODAY_TOTAL"
            echo "   Threshold: $THRESHOLD"
            echo "   Remaining: $(( DAILY_LIMIT - TODAY_TOTAL )) of $DAILY_LIMIT"
            echo ""
        fi
    fi
    exit 0
fi

# ============ SESSION START ============
if [ "$CMD" = "session" ]; then
    echo ""
    echo "💡 Budget snapshot (session start):"
    bash "$0" warn "$WARN_THRESHOLD"
    bash "$0" report 2>/dev/null | grep -A 5 "Today:" | head -8
    exit 0
fi

echo "Usage: token-budget.sh [log|report|warn|session]"
exit 1
