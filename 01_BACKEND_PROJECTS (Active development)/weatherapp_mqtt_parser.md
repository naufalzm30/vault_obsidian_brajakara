---
tags: [project, backend, mqtt, iot, weatherapp]
status: active
repo: local only (~/weatherapp_mqtt_parser)
related: [[BE_WEATHERAPP]]
---

# weatherapp_mqtt_parser

MQTT subscriber/parser — terima data dari logger IoT via MQTT, parse, simpan ke MySQL `weather_app`. Komponen IoT layer dari ekosistem [[BE_WEATHERAPP]].

## Arsitektur

```
[Logger IoT]
    │  publish CSV via MQTT
    ▼
[MQTT Broker: mqtt.blitztechnology.tech:1883]
    │
    ├── weatherapp_client.py     ← subscriber utama (semua stasiun)
    ├── inovastekMqttClient.py   ← khusus inovastek/aws topics
    ├── pdamSubClient.py         ← PDAM Surabaya re-router
    ├── telegramMqtt.py          ← notifikasi Telegram (pdam/malang, bwspalu)
    └── MQTT_Time_Client.py      ← sync waktu logger
    │
    ▼
[MySQL: weather_app]
    ├── weatherapp_weather_data  ← data mentah per record
    └── weatherapp_hourly        ← agregasi per jam
```

## Format Data MQTT

CSV string dari logger:
```
YYYY-MM-DD HH:MM:SS, CH1, CH2, ..., CHn, temperature, battery, uptime
```
- Field terakhir: `uptime`
- Field kedua dari akhir: `battery`
- Field ketiga dari akhir: `temperature`
- CH1..CHn: sensor channels (jumlah dynamic)

**Pengecualian format:**
- `inovastek/aws/ayana_resort` dan `aws/itb_ganesha`: tidak ada battery, uptime di posisi terakhir

## Komponen / Sub-Client

### `dockerize/weatherapp_client.py` (versi aktif utama)
- Subscribe semua topic dari `weatherapp_station.topic_MQTT` di DB
- **Auto topic refresh tiap 5 menit** — subscribe topic baru, unsubscribe topic dihapus tanpa reconnect
- Loop utama non-blocking (`loop_start()` + `while True` + `sleep(1)`)
- Track `subscribed_topics` sebagai set
- Error handling lebih lengkap vs versi lama

### `Weather_App_MQTT_Client.py` (versi lama/root)
- Subscribe dari DB, tapi **reconnect penuh tiap 120 detik** (destroy + recreate `mqttobj`)
- Lebih fragile, tidak ada dynamic topic refresh

### `inovastekClient/inovastekMqttClient.py`
- Subscribe `inovastek/#` dan `aws/#`
- **Station ID hardcoded**: `inovastek/*` → station 71, `aws/*` → station 72
- Tidak pakai Config.ini untuk station mapping

### `pdamSubClient/pdamSubClient.py`
- Subscribe `pdam/#`
- **Re-publish** ke topic baru:
  - `pdam/ngagel_1` → `pdam/surabaya/ngagel_1`
  - `pdam/rp_ketegan` → `pdam/surabaya/rp_ketegan`
- Bukan writer ke DB — hanya MQTT router

### `telegram-client/telegramMqtt.py`
- Subscribe `pdam/malang/#` dan `bwspalu/#`
- Kirim notifikasi Telegram berdasarkan data sensor
- Ambil `observator_phone` dan `elevasi` dari `weatherapp_station`

### `MQTT_Time_Client/MQTT_Time_Client.py`
- Kirim waktu server ke broker MQTT (untuk sync jam logger)

## Logic Insert DB (`Weather_App_Client_MySQL_Connector.py`)

### Dedup check `weatherapp_weather_data`
```sql
SELECT date_time FROM (
    SELECT date_time FROM weatherapp_weather_data 
    WHERE station_id = %s ORDER BY id DESC LIMIT 3825
) AS ATX WHERE date_time = %s;
```
- Cek duplikat hanya di 3825 data terakhir
- Kalau `check is None` → INSERT
- Kalau `check[0] != date_time_obj` → INSERT (beda timestamp)
- Kalau sama → skip

### Logic `weatherapp_hourly`
- `minute == 0` → `hour_col = hour`
- `minute >= 56` → `hour_col = hour + 1`
- `minute < 56` → `hour_col = hour`
- Kalau row `hour_col` sudah ada dan `date_time` lebih lama → UPDATE
- Kalau belum ada → INSERT

## Bug / Quirk Penting

### Year Bug Logger
Logger kadang kirim tahun `current_year + 41/42/43`. Ada fix hardcoded:
```python
elif year == current_year + 42 or year == current_year + 43 or year == current_year + 41:
    year = current_year
```
Ini sebabnya ada SQL di README untuk koreksi data tahun 2066 → 2023/2022.

### Inovastek Ayana Resort — Offset Hardcoded
```python
if self.topic == "inovastek/aws/ayana_resort":
    ch3 = float(data[ch]) + 3      # offset +3
    ch4 = float(data[ch]) - 20     # offset -20
    ch9 = float(data[ch]) + 3.1    # offset +3.1
    # timezone juga di-offset +1 jam
```

### Service File Path Stale
`WeatherApp_MQTT_Client.service` masih pakai:
```
WorkingDirectory=/home/viusp/...
ExecStart=/usr/bin/python3 /home/viusp/...
```
Path ini untuk user lama (`viusp`). Kalau deploy ulang, perlu update.

## Konfigurasi (`Config.ini`)

```ini
[Server]
Broker = mqtt.blitztechnology.tech
Port   = 1883
UserID = vius
Pass   = vius
KAI    = 60          ; keep-alive interval

[DB]
dbid = weather_app
host = localhost
user = MySQL_Master
pass = BTech_MySQL999
```

> **Catatan:** Credentials ada di Config.ini plaintext — tidak pakai `.env`.

## Struktur Folder

```
weatherapp_mqtt_parser/
├── Weather_App_MQTT_Client.py          ← client lama (root)
├── Weather_App_Client_MySQL_Connector.py
├── Config.ini
├── WeatherApp_MQTT_Client.service      ← systemd service (path stale!)
├── WeatherApp_Dummy.py
├── modified_data_pagaralam.py
├── monitor_script.sh
│
├── dockerize/                          ← versi Docker (aktif)
│   ├── weatherapp_client.py            ← MAIN CLIENT
│   ├── weatherapp_mysql_connector.py
│   ├── Config.ini
│   ├── docker-compose.yml
│   ├── Dockerfile
│   └── requirements.txt
│
├── inovastekClient/
│   ├── inovastekMqttClient.py
│   └── monitorInovastek.sh
│
├── pdamSubClient/
│   ├── pdamSubClient.py
│   ├── config.ini
│   └── monitorPdamSubClient.sh
│
├── telegram-client/
│   ├── telegramMqtt.py
│   ├── pdamTelegram.py
│   ├── pdamMqttSendData.py
│   └── conf.ini / config.ini
│
├── MQTT_Time_Client/
│   └── MQTT_Time_Client.py
│
├── old_mqtt_client/                    ← arsip versi lama
└── Backup/                             ← arsip backup
```

## Deployment

- Versi aktif: `dockerize/` via Docker
- Monitoring script tersedia: `monitor_script.sh`, `monitorInovastek.sh`, `monitorPdamSubClient.sh`
- Systemd service: `WeatherApp_MQTT_Client.service` (perlu update path)
