---
type: detail
category: infrastructure
hop: 2
tags: [infrastructure/registry, docker, storage]
---

# Docker Registry Brajakara

> Repository sentral untuk menyimpan hasil build Docker image Brajakara.

## Informasi Registry
- **URL:** [https://registry-ui.blitztechnology.tech/](https://registry-ui.blitztechnology.tech/)
- **Fungsi:** Tempat menyimpan hasil build image docker (container registry)

## Rencana Implementasi
- Kedepannya, semua hasil build image project backend (BE_WEATHERAPP, BRAJA_PDAMSBY, dll) akan di-push ke registry ini.
- Tujuannya untuk sentralisasi image dan mempermudah deployment ke berbagai server (rockbottom, azkaban, riverstyx, dll).

## Catatan Akses
*(Pastikan credential tersimpan dengan aman di `~/.docker/config.json` atau via secret manager)*
