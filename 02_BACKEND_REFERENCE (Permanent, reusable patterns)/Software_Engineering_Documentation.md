---
type: reference
category: documentation
hop: 2
tags: [documentation, engineering, process, brajakara]
up: "[[02_BACKEND_REFERENCE (Permanent, reusable patterns)/index]]"
date: 2026-05-08
---

# Software Engineering Documentation Types — Complete Reference

Referensi lengkap doc types dalam SDLC: kapan buat, siapa audience, apa isinya, tujuan.

---

## Quick Reference Table

| Doc Type | Audience | Kapan | Tujuan | Sebelum/Sesudah Code |
|---|---|---|---|---|
| **BRD** | Stakeholder, PM, Client, Finance | Sebelum kickoff | Problem → Goal, budget, timeline, KPI | Sebelum (proposal) |
| **PRD** | PM, Engineer, Designer, QA | Sebelum sprint | Fitur, user story, acceptance criteria, wireframe | Sebelum (outline) |
| **SRS** | Engineer, Tech Lead, Reviewer | Sebelum + Sesudah | Spec teknis detail: API, DB, flow logic, error handling | Sebelum (outline) + Sesudah (final) |
| **TDD** | Engineer (QA + Dev) | Sebelum code | Test case, edge case, performance spec | Sebelum (optional) |
| **Architecture Doc** | Tech Lead, Engineer, DevOps, Reviewer | Sebelum design finalize + Sesudah | Component diagram, technology choice, trade-off, risk | Sebelum (sketch) + Sesudah (detailed) |
| **API Reference** | Backend, Frontend, Integration partner | Sesudah API jadi | Endpoint list, request/response, auth, rate limit, example | Sesudah (extract) |
| **User Manual** | End user (operator, customer) | Sesudah prod ready | Getting started, feature walkthrough, FAQ, troubleshoot | Sesudah |
| **Deployment Guide** | DevOps, Release manager, SysAdmin | Sesudah codebase mature | Infrastructure spec, install step, config, backup, monitoring | Sesudah |

---

## 📋 Rincian Setiap Doc Type

### 1. BRD (Business Requirements Document)

**Audience:** Direktur, PM, Client, Finance  
**Kapan buat:** Sebelum project dimulai (proposal/marketing stage)  
**Tujuan:** Justifikasi bisnis project, budget, timeline, success metric

**Isinya:**
- **Problem statement:** Apa masalah client? Kenapa urgent? Data/metrik supporting.
- **Business goal:** Revenue uplift? Cost saving? Market share? User satisfaction?
- **Scope:** Feature in-scope + out-of-scope (explicit!)
- **Timeline:** Project duration, milestone, release date
- **Budget:** Cost estimate (development, infrastructure, maintenance)
- **Success metric (KPI):** Terukur, time-bound (e.g., latency <500ms, uptime 99.9%, MTTR <15 min)
- **Risk:** Dependency, constraint, assumption
- **Stakeholder:** Siapa sponsor, approval authority

**Contoh Brajakara PDAM_SBY:**
```
# BRD — Alert System PDAM_SBY

## Problem
Operator PDAM Surabaya manual cek sensor setiap hari:
- Proses: login dashboard, refresh setiap 30 min, check status 50+ sensor
- Akibat: 2-3 jam downtime tidak terdeteksi, MTTR rata-rata 2 jam
- Data: Historical, 40 outage/bulan, cost Rp XX juta per outage (water loss, water quality issue)

## Goal
Alert real-time → MTTR <15 min → 90% early detection → save Rp XX juta/bulan

## Scope (MVP)
- Real-time alert Telegram + email (4 kategori: MISSING, THRESHOLD, VOLTASE, KUBIKASI)
- Alert mute 1-24 jam
- Alert history + statistics dashboard
- Out-of-scope: Mobile app, email scheduling, SMS (phase 2)

## Timeline
- Phase 1 (alert core): 2 bulan
- Phase 2 (mobile): 1 bulan
- Go-live: Juli 2026

## Budget
Development: Rp 50 juta
Infrastructure (Redis, Telegram): Rp 5 juta/tahun
Maintenance: Rp 20 juta/tahun

## Success Metric
- Alert accuracy: 95% (false positive <5%)
- Alert latency: <5 min p95
- Uptime: 99.9%
- Operator satisfaction: >8/10 (survey)
- MTTR improvement: baseline 120 min → target 15 min
```

**Bikin sebelum atau sesudah?**  
→ **Sebelum project** (proposal untuk client) + **update sesudah** kickoff meeting (scope refinement)

---

### 2. PRD (Product Requirements Document)

**Audience:** PM, Engineer, Designer, QA  
**Kapan buat:** Sebelum sprint development  
**Tujuan:** Detail fitur, user perspective, acceptance criteria

**Isinya:**
- **User story:** Format "As a [role], I want [feature], so that [benefit]"
- **Feature list:** Prioritas dengan MoSCoW (Must, Should, Could, Won't)
- **Acceptance criteria:** Kapan feature dianggap DONE
- **User flow:** Step-by-step dari perspective user
- **Wireframe/mockup:** Visual reference (especially frontend)
- **Edge case:** Error scenario, boundary condition
- **Non-functional req:** Performance target, security requirement, accessibility
- **Dependency:** External system, pre-requisite feature

**Contoh Brajakara PDAM — Alert Feature:**
```
# PRD — Alert System PDAM

## User Story 1 (Must)
As an operator PDAM, 
I want to receive alert when sensor offline,
So that I can restart logger within 15 minutes

Acceptance Criteria:
- Alert triggered <5 min setelah data stop
- Alert dikirim via Telegram + email (simultaneously)
- Alert include: station name, last data timestamp, sensor type, alert reason
- Alert message readable + actionable (not cryptic)
- Alert do not duplicate (if already in critical state, suppress <1 jam next alert)

User flow:
1. Sensor stop send data (e.g., network issue, power loss, logger crash)
2. Django check_data run setiap 5 min
3. Detect data gap >20 min = SUSPECT state
4. 2-cycle confirm (10 min double-check)
5. Confirm = MISSING state → generate alert
6. Redis state machine persist state
7. Telegram bot send message
8. Operator receive notification on phone
9. Operator click alert link → navigate dashboard to station detail
10. Operator manually restart logger / Diagnose issue

Edge case:
- Network latency >20 min (common di rural area): do not trigger alert, put in SUSPECT (log but no notif)
- Multiple sensor down in same station: 1 aggregated alert, not 5x
- Alert during quiet hours (22:00-06:00): buffer WARNING, but send CRITICAL real-time
- Redis down: fallback in-memory queue, send when Redis up (graceful degradation)

Non-functional:
- Alert latency: <5 min p95
- Telegram delivery: 99%+ (Telegram reliability)
- Dedup performance: <100ms per check

## User Story 2 (Should)
As an operator PDAM,
I want to mute alert untuk 1 jam,
So that I can debug issue tanpa notification spam

Acceptance Criteria:
- Mute action: click button pada alert card
- Mute duration: pre-set 1h, 4h, 24h (no custom)
- Mute effect: Telegram stop, but still log to DB
- After mute expire: resume alert (auto, no action needed)
- Unmute early: operator can click to resume immediate

Edge case:
- Mute > 2 jam: escalate to supervisor (warning log)
- Mute during actual ongoing issue: still log (audit trail)
```

**Bikin sebelum atau sesudah?**  
→ **Sebelum code** (outline sketch) + **refine sesudah** sprint planning (detail per engineer assignment)

---

### 3. SRS (Software Requirements Specification)

**Audience:** Engineer, Tech Lead, Code reviewer  
**Kapan buat:** Sebelum implementation (outline) + Sesudah (final, most accurate)  
**Tujuan:** Spec teknis exact, reference untuk implementasi + review

**Isinya:**
- **Functional requirement:** Apa system harus lakukan (step-by-step execution flow)
- **Non-functional requirement:** Performance, security, scalability, reliability
  - Latency: p50, p95, p99
  - Throughput: requests/sec, concurrent connection
  - Uptime/availability: SLA percentage
  - Data security: encryption, PII handling
  - Scalability: horizontal vs vertical, max load
- **Data model:** Entity-relationship, field definition, constraint, index
- **API specification:** Endpoint list, method, path param, query param, request body, response format (status code, JSON schema)
- **Algorithm/Business logic:** Step-by-step flow, state transition, calculation (e.g., ARIMA forecast, anomaly detection threshold)
- **Error handling:** Error code list, retry policy, fallback behavior
- **Integration point:** External system, protocol, API contract
- **Backward compatibility:** Migration plan, version compatibility
- **Deployment requirement:** Environment variable, configuration file, secret management
- **Testing requirement:** Unit test, integration test, E2E test scenario

**Contoh Brajakara PDAM — SRS Alert System:**

```
# SRS — Alert System PDAM_SBY

## 1. Functional Requirement

### 1.1 Alert Detection & State Machine
System monitor sensor data setiap 5 menit via check_data Django task.

State machine:
  OK (data normal, timestamp fresh)
  → SUSPECT (lagging 20-40 min, network issue suspected)
    → MISSING (lagging >40 min, sensor considered offline)
      → CRITICAL (missing >2 jam, escalate)
  → OK (data resume, timestamp fresh)

Transition rule:
- OK → SUSPECT: last_data_timestamp < now - 20 min (1st check)
- SUSPECT → MISSING: confirm 2-cycle (10 min delay), if still lagging → MISSING
- MISSING → CRITICAL: missing > 2 jam (7200 sec)
- Any → OK: new data received, timestamp recent

Alert trigger:
- SUSPECT → MISSING: generate WARNING alert (log only, no Telegram unless quiet hour end)
- MISSING → CRITICAL: generate CRITICAL alert (Telegram real-time)
- Multiple same station MISSING: 1 OUTAGE alert (not 5x)

Aggregation rule (OUTAGE):
- If ≥5 station in sama balai MISSING: group into 1 OUTAGE alert
- Format: "OUTAGE Balai Waru: 5 sensor offline (timestamp list)"

### 1.2 Alert Delivery
Channel: Telegram + Email (async, queue-based)
Format Telegram:
```
🚨 ALERT: Sensor Offline
Station: Balai Waru
Type: Flow Meter #01
Last data: 2026-05-08 10:30:00
Reason: No data for 45 minutes
Action: Restart logger / Check network
[Mute 1h] [Mute 4h] [Mute 24h] [Ack]
```

Format Email:
```
Subject: [CRITICAL] Sensor Offline — Balai Waru
From: alerts@brajakara.tech
To: operator@pdam.go.id, supervisor@pdam.go.id

Alert details...
```

### 1.3 Alert Mute
Operator bisa mute alert untuk 1-24 jam via Telegram button atau dashboard.

Mute effect:
- Telegram notification suppress
- Email suppress
- Alert state still persist di DB (for audit)
- When mute expire: resume normal alert (auto, no action)

API: POST /api/alerts/{alert_id}/mute
  { "duration_hour": 1 }
Response: { "muted_until": "2026-05-08T11:30:00Z" }

### 1.4 Alert History & Dashboard
GET /api/alerts/?station_id=1&limit=50&offset=0&date_from=2026-05-01

Response:
```json
{
  "results": [
    {
      "id": "uuid-1",
      "station": { "id": 1, "name": "Balai Waru", "balai": "Waru" },
      "type": "MISSING",
      "state": "CRITICAL",
      "sensor": { "id": 101, "name": "Flow Meter #01", "unit": "m³" },
      "first_seen": "2026-05-08T10:30:00Z",
      "last_seen": "2026-05-08T10:35:00Z",
      "muted_until": null,
      "resolve_action": "logger restart OK",
      "resolve_timestamp": "2026-05-08T10:45:00Z"
    }
  ],
  "count": 150,
  "next": "/api/alerts/?offset=50"
}
```

## 2. Non-Functional Requirement

### 2.1 Performance
- Check data task: <1 sec per 50 station (batch)
- Alert generation latency: <5 min p95 (dari data stop → Telegram send)
- API /alerts/ response: <200ms p95
- Telegram batch send: 100 alert <5 sec
- Dashboard load: <2 sec (p95)

### 2.2 Scalability
- Support 50-100 sensor concurrent monitoring (current MVP)
- Future scale: 500+ sensor → upgrade Redis cluster, PostgreSQL read replica
- Concurrent Telegram connection: <30 (queue-based, not concurrent)
- Concurrent dashboard user: <10

### 2.3 Security
- Authentication: Bearer token (JWT, 24h expiry)
- Authorization: operator role → can mute own station, cannot access other balai
- Encryption: HTTPS for API, encrypt PII (operator name, phone) at rest
- Telegram bot token: store in Redis/env (never commit)
- Alert detail: do not expose internal metric (e.g., raw sensor value) to external user
- Rate limit: 100 request/min per IP (prevent DoS)

### 2.4 Reliability
- Uptime target: 99.9% (43 min downtime/bulan)
- Alert delivery: 99%+ Telegram success (Telegram API reliability)
- State persistence: Redis + PostgreSQL (dual write for critical state)
- Fallback: if Redis down → in-memory queue, send when Redis up (acceptable delay <1 jam)
- Graceful degradation: if Telegram API down → email fallback

### 2.5 Maintainability
- Logging: structured log (JSON), log level DEBUG/INFO/WARNING/ERROR
- Monitoring: Prometheus metrics (alert_latency, alert_count, state_transition)
- Code comment: document state machine transition, edge case handling
- Configuration: all param dalam .env (lag threshold, window, quiet hour, etc)

## 3. Data Model

```
Table: alert
  id: UUID primary key
  station_id: FK to station
  sensor_id: FK to sensor
  type: ENUM(MISSING, THRESHOLD, VOLTASE_TURUN, KUBIKASI_MINUS)
  state: ENUM(OK, SUSPECT, MISSING, CRITICAL)
  first_seen: Timestamp (when state transition to this state)
  last_seen: Timestamp (last time checked)
  last_data_timestamp: Timestamp (dari sensor, when last data received)
  muted_until: Timestamp nullable (when mute expire)
  is_active: Boolean (soft delete)
  created_at: Timestamp
  updated_at: Timestamp
  
  Index: (station_id, created_at DESC) for dashboard query
  Index: (state, last_seen) for background task query

Table: alert_history (audit trail)
  id: UUID primary key
  alert_id: FK to alert
  prev_state: ENUM
  next_state: ENUM
  reason: VARCHAR (e.g., "data received", "2-cycle confirm")
  triggered_by: VARCHAR (system/operator)
  timestamp: Timestamp
```

## 4. API Specification (OpenAPI format)

### 4.1 List Alert
```
GET /api/alerts/?station_id=1&state=CRITICAL&limit=50&offset=0

Query param:
  - station_id: integer (optional, filter by station)
  - state: ENUM optional (filter by state: OK, SUSPECT, MISSING, CRITICAL)
  - limit: integer, default 50, max 100
  - offset: integer, default 0
  - date_from: ISO 8601 (optional)
  - date_to: ISO 8601 (optional)

Response 200:
  Content-Type: application/json
  {
    "results": [ alert object ],
    "count": 150,
    "next": "/api/alerts/?offset=50"
  }

Response 401: Unauthorized (invalid token)
Response 403: Forbidden (operator cannot access other balai)
```

### 4.2 Mute Alert
```
POST /api/alerts/{alert_id}/mute
Authorization: Bearer <token>
Content-Type: application/json

Request body:
  {
    "duration_hour": 1  // 1, 4, or 24
  }

Response 200:
  {
    "id": "uuid-1",
    "muted_until": "2026-05-08T11:30:00Z",
    "muted_by": "operator@pdam.go.id"
  }

Response 400: Bad request (invalid duration)
Response 404: Alert not found
Response 409: Already muted
```

## 5. Error Handling

| Error Code | HTTP Status | Reason | Action |
|---|---|---|---|
| `INVALID_DURATION` | 400 | Duration not in [1h, 4h, 24h] | Return error, prompt user |
| `ALERT_NOT_FOUND` | 404 | Alert ID invalid | Return 404 |
| `UNAUTHORIZED` | 401 | Token invalid/expired | Redirect to login |
| `FORBIDDEN` | 403 | Operator cannot access other balai | Return 403, log |
| `REDIS_TIMEOUT` | 500 | Redis connection timeout | Fallback in-memory, return 500 dengan retry-after header |
| `TELEGRAM_RATE_LIMIT` | 429 | Telegram API rate limit | Queue + exponential backoff, don't fail |
| `DB_CONSTRAINT_VIOLATION` | 409 | Unique constraint or FK error | Log, return generic error |

## 6. Integration Point

### 6.1 Telegram Bot API
- Endpoint: `https://api.telegram.org/bot<TOKEN>/sendMessage`
- Method: POST
- Rate limit: 30 msg/sec (Telegram official)
- Retry: exponential backoff (1s, 2s, 4s, 8s)
- Timeout: 10s

### 6.2 Django Signal (post_save)
- Trigger: post_save station / sensor
- Action: invalidate cache, trigger check_data task if config change
- Latency: <1ms (in-process)

## 7. Configuration (Environment Variable)

```
# .env
ALERT_MISSING_WINDOW_MIN=20          # lag threshold untuk detect SUSPECT
ALERT_CRITICAL_THRESHOLD_MIN=120     # lag untuk escalate to CRITICAL
ALERT_CHECK_INTERVAL_SEC=300         # check_data task interval (5 min)
ALERT_2CYCLE_CONFIRM_SEC=600         # confirmation window (10 min)

TELEGRAM_BOT_TOKEN=<secret>
TELEGRAM_CHAT_ID_OPERATOR=-1001234567890
TELEGRAM_RATE_LIMIT_PER_SEC=30
TELEGRAM_QUIET_HOUR_START=22
TELEGRAM_QUIET_HOUR_END=6

REDIS_URL=redis://redis:6379/0
REDIS_FALLBACK_TTL_SEC=3600          # in-memory fallback timeout

ALERT_AGGREGATION_THRESHOLD=5        # ≥5 station = OUTAGE alert
ALERT_OUTAGE_MIN_DURATION=10         # min duration untuk output alert (10 min)
```

## 8. Testing Requirement

### 8.1 Unit Test
- State machine transition: 8 test case (OK→SUSPECT, SUSPECT→MISSING, etc)
- Alert generation: happy path + edge case (null, boundary)
- Telegram format: message length, special character escape

### 8.2 Integration Test
- E2E alert flow: simulate sensor data stop → detect MISSING → send Telegram
- Mute flow: mute alert → suppress Telegram → unmute → resume
- Redis fallback: stop Redis → check state persist in-memory → resume Redis

### 8.3 Load Test
- 50 sensor, check_data run 5min interval: measure latency, memory usage
- Concurrent alert generation: 50 alert/cycle, measure Telegram batch throughput

### 8.4 Smoke Test (Production)
- Endpoint healthy check: /health/ → 200
- Alert test: manual trigger alert → verify Telegram + email deliver
- Rollback plan: alert module rollback <5 min
```

**Bikin sebelum atau sesudah?**  
→ **Sebelum code** (outline, high-level) → **Sesudah code** (final, detailed reference) — **paling akurat**

---

### 4. TDD (Test-Driven Development Doc)

**Audience:** Engineer (QA + dev)  
**Kapan buat:** Sebelum code (opsional tapi recommended)  
**Tujuan:** Define test case sebelum implement, red-green-refactor workflow

**Isinya:**
- **Test case list:** Input → expected output (organized by scenario)
- **Edge case coverage:** Null, empty, boundary, negative, exception
- **Performance test:** Load test, stress test spec, max load define
- **Integration test:** Multi-component flow, dependency mock

**Contoh Brajakara PDAM — TDD Alert State Machine:**

```
# TDD — Alert State Machine

## Test Case 1: OK → SUSPECT (lagging 20-40 min)

Test: detect_suspect_state
  Given: station last_data_timestamp = now - 25 min
  When: check_data run
  Then: alert.state = SUSPECT
  And: alert.first_seen = now
  And: NO Telegram send (suppress SUSPECT)

## Test Case 2: SUSPECT → OK (recover in window, data resume)

Test: recover_from_suspect
  Given: alert.state = SUSPECT, first_seen = now - 15 min
  When: new data received, timestamp = now - 5 min
  Then: alert.state = OK
  And: alert.last_seen = now
  And: Telegram send "✅ OK: Balai Waru online"

## Test Case 3: SUSPECT → MISSING (2-cycle confirm, still lagging)

Test: confirm_missing_2cycle
  Given: alert.state = SUSPECT, first_seen = now - 10 min
  When: check_data run setelah 10 min, data still lagging 40 min
  Then: alert.state = MISSING
  And: alert.last_seen = now
  And: Telegram send "⚠️ MISSING: Balai Waru offline"

## Test Case 4: MISSING → CRITICAL (missing >2 jam)

Test: escalate_critical
  Given: alert.state = MISSING, first_seen = now - 130 min
  When: check_data run
  Then: alert.state = CRITICAL
  And: Telegram send with @supervisor mention (escalate)

## Test Case 5: Redis down, fallback in-memory

Test: redis_down_fallback
  Given: Redis connection timeout
  When: check_data try to persist state
  Then: fallback in-memory queue
  And: queue persist to .json file
  And: when Redis up → drain queue to Redis
  And: API return 500 dengan Retry-After: 60

## Test Case 6: Multiple same station MISSING → aggregate OUTAGE

Test: outage_aggregation
  Given: 5 station dalam Balai Waru, all MISSING
  When: check_data detect
  Then: 1 OUTAGE alert (not 5x individual)
  And: Telegram message: "OUTAGE Balai Waru: 5 sensor offline"

## Test Case 7: Alert mute 1 hour

Test: mute_alert
  Given: alert.state = CRITICAL
  When: POST /api/alerts/{id}/mute { duration_hour: 1 }
  Then: alert.muted_until = now + 1 hour
  And: Telegram suppress (next cycle check_data, do not send)
  And: When 1 hour pass → resume alert (if still CRITICAL)

## Test Case 8: Quiet hour (22:00-06:00)

Test: quiet_hour_buffer
  Given: time = 23:00, alert type = WARNING
  When: check_data generate WARNING
  Then: alert suppress (buffer to DB)
  And: NO Telegram send
  When: time = 06:30 (next morning)
  Then: send buffered alert batch (or clear if resolved)

## Performance Test

Test: check_50_station_under_1sec
  Given: 50 sensor, data table 100K row
  When: check_data run full check
  Then: execution time < 1000 ms (p95)
  And: memory usage < 200 MB

Test: telegram_batch_100_alert_under_5sec
  Given: 100 alert ready to send
  When: send batch via Telegram API
  Then: all send < 5000 ms (p95)
  And: success rate > 99%

## Integration Test

Test: e2e_alert_flow_sensor_offline
  Given: running system, sensor#1 in Balai Waru
  When:
    1. Sensor stop send data (simulate network down)
    2. Wait 25 min
    3. check_data run → detect SUSPECT
    4. Wait 10 min
    5. check_data confirm → state MISSING
  Then:
    1. DB log both transition
    2. Telegram message deliver
    3. Operator receive notification
    4. Dashboard show alert in real-time (if WebSocket connected)
    5. Operator click mute 4h → suppress next cycle
    6. After 4h → resume alert (if still MISSING)
```

**Bikin sebelum atau sesudah?**  
→ **Sebelum code** (define test first) — TDD discipline, tapi optional di real project

---

### 5. Architecture Document

**Audience:** Tech Lead, Engineer, DevOps, Code reviewer  
**Kapan buat:** Sebelum design finalize (high-level sketch) + Sesudah (detailed with trade-off)  
**Tujuan:** High-level design, technology justification, risk assessment

**Isinya:**
- **System diagram:** Component, data flow, communication protocol
- **Technology stack:** Language, framework, database, cache, message queue (why each choice)
- **Trade-off analysis:** Latency vs reliability, complexity vs scaling, cost vs performance
- **Risk & mitigation:** Bottleneck, single point of failure, concurrency issue
- **Data flow:** Request path dari user → backend → external system
- **Deployment architecture:** Dev, UAT, prod environment
- **Scalability plan:** Horizontal vs vertical scaling, bottleneck when scale 10x

**Contoh Brajakara PDAM — Architecture Alert System:**

```
# Architecture Document — Alert System

## System Diagram (High-level)

```
Sensor (50+)
    ↓ (MQTT every 5 min)
MQTT Broker (rockbottom:1883)
    ↓ (Django consumer)
Django App (tower VM)
    ├→ PostgreSQL (state + audit log)
    ├→ Redis (alert state machine, cache)
    └→ Telegram Bot API
         ↓
    Operator phone (notification)
```

## Component Breakdown

### 1. Sensor & MQTT Broker
- 50+ sensor, each publish meter reading setiap 5 min
- MQTT topic: `pdam/balai/<balai_id>/station/<station_id>/data`
- Payload: JSON dengan timestamp, meter value, sensor status
- Broker: Mosquitto (rockbottom, internal network)

### 2. Django App (Core)
- Role: consume MQTT → check anomali → generate alert → send notification
- Task scheduler: Celery Beat (run check_data setiap 5 min)
- State machine: Redis (persistent state)
- DB: PostgreSQL (audit log, alert history)

**Subcomponent:**
- `check_data`: analyze sensor reading, detect anomali
- `alert_generator`: state transition logic, decide send alert
- `notification_handler`: Telegram + email integration
- `dashboard`: REST API untuk operator view alert

### 3. Redis (In-Memory State)
- Role: state machine persistence (OK, SUSPECT, MISSING, CRITICAL)
- Why Redis?
  - Fast read/write (<5ms)
  - TTL support (auto-expire mute duration)
  - Pub/Sub untuk distribute notification (future worker scale)
- Fallback: in-memory dict kalau Redis down (graceful degradation)

### 4. PostgreSQL (Persistent DB)
- Role: audit log, alert history, user configuration
- Schema: alert, alert_history, mute_log
- Backup: daily snapshot → S3

### 5. Telegram Bot API
- Role: send real-time notification
- Why Telegram?
  - Free, reliable (99%+ delivery)
  - Rich formatting (button, mention)
  - Operator already use (no new app to install)
- Rate limit: 30 msg/sec (acceptable untuk 50 sensor)

## Data Flow — Alert Trigger

```
Timestamp T0:
  Sensor publish data via MQTT
    ↓ (T0 + 1 min)
  Django consumer store to DB (dfm_data table)
    ↓ (T0 + 5 min)
  check_data Celery task run
    ├→ Query last data untuk setiap sensor
    ├→ Compare dengan threshold, lag window
    ├→ Calculate state transition
    ├→ Persist state to Redis
    ├→ If state change: call alert_generator
    └→ alert_generator decide send Telegram?
        ├→ Check mute_until (respect mute)
        ├→ Check quiet hour (suppress WARNING 22:00-06:00)
        ├→ Check aggregation (5+ station = 1 OUTAGE)
        └→ Queue Telegram batch
    ↓ (T0 + 5.5 min, batched)
  Send Telegram batch (100 alert → 5 sec max)
    ↓ (T0 + 10.5 min)
  Operator receive notification on phone
```

**Total latency T0 → Operator notification = 10.5 min (target <5 min p95)**

## Technology Justification

| Component | Choice | Why | Alternative Rejected |
|---|---|---|---|
| **Message broker** | MQTT | Lightweight, sensor native support | Kafka (overkill, heavy) |
| **Cache/State** | Redis | Fast, TTL, Pub/Sub support | Memcached (no Pub/Sub), in-memory only (not persistent) |
| **DB** | PostgreSQL | ACID, JSON support, mature | MySQL (less reliable), MongoDB (no transaction) |
| **Task scheduler** | Celery Beat | Django integration, distributed worker | APScheduler (not distributed), cron (hard to monitor) |
| **Notification** | Telegram | Free, reliable, operator familiar | SMS (cost), Email (slow, low engagement) |
| **API** | REST + Django | Familiar, mature | FastAPI (less ecosystem), GraphQL (overkill) |

## Trade-off Analysis

### 1. Latency vs Reliability
**Issue:** Alert latency target <5 min p95, but need 2-cycle confirm (10 min total)?
**Solution:** Confirm SUSPECT state async, do not block operator. SUSPECT alert log only, no Telegram. When confirmed → MISSING, send Telegram.
**Trade-off:** Slightly slower detection but higher accuracy (reduce false positive).

### 2. Complexity vs Scaling
**Issue:** State machine in Redis add complexity, but enable future worker scale?
**Solution:** Start with single Redis instance + simple in-memory fallback. When scale to 500+ sensor → Redis cluster + distributed worker.
**Trade-off:** Accept MVP complexity for future-proof design.

### 3. Alert Batch vs Real-time
**Issue:** Batch Telegram 100 alert → send every 1 min, vs real-time (immediate send)?
**Solution:** Real-time for CRITICAL, batch for WARNING.
**Trade-off:** Telegram rate limit + cost, vs operator notification overload.

## Risk & Mitigation

| Risk | Impact | Probability | Mitigation |
|---|---|---|---|
| **Redis down** | Alert state loss, miss detection | Medium | In-memory fallback queue, auto-restart Redis, alert + escalate |
| **Telegram API down** | Operator not receive notification | Low (Telegram reliable) | Email fallback, queue + retry when up |
| **MQTT broker down** | Data not received from sensor | Low (rockbottom monitored) | Healthcheck, auto-restart, manual data input fallback |
| **PostgreSQL disk full** | Audit log stop, alert corrupt | Low (auto-monitored) | Auto-truncate old log, alert if >80% usage |
| **Concurrent alert spam** | Telegram rate limit exceeded | Medium | Batch + queue, rate limiter, discard old if queue overflow |
| **Network latency 20+ min** | False SUSPECT/MISSING alert | Medium | Increase lag window, log but suppress Telegram |

## Scalability Plan

**Current MVP:** 50 sensor, 5 balai  
**Target 12 bulan:** 500+ sensor, 20+ balai

**Bottleneck analysis:**
1. **check_data latency:** Linear with sensor count
   - Current: 50 sensor → 0.5 sec
   - 500 sensor → 5 sec (need <1 sec)
   - **Solution:** Parallelize check via map-reduce (divide sensor by balai), or increase Celery worker count

2. **Telegram API rate limit:** 30 msg/sec max
   - Current: ~50 alert/day (~0.001 msg/sec)
   - 500 sensor: ~500 alert/day (~0.006 msg/sec) — still safe
   - 5000 sensor: ~5000 alert/day — approach limit
   - **Solution:** Aggregate alert per balai (not per sensor), batch send

3. **Redis memory:** State per sensor + mute record
   - Current: 50 sensor → ~500 KB
   - 500 sensor → 5 MB — still safe
   - **Solution:** Redis cluster when >100 MB

4. **PostgreSQL write:** Audit log insert every 5 min
   - Current: 50 state transition → 50 insert/5min
   - 500 sensor: 500 insert/5min — still safe
   - **Solution:** Batch insert instead of individual, or write replica

**Scaling strategy:**
- **Phase 1 (100 sensor):** Increase Celery worker from 2 → 4
- **Phase 2 (500 sensor):** Redis cluster + PostgreSQL read replica + aggregate alert
- **Phase 3 (1000+ sensor):** Full horizontal scale (Kubernetes)

## Deployment Architecture

### Dev Environment (tower VM)
- Django: localhost:8000
- PostgreSQL: tower:5432 (local)
- Redis: localhost:6379 (local)
- MQTT: rockbottom:1883

### UAT Environment (tower VM separate instance)
- Django: tower.uats.brajakara:8001
- PostgreSQL: tower:5432 (separate DB instance)
- Redis: tower:6379 (separate instance)
- MQTT: rockbottom:1883 (shared, separate topic prefix `pdam/test/`)

### Production Environment (tower VM)
- Django: tower.prod.brajakara (reverse proxy Nginx)
- PostgreSQL: tower:5432 (backup to S3 daily)
- Redis: tower:6379 (Redis Sentinel planned)
- MQTT: rockbottom:1883 (dedicated connection)

## Deployment Pipeline

```
git push → GitHub
  ↓
CI/CD trigger (GitHub Actions)
  ├→ Run test (unit + integration)
  ├→ Build Docker image
  ├→ Push to registry-ui.blitztechnology.tech
  └→ Trigger deploy job
    ├→ UAT: pull image → run test → notify team
    └→ Prod: wait manual approval → pull image → run smoke test → deploy

Rollback: <5 min (previous image tag)
```
```

**Bikin sebelum atau sesudah?**  
→ **Sebelum design finalize** (high-level sketch) → **Sesudah implementation** (detailed, with lessons learned)

---

### 6. API Reference (Auto-generated dari Code)

**Audience:** Backend engineer, Frontend engineer, Integration partner  
**Kapan buat:** Sesudah API jadi (extract dari code)  
**Tool:** Swagger/OpenAPI, Postman, ReDoc, Scalar  
**Tujuan:** Dokumentasi API endpoint, request/response format, error handling

**Isinya:**
- **Endpoint list:** HTTP method, path, query param, request body, response format
- **Authentication:** Bearer token, API key, session cookie
- **Status code:** 200, 400, 401, 403, 404, 500 + meaning
- **Rate limit:** Request/min, throttling policy
- **Example:** Real curl command, real JSON request/response
- **Error code:** Custom error identifier + message

**Contoh Brajakara PDAM — API Reference (OpenAPI format):**

```yaml
openapi: 3.0.0
info:
  title: PDAM Alert API
  version: 1.0.0
  description: Alert system API untuk monitoring sensor PDAM

servers:
  - url: https://api.pdam.brajakara.tech
    description: Production

paths:
  /api/alerts/:
    get:
      summary: List alerts
      description: Return alert list dengan filter
      tags: [Alert]
      parameters:
        - name: station_id
          in: query
          required: false
          schema:
            type: integer
          example: 1
        - name: state
          in: query
          required: false
          schema:
            type: string
            enum: [OK, SUSPECT, MISSING, CRITICAL]
          example: CRITICAL
        - name: limit
          in: query
          required: false
          schema:
            type: integer
            default: 50
            maximum: 100
        - name: offset
          in: query
          required: false
          schema:
            type: integer
            default: 0
      responses:
        200:
          description: Alert list OK
          content:
            application/json:
              schema:
                type: object
                properties:
                  results:
                    type: array
                    items:
                      $ref: '#/components/schemas/Alert'
                  count:
                    type: integer
                    example: 150
                  next:
                    type: string
                    nullable: true
                    example: "/api/alerts/?offset=50"
              example:
                results:
                  - id: "550e8400-e29b-41d4-a716-446655440000"
                    station:
                      id: 1
                      name: "Balai Waru"
                      balai: "Waru"
                    type: "MISSING"
                    state: "CRITICAL"
                    sensor:
                      id: 101
                      name: "Flow Meter #01"
                      unit: "m³"
                    first_seen: "2026-05-08T10:30:00Z"
                    last_seen: "2026-05-08T10:35:00Z"
                    muted_until: null
                count: 150
                next: "/api/alerts/?offset=50"
        401:
          $ref: '#/components/responses/Unauthorized'
        403:
          $ref: '#/components/responses/Forbidden'

  /api/alerts/{alert_id}/mute:
    post:
      summary: Mute alert
      description: Mute alert untuk duration tertentu
      tags: [Alert]
      parameters:
        - name: alert_id
          in: path
          required: true
          schema:
            type: string
            format: uuid
          example: "550e8400-e29b-41d4-a716-446655440000"
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required: [duration_hour]
              properties:
                duration_hour:
                  type: integer
                  enum: [1, 4, 24]
                  example: 1
      responses:
        200:
          description: Mute success
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Alert'
        400:
          description: Invalid duration
          content:
            application/json:
              example:
                error: "INVALID_DURATION"
                message: "Duration must be 1, 4, or 24 hours"
        404:
          $ref: '#/components/responses/NotFound'
        409:
          description: Alert already muted
          content:
            application/json:
              example:
                error: "ALREADY_MUTED"
                message: "Alert already muted until 2026-05-08T11:30:00Z"

components:
  schemas:
    Alert:
      type: object
      properties:
        id:
          type: string
          format: uuid
        station:
          type: object
          properties:
            id:
              type: integer
            name:
              type: string
            balai:
              type: string
        type:
          type: string
          enum: [MISSING, THRESHOLD, VOLTASE_TURUN, KUBIKASI_MINUS]
        state:
          type: string
          enum: [OK, SUSPECT, MISSING, CRITICAL]
        first_seen:
          type: string
          format: date-time
        last_seen:
          type: string
          format: date-time
        muted_until:
          type: string
          format: date-time
          nullable: true
        resolve_action:
          type: string
          nullable: true
        resolve_timestamp:
          type: string
          format: date-time
          nullable: true

  responses:
    Unauthorized:
      description: Missing or invalid authentication token
      content:
        application/json:
          example:
            error: "UNAUTHORIZED"
            message: "Invalid or expired token"
    Forbidden:
      description: Insufficient permission
      content:
        application/json:
          example:
            error: "FORBIDDEN"
            message: "Cannot access other balai data"
    NotFound:
      description: Resource not found
      content:
        application/json:
          example:
            error: "NOT_FOUND"
            message: "Alert not found"

  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
      description: "Format: Bearer <token>"

security:
  - BearerAuth: []
```

**Contoh curl:**
```bash
# Get alert list
curl -H "Authorization: Bearer <token>" \
  "https://api.pdam.brajakara.tech/api/alerts/?state=CRITICAL&limit=10"

# Mute alert
curl -X POST -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"duration_hour": 1}' \
  "https://api.pdam.brajakara.tech/api/alerts/550e8400-e29b-41d4-a716-446655440000/mute"
```

**Bikin sebelum atau sesudah?**  
→ **Sesudah API jadi** (extract dari code, paling akurat)

---

### 7. User Manual

**Audience:** End user (operator PDAM, manager, customer)  
**Kapan buat:** Sesudah app siap prod + UAT pass  
**Tool:** Markdown, PDF, HTML wiki  
**Tujuan:** Operator onboarding, feature walkthrough, troubleshoot

**Isinya:**
- **Getting started:** Cara login, first-time setup
- **Feature walkthrough:** Step-by-step dengan screenshot
- **Common task:** How to mute alert, check history, export report
- **FAQ:** Frequent question + answer
- **Troubleshoot:** Common error + solution
- **Glossary:** Term yang unfamiliar untuk operator (lagging, ARIMA, kubikasi, voltase)

**Contoh Brajakara PDAM — User Manual (Bahasa Indonesia):**

```markdown
# User Manual — Sistem Alert PDAM Surabaya

## Mulai Cepat

### Login
1. Buka browser → ketik `https://pdam.brajakara.tech`
2. Username: operator ID (e.g., `op_waru_001`)
3. Password: password yang diberikan tim IT
4. Click "Login"

Jika lupa password, hubungi IT: `it@pdam.go.id`

### Dashboard Pertama
Setelah login, Anda lihat:
- **Kotak atas:** Summary (5 sensor offline, 2 warning, 0 kritis)
- **Tengah:** Peta balai dengan indicator status (hijau=OK, kuning=warning, merah=offline)
- **Bawah:** Tabel alert terbaru

## Fitur — Monitoring Sensor

### Lihat Status Real-time
1. Go to menu "Dashboard"
2. Pilih balai: dropdown "Pilih Balai"
3. Click balai → lihat 5-10 sensor list
4. Lihat status tiap sensor:
   - **Hijau (OK):** Data normal, dapat diterima
   - **Kuning (Warning):** Data lagging, perlu dimonitor
   - **Merah (Offline):** Data tidak diterima >40 menit

### Contoh Status
```
Sensor #01 (Flow Meter)
Status: 🔴 OFFLINE
Last data: 10:30 AM (45 menit lalu)
Value: 125.5 m³
Action button: [Restart Logger] [Diagnose]
```

## Fitur — Alert & Notifikasi

### Receive Alert di Telegram
Setiap kali sensor offline, Anda dapat notifikasi Telegram:

```
🚨 ALERT: Sensor Offline
Station: Balai Waru
Type: Flow Meter #01
Last data: 2026-05-08 10:30:00
⏱ No data for 45 minutes

[Mute 1h] [Mute 4h] [Mute 24h] [Acknowledge]
```

Click button untuk action cepat.

### Mute Alert (Tidak Terima Notifikasi)
Jika sedang memperbaiki sensor dan tidak mau notifikasi spam:

1. Click alert card di dashboard → opsi "Mute"
2. Atau click button "Mute 1h" langsung di Telegram message
3. Pilih duration: 1 jam, 4 jam, atau 24 jam
4. Setelah waktu habis, alert resume otomatis

**Catatan:** Alert tetap dicatat di database (audit trail), hanya notifikasi yang dihentikan.

### Check Alert History
1. Go to menu "Alert History"
2. Filter:
   - Date range: pick tanggal (default hari ini)
   - Balai: pilih balai
   - Status: OK, Warning, Offline
3. Lihat tabel alert dengan:
   - Waktu alert pertama kali muncul
   - Waktu data terakhir diterima
   - Action yang dilakukan (mute, restart, etc)
   - Resolved: kapan sensor kembali online

### Export Report
1. Go to "Alert History"
2. Filter sesuai kebutuhan
3. Click "Export CSV" atau "Export PDF"
4. File download ke computer Anda

## FAQ (Pertanyaan Umum)

### Q: Kenapa sensor saya status "Warning" terus?

**A:** Status warning berarti data lagging (terlambat). Kemungkinan penyebab:
1. **Network problem:** Cek kabel internet logger, restart router
2. **Logger hang:** Power cycle logger (off 10 detik, on lagi)
3. **MQTT broker down:** Hubungi IT untuk diagnose rockbottom server

Biasanya 15-20 menit perbaikan, data resume normal.

### Q: Alert terus masuk Telegram, gimana?

**A:** Click "Mute 4h" di Telegram message atau dashboard. Sambil itu, coba:
1. Cek fisik sensor: kabel, power, LCD display
2. Restart logger (off-on)
3. Jika masih offline setelah 30 menit, escalate ke IT

### Q: Bisakah ganti notifikasi ke Email?

**A:** Sekarang alert hanya via Telegram. Plan phase 2 ada email notif. Hubungi PM untuk request fitur tambahan.

### Q: Data tidak cocok dengan meter fisik, apa yang salah?

**A:** Kemungkinan:
1. **Logger perlu kalibrasi:** Contact sensor vendor
2. **Data corrupt:** IT akan reset data logger
3. **Reset meter:** Jika ada perbaikan meter manual

Hubungi IT + technical lead untuk diagnose lebih lanjut.

### Q: Berapa lama data simpan di sistem?

**A:** Alert history simpan seumur hidup. Dashboard menampilkan last 30 hari. History lama bisa export jika perlu laporan audit.

## Glossary

| Term | Arti | Contoh |
|---|---|---|
| **Status OK** | Sensor kirim data normal setiap 5 menit | Flow Meter #01 upload 125.5 m³ |
| **Lagging/Warning** | Data terlambat (>20 menit sejak upload terakhir) | Last data: 10:30 AM, sekarang 10:55 AM |
| **Offline/MISSING** | Sensor tidak kirim data >40 menit | Sensor tidak respond sama sekali |
| **CRITICAL** | Offline >2 jam, escalate ke supervisor | Escalation via Telegram mention @supervisor |
| **Kubikasi** | Volume air dalam m³ (cubic meter) | 125.5 m³ = 125,500 liter |
| **Voltase** | Voltage power supply logger | Normal 12V, warning jika <10V |
| **MQTT** | Protokol komunikasi sensor ke server | Teknologi di balik sensor publish data |
| **Mute** | Suppress notifikasi alert (data tetap tercatat) | Mute 4 jam → no Telegram 4 jam, resume otomatis |

## Troubleshoot

### Alert tidak datang ke Telegram
1. Cek setting Telegram: apakah follow bot `@suryasembadabot`?
2. Cek Telegram notification enable (phone setting → app notification)
3. Cek internet connection Telegram
4. Jika masih tidak, hubungi IT

### Dashboard load lambat
1. Clear browser cache (Ctrl+Shift+Delete)
2. Refresh page (Ctrl+R atau F5)
3. Coba browser lain (Chrome, Firefox)
4. Jika masih lambat, hubungi IT

### Lupa password
1. Click "Forget Password" di login page
2. Input username
3. Check email untuk reset link (biasanya 5-10 menit)
4. Click link, set password baru
5. Login lagi

Jika email tidak datang dalam 15 menit, hubungi IT.

## Contact & Support

| Issue | Contact | Channel |
|---|---|---|
| Alert/sensor technical | IT Brajakara | Telegram: @brajakara-it |
| Feature request | PM | Email: pm@brajakara.tech |
| Training/onboarding | Team lead | Wa: +62xxx |
| Emergency (sensor critical) | Supervisor | Phone: +62xxx |

## Update & Changelog

**v1.0 (2026-05-08)**
- Alert system launch (MISSING, THRESHOLD, VOLTASE, KUBIKASI)
- Telegram + email notification
- Mute alert feature
- Alert history + export

**v1.1 (planned Q3 2026)**
- Mobile app (iOS, Android)
- Email scheduling
- SMS notification
- Advanced report (daily, weekly, monthly)
```

**Bikin sebelum atau sesudah?**  
→ **Sesudah app siap prod** (UAT pass, feature stable)

---

### 8. Deployment Guide

**Audience:** DevOps, Release manager, System admin, on-call engineer  
**Kapan buat:** Sesudah codebase mature + ready production  
**Tool:** Markdown, shell script, runbook  
**Tujuan:** Operator reproduce setup, maintain system, disaster recovery

**Isinya:**
- **Infrastructure spec:** CPU, RAM, disk, network requirement
- **Prerequisites:** Tools, library, account yang diperlukan
- **Installation step:** Clone, env setup, build, migrate, run
- **Configuration:** Environment variable, config file, secret management
- **Backup & disaster recovery:** Backup strategy, restore procedure
- **Monitoring & alerting:** Healthcheck, log location, metric, alert rule
- **Troubleshoot:** Common error, fix, log location untuk debug
- **Rollback:** Procedure revert to previous version
- **Upgrade:** Procedure patch, minor, major version

**Contoh Brajakara PDAM — Deployment Guide:**

```markdown
# Deployment Guide — Alert System PDAM_SBY

## Infrastructure Requirement

### Compute
- VM: 2 CPU core, 4GB RAM, 50GB disk minimum
- OS: Ubuntu 20.04 LTS or later
- Network: Inbound 443 (HTTPS), 1883 (MQTT internal), Outbound 443 (Telegram API)

### Database
- PostgreSQL 13+: dedicated instance atau same VM
  - Storage: 10GB min (auto-grow)
  - Backup: daily snapshot (S3 or cloud storage)
- Redis 6+: same VM atau dedicated (fallback in-memory jika down)

### Monitoring
- Prometheus (optional, untuk metrics collection)
- ELK stack (optional, untuk centralized logging)

---

## Installation (Fresh Setup)

### 1. Prerequisites
```bash
# Ubuntu/Debian
apt-get update
apt-get install -y \
  python3.9 python3.9-venv python3-pip \
  postgresql-13 postgresql-client \
  redis-server \
  docker docker.io docker-compose \
  git curl wget

# Verify versions
python3 --version  # Python 3.9+
psql --version     # PostgreSQL 13+
redis-cli --version # Redis 6+
docker --version
```

### 2. Clone Repository
```bash
cd /opt
git clone https://github.com/brajakara/pdam-alert.git
cd pdam-alert
git checkout main
```

### 3. Environment Setup
```bash
# Copy env template
cp .env.example .env

# Edit .env (sensitive data!)
# Do NOT commit .env to git
nano .env
```

**Content .env (important field):**
```
DEBUG=False
ENVIRONMENT=production

# Database
DATABASE_URL=postgresql://pdam_user:PASSWORD@localhost:5432/pdam_alert
# Create user + database:
# $ sudo -u postgres psql
# psql> CREATE USER pdam_user WITH PASSWORD 'PASSWORD';
# psql> CREATE DATABASE pdam_alert OWNER pdam_user;

# Redis
REDIS_URL=redis://localhost:6379/0

# Telegram Bot
TELEGRAM_BOT_TOKEN=<get from @botfather>
TELEGRAM_CHAT_ID_OPERATOR=-1001234567890
TELEGRAM_RATE_LIMIT_PER_SEC=30

# Alert config
ALERT_MISSING_WINDOW_MIN=20
ALERT_CRITICAL_THRESHOLD_MIN=120
ALERT_CHECK_INTERVAL_SEC=300
ALERT_2CYCLE_CONFIRM_SEC=600

# Email (optional)
EMAIL_BACKEND=django.core.mail.backends.smtp.EmailBackend
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=<email>
EMAIL_HOST_PASSWORD=<app_password>

# Security
ALLOWED_HOSTS=pdam.brajakara.tech,pdam-test.brajakara.tech
SECRET_KEY=<generate: python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())">
```

### 4. Build & Install Python Dependencies
```bash
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn
```

### 5. Database Migration
```bash
source venv/bin/activate
python manage.py migrate
python manage.py createsuperuser  # Create admin user
```

### 6. Collect Static Files (if using Django static)
```bash
python manage.py collectstatic --noinput
```

### 7. Test Local (optional)
```bash
source venv/bin/activate
python manage.py runserver 0.0.0.0:8000

# In another terminal
curl http://localhost:8000/health/
# Expected: 200 OK
```

### 8. Setup Systemd Service
```bash
# Create systemd service file
sudo tee /etc/systemd/system/pdam-alert.service > /dev/null <<EOF
[Unit]
Description=PDAM Alert Django Application
After=network.target postgresql.service redis.service

[Service]
Type=notify
User=pdam
WorkingDirectory=/opt/pdam-alert
ExecStart=/opt/pdam-alert/venv/bin/gunicorn \
  --workers 4 \
  --bind 127.0.0.1:8000 \
  --timeout 60 \
  --access-logfile /var/log/pdam-alert/access.log \
  --error-logfile /var/log/pdam-alert/error.log \
  config.wsgi:application

Environment="PATH=/opt/pdam-alert/venv/bin"
Environment="ENVIRONMENT=production"
EnvironmentFile=/opt/pdam-alert/.env

Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Create log directory
sudo mkdir -p /var/log/pdam-alert
sudo chown pdam:pdam /var/log/pdam-alert

# Create pdam user if not exist
sudo useradd -m -s /bin/bash pdam

# Enable & start service
sudo systemctl daemon-reload
sudo systemctl enable pdam-alert
sudo systemctl start pdam-alert
```

### 9. Setup Celery Beat (for periodic check_data task)
```bash
# Create systemd service for Celery Beat
sudo tee /etc/systemd/system/pdam-celery-beat.service > /dev/null <<EOF
[Unit]
Description=PDAM Alert Celery Beat Scheduler
After=network.target redis.service

[Service]
Type=simple
User=pdam
WorkingDirectory=/opt/pdam-alert
ExecStart=/opt/pdam-alert/venv/bin/celery -A config beat \
  --loglevel=info \
  --logfile=/var/log/pdam-alert/celery-beat.log \
  --scheduler django_celery_beat.schedulers:DatabaseScheduler

EnvironmentFile=/opt/pdam-alert/.env
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Also create Celery Worker
sudo tee /etc/systemd/system/pdam-celery-worker.service > /dev/null <<EOF
[Unit]
Description=PDAM Alert Celery Worker
After=network.target redis.service

[Service]
Type=simple
User=pdam
WorkingDirectory=/opt/pdam-alert
ExecStart=/opt/pdam-alert/venv/bin/celery -A config worker \
  --loglevel=info \
  --logfile=/var/log/pdam-alert/celery-worker.log \
  --concurrency=2

EnvironmentFile=/opt/pdam-alert/.env
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable pdam-celery-beat pdam-celery-worker
sudo systemctl start pdam-celery-beat pdam-celery-worker
```

### 10. Setup Nginx Reverse Proxy
```bash
sudo tee /etc/nginx/sites-available/pdam-alert > /dev/null <<EOF
server {
    listen 443 ssl http2;
    server_name pdam.brajakara.tech;

    ssl_certificate /etc/letsencrypt/live/pdam.brajakara.tech/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/pdam.brajakara.tech/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }

    location /ws/ {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_read_timeout 86400;
    }

    location /static/ {
        alias /opt/pdam-alert/static/;
        expires 1d;
        add_header Cache-Control "public, immutable";
    }
}

# Redirect HTTP to HTTPS
server {
    listen 80;
    server_name pdam.brajakara.tech;
    return 301 https://\$server_name\$request_uri;
}
EOF

# Enable site
sudo ln -s /etc/nginx/sites-available/pdam-alert /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

---

## Verification (Smoke Test)

```bash
# Check service status
sudo systemctl status pdam-alert
sudo systemctl status pdam-celery-beat
sudo systemctl status pdam-celery-worker

# Check health endpoint
curl -k https://pdam.brajakara.tech/health/
# Expected: {"status": "healthy", "database": "ok", "redis": "ok"}

# Check API
curl -k https://pdam.brajakara.tech/api/alerts/?limit=5 \
  -H "Authorization: Bearer <token>"

# Check logs
tail -f /var/log/pdam-alert/error.log
tail -f /var/log/pdam-alert/celery-worker.log

# Test Telegram notification (manual)
# Edit check_data test to trigger alert
```

---

## Configuration & Secrets

### Environment Variable List

| Variable | Purpose | Example |
|---|---|---|
| `DEBUG` | Enable debug mode (NEVER True di prod) | `False` |
| `DATABASE_URL` | PostgreSQL connection string | `postgresql://user:pass@host:5432/db` |
| `REDIS_URL` | Redis connection string | `redis://localhost:6379/0` |
| `TELEGRAM_BOT_TOKEN` | Telegram bot token (secret!) | `123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11` |
| `ALERT_MISSING_WINDOW_MIN` | Lag threshold untuk SUSPECT | `20` |
| `ALERT_CRITICAL_THRESHOLD_MIN` | Lag threshold untuk CRITICAL | `120` |

### Secret Management

**❌ NEVER:**
```bash
# Don't do this!
export TELEGRAM_BOT_TOKEN="token-in-plaintext"
git add .env  # Exposed!
```

**✅ DO:**
```bash
# 1. .env file in .gitignore
echo ".env" >> .gitignore
echo ".env.local" >> .gitignore
git add .gitignore
git commit

# 2. .env.example (template only, no secrets)
cat > .env.example <<EOF
DEBUG=False
DATABASE_URL=postgresql://user:pass@host/db
TELEGRAM_BOT_TOKEN=<YOUR_TOKEN_HERE>
EOF
git add .env.example
git commit

# 3. In production, load secret dari:
# - Environment variable (CI/CD pipeline)
# - Secret manager (AWS Secrets Manager, HashiCorp Vault)
# - Manual set on server (secure handoff process)
```

---

## Backup & Disaster Recovery

### Database Backup (Daily)

```bash
# Create backup script: /opt/pdam-alert/backup.sh
#!/bin/bash
set -e

BACKUP_DIR="/backups/pdam-alert"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DB_NAME="pdam_alert"
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.sql"

# Create directory if not exist
mkdir -p "$BACKUP_DIR"

# Backup database
pg_dump -U pdam_user -h localhost "$DB_NAME" | gzip > "${BACKUP_FILE}.gz"

# Upload to S3 (if using AWS)
aws s3 cp "${BACKUP_FILE}.gz" s3://brajakara-backup/pdam-alert/

# Keep only last 30 days locally
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +30 -delete

echo "Backup success: ${BACKUP_FILE}.gz"

# Cron job
# 0 2 * * * /opt/pdam-alert/backup.sh >> /var/log/pdam-alert/backup.log 2>&1
```

### Restore from Backup

```bash
# Stop application
sudo systemctl stop pdam-alert pdam-celery-beat pdam-celery-worker

# Restore database
BACKUP_FILE="/backups/pdam-alert/pdam_alert_20260508_020000.sql.gz"
gunzip -c "$BACKUP_FILE" | psql -U pdam_user -h localhost -d pdam_alert

# Start application
sudo systemctl start pdam-alert pdam-celery-beat pdam-celery-worker

# Verify
curl https://pdam.brajakara.tech/health/
```

---

## Monitoring & Alerting

### Healthcheck Endpoint

```bash
# GET /health/
curl https://pdam.brajakara.tech/health/

# Response:
{
  "status": "healthy",
  "timestamp": "2026-05-08T12:00:00Z",
  "database": "ok",
  "redis": "ok",
  "celery": "ok",
  "checks": {
    "database_connection": "ok",
    "redis_connection": "ok",
    "celery_worker_alive": true,
    "disk_space_percent": 45
  }
}
```

### Log Location

| Component | Log File |
|---|---|
| Django app | `/var/log/pdam-alert/error.log` + `access.log` |
| Celery worker | `/var/log/pdam-alert/celery-worker.log` |
| Celery beat | `/var/log/pdam-alert/celery-beat.log` |
| Nginx | `/var/log/nginx/error.log` |
| PostgreSQL | `/var/log/postgresql/postgresql.log` |
| Redis | `/var/log/redis/redis-server.log` |

### View Logs

```bash
# Real-time tail
tail -f /var/log/pdam-alert/error.log

# Search error
grep -i error /var/log/pdam-alert/error.log | tail -20

# Journalctl (systemd log)
journalctl -u pdam-alert -f
journalctl -u pdam-alert --since "1 hour ago" --grep="ERROR"
```

### Prometheus Metrics (Optional)

```bash
# GET /metrics/ → Prometheus format
curl https://pdam.brajakara.tech/metrics/

# Export metrics untuk scrape
app_info{version="1.0.0"} 1
alert_created_total{type="MISSING"} 150
alert_latency_seconds{percentile="p95"} 4.2
celery_task_success_total 500
celery_task_failure_total 2
```

---

## Troubleshoot

### Service tidak start

```bash
# Check status
sudo systemctl status pdam-alert

# View error log
sudo journalctl -u pdam-alert -n 50 --no-pager

# Common issue:
# 1. Port already in use
lsof -i :8000

# 2. Env var not set
grep TELEGRAM_BOT_TOKEN /opt/pdam-alert/.env

# 3. Permission denied
ls -la /var/log/pdam-alert/
sudo chown pdam:pdam /var/log/pdam-alert/
```

### Database connection error

```bash
# Test PostgreSQL
psql -U pdam_user -h localhost -d pdam_alert -c "SELECT 1;"

# Check DATABASE_URL format
echo $DATABASE_URL

# Restart PostgreSQL
sudo systemctl restart postgresql
```

### Redis connection fail

```bash
# Test Redis
redis-cli ping
# Response: PONG (healthy)

# If timeout, check service
sudo systemctl status redis-server

# Restart Redis
sudo systemctl restart redis-server
```

### Celery task not running

```bash
# Check Celery worker log
tail -f /var/log/pdam-alert/celery-worker.log

# Check Redis (broker)
redis-cli -n 0 KEYS "*" | head

# Check scheduled task
python manage.py shell
>>> from django_celery_beat.models import PeriodicTask
>>> PeriodicTask.objects.all()

# Restart Celery
sudo systemctl restart pdam-celery-worker pdam-celery-beat
```

### Telegram alert tidak terkirim

```bash
# Check bot token valid
curl "https://api.telegram.org/bot{TOKEN}/getMe"

# Check alert table
psql -U pdam_user -d pdam_alert -c "SELECT * FROM alert ORDER BY created_at DESC LIMIT 5;"

# Check Celery task queue
redis-cli -n 0 LLEN celery

# Test send manually (dev shell)
python manage.py shell
>>> from core_logic.check_data.notification_handler import send_telegram_alert
>>> send_telegram_alert("Test message", "test_channel")
```

---

## Rollback

### Rollback to Previous Version

```bash
# Current version
git log --oneline | head -5

# Checkout previous commit
git checkout <commit_hash_previous>

# Recompile + restart
pip install -r requirements.txt
python manage.py migrate

sudo systemctl restart pdam-alert pdam-celery-beat pdam-celery-worker

# Verify
curl https://pdam.brajakara.tech/health/
```

### Rollback Database (from backup)

```bash
# See backup section above
```

---

## Upgrade

### Minor Version (1.0 → 1.1, no DB change)

```bash
git pull origin main
pip install -r requirements.txt  # No breaking change
python manage.py collectstatic --noinput  # If static file change
sudo systemctl restart pdam-alert
```

### Major Version (1.x → 2.x, DB migration needed)

```bash
# Backup database first
/opt/pdam-alert/backup.sh

# Checkout new version
git checkout v2.0

# Install dependencies
pip install -r requirements.txt

# Run migration
python manage.py migrate  # Create new table, field, etc

# Restart
sudo systemctl restart pdam-alert pdam-celery-beat pdam-celery-worker

# Verify
curl https://pdam.brajakara.tech/health/

# If error, rollback to previous version (see Rollback section)
```

---

## Performance Tuning (Optional)

### Gunicorn Worker Tuning
```bash
# Current: --workers 4
# Formula: (2 x CPU cores) + 1
# For 2-core VM: (2 x 2) + 1 = 5 workers
# For 4-core VM: (2 x 4) + 1 = 9 workers

# Edit /etc/systemd/system/pdam-alert.service
# --workers 9
sudo systemctl restart pdam-alert
```

### PostgreSQL Connection Pool
```bash
# If many concurrent connection, increase pool size
# Edit .env
CONN_MAX_AGE=600  # Connection keep-alive 10 min

sudo systemctl restart pdam-alert
```

### Redis Persistence
```bash
# For high-frequency state change, enable RDB snapshot
# Edit /etc/redis/redis.conf
# save 900 1  (snapshot every 15 min if 1+ key change)
# appendonly yes (AOF for durability)

sudo systemctl restart redis-server
```

---

## Checklist Deployment Baru

- [ ] Prerequisite: VM, DB, Redis setup
- [ ] Clone repo, .env configured (secret aman)
- [ ] Database migrate OK
- [ ] Systemd service registered
- [ ] Nginx reverse proxy configured
- [ ] Health check passing (/health/)
- [ ] Manual test: alert trigger, Telegram send
- [ ] Backup script running (cron)
- [ ] Monitoring setup (health check, log tail)
- [ ] Documentation updated
- [ ] Operator trained (user manual review)
- [ ] Rollback plan reviewed
- [ ] Go-live approval from PM + lead

```

**Bikin sebelum atau sesudah?**  
→ **Sesudah codebase stable** + **before go-live** (prod ready)

---

## 🔥 Workflow Brajakara — Recommended

**Sebelum development sprint:**
```
Client brief → BRD (atau PRD) → SRS outline → Engineer start
```

**Selama coding:**
```
Inline comment (code) → commit message descriptive → daily note log progress
```

**Sesudah code stable:**
```
SRS final (extract dari code) → API Reference → Architecture doc → test + deploy
```

**Sesudah prod ready:**
```
User Manual → Deployment Guide → operator training
```

---

## 🔥 Rekomendasi Brajakara — Perbaikan Mendadak

| Doc | Status | Priority | Action |
|---|---|---|---|
| **SRS** | Missing untuk project aktif | 🔴 High | Bikin template SRS, apply ke PDAM_SBY + BE_WEATHERAPP |
| **API Reference** | Tidak ada, API ada | 🟡 Medium | Setup Swagger/OpenAPI comment di code, auto-generate |
| **Architecture Doc** | Implicit di rekam_jejak | 🟡 Medium | Formalize ke detail file per project |
| **Deployment Guide** | Ada (`docker-compose.yml`, `install.sh`) | 🟡 Medium | Formalize jadi markdown doc lengkap |
| **User Manual** | Pending, crucial untuk operator | 🟡 Medium | Bikin setelah API Reference (phase 2) |
| **TDD** | Ad-hoc untuk logic kompleks | 🟢 Low | Terstruktur untuk alert state machine (opsional) |

---

## Lihat Juga

- [[01_BACKEND_PROJECTS (Active development)|Backend Projects]] — tempat apply doc ini
- [[CLAUDE.md|CLAUDE.md]] — development rules
- [[06_INDEX (Navigation hub)/Navigation_Map|Navigation_Map]] — routing

---

Last updated: 2026-05-08
```

**Sync ke daily note udah done.** Sekarang update rekam_jejak dulu.

<function_calls>
<invoke name="edit_ide">
<parameter name="path">/home/salazar/vault_obsidian_brajakara/07_PROFIL (Professional Identity)/rekam_jejak.md