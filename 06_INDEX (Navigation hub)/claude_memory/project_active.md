---
name: Project Backend Aktif
description: Daftar project backend aktif di Brajakara
type: project
originSessionId: a3a7fb23-fce1-4545-8801-5683083eb8b4
---
Dua project backend besar yang sedang dikerjakan:

| Project | Status | Notes |
|---|---|---|
| **WEATHERAPP** | Aktif | Detail belum dicatat |
| **PDAM_SBY** | Aktif | Arsitektur lengkap dicatat di `01_BACKEND_PROJECTS (Active development)/PDAM_SBY.md` |

### PDAM_SBY — Ringkasan
- Monitoring flow meter air PDAM Surabaya
- Stack: Django + Gunicorn, Redis 7, Supercronic, Docker Compose, PostgreSQL (`128.46.8.224`, db: `dbflowmeter`)
- MQTT subscriber → raw message → SensorData + Kubikasi + Anomali (cron tiap 2.5 menit)
- 4 container: `pdam_redis`, `pdam_web`, `pdam_scheduler`, `pdam_mqtt_collect_message` — semua `network_mode: host`
- Model ML di `predictions/` (ARIMA, LightGBM, XGBoost, RF, LSTM) — saat ini **tidak dijadwalkan**
- Guard: `docker_compose_guard.sh`; hati-hati file `taksasi_old.py` vs `taksasi.py`

**Why:** Dicatat user di vault untuk konteks lintas session.

**How to apply:** Ketika user bahas project backend, kemungkinan besar salah satu dari dua ini. Detail PDAM_SBY ada di vault note-nya.
