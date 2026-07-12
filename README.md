# Allox Auto Bot 🤖

> Auto-login pakai Web3 wallet signature, auto-chat ke AI, dan farming
> point dari [Allox](https://allox.ai) — dengan laporan Telegram tiap
> 24 jam (opsional).

![Python](https://img.shields.io/badge/Python-3.10%2B-blue?logo=python)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Edukasi-orange)

---

## ✨ Fitur

- 🔐 **Login Web3 signature** — tanpa password, sign nonce dari server
  pakai `eth-account`
- 💬 **Auto-chat** — sampai **20 pesan per akun per siklus 24 jam**
- 📰 **Prompt crypto multi-source** — 4 RSS feed (Cointelegraph, Coindesk,
  Decrypt, Bitcoin.com), diacak tiap siklus, dibungkus natural language
  biar kelihatan kayak pertanyaan user
- 🌐 **Support proxy** — HTTP/HTTPS, dengan auth, opsional per run
- 📊 **Live point tracking** — log terminal berwarna, zona waktu
  `Asia/Jakarta` (WIB)
- 🔁 **Auto-cycle** — semua akun selesai → tidur 24 jam → ulang lagi
- 📩 **Laporan Telegram** *(opsional)* — ringkasan siklus harian
  dikirim ke chat lo

---

## 📁 Struktur project

```
allox-auto-bot/
├── bot.py                  ← entry point
├── telegram.py             ← reporter Telegram (opsional)
├── requirements.txt
├── .env.example            ← copy ke .env
├── accounts.txt.example    ← copy ke accounts.txt
├── proxy.txt.example       ← copy ke proxy.txt
├── .gitignore
└── README.md
```

> ⚠️ **JANGAN PERNAH commit** `accounts.txt`, `proxy.txt`, `.env`, atau
> file `*.session`. Semuanya udah di-exclude `.gitignore`.

---

## 🚀 Cara pakai

### 1. Syarat

- Python **3.10+**
- Daftar private key Ethereum (satu per wallet yang mau lo farming)

### 2. Install

```bash
git clone https://github.com/<username-kamu>/allox-auto-bot.git
cd allox-auto-bot

python3 -m venv .venv
source .venv/bin/activate          # Windows: .venv\Scripts\activate

pip install -r requirements.txt
```

### 3. Konfigurasi

```bash
cp accounts.txt.example accounts.txt
cp proxy.txt.example    proxy.txt       # opsional
cp .env.example        .env            # opsional (Telegram)
```

Edit `accounts.txt`, isi satu private key per baris:

```
0x0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef
0xabcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789ab
```

> Baris yang mulai dengan `#` dan baris kosong di-skip. Awalan `0x`
> boleh ada boleh juga nggak.

### 4. Jalankan

```bash
python bot.py
```

Pas pertama kali jalan, lo ditanya:

```
[19:00:00] [INFO] Select run mode:
  1. Run with proxy
  2. Run without proxy
Choice [1/2]:
```

Pilihan lo disimpan ke `.allox_state.json`, jadi nggak ditanya lagi
di run berikutnya.

Setelah login, log bakal muncul kayak gini:

```
[19:42:08] [SUCCESS] Logged in: 0xFCAd...377c
[19:42:10] [SUCCESS] Chat 1/20 Sent | +10 Pts | Total: 10 | Limit: 19
[19:42:13] [SUCCESS] Chat 2/20 Sent | +10 Pts | Total: 20 | Limit: 18
...
```

Kalau semua akun udah selesai, bot tidur 24 jam terus mulai siklus
berikutnya. Tekan `Ctrl+C` kapan aja buat stop.

---

## 📩 Laporan Telegram (opsional)

Laporan Telegram **mati secara default**. Buat nyalain, isi `.env`:

### Opsi A — Bot API (recommended, paling gampang)

1. Buka Telegram, chat [@BotFather](https://t.me/BotFather), kirim `/newbot`
2. Copy token bot yang dikasih
3. Buka chat sama bot baru lo, kirim `/start` (**wajib!**)
4. Dapetin chat_id lo dari [@userinfobot](https://t.me/userinfobot)
5. Tambahin ke `.env`:

```env
TELEGRAM_BOT_TOKEN=123456:ABC-DEF1234ghIkl-zyx57W2v1u123ew11
TELEGRAM_CHAT_ID=123456789
```

### Opsi B — Telethon userbot (advanced)

Pake ini cuma kalau lo perlu post ke channel/group atas nama akun lo
sendiri. Resiko rate-limit / akun ke-restrict lebih tinggi.

```env
TELEGRAM_API_ID=12345
TELEGRAM_API_HASH=abcdef0123456789...
TELEGRAM_SESSION=allox_reporter
TELEGRAM_CHAT_ID=123456789
```

> `TELEGRAM_SESSION` itu nama file (nggak pake path) — Telethon bikin
> otomatis pas run pertama dan minta nomor HP lo. Cuma sekali aja.

### Format laporan

Tiap 24 jam, lo bakal dapet pesan kayak gini:

```
📊 Allox Auto Bot — Cycle #1 Report
🕐 2026-07-12 19:00:00 WIB → 2026-07-12 19:42:00 WIB

───────────────────────────────────────────
| Akun sukses  | 1                          |
| Akun gagal   | 2                          |
───────────────────────────────────────────

⚠️ Detail Kegagalan
  • 0xFCAd...377c — Invalid private key length: 8 hex chars (expected 64)
  • 0x9B12...aa91 — Failed to fetch nonce (network / proxy / API error)

🛠 Solusi Umum
  • Invalid private key length: ... → Cek format key di accounts.txt — harus 64 hex char (0x prefix opsional).
  • Failed to fetch nonce ... → Cek koneksi/proxy, atau tunggu beberapa menit.
```

Teks yang sama juga **selalu di-print ke terminal**, jadi lo punya
copy lokal meskipun Telegram belum di-konfigurasi.

---

## ⚙️ Referensi konfigurasi

Semua setting dibaca dari environment variable (atau `.env`).

| Variable               | Default                        | Keterangan                          |
|------------------------|--------------------------------|--------------------------------------|
| `ALLOX_API_BASE`       | `https://api.allox.ai/v1`      | Root API (override untuk testnet)   |
| `RSS_FEEDS`            | *(lihat di bawah)*             | Daftar RSS, pisahkan pakai koma      |
| `PROMPT_TEMPLATES`     | *(lihat di bawah)*             | Template prompt, pisahkan pakai `\|` |
| `TELEGRAM_BOT_TOKEN`   | *(kosong)*                     | Token Bot API                       |
| `TELEGRAM_CHAT_ID`     | *(kosong)*                     | Target chat / user / channel        |
| `TELEGRAM_API_ID`      | *(kosong)*                     | Telethon api_id                     |
| `TELEGRAM_API_HASH`    | *(kosong)*                     | Telethon api_hash                   |
| `TELEGRAM_SESSION`     | *(kosong)*                     | Nama file session Telethon          |
| `TELEGRAM_PARSE_MODE`  | `HTML`                         | `HTML`, `Markdown`, atau kosong     |

Kalau `TELEGRAM_BOT_TOKEN` dan variabel Telethon di-set barengan, Bot
API yang dipake.

### RSS feed

Default feed-nya:

```
https://cointelegraph.com/rss
https://www.coindesk.com/arc/outboundfeeds/rss/
https://decrypt.co/feed
https://news.bitcoin.com/feed/
```

Tiap siklus, feed di-coba **urutannya diacak** — jadi kalau satu mati
atau ke-rate-limit, feed berikutnya langsung ngeganti. Judul yang
sama dari feed berbeda di-dedup.

Buat pake feed sendiri, set `RSS_FEEDS` di `.env`:

```env
RSS_FEEDS=https://cointelegraph.com/rss,https://decrypt.co/feed,https://my-fav-feed.example.com/rss
```

### Template prompt

Judul mentah dibungkus di template natural language secara acak, biar
keliatan kayak pertanyaan user bukan copy-paste judul berita. Template
default:

```
Can you explain this crypto news: {title}?
What are your thoughts on this event: {title}?
Summarize the impact of this headline: {title}
Is this bullish or bearish for the market: {title}?
Provide a brief analysis on this news: {title}
```

Buat customize, set `PROMPT_TEMPLATES` di `.env` (pake `|` sebagai
pemisah, `{title}` jadi placeholder):

```env
PROMPT_TEMPLATES=Jelasin headline ini: {title}|Menurut lo gimana: {title}?|Ringkas berita ini: {title}
```

---

## 🛠 Troubleshooting

| Masalah                                   | Solusi                                                                 |
|-------------------------------------------|------------------------------------------------------------------------|
| `No nonce in response`                    | Skema API berubah. Edit `request_nonce()` di `bot.py`.                |
| `No token in response`                    | Skema API berubah. Edit `login()` di `bot.py`.                        |
| `Proxy error` / `SSL error`               | Proxy-nya mati. Ganti di `proxy.txt` atau jalan tanpa proxy.          |
| `Request failed after 3 attempts`         | Network/timeout. Cek internet, coba proxy lain.                       |
| `Invalid private key length`              | Key di `accounts.txt` salah. Harus 64 hex char (0x boleh, boleh ngga).|
| `Signing failed`                          | `pip install -U eth-account`                                          |
| `All RSS feeds failed`                    | Semua sumber RSS down. Bot fallback ke prompt statis dan tetap jalan. |
|                                           | Cek internet, atau override `RSS_FEEDS` ke feed yang masih hidup.     |
| `Only got N prompts from RSS, padding`    | Beberapa feed balikin lebih sedikit dari yang diharapkan. Siklus tetap |
|                                           | jalan normal.                                                          |
| Telegram: laporan nggak masuk             | Cek nilai `.env`. Buat Bot API, pastikan udah kirim `/start` ke bot. |
| Telegram: `HTTP 400 parse error`          | Set `TELEGRAM_PARSE_MODE=` (kosong) buat fallback ke plain text.       |

---

## 🔒 Keamanan

- **Private key itu SANGAT sensitif.** Siapapun yang punya key lo,
  bisa kontrol wallet-nya. Jangan pernah share `accounts.txt`, jangan
  commit, jangan upload ke tempat publik.
- `.gitignore` udah exclude `accounts.txt`, `proxy.txt`, `.env`, dan
  `*.session`. Tetap double-check sebelum tiap commit: `git status`
  nggak boleh nampilin file-file itu.
- Jalanin di mesin yang lo percaya. Jangan paste key di shared/cloud
  VM yang nggak lo kontrol.
- Project ini **edukatif**. Pake dengan risiko sendiri dan hormati
  Terms of Service platform target.

---

## 📜 Lisensi

MIT — lihat [LICENSE](LICENSE).
