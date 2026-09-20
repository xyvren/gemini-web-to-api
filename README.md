# gemini-web-to-api

<p align="center">
  <b>Konversi antarmuka Google Gemini Web menjadi API lokal yang kompatibel dengan format OpenAI secara gratis, efisien, dan mandiri.</b>
</p>

<p align="center">
  <a href="https://github.com/xyvren/gemini-web-to-api"><img src="https://img.shields.io/badge/GitHub-xyvren%2Fgemini--web--to--api-2563eb?style=flat&logo=github" alt="GitHub Repository"></a>
  <a href="https://github.com/xyvren/gemini-web-to-api/releases"><img src="https://img.shields.io/badge/Release-v1.1.0%20Portable-10b981?style=flat&logo=windows" alt="Release Portable"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT"></a>
  <a href="https://www.python.org/"><img src="https://img.shields.io/badge/Python-3.8+-38bdf8.svg?logo=python" alt="Python 3.8+"></a>
</p>

<p align="center">
  <a href="README_EN.md">English Documentation</a> •
  <a href="README_CN.md">中文文档</a>
</p>

---

## 📌 Ringkasan

**gemini-web-to-api** adalah jembatan (*reverse-proxy*) ringan yang mengubah antarmuka web publik Google Gemini menjadi endpoint API standar OpenAI (`/v1/chat/completions` dan `/v1/models`).

Dengan proyek ini, Anda dapat menghubungkan kapabilitas model Gemini ke berbagai aplikasi AI klien seperti **Cherry Studio**, **ChatBox**, **NextChat**, **OpenWebUI**, **Cursor**, **Cline**, ataupun skrip otomasi berbasis OpenAI SDK tanpa biaya langganan API berbayar.

---

## ✨ Fitur Utama

- **100% OpenAI Compatible:** *Drop-in replacement* untuk endpoint `/v1/chat/completions` dan `/v1/models`.
- **Dukungan Model Terbaru:** Mendukung model seri **`gemini-3.8`**, **`gemini-3.8-flash`**, **`gemini-3.8-thinking`**, serta lini 3.7 dan 3.6.
- **Graceful Model Fallback:** Mencegah error 400 jika klien meminta nama varian model baru; otomatis diarahkan ke engine model yang aktif.
- **Built-in Web Test Client:** Antarmuka web interaktif lokal (`test-chat.html`) untuk menguji koneksi, model, dan streaming langsung dari browser.
- **Real-time SSE Streaming:** Streaming respons token-by-token menggunakan pustaka `httpx`.
- **Kontrol Kedalaman Berpikir (*Thinking Depth*):** Penyesuaian durasi berpikir model reasoning menggunakan suffix `@think=N` (0 = paling mendalam, 4 = cepat/ringkas).
- **One-Click Windows Launcher:** Disertakan script otomatis (`start-gemini-web2api.bat` dan `open-test-web.bat`) untuk kemudahan penggunaan di Windows.
- **Autentikasi Fleksibel:** Pengamanan endpoint menggunakan Bearer Token lokal (`api_keys`).
- **Akses Anonim:** Berjalan secara default tanpa memerlukan cookie akun Google pribadi.

---

## 📋 Daftar Model yang Didukung

| Model ID | Mode / Deskripsi | Estimasi Output |
| :--- | :--- | :--- |
| **`gemini-3.8`** | Model serbaguna Gemini 3.8 (*Fast mode*) | ~12k karakter |
| **`gemini-3.8-flash`** | Versi Flash Gemini 3.8 berkecepatan tinggi | ~12k karakter |
| **`gemini-3.8-thinking`** | Gemini 3.8 dengan penalaran mendalam (*Extended Thinking*) | ~20k karakter |
| **`gemini-3.7-flash`** | Model Flash generasi 3.7 | ~12k karakter |
| **`gemini-3.6-flash`** | Model default stabil (*recommended fallback*) | ~12k karakter |
| **`gemini-3.5-flash-thinking`** | Penalaran mendalam generasi 3.5 | ~20k karakter |
| **`gemini-3.5-flash-thinking-lite`**| Penalaran dinamis dengan kedalaman adaptif | ~15k karakter |
| **`gemini-flash-lite`** | Model paling ringan dengan latensi terendah | ~10k karakter |
| **`gemini-auto`** | Pemilihan model otomatis oleh sistem Gemini | Bervariasi |
| **`gemini-3.1-pro`** | Mode Pro (*memerlukan cookie akun Gemini Advanced*) | ~12k karakter |

> **Tips Thinking Mode:** Anda dapat menambahkan suffix `@think=0` (terdalam) hingga `@think=4` (tercepat) di belakang nama model saat request, contoh: `gemini-3.8-thinking@think=2`.

---

## 🚀 Panduan Instalasi & Menjalankan

### Persyaratan Sistem
- Sistem Operasi: Windows 10/11, macOS, atau Linux
- Python: Versi 3.8 atau lebih baru
- Git

---

### Cara Cepat (Pengguna Windows)

#### Opsi 1: Versi Portable Standalone (.exe)
Tersedia file executable mandiri tanpa perlu install Python:
- Unduh paket zip dari [Releases](https://github.com/xyvren/gemini-web-to-api/releases) (`gemini-web-to-api-v1.1.0-windows-x64-portable.zip`).
- Ekstrak dan jalankan **`start-portable.bat`** atau double-click **`gemini-web-to-api-portable.exe`**.
- Server langsung aktif dan Web UI pengujian otomatis siap diakses di browser (`http://127.0.0.1:8081/`).
- Untuk membangun ulang file executable ini kapan saja, cukup jalankan **`build-portable.bat`**.

#### Opsi 2: Skrip Batch (.bat)
- Double-click **`start-gemini-web2api.bat`** untuk menyalakan server dengan Python lokal.
- Double-click **`open-test-web.bat`** untuk membuka antarmuka chat di browser.

---

### Cara Manual (CLI / Terminal)

1. **Clone repository:**
   ```bash
   git clone https://github.com/xyvren/gemini-web-to-api.git
   cd gemini-web-to-api
   ```

2. **Buat & aktifkan virtual environment:**
   ```bash
   # Windows (CMD / PowerShell)
   python -m venv .venv
   .venv\Scripts\activate

   # Linux / macOS
   python3 -m venv .venv
   source .venv/bin/activate
   ```

3. **Install dependensi:**
   ```bash
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

4. **Siapkan konfigurasi (`config.json`):**
   Salin dari `config.example.json`:
   ```bash
   cp config.example.json config.json
   ```

5. **Jalankan server:**
   ```bash
   python gemini_web2api.py --config config.json
   ```
   Server akan aktif di:
   - Status & Web UI: `http://127.0.0.1:8081/`
   - Base URL API: `http://127.0.0.1:8081/v1`

---

## 🐳 Docker

Jalankan server menggunakan Docker container:

```bash
cp config.example.json config.json
docker build -t gemini-web-to-api .
docker run -d --name gemini-web-to-api -p 8081:8081 -v ./config.json:/app/config.json gemini-web-to-api
```

Atau gunakan Docker Compose:

```bash
docker compose -f docker-compose.local.yml up -d
```

---

## ⚙️ Konfigurasi (`config.json`)

Contoh file konfigurasi `config.json` untuk penggunaan lokal:

```json
{
  "port": 8081,
  "host": "127.0.0.1",
  "retry_attempts": 3,
  "retry_delay_sec": 2,
  "request_timeout_sec": 180,
  "default_model": "gemini-3.6-flash",
  "api_keys": [
    "sk-gemini-local"
  ],
  "cookie_file": null,
  "proxy": null,
  "log_requests": true,
  "temporary_chats": true
}
```

* **`port`**: Port lokal yang digunakan (default: `8081`).
* **`host`**: Host binding (`127.0.0.1` disarankan untuk keamanan lokal).
* **`api_keys`**: Kunci API yang diperlukan klien (misal: `sk-gemini-local`). Kosongkan array `[]` jika tidak ingin proteksi API Key.
* **`temporary_chats`**: Jika `true`, percakapan tidak disimpan dalam riwayat akun Gemini.
* **`proxy`**: Alamat HTTP/HTTPS proxy jika jaringan Anda memerlukan koneksi proxy (contoh: `"http://127.0.0.1:7890"`).

---

## 🔌 Contoh Penggunaan & Integrasi

### 1. Web Test Client Bawaan
Buka file `test-chat.html` di browser Anda. Anda dapat langsung:
- Memilih model dari dropdown (otomatis memuat dari `/v1/models`).
- Mengetes streaming respons teks.
- Menguji fungsi cancel/stop response dan copy code blocks.

---

### 2. cURL

**Chat Completion:**
```bash
curl http://127.0.0.1:8081/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer sk-gemini-local" \
  -d '{
    "model": "gemini-3.8",
    "messages": [
      {"role": "user", "content": "Halo! Siapa kamu?"}
    ]
  }'
```

**Daftar Model:**
```bash
curl http://127.0.0.1:8081/v1/models \
  -H "Authorization: Bearer sk-gemini-local"
```

---

### 3. Python (OpenAI SDK)

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://127.0.0.1:8081/v1",
    api_key="sk-gemini-local"
)

response = client.chat.completions.create(
    model="gemini-3.8",
    messages=[
        {"role": "user", "content": "Jelaskan konsep dasar komputasi kuantum secara singkat."}
    ]
)

print(response.choices[0].message.content)
```

---

### 4. Cherry Studio / ChatBox / NextChat / Client Lainnya

Masukkan parameter koneksi berikut pada pengaturan penyedia *OpenAI Custom*:

* **API Provider:** OpenAI Compatible
* **Base URL / Host:** `http://127.0.0.1:8081/v1`
* **API Key:** `sk-gemini-local` (sesuai isi `config.json`)
* **Model ID:** `gemini-3.8`, `gemini-3.8-thinking`, atau `gemini-3.6-flash`

---

## 📁 Struktur Folder

```text
gemini-web-to-api/
├── gemini_web2api/              # Modul internal & handler API
│   ├── __main__.py
│   ├── config.py
│   ├── gemini.py
│   ├── models.py                # Definisi & pemetaan model
│   └── server.py
├── config.example.json          # Template konfigurasi
├── gemini_web2api.py            # Skrip server utama
├── requirements.txt             # Dependensi Python
├── test-chat.html               # Antarmuka web pengujian lokal
├── start-portable.bat           # Windows launcher portable sekali klik
├── start-gemini-web2api.bat     # Windows launcher via Python
├── open-test-web.bat            # Shortcut membuka Web UI di browser
├── build-portable.bat           # Skrip build PyInstaller standalone .exe
├── README.md                    # Dokumentasi utama (Bahasa Indonesia)
├── README_EN.md                 # English documentation
└── README_CN.md                 # 中文文档
```

---

## 🛡️ Keamanan & Privasi

1. **Jaringan Lokal:** Server secara default berjalan pada interface loopback `127.0.0.1` sehingga aman dan tidak dapat diakses dari jaringan luar/internet tanpa konfigurasi eksplisit.
2. **Kredensial Sensitif:** File `config.json` dan file sesi lokal lainnya telah dimasukkan ke dalam `.gitignore` agar tidak terunggah ke publik saat Anda melakukan `git push`.
3. **Penyimpanan Cookie:** Proyek ini dapat berjalan penuh dalam mode anonim tanpa perlu mengunggah akun atau kredensial Google Anda.

---

## 📄 Lisensi

Didistribusikan di bawah lisensi [MIT](LICENSE).
