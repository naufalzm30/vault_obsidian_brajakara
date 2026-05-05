# Caveman Watchdog — Mid-Session Enforcement

**Purpose:** Monitor Claude response untuk drift dari caveman, auto-correct.

**Trigger:** After every Claude response (hypothetical — need skill trigger support).

---

## How It Works

1. **Capture response** dari Claude (last response buffer)
2. **Check for drift indicators:**
   - Formal phrases: "Saya akan", "Mari kita", "Baik, saya mengerti", "Terima kasih", "Maaf"
   - Hedging: "mungkin", "sangat", "cukup", "agak", "kira-kira"
   - Wall of text: paragraf >3 kalimat tanpa line break
   - English ketika should be Indonesian (kecuali code/commit/security)
3. **Trigger correction:**
   - Print warning: `⚠️ DRIFT DETECTED — RESET CAVEMAN`
   - Re-read `CAVEMAN_RULES.md`
   - Optionally: rewrite last response dalam caveman style

---

## Drift Indicators (Regex Patterns)

```regex
# Formal Indonesian
(Saya akan|Mari kita|Baik,? saya|Terima kasih|Maaf|Mohon maaf|Saya rasa|Menurut saya|Sebagai)

# Hedging
(mungkin|sangat|cukup|agak|kira-kira|sepertinya)

# English drift (outside code blocks)
(?<!```)(I will|Let's|As you know|According to|In my opinion)(?!```)

# Wall of text (paragraf >3 kalimat tanpa break)
([A-Z][^.!?]*[.!?]){4,}(?!\n)
```

---

## Self-Correction Flow

**Detected drift:**
```
⚠️ CAVEMAN DRIFT — RESET

Last response terlalu formal. Rewrite:

Original:
"Baik, saya akan mencoba membantu Anda dengan masalah ini. Mari kita lihat file PDAM_SBY.md terlebih dahulu untuk memahami struktur yang ada."

Caveman:
"Cek PDAM_SBY.md dulu."
```

---

## Manual Trigger

**User ketik:** `caveman`

**Claude respond:**
```
🔥 RESET. Caveman aktif.

[re-read CAVEMAN_RULES.md]

Lanjut — fragmen mode.
```

---

## Implementation Notes

**Current limitation:** Claude Code skill system tidak ada `PostResponse` hook (hanya `PreToolUse`, `PostToolUse`, `SessionStart`, `Notification`).

**Workaround:**
- User manual trigger (`caveman` keyword)
- Self-check di setiap response (Claude internal awareness)
- Aggressive session-start enforcement (ini sudah done)

**Future:** Kalau ada `PostResponse` hook support → automate drift detection + correction.

---

## Integration dengan Session Start

`session-start.sh` sudah print CAVEMAN_RULES full → Claude load rule di awal.

Watchdog = reinforcement mid-session (manual atau auto kalau ada hook support).

---

## Token Impact

**Drift = token waste:**
- Formal phrase: +20-30% token per response
- Wall of text: +40-50% token (no visual parsing)
- English drift ketika should Indonesian: +10-15% token (longer words)

**Caveman = compact:**
- Fragmen: -25% avg token
- Bahasa gue/lo: -10% token (shorter words)
- Line breaks: +20% readability, -0% token (whitespace free)

**Watchdog enforcement → estimated savings:** 30-40% over session.

---

Last updated: 2026-05-05
Status: MANUAL TRIGGER (auto pending hook support)
