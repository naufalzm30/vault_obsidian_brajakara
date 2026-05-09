---
type: detail
category: infrastructure
hop: 2
tags: [infrastructure/auth, authentik, sso, oauth]
up: "[[04_INFRASTRUCTURE_REFERENCE/index]]"
---

# Authentik SSO — Brajakara Identity Provider

> Self-hosted Identity Provider untuk semua aplikasi Brajakara. Pakai Google OAuth + native Authentik login.

- **URL:** https://auth.blitztechnology.tech
- **Host:** DungeonTower (`10.20.0.11`)
- **Version:** 2024.10.1

---

## Quick Reference

### Direct Login URLs (untuk aplikasi)

| Method | URL | Behavior |
|---|---|---|
| **Login with Google** | `https://auth.blitztechnology.tech/source/oauth/login/google/?next=<REDIRECT_URL>` | Langsung redirect ke Google OAuth, skip UI Authentik |
| **Login with Authentik** | `https://auth.blitztechnology.tech/flows/default-authentication-flow/?next=<REDIRECT_URL>` | Form login Authentik (username/password) |

**Catatan:**
- Ganti `<REDIRECT_URL>` dengan URL aplikasi lo (harus URL-encoded)
- Google OAuth auto-create user di Authentik kalau belum ada
- Semua login tercatat di Authentik events untuk monitoring

---

## Setup di Aplikasi

### Frontend Button Example

```html
<!-- Login with Google -->
<button onclick="location.href='https://auth.blitztechnology.tech/source/oauth/login/google/?next=' + encodeURIComponent(window.location.origin + '/auth/callback')">
  Continue with Google
</button>

<!-- Login with Authentik -->
<button onclick="location.href='https://auth.blitztechnology.tech/flows/default-authentication-flow/?next=' + encodeURIComponent(window.location.origin + '/auth/callback')">
  Sign in with Email
</button>
```

### Backend OAuth2 Integration

Pakai **OAuth2 Provider** dari Authentik:
1. Buat aplikasi baru di Authentik Admin
2. Ambil Client ID + Client Secret
3. Setup OAuth2 flow di backend aplikasi lo

**Endpoint standard OAuth2:**
- Authorization: `https://auth.blitztechnology.tech/application/o/authorize/`
- Token: `https://auth.blitztechnology.tech/application/o/token/`
- User Info: `https://auth.blitztechnology.tech/application/o/userinfo/`

---

## Monitoring User Activity

Semua aktivitas login/signup tercatat di Authentik Events:
- **URL:** https://auth.blitztechnology.tech/if/admin/#/events/log
- Filter by event type: `user_login`, `user_write` (signup)
- Filter by source: `google` (Google OAuth) vs native Authentik

---

## OAuth Sources

| Source | Enabled | Slug | Provider |
|---|---|---|---|
| Continue with Google | ✅ | `google` | Google OAuth2 |

---

## Catatan Teknis

- **Social login (Google)** pakai flow:
  - Authentication: `default-source-authentication`
  - Enrollment: `default-source-enrollment`
- Auto-create user baru dengan email dari Google
- User tetap tercatat di Authentik database → bisa di-manage manual kalau perlu
- Session tracking + audit log otomatis aktif
