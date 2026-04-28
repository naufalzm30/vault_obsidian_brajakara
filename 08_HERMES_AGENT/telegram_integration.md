# Telegram Integration

Integrasi bot Telegram untuk Brajakara.

## Detail Bot
- **Bot Token**: (Disimpan di `~/.hermes/.env` — JANGAN simpan plain text di sini)
- **Status**: Perlu setup via `hermes gateway setup`

## Cara Setup
1. Jalankan `hermes gateway setup` pilih Telegram.
2. Masukkan API Token dari BotFather.
3. Install service: `hermes gateway install`.
4. Cek status: `hermes gateway status`.

## Troubleshooting
- Jika bot silent: Pastikan update token di `~/.hermes/.env`.
- Cek log: `tail -f ~/.hermes/logs/gateway.log`
