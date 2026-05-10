# DEX Session Manager — Full Project Plan

**Project:** Session monitoring & management dashboard for Dex SSO  
**Stack:** FastAPI + SQLite + Vue 3 + Nginx log parser  
**Start Date:** 2026-05-10  
**Target Completion:** 2026-06-07 (4 weeks)

---

## Architecture Overview

**Admin Access:** `https://auth.blitztechnology.tech/admin`

```
User Flow:
1. User login via Dex SSO (auth.blitztechnology.tech)
2. Dex trigger webhook on successful auth → FastAPI backend
3. Nginx access log parser → track activity & last_active
4. Admin access dashboard via /admin (same domain)

Components:
┌──────────────────────────────────────────────────────────┐
│  auth.blitztechnology.tech (Nginx di azkaban)            │
├──────────────────────────────────────────────────────────┤
│  /               → Dex (tower:5556)                      │
│  /auth, /token   → Dex (tower:5556)                      │
│  /admin          → FastAPI + Vue (tower:8000)            │
└──────────────────────────────────────────────────────────┘
    │ webhook on auth    │ access log (tail)  │
    ▼                    ▼                    │
┌──────────┐    ┌─────────────────┐           │
│ Dex SSO  │    │  Nginx Log      │           │
│ (5556)   │    │  Parser (py)    │           │
└────┬─────┘    └───────┬─────────┘           │
     │                  │                     │
     └──────────────────▼─────────────────────▼
                  ┌──────────────────┐
                  │  FastAPI Backend │
                  │  + Vue Dashboard │
                  │  (8000)          │
                  └────────┬─────────┘
                           │
                     ┌─────▼──────┐
                     │  SQLite DB │
                     └────────────┘
```

---

## Folder Structure

```
dex-session-manager/
│
├── backend/                    # FastAPI
│   ├── main.py                # Entry point
│   ├── models.py              # SQLAlchemy models
│   ├── schemas.py             # Pydantic schemas
│   ├── database.py            # DB connection
│   ├── crud.py                # CRUD operations
│   ├── auth.py                # JWT verification
│   ├── routes/
│   │   ├── sessions.py        # Session endpoints
│   │   ├── users.py           # User management
│   │   └── admin.py           # Admin-only routes
│   ├── utils/
│   │   ├── security.py        # Hash, token utils
│   │   └── device_parser.py  # Parse user-agent
│   ├── requirements.txt
│   └── sessions.db            # SQLite database
│
├── frontend/                   # Vue 3
│   ├── src/
│   │   ├── components/
│   │   │   ├── SessionTable.vue
│   │   │   ├── UserCard.vue
│   │   │   ├── ActivityChart.vue
│   │   │   └── RevokeModal.vue
│   │   ├── views/
│   │   │   ├── Dashboard.vue
│   │   │   ├── UserDetail.vue
│   │   │   └── Login.vue
│   │   ├── router/index.js
│   │   ├── stores/session.js  # Pinia
│   │   ├── services/api.js    # Axios wrapper
│   │   ├── App.vue
│   │   └── main.js
│   ├── package.json
│   └── vite.config.js
│
├── log_parser/                 # Nginx log parser
│   ├── parser.py              # Tail access log
│   ├── config.py              # Log patterns
│   └── requirements.txt       # re, requests
│
└── docs/
    ├── API.md
    ├── DATABASE_SCHEMA.md
    ├── DEPLOYMENT.md
    └── DEX_WEBHOOK_SETUP.md   # Dex config guide
```

---

## Database Schema (SQLite)

### Table: users
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT 1
);
```

### Table: sessions
```sql
CREATE TABLE sessions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    session_token VARCHAR(512) NOT NULL,
    device_info TEXT,
    browser VARCHAR(100),
    os VARCHAR(100),
    ip_address VARCHAR(45),
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active',
    revoked_by INTEGER,
    revoked_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (revoked_by) REFERENCES users(id)
);
```

### Table: activity_logs
```sql
CREATE TABLE activity_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    session_id INTEGER NOT NULL,
    action VARCHAR(100),
    resource VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    metadata TEXT,
    FOREIGN KEY (session_id) REFERENCES sessions(id)
);
```

### Indexes
```sql
CREATE INDEX idx_sessions_user ON sessions(user_id);
CREATE INDEX idx_sessions_status ON sessions(status);
CREATE INDEX idx_sessions_token ON sessions(session_token);
CREATE INDEX idx_activity_session ON activity_logs(session_id);
CREATE INDEX idx_activity_timestamp ON activity_logs(timestamp);
```

---

## API Endpoints (FastAPI)

### Authentication
- `POST /api/auth/login` — Admin login
- `POST /api/auth/verify` — Verify JWT token

### Session Management
- `GET /api/sessions` — List all active sessions
- `GET /api/sessions/{id}` — Session detail
- `POST /api/sessions` — Create session (from Dex)
- `PUT /api/sessions/{id}` — Update last_activity
- `DELETE /api/sessions/{id}` — Revoke session
- `DELETE /api/sessions/user/{email}` — Revoke all user sessions

### User Management
- `GET /api/users` — List users
- `GET /api/users/{id}` — User detail + sessions
- `POST /api/users` — Create user
- `PUT /api/users/{id}` — Update user
- `DELETE /api/users/{id}` — Deactivate user

### Activity & Monitoring
- `GET /api/activity` — Activity logs (paginated)
- `GET /api/activity/user/{id}` — User-specific activity
- `GET /api/stats` — Dashboard stats

### WebSocket
- `WS /ws/sessions` — Real-time session updates

---

## Implementation Phases

### Phase 1: Backend Foundation (Week 1)
**Start:** 2026-05-10 | **Target:** 2026-05-17
**Work Item:** SOFTW-64 (urgent)
**Access:** `https://auth.blitztechnology.tech/admin`

- Setup FastAPI + SQLAlchemy + Pydantic
- Create SQLite database (users, sessions, activity_logs)
- Implement CRUD endpoints (prefix: `/admin/api/`)
- Add JWT authentication for admin
- FastAPI serve Vue static files di `/admin`
- Write API tests

**Stack:** FastAPI, SQLite, SQLAlchemy, python-jose, passlib

---

### Phase 2: Dex Integration & Activity Tracking (Week 1-2)
**Start:** 2026-05-13 | **Target:** 2026-05-20  
**Work Item:** SOFTW-63 (high)

**Goal:** Track login events & user activity tanpa browser extension

#### A. Dex Webhook Integration
- Configure Dex connector untuk trigger webhook on successful auth
- Endpoint: `POST /admin/api/sessions/webhook` (receive login event)
- Extract: email, IP, timestamp, OAuth client_id
- Parse user-agent → device info (browser, OS)
- Create session record di DB

#### B. Nginx Access Log Parser
- Setup log format di azkaban Nginx:
  ```nginx
  log_format session_track '$remote_addr - $remote_user [$time_local] '
                          '"$request" $status $body_bytes_sent '
                          '"$http_referer" "$http_user_agent" '
                          '$upstream_http_x_user_email';
  ```
- Background service (Python script) parse log setiap 5 detik
- Update `last_activity` untuk matching sessions
- Log activity: `POST /admin/api/activity` (action, resource, timestamp)

#### C. Session Expiry Logic
- Auto-mark session sebagai `expired` kalau `last_activity` > 24h
- Cron job tiap 1 jam: cleanup expired sessions

**Stack:** Dex webhooks, Python log parser (tail -f), Nginx custom log format

**Note:** Extension-based tracking postponed → Phase 7 (optional enhancement)

---

### Phase 3: Frontend Dashboard (Week 2)
**Start:** 2026-05-17 | **Target:** 2026-05-24
**Work Item:** SOFTW-62 (high)
**Access:** `https://auth.blitztechnology.tech/admin`

- Setup Vue 3 + Vite + TailwindCSS
- Create routing (Dashboard, UserDetail, Login) — base path: `/admin`
- Build components: SessionTable, UserCard, StatCard, Badge, RevokeModal
- Axios API integration (prefix: `/admin/api`)
- Pinia store for session state
- FastAPI serve Vue dist/ sebagai static files di `/admin`

**Stack:** Vue 3, Vite, Pinia, Axios, TailwindCSS

---

### Phase 4: Real-time Features (Week 3)
**Start:** 2026-05-20 | **Target:** 2026-05-27  
**Work Item:** SOFTW-65 (medium)

- WebSocket implementation (FastAPI)
- WebSocket client (Vue)
- Live session updates
- Activity timeline real-time

---

### Phase 5: Advanced Features (Week 3-4)
**Start:** 2026-05-24 | **Target:** 2026-05-31  
**Work Item:** SOFTW-65 (medium)

- User detail view
- Activity charts (Chart.js/ApexCharts)
- Revoke session functionality
- Search & filter
- Export data (CSV/JSON)

---

### Phase 6: Security & Deploy (Week 4)
**Start:** 2026-05-31 | **Target:** 2026-06-07
**Work Item:** SOFTW-63 (high)

- Rate limiting (100 req/min per IP)
- CORS whitelist (same-origin: auth.blitztechnology.tech)
- Admin RBAC validation
- Hash session tokens sebelum simpan DB
- Auto-expire sessions (24h default)
- Docker: backend Dockerfile, frontend build into backend, docker-compose.yml
- Deploy ke tower (10.20.0.11:8000)
- **Nginx config azkaban:**
  - `/admin` → proxy ke `tower:8000` (FastAPI)
  - `/` → proxy ke `tower:5556` (Dex)
- HTTPS already setup (Let's Encrypt existing — gratis)

---

## Tech Stack Detail

### Backend
```
fastapi==0.104.1
uvicorn[standard]==0.24.0
sqlalchemy==2.0.23
pydantic==2.5.0
python-jose[cryptography]==3.3.0
passlib[bcrypt]==1.7.4
python-multipart==0.0.6
websockets==12.0
```

### Frontend
```json
{
  "dependencies": {
    "vue": "^3.3.8",
    "vue-router": "^4.2.5",
    "pinia": "^2.1.7",
    "axios": "^1.6.2",
    "chart.js": "^4.4.0",
    "vue-chartjs": "^5.2.0",
    "dayjs": "^1.11.10"
  },
  "devDependencies": {
    "vite": "^5.0.0",
    "@vitejs/plugin-vue": "^4.5.0",
    "tailwindcss": "^3.3.5"
  }
}
```

---

## Security Considerations

1. **Admin Authentication**
   - Separate admin login (beda dari user SSO)
   - RBAC (role-based access control)
   - JWT expiry: 1 hour

2. **API Security**
   - Rate limiting: 100 req/min per IP
   - CORS: whitelist frontend domain only
   - Pydantic input validation

3. **Session Token Storage**
   - Hash token sebelum simpan DB
   - Never expose full token di frontend
   - Auto-expire 24 jam

4. **Data Privacy**
   - Mask IP address (show last 2 octets)
   - GDPR: user delete data sendiri
   - Encrypt sensitive fields (optional SQLCipher)

---

## Dashboard Features

### Main Stats
```
Active Sessions: 42  │  Total Users: 128
Today Logins: 15     │  Avg Session Time: 3h 24m
```

### Session Table
```
User               │ Device            │ IP          │ Status
user@brajakara.com │ Chrome/Windows    │ 192.168.x.x │ 🟢 Active
admin@brajakara.com│ Firefox/Linux     │ 10.0.x.x    │ 🟢 Active
test@brajakara.com │ Safari/macOS      │ 172.16.x.x  │ 🔴 Revoked
```

### Activity Timeline
```
10:30  user@brajakara.com logged in
10:32  Accessed /dashboard
10:35  API call: GET /api/data
10:40  Session revoked by admin@brajakara.com
```

---

## Deployment (Docker)

### Backend Dockerfile
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Frontend Dockerfile
```dockerfile
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
```

### docker-compose.yml
```yaml
version: '3.8'
services:
  backend:
    build: ./backend
    ports:
      - "8000:8000"
    volumes:
      - ./backend/sessions.db:/app/sessions.db
    environment:
      - SECRET_KEY=your_secret_key_here
  
  frontend:
    build: ./frontend
    ports:
      - "5173:80"
    depends_on:
      - backend
```

---

## Deployment Architecture

**Host:** DungeonTower VM (10.20.0.11) — existing infrastructure
**Proxy:** Nginx di azkaban (103.103.23.233)
**Domain:** `auth.blitztechnology.tech` — existing domain
**SSL:** Let's Encrypt (already active)
**Cost:** $0 — pakai infra existing

**Nginx routing:**
```
/admin       → proxy_pass http://10.20.0.11:8000  (FastAPI + Vue)
/auth, /     → proxy_pass http://10.20.0.11:5556  (Dex SSO)
```

---

## Scalability & Future Enhancements

### Short-term
- Export CSV/Excel
- Email notification suspicious login
- Geolocation (IP → City/Country)
- Session duration histogram

### Mid-term
- MFA logs
- Device fingerprinting (Canvas/WebGL)
- Anomaly detection
- Audit trail admin actions

### Long-term
- Migrate SQLite → PostgreSQL (>10K users)
- Redis cache session lookup
- Elasticsearch activity search
- ML: account takeover detection

---

## Work Items Reference

- **SOFTW-64** — Phase 1: Backend Foundation (urgent)
- **SOFTW-63** — Phase 2: Extension Integration (high)
- **SOFTW-62** — Phase 3: Frontend Dashboard (high)
- **SOFTW-65** — Phase 4: Real-time WebSocket (medium)
- **SOFTW-65** — Phase 5: Advanced Features (medium)
- **SOFTW-63** — Phase 6: Security & Deploy (high)

---

**Last Updated:** 2026-05-10  
**Project Lead:** TBD  
**Tech Stack:** FastAPI, SQLite, Vue 3, Dex Extension
