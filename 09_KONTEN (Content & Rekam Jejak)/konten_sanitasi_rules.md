---
type: reference
category: konten
hop: 2
tags: [konten/rules, konten/sanitasi, konten/ethics]
up: "[[09_KONTEN (Content & Rekam Jejak)/index]]"
date: 2026-05-06
---

# Konten Sanitasi Rules

Master checklist & rules untuk evaluasi konten sebelum publish. Reference untuk diskusi konten brajakara.

---

## 🟢 AMAN PUBLISH — Kategori & Contoh

### 1. **Arsitektur & Design Pattern** (tanpa detail bisnis)

**Topik yang aman:**
- System design approach (state machine, tier routing, fallback mechanism)
- Technology choice & trade-offs (Redis vs in-memory, Telegram vs SMS, pakai ARIMA vs simple moving average)
- Performance optimization technique (token savings, context loading, hot-reload)
- Design pattern implementation (publish-subscribe, stateful FSM, quiet hours scheduling)

**Contoh aman:**
- ✅ "Stateful Alert System pakai Redis: 2-cycle confirm, tier routing (WARNING/CRITICAL/INFO), quiet hours buffer"
- ✅ "WireGuard Auto-Provisioning: subnet validation, hot-reload technique, auto-increment client ID"
- ✅ "Context memory optimization: Tier 1 aggressive load + Tier 2 auto-generate summary = 70% token savings"

**Contoh JANGAN:**
- ❌ "PDAM Surabaya alert system: kubikasi minus > -10 = threshold kritis"
- ❌ "Voltase turun < 170V → escalate ke supervisor balai Sukolilo"

---

### 2. **Problem Solving Journey** (anonymized, educational)

**Topik yang aman:**
- Debug & troubleshooting process (step-by-step, root cause analysis)
- Technical challenges & solutions (tanpa context bisnis)
- Learning moments & lesson learned
- Trade-off analysis (performance vs maintainability, complexity vs simplicity)

**Contoh aman:**
- ✅ "Debug exit 137 SIGKILL: root cause `set -e` conflict dengan `tee` pipe, fixed dengan direct file redirect"
- ✅ "Graph view routing issue: flat structure = poor Claude routing, solved via Breadcrumbs plugin + hierarchical metadata"
- ✅ "Installer TUI frame leakage: output buffer conflict dengan UI box frame, fixed dengan explicit `clear` before headers"

**Contoh JANGAN:**
- ❌ Expose actual error logs dengan IP/hostname
- ❌ Cerita bug yang mengungkap security vulnerability client

---

### 3. **Infrastructure Challenges** (high-level, no IP/hostname)

**Topik yang aman:**
- Scale management (30+ clients, 4 VMs, multiple server regions)
- Network topology & design (subnet planning, VPN architecture)
- Operational challenges (provisioning, hot-reload, downtime-free updates)
- Monitoring & reliability (alert system load, SLA consideration)

**Contoh aman:**
- ✅ "Manage 30+ VPN clients pakai WireGuard: subnet planning `10.20.0.x` admin vs `10.20.1.x` station, hot-reload without downtime"
- ✅ "Sandbox environment setup di Proxmox: isolated network segment, separate storage, load test capability"
- ✅ "Alert system handling 50+ alerts/day: smart routing (tier-based), quiet hours (22:00-06:00), deduplication logic"

**Contoh JANGAN:**
- ❌ Actual IP address: "192.168.1.41:2800"
- ❌ Hostname: "azkaban production node"
- ❌ Firewall rules: "open port 5432 for PostgreSQL replication"

---

### 4. **Tooling & Automation** (reusable, general-purpose)

**Topik yang aman:**
- CLI tool development (RTK filter system, bash script patterns)
- Automation workflow (git sync, memory hooks, session startup)
- Developer experience improvement (Obsidian vault structure, daily note system)
- Open-source tools usage & configuration

**Contoh aman:**
- ✅ "RTK integration: bash filter system untuk token savings, command categorization, output compression"
- ✅ "Bash TUI design: box drawing, colored output, interactive menu pattern, output stream handling"
- ✅ "Obsidian vault automation: daily note templating, wikilink cross-reference, hierarchical graph structure"
- ✅ "Git workflow optimization: interactive rebase, pre-push hooks, commit message standardization"

**Contoh JANGAN:**
- ❌ Custom script yang hardcode client-specific logic
- ❌ Proprietary deployment automation (kecuali lo punya permission)

---

## 🟡 HATI-HATI — Sanitasi Required

### 1. **Domain-Specific Logic** (hapus detail bisnis, keep pattern)

| ❌ JANGAN | ✅ BOLEH |
|---|---|
| "Taksasi PDAM pakai ARIMA, input kubikasi per balai" | "Automated calculation system dengan ML fallback untuk missing data" |
| "Voltase turun < 170V → escalate ke supervisor" | "Threshold-based escalation rule: parameter-driven, tier routing" |
| "Sensor air di 5 balai Surabaya" | "Water utility monitoring across multiple stations" |
| "Formula: (Q1-Q0)/30 - adjustment kubikasi minus" | "Calculation pipeline: input validation → algorithm → output adjustment" |

**Rule:** Abstrak ke general pattern, hide domain/parameter value.

---

### 2. **Client/Project Names** (anonymize, use generic term)

| ❌ JANGAN | ✅ BOLEH |
|---|---|
| "PDAM Surabaya deployment" | "Water utility monitoring system for municipal client" |
| "Brajakara project PDAM_SBY" | "Backend project for city-scale data collection" |
| "FE_weatherapp_palembang" | "Weather intelligence frontend application" |
| "BRAJA_PDAMSBY repository" | "Client project repository" |

**Rule:** Client names → generic category (water utility, weather service, telecom, dll). Location detail → anonymize (city-scale, regional, dll).

---

### 3. **Screenshots & Visual Data** (blur/mockup, no real data)

| ❌ JANGAN | ✅ BOLEH |
|---|---|
| Screenshot dashboard dengan angka real | Mockup/wireframe ilustrasi |
| Alert log dengan timestamp actual | Sanitized log: replace timestamp, blur data |
| Database schema dengan nama tabel bisnis | Generic ER diagram, abstracted entity names |
| Server monitoring graph dengan hostname | Graph dengan placeholder label ("Server A", "Server B") |

**Rule:** Visual aids = educational, bukan actual data. Blur real value, replace hostname, abstract entity name.

---

### 4. **Error Messages & Logs** (sanitize, no internal details)

| ❌ JANGAN | ✅ BOLEH |
|---|---|
| Full stack trace dengan IP 192.168.1.41 | Stack trace dengan IP replaced "XXX.XXX.X.X" |
| Error: "Cannot connect to azkaban:5432" | Error: "Database connection timeout" |
| "sensor_data table constraint violation" | "Data validation constraint error" |
| Syslog dengan internal service names | Generic error message, flow diagram |

**Rule:** Error message boleh publish, tapi sanitasi hostname/IP/table name sebelum.

---

## 🔴 JANGAN PUBLISH — Hard Rules

### 1. **Credentials & Secrets** (absolute no)
- ❌ API keys, tokens, passwords (obviously)
- ❌ SSH keys, private certificates
- ❌ Database connection string (bahkan dengan fake password, structure tetap reveal)
- ❌ VPN config files atau connection parameters
- ❌ Client-side secrets (env vars yang contain real value)

**Exception:** Code example pakai placeholder `${API_KEY}`, `$DB_PASSWORD`, dll — OK.

---

### 2. **Network & Security Architecture** (risk pattern leak)
- ❌ IP address (internal/external/VPN subnet)
- ❌ Hostname (server name, domain structure)
- ❌ Port mapping (bahkan port standard bisa reveal pattern)
- ❌ Firewall rules atau network topology diagram actual
- ❌ VPN subnet assignment (`10.20.0.x`, `10.20.1.x`)
- ❌ Security vulnerability atau incident post-mortem (kecuali ethical disclosure dengan permission)

**Exception:** Generic architecture diagram dengan placeholder label OK.

---

### 3. **Business Logic Detail** (proprietary)
- ❌ Formula kalkulasi spesifik (pricing, taksasi, scoring algorithm)
- ❌ Threshold angka spesifik (tolerance, limit, cutoff value)
- ❌ Business rule atau workflow (approval chain, SLA calculation)
- ❌ Financial data (revenue, cost, margin)
- ❌ Client-specific customization atau feature request

**Exception:** General approach OK ("adaptive threshold based on historical data"), spesifik value NO.

---

### 4. **Proprietary Code** (unless explicit permission)
- ❌ Full source code project client (utuh repo, besar file, produksi)
- ❌ Custom framework atau library internal client
- ❌ Generated code atau boilerplate client-specific
- ❌ Database schema lengkap dengan relasi bisnis

**Exception:** 
- Code snippet kecil (<50 baris) untuk education (with anonymization) OK
- Open-source contribution OK (karena lisensi explicit)
- Personal project / portfolio project OK

---

### 5. **Identifiable Information** (privacy concern)
- ❌ Real client name, contact, location (specific)
- ❌ Team member name (kecuali diri sendiri atau public credit)
- ❌ Personal data user/customer (email, phone, ID)
- ❌ Screenshot dengan watermark/logo client visible

---

## 🎯 Sanitasi Checklist — Pre-Publish

**Sebelum konten publish, validate semua poin ini:**

### Content Scope Review
- [ ] Konten fokus ke **teknis/pattern** atau **bisnis logika**?
  - Teknis/pattern → proceed
  - Bisnis logika → abstract dulu atau don't publish
  
- [ ] Ada **client/project name** yang specific?
  - Ya → replace dengan generic term
  - Tidak → OK
  
- [ ] Ada **anonymized case** dari client project?
  - Ya → validate 5 poin di bawah
  - Tidak → OK

### Sanitasi Detail (untuk anonymized case)
- [ ] **Client identification:** Dihapus atau generic category (e.g., "municipal utility")
- [ ] **Domain values:** Hapus spesifik angka, replace dengan "parameter-driven", "configurable threshold", dll
- [ ] **IP/hostname:** Semua IP/hostname diganti placeholder atau dihapus
- [ ] **Table/resource names:** Generic label atau diagram abstrak
- [ ] **Screenshots/logs:** Blur real data, replace identifier, mockup jika perlu

### Competitive & Security Review
- [ ] Kompetitor bisa replicate **value bisnis** dari konten ini?
  - Ya → Don't publish atau abstract lebih jauh
  - Tidak → OK
  
- [ ] Konten reveal **security pattern** yang risky?
  - Ya → Don't publish
  - Tidak → OK
  
- [ ] Ada **password/key/credential** bahkan tertulis di error message?
  - Ya → Remove
  - Tidak → OK

### Final Check
- [ ] Konten ini **educational**? (bukan cuma flex)
- [ ] Orang lain bisa **learn** dari konten tanpa perlu access client project?
- [ ] Lo **confident** client tidak perlu harus give permission? (atau permission already granted)

---

## 📋 Content Type Reference Table

| Content Type | Risk Level | Sanitasi | Contoh Topik |
|---|---|---|---|
| Arsitektur & Design Pattern | 🟢 Low | Minimal | State machine, Redis usage, tier routing |
| Problem Solving / Debug Story | 🟢 Low | Anonymize case | Error handling, troubleshooting process |
| Tooling & Automation | 🟢 Low | Minimal | CLI tool, bash script, git workflow |
| Infrastructure Challenges | 🟢 Low | Hide IP/hostname | Scale management, provisioning, hot-reload |
| Domain-Specific Logic | 🟡 Medium | High | Calculation algorithm, business rule |
| Client/Project Showcase | 🟡 Medium | High | Feature demo, case study |
| Security/Vulnerability | 🔴 High | Prohibited | Incident report, exploit detail |
| Credentials & Secrets | 🔴 High | Prohibited | API key, password, token |
| Proprietary Code | 🔴 High | Prohibited | Full source code, custom framework |

---

## 🔄 Revision Workflow

**Kalau ragu atau ada grey area:**

1. **Draft konten** → simpan di strategi_konten.md atau daily note
2. **Review pakai checklist** di atas — mark mana yang fail
3. **Tanya di sini** → tag conversation dengan konten title + risk concern
4. **Iterate** → abstract dulu, sanitasi, atau defer publish

**Quick ask template:**
```
Konten: "[Judul]"
Risk concern: [Mana yang ragu — domain logic? credentials? client name?]
Sanitasi plan: [Apa yang lo rencanain untuk handle]
Gray area?: [Ada yg ga fit ke hard rule di atas?]
```

---

## 📝 Notes

- **Boundaries bukan permanent.** Kalau lo dapet explicit permission dari client (tertulis), boundary boleh shift (e.g., boleh publikasi code dengan NDA).
- **Context matters.** Platform beda, audience beda, risk profile beda. LinkedIn post ≠ GitHub repo ≠ Medium article.
- **Err on the side of caution.** Kalau 60% yakin aman, better don't publish. Reputation > short-term flex.
- **Learn as you go.** Konten pertama mungkin terlalu abstract, next time lo bisa lebih bold (atau perlu lebih hati-hati).

---

**Last updated:** 2026-05-06
**Next review:** Setelah publish konten pertama, iterate based on learning

