---
name: Project Backend Aktif
description: Daftar project backend aktif di Brajakara + task pending
type: project
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

---

## ⚠️ Task Pending — Notif Telegram check_data (2026-04-20)

**Ingatkan user saat buka session baru.**

`core_logic/check_data/` sudah dibuat di branch `docker-preparations`:
- `check_missing.py`, `check_threshold.py`, `check_voltased.py`
- `run_checks.py` — loop semua check + kirim Telegram, tapi **masih placeholder**

### Yang masih perlu dikerjakan:
1. **Token bot Telegram + channel ID** per grup → isi di `run_checks.py` (`TELEGRAM_BOT_TOKEN`, `TELEGRAM_CHANNELS`)
2. **Fix timezone bug** di `views.py` — ganti `.astimezone(jakarta_tz)` → `JAKARTA_TZ.localize(...)` di ketiga CheckXxx class
3. **Hapus debug timezone** dari response `CheckMissingDataCount` setelah konfirmasi
4. **Wire ke cron** Supercronic setelah Telegram selesai

### Cara jalankan manual:
```bash
cd /app/pdam_project
python -m core_logic run --module core_logic.check_data.run_checks --func main \
  --kwargs since="2026-04-20 15:00" until="2026-04-20 15:55"
```

**Why:** User mau notif otomatis ke Telegram tiap ada anomali data sensor.
**How to apply:** Tanya user apakah sudah punya token bot dan channel ID saat mulai session baru.
