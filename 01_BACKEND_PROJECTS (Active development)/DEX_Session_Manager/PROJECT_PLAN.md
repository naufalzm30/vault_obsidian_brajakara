# DEX Session Manager — Full Project Plan

**Project:** Session monitoring & management dashboard for Dex SSO extension  
**Stack:** FastAPI + SQLite + Vue 3  
**Start Date:** 2026-05-10  
**Target Completion:** 2026-06-07 (4 weeks)

---

## Architecture Overview

```
User Flow:
1. User login via FE_SSO (existing HTML form)
2. Dex extension intercepts auth → stores JWT token
3. Extension sends session data → FastAPI backend
4. Admin monitors via Vue dashboard (real-time)

Components:
┌──────────────┐      ┌──────────────┐      ┌──────────────┐
│   FE_SSO     │─────>│ Dex Extension│─────>│  FastAPI     │
│  (login UI)  │      │ (auth layer) │      │  Backend     │
└──────────────┘      └──────────────┘      └──────┬───────┘
                                                    │
                                              ┌─────▼──────┐
                                              │  SQLite DB │
                                              └─────┬──────┘
                                                    │
                                              ┌─────▼──────┐
                                              │  Vue Admin │
                                              │  Dashboard │
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
├── extension/                  # Dex (existing, modified)
│   ├── manifest.json
│   ├── background.js          # + session tracking
│   ├── content.js
│   └── utils/api-client.js    # Send data to backend
│
└── docs/
    ├── API.md
    ├── DATABASE_SCHEMA.md
    └── DEPLOYMENT.md
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

- Setup FastAPI + SQLAlchemy + Pydantic
- Create SQLite database (users, sessions, activity_logs)
- Implement CRUD endpoints
- Add JWT authentication
- Write API tests

**Stack:** FastAPI, SQLite, SQLAlchemy, python-jose, passlib

---

### Phase 2: Extension Integration (Week 1-2)
**Start:** 2026-05-13 | **Target:** 2026-05-20  
**Work Item:** SOFTW-63 (high)

- Modify Dex background.js
- Intercept login → send session data
- Heartbeat mechanism (5 min interval)
- Track page navigation → activity log
- Store session_id in chrome.storage.local

---

### Phase 3: Frontend Dashboard (Week 2)
**Start:** 2026-05-17 | **Target:** 2026-05-24  
**Work Item:** SOFTW-62 (high)

- Setup Vue 3 + Vite + TailwindCSS
- Create routing (Dashboard, UserDetail, Login)
- Build components: SessionTable, UserCard, StatCard, Badge
- Axios API integration
- Pinia store

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
- CORS configuration
- Admin role validation
- Hash session tokens
- Auto-expire (24h)
- Docker: backend + frontend + compose
- HTTPS setup
- Deploy VPS ($13/month est.)

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

## Cost Estimate (VPS Deployment)

| Service | Spec | Cost/Month |
|---------|------|------------|
| DigitalOcean Droplet | 2GB RAM, 1 vCPU | $12 |
| Domain (.com) | - | $12/year |
| SSL (Let's Encrypt) | - | Free |
| **Total** | | **~$13/month** |

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
