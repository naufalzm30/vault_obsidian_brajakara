# Docker Compose MinIO

Setup MinIO dengan console GUI di port 9001.

## docker-compose.yml

```yaml
services:
  minio:
    image: quay.io/minio/minio:latest
    container_name: minio
    ports:
      - "127.0.0.1:9000:9000"    # API (Local Only)
      - "127.0.0.1:9001:9001"    # Console GUI (Local Only)
    environment:
      MINIO_ROOT_USER: admin
      MINIO_ROOT_PASSWORD: password_kuat_banget
    volumes:
      - ./data:/data
    command: server /data --console-address ":9001"
    restart: always
```

## Cara Jalankan
1. Simpan di folder baru.
2. `docker compose up -d`.
3. Akses GUI di `http://IP_SERVER:9001`.

↗ Masuk rekam_jejak
