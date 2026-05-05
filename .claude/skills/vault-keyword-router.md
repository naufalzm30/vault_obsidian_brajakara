# Vault Keyword Router — Auto-Load Context

**Purpose:** Auto-detect vault keywords in user input, lookup relevant files, pre-load to context.

**Trigger:** Any user message mentioning vault keywords (project names, server aliases, profile docs).

---

## How It Works

1. **Parse user input** for keywords: PDAM_SBY, tower, azkaban, rockbottom, BE_WEATHERAPP, identitas, etc
2. **Lookup** `~/.claude/vault-keyword-map.tsv` untuk file path
3. **Pre-load file** ke context (baca dulu sebelum jawab)
4. **No hallucination** — kalau keyword tidak ada di map, tanya user atau search manual

---

## Keyword Map Location

`~/.claude/vault-keyword-map.tsv` — auto-generated dari `Navigation_Map.md` + folder indexes

Format:
```
keyword | file_path | type | category | detail
```

---

## Example Flow

**User bilang:** "ssh ke tower"

**Claude detects:** keyword `tower`

**Lookup TSV:** 
```
tower | 04_INFRASTRUCTURE_REFERENCE/Brajakara_Infrastructure_Overview.md | infra | vm | VM 102 Proxmox MORDOR, IP 10.20.0.11
```

**Claude pre-loads:**
```bash
Read 04_INFRASTRUCTURE_REFERENCE/Brajakara_Infrastructure_Overview.md
# Cari section tentang tower (VM 102, IP 10.20.0.11, SSH user tower@10.20.0.11)
```

**Claude jawab:** Berdasarkan context yang sudah di-load, tanpa asumin.

---

## Implementation (pseudo-code logic)

```python
# Di setiap user turn — before main response

keywords_mentioned = extract_keywords(user_message)  # regex atau simple split
matched_files = []

for keyword in keywords_mentioned:
    lookup_result = grep(f"^{keyword}\t", "~/.claude/vault-keyword-map.tsv")
    if lookup_result:
        file_path = parse_tsv_column(lookup_result, col=2)
        matched_files.append(file_path)

if matched_files:
    for file in matched_files:
        Read(f"~/vault_obsidian_brajakara/{file}")
    # Now respond with loaded context
else:
    # No keyword match — proceed normal, atau baca Navigation_Map kalau ragu
    pass
```

---

## Maintenance

**Update keyword map:** Saat ada project/server/doc baru di vault, tambahkan entry ke `~/.claude/vault-keyword-map.tsv`.

**Auto-sync:** Keyword map bisa di-generate ulang dari folder indexes secara periodik (future: housekeeping script).

---

## Token Savings

**Before:** User bilang "PDAM" → Claude baca Navigation_Map → folder index → project note = 3 file reads
**After:** User bilang "PDAM" → Claude lookup TSV → baca project note langsung = 1 file read

**Estimated savings:** 20-30% on knowledge retrieval (skip intermediate navigation)
