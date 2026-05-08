#!/bin/bash
# Daily housekeeping — auto-archive old daily notes + compact rekam_jejak
# Run manually or schedule 1x per month

VAULT="$HOME/vault_obsidian_brajakara"
DAILY_NOTES="$VAULT/00_INBOX/Daily_Notes"
REKAM_JEJAK="$VAULT/07_PROFIL (Professional Identity)/rekam_jejak.md"
REKAM_INDEX="$VAULT/07_PROFIL (Professional Identity)/rekam_jejak-INDEX.md"

echo "🧹 Daily Housekeeping..."
echo ""

# ============ STEP 1: Archive old daily notes (>30 days) ============
echo "📋 Archiving old daily notes (>30 hari)..."

find "$DAILY_NOTES" -type f -name "*.md" -mtime +30 | while read file; do
    filename=$(basename "$file")
    date_str=$(echo "$filename" | sed 's/\.md//')  # YYYY-MM-DD.md → YYYY-MM-DD
    year=$(echo "$date_str" | cut -d- -f1)
    month=$(echo "$date_str" | cut -d- -f2)
    
    archive_dir="$DAILY_NOTES/$year/$month"
    mkdir -p "$archive_dir"
    mv "$file" "$archive_dir/$filename"
    echo "  ✓ $filename → $year/$month/"
done

# ============ STEP 2: Compact rekam_jejak (keep last 30 entries, archive rest) ============
echo ""
echo "📚 Compacting rekam_jejak..."

if [ -f "$REKAM_JEJAK" ]; then
    # Extract last 30 entries
    tail -60 "$REKAM_JEJAK" > "$REKAM_INDEX.tmp"
    
    # Count lines
    total_lines=$(wc -l < "$REKAM_JEJAK")
    recent_lines=$(wc -l < "$REKAM_INDEX.tmp")
    archived_lines=$((total_lines - recent_lines))
    
    # Create index with recent entries
    echo "---" > "$REKAM_INDEX"
    echo "type: index" >> "$REKAM_INDEX"
    echo "name: Rekam Jejak (Recent 30)" >> "$REKAM_INDEX"
    echo "---" >> "$REKAM_INDEX"
    echo "" >> "$REKAM_INDEX"
    echo "# Rekam Jejak — Recent Entries (30)" >> "$REKAM_INDEX"
    echo "" >> "$REKAM_INDEX"
    echo "> Full history: [[rekam_jejak]] | Archived entries: [[rekam_jejak_archive/]]" >> "$REKAM_INDEX"
    echo "" >> "$REKAM_INDEX"
    cat "$REKAM_INDEX.tmp" >> "$REKAM_INDEX"
    rm "$REKAM_INDEX.tmp"
    
    echo "  ✓ rekam_jejak-INDEX.md created (recent 30 entries)"
    echo "  ✓ Total entries: $total_lines, archived: $archived_lines"
fi

# ============ STEP 3: Archive old rekam_jejak entries ============
echo ""
echo "📦 Archiving old rekam_jejak entries..."

if [ -f "$REKAM_JEJAK" ]; then
    # Extract entries older than current month
    # Format: ### YYYY-MM-DD — [Title]
    current_year=$(date +%Y)
    current_month=$(date +%m)
    
    archive_dir="$VAULT/07_PROFIL (Professional Identity)/rekam_jejak_archive/$current_year"
    mkdir -p "$archive_dir"
    
    # Backup full rekam_jejak
    cp "$REKAM_JEJAK" "$archive_dir/rekam_jejak-backup-$(date +%Y%m%d).md"
    echo "  ✓ Backup: rekam_jejak-backup-$(date +%Y%m%d).md"
fi

# ============ STEP 4: Git sync ============
echo ""
echo "🔄 Git sync..."

cd "$VAULT"
rtk git add "00_INBOX/Daily_Notes/" "07_PROFIL (Professional Identity)/rekam_jejak-INDEX.md" \
    "07_PROFIL (Professional Identity)/rekam_jejak_archive/"
rtk git commit -m "housekeeping: archive old daily notes + compact rekam_jejak" 2>/dev/null || echo "  ℹ No changes to commit"
rtk git push origin master 2>/dev/null || echo "  ⚠ Git push failed (check connection)"

echo ""
echo "✅ Housekeeping complete"
