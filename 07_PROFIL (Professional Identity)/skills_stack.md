---
type: reference
category: profile
hop: 2
tags: [profile/skills]
up: "[[07_PROFIL (Professional Identity)/index]]"
date: 2026-04-17
---

# Skills & Stack Teknis

## Backend

- Bahasa: **Python** (utama — Django, DRF, scripting), **Go** (in progress — GO_WHATSAPP_API)
- Framework: Django 3.2 + Django REST Framework, Gunicorn
- Protocol: MQTT (`paho-mqtt`, Mosquitto broker), REST API
- Database: **PostgreSQL** (PDAM — `dbflowmeter`), **MySQL** (WeatherApp — `weather_app`, via PyMySQL)

## Infrastructure & DevOps

- VPS: Biznet, Hostinger
- On-premise: **Proxmox VE** — virtualisasi untuk lingkungan sandbox pengujian fitur baru secara terisolasi
- VPN: WireGuard
- Container: **Docker** + **docker-compose** (semua project pakai ini)
- Scheduler: **Supercronic** (PDAM), **django-crontab** (WeatherApp)
- Cache: **Redis 7** (PDAM — stateful alert, session)
- OS: Linux (EndeavourOS/Arch, Debian)

## Monitoring & IoT

- Weather monitoring system
- CCTV integration
- MQTT broker

## Data Engineering & Scientific Data

- Ekstraksi dan parsing format data saintifik: **NetCDF**, **Weatherlink**
- Data mining untuk pengolahan data presipitasi (curah hujan)
- Pipeline dari raw scientific format → data siap pakai untuk analisis/prediksi

## Machine Learning

- Prediction model (terintegrasi ke weather app)
- Input data: hasil olahan dari NetCDF/Weatherlink
- *(detail model/library perlu dilengkapi)*

---

> **Catatan:** Bagian bertanda *perlu dilengkapi* harus diisi manual oleh Naufal untuk akurasi resume.
