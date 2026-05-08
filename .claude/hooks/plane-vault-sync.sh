#!/bin/bash
# Plane ↔ Vault Bidirectional Sync — Scaffold + manual trigger
# Full auto-sync requires webhook listener (not implemented yet)
#
# Usage:
#   plane-vault-sync.sh vault-to-plane [file] [project]   — sync vault note → Plane
#   plane-vault-sync.sh plane-to-vault [project] [seq]    — sync Plane issue → vault
#   plane-vault-sync.sh auto [file]                       — detect + suggest sync

VAULT_ROOT="$HOME/vault_obsidian_brajakara"
PLANE_WORKSPACE="brajakara"

CMD="${1:-auto}"

# ============ UTILITY: Detect project from file path ============
detect_project() {
    local file="$1"
    
    # Map vault project files to Plane project IDs
    if echo "$file" | grep -qi "pdam"; then
        echo "HARDW"  # Hardware/IoT project
    elif echo "$file" | grep -qi "weatherapp"; then
        echo "WEBAP"
    elif echo "$file" | grep -qi "whatsapp\|wa_"; then
        echo "SOFTW"
    else
        echo "WEBAP"  # default
    fi
}

# ============ UTILITY: Extract title + description from vault note ============
extract_from_vault() {
    local file="$1"
    
    # Extract title (## heading or filename)
    local title=$(grep -m 1 "^## " "$file" | sed 's/^## //' || basename "$file" .md)
    
    # Extract description (skip frontmatter, get first paragraph)
    local desc=$(awk '/^---$/{p++} p==2{print}' "$file" | grep -v "^#" | head -10 | tr '\n' ' ' | sed 's/  */ /g' | cut -c1-500)
    
    echo "$title||$desc"
}

# ============ VAULT → PLANE ============
if [ "$CMD" = "vault-to-plane" ]; then
    FILE="${2:-}"
    PROJECT="${3:-}"
    
    if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
        echo "❌ Usage: plane-vault-sync.sh vault-to-plane [file] [project-optional]"
        exit 1
    fi
    
    echo ""
    echo "🔄 Vault → Plane Sync"
    echo "════════════════════════════════════"
    echo ""
    
    # Auto-detect project if not provided
    if [ -z "$PROJECT" ]; then
        PROJECT=$(detect_project "$FILE")
        echo "  Auto-detected project: $PROJECT"
    fi
    
    # Extract content
    CONTENT=$(extract_from_vault "$FILE")
    TITLE=$(echo "$CONTENT" | cut -d'|' -f1)
    DESC=$(echo "$CONTENT" | cut -d'|' -f3)
    
    echo "  Title: $TITLE"
    echo "  Description: ${DESC:0:80}..."
    echo ""
    
    # Check if work item already exists (basic — search by title)
    echo "  Checking if work item exists in Plane..."
    
    # This would use MCP plane integration
    # For now, print command that Claude Code would execute
    echo ""
    echo "  Next: Claude Code will execute:"
    echo "    plane_list_issues_ide(project='$PROJECT')"
    echo "    → search for matching title"
    echo "    → if not found: plane_create_issue_ide(project='$PROJECT', title='$TITLE', description='$DESC')"
    echo "    → if found: plane_update_issue_ide(...)"
    echo ""
    echo "⚠️  Full sync requires Claude Code session with MCP enabled"
    echo ""
    exit 0
fi

# ============ PLANE → VAULT ============
if [ "$CMD" = "plane-to-vault" ]; then
    PROJECT="${2:-}"
    SEQ_ID="${3:-}"
    
    if [ -z "$PROJECT" ] || [ -z "$SEQ_ID" ]; then
        echo "❌ Usage: plane-vault-sync.sh plane-to-vault [project] [sequence_id]"
        echo "   Example: plane-vault-sync.sh plane-to-vault WEBAP 22"
        exit 1
    fi
    
    echo ""
    echo "🔄 Plane → Vault Sync"
    echo "════════════════════════════════════"
    echo ""
    echo "  Fetching: $PROJECT-$SEQ_ID"
    echo ""
    
    # This would use MCP plane integration
    echo "  Next: Claude Code will execute:"
    echo "    plane_get_issue_ide(project='$PROJECT', sequence_id=$SEQ_ID)"
    echo "    → extract title, description, state, priority"
    echo "    → find matching vault note or create new"
    echo "    → update vault note with Plane metadata"
    echo ""
    echo "⚠️  Full sync requires Claude Code session with MCP enabled"
    echo ""
    exit 0
fi

# ============ AUTO-DETECT + SUGGEST ============
if [ "$CMD" = "auto" ]; then
    FILE="${2:-}"
    
    if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
        echo "❌ Usage: plane-vault-sync.sh auto [file]"
        exit 1
    fi
    
    echo ""
    echo "🤖 Auto-Detect Sync Opportunity"
    echo "════════════════════════════════════"
    echo ""
    
    # Check if file has Plane link
    if grep -q "plane.blitztechnology.tech" "$FILE"; then
        echo "  ✓ File already linked to Plane"
        PLANE_LINK=$(grep -o "https://plane.blitztechnology.tech/[^)]*" "$FILE" | head -1)
        echo "    Link: $PLANE_LINK"
        echo ""
        echo "  Suggest: plane-to-vault sync to refresh vault from Plane"
    else
        echo "  ℹ️  File not linked to Plane yet"
        echo ""
        
        PROJECT=$(detect_project "$FILE")
        echo "  Suggested sync: vault-to-plane"
        echo "  Detected project: $PROJECT"
        echo ""
        
        CONTENT=$(extract_from_vault "$FILE")
        TITLE=$(echo "$CONTENT" | cut -d'|' -f1)
        
        echo "  Preview:"
        echo "    Title: $TITLE"
        echo "    Project: $PROJECT"
        echo ""
        echo "  To execute: plane-vault-sync.sh vault-to-plane '$FILE' '$PROJECT'"
    fi
    
    echo ""
    echo "════════════════════════════════════"
    echo ""
    exit 0
fi

echo "❌ Unknown command: $CMD"
echo ""
echo "Usage:"
echo "  plane-vault-sync.sh vault-to-plane [file] [project]"
echo "  plane-vault-sync.sh plane-to-vault [project] [sequence_id]"
echo "  plane-vault-sync.sh auto [file]"
echo ""
exit 1
