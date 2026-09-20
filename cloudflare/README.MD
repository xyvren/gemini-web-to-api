# gemini-web-to-api - Panduan Deployment Cloudflare Workers

<p align="center">
  <a href="https://github.com/xyvren/gemini-web-to-api"><img src="https://img.shields.io/badge/GitHub-xyvren%2Fgemini--web--to--api-2563eb?style=flat&logo=github" alt="GitHub Repository"></a>
  <a href="https://workers.cloudflare.com/"><img src="https://img.shields.io/badge/Platform-Cloudflare%20Workers-f38020?style=flat&logo=cloudflare" alt="Cloudflare Workers"></a>
  <a href="../LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
</p>

<p align="center">
  <a href="README_CN.md">中文文档</a> • <a href="../README.md">Dokumentasi Utama Proyek</a>
</p>

---

## 📖 Ringkasan Proyek

**gemini-web-to-api (Cloudflare Workers Edition)** adalah layanan proxy tanpa server (*serverless reverse-proxy*) yang mengubah antarmuka web publik Google Gemini menjadi endpoint API standar yang 100% kompatibel dengan format **OpenAI API**.

Layanan ini berjalan sepenuhnya di jaringan edge Cloudflare: **tanpa memerlukan server pribadi**, gratis (hingga 100.000 request per hari), dan siap digunakan untuk menghubungkan berbagai aplikasi AI klien.

---

## ✨ Fitur Utama

- **Deployment Bebas Biaya:** Memanfaatkan paket gratis Cloudflare Workers tanpa perlu kartu kredit atau server VPS.
- **Akselerasi Jaringan Global:** Didistribusikan secara otomatis ke 300+ lokasi pusat data edge Cloudflare di seluruh dunia.
- **100% OpenAI Compatible:** *Drop-in replacement* untuk endpoint `/v1/chat/completions` dan `/v1/models`.
- **Real-time SSE Streaming:** Respons teks mengalir langsung secara live per-token (*typewriter effect*).
- **Rotasi Multi-Fingerprint:** 8 variasi browser fingerprint + 6 preferensi bahasa secara acak untuk meminimalkan risiko deteksi anti-bot Google.
- **Rotasi Multi-Cookie:** Mendukung konfigurasi banyak akun Google sekaligus dengan pemilihan acak otomatis pada tiap request.
- **Aman Konkurensi (*Concurrency-Safe*):** Isolasi konfigurasi per-request sehingga tidak terjadi tabrakan konfigurasi pada trafik tinggi.
- **Dukungan Tool Calling:** Kompatibel dengan format OpenAI Function Calling.

---

## 🎯 Skenario Penggunaan

- Menyediakan endpoint API gratis untuk aplikasi klien seperti **Cherry Studio**, **ChatBox**, **NextChat**, **OpenWebUI**, **Cursor**, atau **Cline**.
- Sebagai backend model AI untuk ekstensi peramban, asisten virtual, atau skrip otomasi pribadi.
- Eksperimen dan riset pengembangan AI tanpa biaya langganan API berbayar.

---

## 🚀 Panduan Cepat Deployment

### Langkah 1: Buka Cloudflare Dashboard
1. Akses [Cloudflare Dashboard](https://dash.cloudflare.com) dan login ke akun Anda (daftar gratis jika belum memiliki akun).
2. Di panel menu navigasi sebelah kiri, pilih **Workers & Pages**.

### Langkah 2: Buat Worker Baru
1. Klik tombol **Create Application** (Buat Aplikasi) → pilih tab **Workers** → klik **Create Worker**.
2. Berikan nama untuk Worker Anda (misalnya: `gemini-api`).
3. Klik tombol **Deploy**.
4. Setelah selesai dibuat, klik tombol **Edit code** (Edit kode).
5. Hapus seluruh kode bawaan yang ada di editor.
6. Buka file [`worker.js`](worker.js) di repository ini, salin seluruh kodenya, dan tempelkan ke editor Cloudflare.
7. Klik tombol **Save and deploy** di pojok kanan atas.

### Langkah 3: Dapatkan Alamat API Anda
Setelah berhasil dideploy, Worker Anda dapat diakses melalui domain publik:

```text
https://<nama-worker>.<subdomain-akun>.workers.dev
```

*Contoh: `https://gemini-api.myaccount.workers.dev`*

### Langkah 4: Verifikasi Status Deployment
Buka URL health check di browser Anda:

```text
https://<nama-worker>.<subdomain-akun>.workers.dev/health
```

Jika deployment berhasil, Anda akan melihat respons JSON seperti berikut:

```json
{
  "status": "ok",
  "version": "1.5.0-cf-multifingerprint",
  "platform": "Cloudflare Workers",
  "models": ["gemini-3.6-flash", "gemini-3.5-flash", "gemini-3.5-thinking", "..."],
  "hasCookie": false,
  "hasSapisid": false
}
```

---

## 🔧 Konfigurasi Aplikasi Klien

### 1. NextChat (ChatGPT-Next-Web)
| Parameter | Nilai Konfigurasi |
| :--- | :--- |
| **Model Provider** | OpenAI |
| **Endpoint / Base URL** | `https://<nama-worker>.workers.dev/v1` |
| **API Key** | `sk-gemini` *(atau kunci yang Anda tentukan di env)* |
| **Model** | `gemini-3.6-flash` atau `gemini-3.5-flash-thinking` |

### 2. Cherry Studio
| Parameter | Nilai Konfigurasi |
| :--- | :--- |
| **API Provider** | OpenAI Compatible |
| **API URL / Host** | `https://<nama-worker>.workers.dev/v1` |
| **API Key** | `sk-gemini` |
| **Model ID** | `gemini-3.6-flash` |

### 3. ChatBox
| Parameter | Nilai Konfigurasi |
| :--- | :--- |
| **Model Provider** | OpenAI API |
| **API Host** | `https://<nama-worker>.workers.dev` |
| **API Path** | `/v1/chat/completions` |
| **API Key** | `sk-gemini` |

---

## 🧪 Contoh Pengujian dengan cURL

**Request Non-Streaming:**
```bash
curl https://<nama-worker>.workers.dev/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer sk-gemini"   -d '{
    "model": "gemini-3.6-flash",
    "messages": [{"role": "user", "content": "Halo! Siapa kamu?"}],
    "stream": false
  }'
```

**Request Real-Time SSE Streaming:**
```bash
curl -N https://<nama-worker>.workers.dev/v1/chat/completions   -H "Content-Type: application/json"   -H "Authorization: Bearer sk-gemini"   -d '{
    "model": "gemini-3.6-flash",
    "messages": [{"role": "user", "content": "Ceritakan ringkasan singkat sejarah komputer."}],
    "stream": true
  }'
```

---

## ⚙️ Konfigurasi Environment Variables (Opsional)

Untuk kustomisasi tingkat lanjut, buka Cloudflare Dashboard:  
**Workers & Pages** → pilih Worker Anda → **Settings** → **Variables and Secrets** → **Add variable**.

### 1. Kredensial & Autentikasi
| Nama Variabel | Deskripsi | Contoh Nilai |
| :--- | :--- | :--- |
| **`API_KEYS`** | Daftar whitelist API Key dalam format JSON array | `["sk-gemini", "kunci-rahasia-saya"]` |
| **`COOKIE_STRING`** | String Cookie Gemini (pisahkan dengan `\|` jika banyak) | `cookie_akun1\| cookie_akun2` |
| **`SAPISID`** | Nilai token SAPISID (pisahkan dengan `\|` jika banyak) | `sapisid_1\| sapisid_2` |

### 2. Pengaturan Gemini
| Nama Variabel | Deskripsi | Default / Contoh |
| :--- | :--- | :--- |
| **`GEMINI_BL`** | Build label backend Gemini (perbarui jika muncul error 405) | `boq_assistant-bard-web-server_20260730.02_p0` |
| **`DEFAULT_MODEL`**| Model default yang digunakan | `gemini-3.6-flash` |
| **`AUTH_USER`** | Indeks profil akun Google (jika multi-profil) | `0` |

### 3. Optimasi Performa & Keamanan
| Nama Variabel | Deskripsi | Nilai Default |
| :--- | :--- | :--- |
| **`RETRY_ATTEMPTS`** | Jumlah percobaan ulang jika terjadi kegagalan | `3` |
| **`RETRY_DELAY_SEC`** | Jeda antar percobaan ulang (detik) | `2` |
| **`REQUEST_TIMEOUT_SEC`** | Batas waktu timeout request (detik) | `28` |
| **`FINGERPRINT_JITTER_MS`**| Variasi jeda acak pra-request untuk meniru manusia | `1500` (ms) |
| **`RATE_LIMIT_MAX`** | Batas maksimal request per window | `3000` |
| **`RATE_LIMIT_WINDOW`** | Jendela waktu rate limiting (detik) | `60` |

---

## 🍪 Mengambil Cookie Akun Gemini (Opsional untuk Model Pro)

### Mengapa Memerlukan Cookie?
Request anonim rentan terkena pembatasan frekuensi (*HTTP 429 Too Many Requests*). Menggunakan cookie akun Google:
- Menghindari pembatasan laju request anonim.
- Membuka akses ke rute penalaran model Pro secara optimal (memerlukan langganan Gemini Advanced).
- Menyediakan stabilitas koneksi yang lebih andal.

### Langkah Pengambilan Cookie Manual:
1. Buka browser Chrome atau Edge.
2. Kunjungi [https://gemini.google.com/app](https://gemini.google.com/app) dan login ke akun Google Anda.
3. Tekan **F12** untuk membuka Developer Tools.
4. Buka tab **Application** (atau Penyimpanan).
5. Pada panel samping kiri, pilih **Cookies** → `https://gemini.google.com`.
6. Cari dan salin nilai dari cookie berikut:
   - `__Secure-1PSID`
   - `__Secure-3PSID`
   - `SAPISID`
7. Gabungkan menjadi format satu baris:
   ```text
   __Secure-1PSID=nilai_1psid; __Secure-3PSID=nilai_3psid; SAPISID=nilai_sapisid
   ```

*(Atau gunakan ekstensi Chrome bawaan di folder `../gemini-cookie-sync-extension/` untuk mengekspor otomatis).*

---

## 🔄 Mengatasi Error HTTP 405 (Update BL Version)

Jika Anda mendapatkan pesan error `HTTP 405: Method Not Allowed`, ini menandakan build version backend Google Gemini telah diperbarui:

1. Buka browser dan akses [https://gemini.google.com/app](https://gemini.google.com/app).
2. Tekan **F12** → buka tab **Network**.
3. Ketik `boq_assistant` di kolom filter pencarian network request.
4. Salin nomor versi build terbaru dari URL, contoh:
   ```text
   boq_assistant-bard-web-server_20260730.02_p0
   ```
5. Perbarui nilai variabel lingkungan **`GEMINI_BL`** di pengaturan Cloudflare Worker Anda.

---

## 🎭 Mekanisme Rotasi Fingerprint Peramban

Worker ini dilengkapi modul emulasi peramban otomatis untuk mencegah pemblokiran:

| Komponen Fingerprint | Variasi | Keterangan |
| :--- | :--- | :--- |
| **User-Agent** | 8 varian | Bobot acak menyesuaikan statistik pangsa pasar peramban modern |
| **Accept-Language** | 6 varian | Meniru keragaman demografis wilayah pengguna |
| **Sec-Ch-Ua** | 3 varian | Header Client Hints modern (disesuaikan dengan Chrome UA) |
| **Jitter Delay** | 0-1500 ms | Menambahkan jeda waktu mikro alami sebelum mengirim request |

---

## 📊 Daftar Model yang Didukung

| Model ID | Mode | Keterangan |
| :--- | :--- | :--- |
| `gemini-3.6-flash` | FAST | Model serbaguna default stabil |
| `gemini-3.5-flash` | FAST | Alias untuk model 3.6 Flash |
| `gemini-3.5-flash-thinking` | THINKING | Model dengan penalaran mendalam (*Extended Thinking*) |
| `gemini-3.1-pro` | PRO | Mode Pro (*membutuhkan Cookie Google*) |
| `gemini-auto` | AUTO | Penentuan model otomatis oleh sistem Gemini |
| `gemini-3.5-flash-thinking-lite` | DYNAMIC | Mode penalaran dinamis adaptif |
| `gemini-flash-lite` | LITE | Model paling ringan dengan latensi terendah |

> **Kontrol Thinking Depth:** Anda dapat menambahkan suffix `@think=N` (0 = terdalam, 4 = teringkas) pada nama model, contoh: `gemini-3.6-flash@think=0`.

---

## ❓ Tanya Jawab & Troubleshooting (FAQ)

### Q: Muncul pesan `empty response from server` di NextChat
**Penyebab:** Masalah parser SSE pada klien lama.  
**Solusi:** Pastikan kode `worker.js` Anda menggunakan versi terbaru dari repository ini yang telah memformat SSE secara baku.

### Q: Menerima respons `HTTP 429: Too Many Requests`
**Penyebab:** Permintaan anonim telah mencapai limit Google.  
**Solusi:** Konfigurasikan variabel `COOKIE_STRING` dan `SAPISID` pada pengaturan environment Cloudflare.

### Q: Muncul pesan `invalid api key`
**Penyebab:** Kunci API yang dikirimkan klien tidak sesuai dengan whitelist.  
**Solusi:** Periksa apakah klien Anda mengirimkan header `Authorization: Bearer <key>` yang cocok dengan variabel `API_KEYS` (default: `sk-gemini`).

---

## 📝 Catatan Rilis

| Versi | Pembaruan |
| :--- | :--- |
| **1.5.0** | Penambahan rotasi multi-fingerprint, rotasi multi-cookie, dan jeda mikro acak. |
| **1.4.0** | Perbaikan isolasi konfigurasi konkuren (*concurrency safety*) & memori rate limiter. |
| **1.3.0** | Standardisasi format streaming SSE untuk kompatibilitas penuh NextChat & Cherry Studio. |
| **1.0.0** | Rilis perdana porting Cloudflare Workers berbasis arsitektur v1.1.0. |

---

## 📄 Lisensi

Didistribusikan di bawah lisensi [MIT](../LICENSE) sebagai bagian dari proyek [gemini-web-to-api](https://github.com/xyvren/gemini-web-to-api).
