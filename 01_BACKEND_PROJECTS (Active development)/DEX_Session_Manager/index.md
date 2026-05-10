# DEX Session Manager — Project Index

**Status:** Planning ✅ | Ready for Development  
**Start Date:** 2026-05-10  
**Target Completion:** 2026-06-07 (4 weeks)  
**Stack:** FastAPI + SQLite + Vue 3

---

## Quick Links

- **Full Plan:** [[PROJECT_PLAN.md]]
- **Architecture:** FastAPI Backend | SQLite Database | Vue 3 Dashboard
- **Work Items:** SOFTW-64, SOFTW-63, SOFTW-62, SOFTW-65 (x2)

---

## Project Overview

Monitor & manage user sessions connected via Dex SSO (webhook + log parsing).

**Features:**
- Real-time active sessions tracking
- Session revocation
- User activity logs
- Device fingerprinting (browser/OS/IP)
- Admin dashboard with charts

---

## Tech Stack

### Backend
- **Framework:** FastAPI (Python)
- **Database:** SQLite (3 tables: users, sessions, activity_logs)
- **Auth:** JWT + Python-jose
- **Real-time:** WebSocket

### Frontend
- **Framework:** Vue 3 + Vite
- **State:** Pinia (store)
- **API:** Axios
- **UI:** TailwindCSS
- **Charts:** Chart.js / ApexCharts

### Activity Tracking
- **Dex Webhooks** — trigger on successful auth
- **Nginx Log Parser** — Python script tail access log → passive heartbeat
- **(Optional)** Browser extension postponed → Phase 7

---

## Database Schema (Quick)

```
users
├── id, email, full_name, role, created_at, is_active

sessions
├── id, user_id, session_token, device_info
├── browser, os, ip_address
├── login_time, last_activity, expires_at
├── status (active/expired/revoked), revoked_by, revoked_at

activity_logs
├── id, session_id, action, resource, timestamp, metadata
```

---

## API Endpoints (Quick Reference)

### Sessions
- `GET /api/sessions` — List all
- `POST /api/sessions` — Create (from Dex)
- `DELETE /api/sessions/{id}` — Revoke
- `DELETE /api/sessions/user/{email}` — Revoke all user

### Users
- `GET /api/users` — List
- `GET /api/users/{id}` — Detail + sessions
- `POST /api/users` — Create

### Activity
- `GET /api/activity` — Logs (paginated)
- `GET /api/stats` — Dashboard stats

### WebSocket
- `WS /ws/sessions` — Real-time updates

---

## Implementation Timeline

| Phase | Week | Dates | Status | Work Item |
|-------|------|-------|--------|-----------|
| 1. Backend | Week 1 | 5/10-5/17 | Todo | SOFTW-64 🔴 |
| 2. Extension | Week 1-2 | 5/13-5/20 | Todo | SOFTW-63 🔴 |
| 3. Frontend | Week 2 | 5/17-5/24 | Todo | SOFTW-62 🔴 |
| 4. WebSocket | Week 3 | 5/20-5/27 | Todo | SOFTW-65 🔴 |
| 5. Advanced | Week 3-4 | 5/24-5/31 | Todo | SOFTW-65 🔴 |
| 6. Security | Week 4 | 5/31-6/7 | Todo | SOFTW-63 🔴 |

---

## Dashboard Mockup

```
┌─────────────────────────────────────────────┐
│  DEX Session Manager — Admin Dashboard     │
├─────────────────────────────────────────────┤
│  Active: 42  |  Users: 128  |  Today: 15   │
├─────────────────────────────────────────────┤
│ User          | Device          | Status    │
├─────────────────────────────────────────────┤
│ user@bkt.com  | Chrome/Windows  | 🟢 Active │
│ admin@bkt.com | Firefox/Linux   | 🟢 Active │
│ test@bkt.com  | Safari/macOS    | 🔴 Revoked│
└─────────────────────────────────────────────┘
```

---

## Security Checklist

- [ ] Rate limiting (100 req/min)
- [ ] CORS whitelist
- [ ] JWT 1h expiry
- [ ] Hash session tokens
- [ ] Auto-expire 24h
- [ ] HTTPS/Let's Encrypt
- [ ] RBAC (admin only)
- [ ] Input validation (Pydantic)

---

## Deployment

**VPS Cost:** ~$13/month (DigitalOcean 2GB)

**Docker:**
- `Dockerfile` — backend (Python 3.11)
- `Dockerfile` — frontend (Node 20 → nginx)
- `docker-compose.yml` — orchestration

---

## Known Constraints

1. **SQLite Limit** — ~10K users max before migrate to PostgreSQL
2. **Real-time** — WebSocket needs proper load balancing at scale
3. **Dex Extension** — depends on existing manifest + background script
4. **Admin Auth** — separate from user SSO (new login)

---

## Next Steps

1. ✅ Plan finalized (2026-05-10)
2. 🔄 Start Phase 1: Backend (2026-05-10)
3. → Phase 2: Extension (2026-05-13)
4. → Phase 3-6: Frontend + Deploy (2026-05-17 onwards)

---

**Last Updated:** 2026-05-10  
**Created By:** Claude Code  
**Ref:** [[PROJECT_PLAN.md]]
