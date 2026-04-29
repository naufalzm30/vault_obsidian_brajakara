---
type: detail
category: project
hop: 2
tags: [project/backend, django, weatherapp, iot, monitoring]
up: "[[01_BACKEND_PROJECTS (Active development)/index]]"
status: active
repo: git@github.com:Brajakara-Teknologi-Media/BE_WEATHERAPP.git
---

# BE_WEATHERAPP

Backend sistem monitoring cuaca & hidrologi multi-balai. Digunakan oleh beberapa instansi pemerintah (BWS, BNPB, dll).

## Stack

| Komponen | Detail |
|---|---|
| Framework | Django 3.2 + Django REST Framework |
| Auth | JWT via `djangorestframework-simplejwt` (access 1 hari, refresh 30 hari) |
| Database | MySQL (PyMySQL), DB name: `weather_app` |
| Cron | `django-crontab` — job `data_json` jalan tiap 4 menit |
| Notifikasi | Telegram Bot (`python-telegram-bot`) — ada 2 bot: Malang & Palu |
| IoT | MQTT via `paho-mqtt` |
| Export | Excel via `XlsxWriter` |
| Containerisasi | Docker + docker-compose |

## Struktur Folder

```
BE_WEATHERAPP/
├── manage.py
├── docker-compose.yml
├── Dockerfile
├── requirements.txt
├── weatherapp/           ← Django app utama
│   ├── models.py         ← semua model DB
│   ├── views.py          ← 326KB — semua view/API handler
│   ├── serializers.py    ← DRF serializers
│   ├── urls.py           ← routing endpoint
│   ├── cron.py           ← cron job (68KB), job utama: data_json
│   ├── cron.pyback       ← backup cron lama
│   ├── checkup.py        ← utility checkup
│   ├── admin.py
│   ├── utils/
│   │   └── loggerLocal.py
│   └── management/
│       └── commands/
│           └── mod_job.py
└── weather_project/      ← Django project config
    ├── settings.py
    ├── urls.py
    └── .env              ← secret: DB creds, Telegram token, Django key
```

## Model Utama

| Model | Fungsi |
|---|---|
| `Station` | Data stasiun monitoring (koordinat, MQTT topic, observator, dll) |
| `Sensor_modified` | Konfigurasi sensor per stasiun — hingga 20 sensor (sensor1..sensor20), tiap sensor punya `type`, `act`, `ch`, `w_lvl_1/2/3`, `mix` |
| `Weather_data` | Data raw dari logger — CH1..CH20, temperature, battery, uptime, source |
| `Hourly` | Agregasi per jam dari weather_data |
| `Weather_data_clean` | Data yang sudah diproses/dibersihkan, array-based (JSON text fields) |
| `Debit` | Kalkulasi debit dari weather_data |
| `Debit_setup` | Konstanta kalkulasi debit (kons_a, kons_b, tma_0) per stasiun |
| `Balai` | Unit organisasi (BWS/Balai) |
| `Provinsi` | Provinsi |
| `Profile` | Ekstensi User Django — role, balai, provinsi |
| `Dummy` | Data dummy untuk stasiun tertentu |

**Source field:** `0`=logger, `1`=dummy, `2`=csv, `3`=maintenance

## API Endpoints Utama

```
POST   /login/
POST   /token/refresh/

GET    /station/              ← list semua stasiun
GET    /home-data/            ← data dashboard utama (auth)
GET    /home-data/non-auth/   ← data dashboard publik
GET    /data/<station_id>/<user_id>

GET    /weather-data/
GET    /hourly/
GET    /excel/
GET    /excel-v2/<type_id>/

GET    /public-data/
GET    /public-data/<balai_id>/<station_id>

POST   /csv/
GET    /json/<file>
GET    /json-public/<file>

POST   /bot-massage/<bot_name>/<msg_type>/...
POST   /ptz/control
POST   /ptz/control/status/
GET    /ptz/status/<station_id>

GET/POST /balai/
GET/POST /station-sensor/<balai_id>
GET/POST /debit-setup/<station_id>
```

## Konfigurasi Penting

- `DEBUG = True` — **belum production-ready**
- `ALLOWED_HOSTS`: IP server + domain blitztechnology.tech + brajakara.id
- `CORS_ORIGIN_WHITELIST`: banyak domain BWS + blitztechnology + brajakara
- `CONN_MAX_AGE = 600` (koneksi MySQL reuse 10 menit)
- `read_timeout = 1800` (30 menit — query besar)
- Cronjob `data_json` tiap `*/4 * * * *`
- Telegram: 2 config — `TELEGRAM_MALANG` dan `TELEGRAM_PALU`

## Catatan Teknis

- `views.py` sangat besar (326KB) — semua logika ada di satu file
- `Sensor_modified` model sangat repetitif — 20 sensor field ditulis manual (bukan ArrayField/JSONField)
- `Weather_data_clean.array_*` pakai `TextField` untuk menyimpan array sebagai string JSON
- Log file hardcoded ke path `/home/viusp/...` di `views.py:36-37` — path ini kemungkinan tidak exist di mesin lain
- `cron.pyback` ada sebagai backup versi lama cron
- PTZ Camera control disimpan di `Station.note` field sebagai JSON string

## Deployment

- Docker container
- Akses via domain `weatherapi.blitztechnology.tech`
- IP server: `154.41.251.49` dan `103.94.239.32`
- Git remote: `github.com/Brajakara-Teknologi-Media/BE_WEATHERAPP`

## Recent Commits (snapshot Feb 2025)

```
a45de04 balikin ke non debug
940650d tambahan untuk debug auth
cab954f mencoba migrasi knox ke jwt  ← migrasi auth dari Knox ke JWT
b05f66a try fix mysql connection loss
45d7cb1 change network mode
```
