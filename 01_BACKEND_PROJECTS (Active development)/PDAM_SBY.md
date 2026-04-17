---
tags: [project, backend, django, mqtt, docker, pdam]
date_created: 2026-04-16
status: aktif
repo: git@github.com:Brajakara-Teknologi-Media/BRAJA_PDAMSBY.git
branch_aktif: docker-preparations
---

# PDAM Surabaya — Backend Project

Project monitoring flow meter air PDAM Surabaya. Data dari sensor lapangan dikirim via MQTT, diproses, disimpan ke PostgreSQL.

## Stack

| Komponen | Detail |
|---|---|
| Framework | Django + Gunicorn |
| Cache | Redis 7 (Alpine) |
| Scheduler | Supercronic (cron in Docker) |
| Containerization | Docker Compose |
| Database | PostgreSQL — `128.46.8.224`, db: `dbflowmeter`, user: `usflowmeter` |
| Messaging | MQTT (subscriber via `pdamMqttClient`) |

## Struktur Folder

```
~/BRAJA_PDAMSBY/
├── docker-compose.yml
├── Dockerfile
├── docker_compose_guard.sh
├── pdam_project/          ← Django app utama
│   ├── pdam_app/          ← app logic (models, views, serializer, management commands)
│   ├── core_logic/        ← threshold creation
│   ├── crontab            ← jadwal Supercronic
│   └── pdam_project/.env  ← config env
├── pdamMqttClient/
│   └── client_collect_message/  ← MQTT subscriber
└── predictions/           ← model ML (ARIMA, LightGBM, XGBoost, RF, LSTM)
```

## Arsitektur Container

| Container | Image | Fungsi |
|---|---|---|
| `pdam_redis` | redis:7-alpine | Cache layer |
| `pdam_web` | braja_pdamsby:latest | Django via Gunicorn (2 worker, 4 thread) |
| `pdam_scheduler` | braja_pdamsby:latest | Cron jobs via Supercronic |
| `pdam_mqtt_collect_message` | braja_pdamsby:latest | MQTT subscriber, simpan raw message |

Semua container pakai `network_mode: host`.

## Flow Data

```
MQTT Broker
    ↓
pdam_mqtt_collect_message
    ↓
RawMessageModel (PostgreSQL)
    ↓
cron: message2sensordata (tiap 2.5 menit)
    ↓
SensorData + Kubikasi + Anomali check
    ↓
Taksasi (tiap jam / tiap 15 menit)
```

## Cron Jobs (Supercronic)

| Job | Jadwal | Fungsi |
|---|---|---|
| `message2sensordata` | tiap 2.5 menit* | Parse raw message → sensor data + kubikasi |
| `call_insertMissing` | tiap 5 menit | Isi data yang hilang |
| `cek_anomali_kubikasi` | tiap 5 menit | Deteksi anomali kubikasi |
| ~~`runningTaksasi`~~ | ~~tiap jam (menit ke-3)~~ | **dinonaktifkan** |
| `runningTaksasiOtomatis` | tiap 15 menit (semua balai) | Taksasi otomatis |
| `publish_resend2` | tiap 3 jam | Resend data gagal terkirim |
| `create_threshold` | Senin 01:00 | Update threshold sensor |

*Stagger trick: dua job `*/5` + `sleep 150` = efektif jalan tiap 2.5 menit.

> Forecast jobs (`run_insert_forecast`, `run_insert_accuracy`) saat ini **dinonaktifkan** di crontab.

## Model ML (Predictions)

Ada di `predictions/` — saat ini tidak dijadwalkan:
- ARIMA (`predARIMA.py`)
- LightGBM (`predLightgbm.py`, `pred-MCAR20-lightgbm.py`)
- XGBoost (`predXgboost.py`, `pred-MCAR20-xgboost.py`)
- Random Forest (`predRF.py`)
- LSTM (`pred_LSTM.py`)

## Koneksi DB Langsung

```bash
psql -U usflowmeter -h 128.46.8.224 -d dbflowmeter
```

## Catatan Operasional

- Guard script: `docker_compose_guard.sh` — kemungkinan watchdog container
- `taksasi.py` ada versi lama (`taksasi_old.py`, `taksasi_backup.py`) — hati-hati salah file
- Log container: json-file, max 20MB × 3 file per container
