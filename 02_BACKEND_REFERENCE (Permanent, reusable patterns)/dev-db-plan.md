---
type: reference
category: backend
hop: 2
tags: [backend, database, docker, reference, development]
up: "[[02_BACKEND_REFERENCE (Permanent, reusable patterns)/index]]"
related:
  - "[[01_BACKEND_PROJECTS (Active development)/PDAM_SBY]]"
  - "[[01_BACKEND_PROJECTS (Active development)/BE_WEATHERAPP]]"
---

# Dev Database Portable — Plan

> Tujuan: DB lokal yang portable via Docker, bisa dibangkitkan di mesin manapun untuk debugging Django app tanpa perlu akses prod atau setup manual.

---

## Konsep

- **Static data** → disimpan di `db/init/` (SQL), auto-load saat volume baru
- **Dynamic data** → dibatasi 7 hari terakhir, di-fetch dari prod via SSH tunnel → CSV → import ke container → CSV dihapus
- **Hasil akhir**: DB size kecil, reproducible, tidak perlu koneksi prod setelah fetch

---

## Struktur Direktori

```
project/
├── docker-compose.yml
├── manage.sh                        # Entry point: start/stop/pause/seed
├── config.ini                       # Credentials + config (di .gitignore)
├── config.ini.example               # Template kosong untuk onboarding
└── db/
    ├── init/                        # Auto-run sekali saat volume kosong
    │   ├── 01_schema.sql
    │   ├── 02_accounts.sql
    │   ├── 03_static_data.sql
    │   └── 04_dynamic_data.sql      # Placeholder/kosong awal
    ├── seeds/                       # CSV sementara hasil fetch (di .gitignore)
    │   └── .gitkeep
    └── scripts/
        ├── fetch_from_prod.sh       # SSH tunnel + export CSV dari prod
        ├── import_dynamic.sh        # Import CSV ke postgres, hapus CSV
        └── seed_ulang.sh            # Truncate tabel dynamic + re-import
```

---

## Docker Compose

```yaml
services:
  db:
    image: postgres:16-alpine
    container_name: devdb
    restart: unless-stopped
    environment:
      POSTGRES_DB: myapp_dev
      POSTGRES_USER: devuser
      POSTGRES_PASSWORD: devpass
    volumes:
      - pg_data:/var/lib/postgresql/data
      - ./db/init:/docker-entrypoint-initdb.d:ro
      - ./db/seeds:/seeds
    ports:
      - "5433:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U devuser -d myapp_dev"]
      interval: 5s
      timeout: 5s
      retries: 10

volumes:
  pg_data:
```

> `docker-entrypoint-initdb.d` hanya dieksekusi **sekali** saat volume pertama kali dibuat. Urutan file berdasarkan nama (prefix `01_`, `02_`, dst).

---

## Alur Data

```
[Prod DB] ←SSH Tunnel→ fetch_from_prod.sh → CSV di seeds/
                                                    ↓
                                         import_dynamic.sh
                                                    ↓
                                        [Postgres Docker] → CSV dihapus
```

---

## Scripts

### `config.ini`

Dibaca oleh `fetch_from_prod.sh` via `source` atau parser sederhana.

```ini
[ssh]
SSH_HOST=
SSH_USER=
SSH_KEY=~/.ssh/id_rsa
SSH_LOCAL_PORT=15432

[remote_db]
REMOTE_DB_HOST=127.0.0.1
REMOTE_DB_PORT=5432
DB_NAME=
DB_USER=
DB_PASS=

[dynamic]
DYNAMIC_TABLES=table1 table2 table3
TIMESTAMP_COL=created_at
DAYS=7
```

`config.ini` masuk `.gitignore`. `config.ini.example` di-commit sebagai template.

### `fetch_from_prod.sh`
- Baca config dari `config.ini` (source atau manual parse)
- Buka SSH tunnel ke jump server
- Export tiap tabel dynamic via `\COPY ... TO csv WITH CSV HEADER`
- Filter: `WHERE created_at >= NOW() - INTERVAL '7 days'`
- Tutup tunnel via `trap cleanup EXIT`

### `import_dynamic.sh`
- Jalan **di dalam container**
- Loop tiap CSV di `/seeds/`
- `\COPY table FROM csv WITH CSV HEADER`
- Hapus CSV setelah berhasil import

### `seed_ulang.sh`
- Jalan **di host**, eksekusi via `docker exec`
- `TRUNCATE TABLE ... RESTART IDENTITY CASCADE` (urutan: child dulu, baru parent)
- Panggil `import_dynamic.sh` di dalam container

---

## `manage.sh` — Command Reference

| Command | Aksi |
|---------|------|
| `start` | `docker compose up -d` + tunggu healthcheck |
| `stop` | `docker compose stop` (volume aman) |
| `pause` | `docker compose pause` |
| `resume` | `docker compose unpause` |
| `destroy` | `docker compose down -v` (hapus volume, reset total) |
| `fetch` | Jalankan `fetch_from_prod.sh` |
| `seed` | Jalankan `import_dynamic.sh` di container |
| `reseed` | Truncate + import ulang (jalankan `seed_ulang.sh`) |
| `status` | `docker compose ps` |
| `logs` | `docker compose logs -f db` |
| `psql` | Masuk psql prompt di container |

---

## Cara Pakai (Onboarding Orang Baru)

```bash
# 1. Clone repo
git clone ...

# 2. Minta file CSV seeds dari maintainer (atau fetch sendiri jika punya akses SSH)
./manage.sh fetch   # butuh akses SSH ke prod

# 3. Start DB
./manage.sh start

# 4. Import dynamic data
./manage.sh seed

# 5. Selesai — DB siap di localhost:5433
```

Untuk **update data** (misal setelah beberapa hari):
```bash
./manage.sh fetch    # fetch data baru dari prod
./manage.sh reseed   # truncate + import ulang
```

---

## `.gitignore`

```gitignore
db/seeds/*.csv
!db/seeds/.gitkeep
config.ini
```

---

## TODO / Yang Perlu Disesuaikan

- [ ] Isi config SSH di `fetch_from_prod.sh`
- [ ] Tentukan daftar `DYNAMIC_TABLES` (tabel mana yang masuk kategori 7 hari)
- [ ] Cek nama kolom timestamp di tiap tabel dynamic (default: `created_at`)
- [ ] Tentukan urutan TRUNCATE yang aman (child table dulu sebelum parent)
- [ ] Buat readonly user di prod khusus untuk fetch
- [ ] Export schema prod: `pg_dump --schema-only` → simpan ke `db/init/01_schema.sql`
- [ ] Export static data: `pg_dump --data-only -t nama_tabel` → `03_static_data.sql`
- [ ] Pertimbangkan: apakah `db/seeds/` perlu diisi CSV awal untuk onboarding offline?

---

## Catatan Teknis

- Port `5433` di host (bukan 5432) untuk hindari konflik dengan postgres lokal
- `RESTART IDENTITY CASCADE` pada truncate akan reset sequence/autoincrement
- SSH tunnel pakai `trap cleanup EXIT` agar pasti tertutup meski script error
- `docker-entrypoint-initdb.d` tidak akan re-run jika volume sudah ada → aman untuk `start` berulang
