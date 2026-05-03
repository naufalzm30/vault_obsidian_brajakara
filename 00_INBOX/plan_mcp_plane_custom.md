---
type: detail
category: inbox
tags: [plane, mcp, integration, pi-extension]
date: 2026-05-03
---

# Plan: Custom Plane Integration (pi Extension)

## Tujuan
MCP server Python yang jadi jembatan antara Claude dan Plane (`plane.blitztechnology.tech`), sehingga Claude bisa manage issues langsung saat diskusi — tanpa buka browser.

## Stack
- **Python 3.10+** + `mcp` SDK + `httpx`
- Transport: **stdio** (lokal, Claude Code CLI)
- Target: Plane REST API di `plane.blitztechnology.tech`

## Arsitektur
```
Claude Code (diskusi)
    ↓ manggil tool
MCP Server (Python, jalan lokal)
    ↓ HTTP request
Plane REST API
    ↓
plane.blitztechnology.tech
```

## Config
- `PLANE_BASE_URL`: `https://plane.blitztechnology.tech`
- `PLANE_API_KEY`: *(dari env variable, jangan hardcode)*
- `PLANE_WORKSPACE_SLUG`: `brajakara`

---

## Phase 1 — Setup & Test Koneksi
- [ ] Buat folder project, init venv
- [ ] `pip install mcp httpx`
- [ ] Test manual: `GET /api/v1/workspaces/{slug}/projects/` → pastikan API key valid
- [ ] **Stop di sini kalau gagal** — fix auth dulu sebelum lanjut

## Phase 2 — Tools Inti
- [ ] `list_projects` — ambil semua project + ID
- [ ] `create_issue(project_id, title, description?, priority?)` — bikin work item baru
- [ ] `list_issues(project_id, filters?)` — lihat issues, bisa filter status/priority
- [ ] `get_issue(project_id, issue_id)` — detail satu issue
- [ ] `update_issue(project_id, issue_id, **fields)` — update status, priority, label, start_date, due_date

## Phase 3 — Register ke Claude Code
```bash
claude mcp add plane-custom -- python /path/to/plane_mcp/server.py
```
- Set env vars di `.claude.json` atau export sebelum jalanin Claude Code
- Test dari Claude: *"list semua projects di Plane"*

## Phase 4 — Tools Tambahan (Opsional)
- [ ] `add_label(project_id, issue_id, label_id)`
- [ ] `list_labels(project_id)`
- [ ] `list_cycles(project_id)` + `add_to_cycle`
- [ ] `bulk_update_issues` — update banyak sekaligus

---

## Kemungkinan Berhasil
**~90%** — Plane punya REST API lengkap, MCP SDK sudah mature, ini murni CRUD wrapper.
Risiko utama hanya di auth header / endpoint path — bukan masalah fundamental.

## Catatan
- MCP server ini jalan di laptop/mesin yang sama dengan Claude Code
- Bukan di VPS — karena transport stdio butuh proses lokal
- Kalau mau remote (dari claude.ai web), perlu ganti ke HTTP/SSE transport (bisa dikerjakan di Phase 5 nanti)
