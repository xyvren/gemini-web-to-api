# Panduan Penyiapan Gemini Cookie Sync (Chrome Extension)

Panduan praktis untuk mengekstrak data autentikasi dan cookie sesi Google Gemini aktif ke proyek **`gemini-web-to-api`**.

---

## 📌 Apa yang Diekspor oleh Ekstensi Ini?

Ekstensi browser ini membaca sesi login aktif Google Gemini Anda di browser dan mengekstrak:

- **Cookie Sesi Google:** `SID`, `HSID`, `SSID`, `APISID`, `SAPISID`, `__Secure-1PSID`, dsb.
- **`SAPISID`:** Token otorisasi permintaan origin Google.
- **`SNlM0e` (`xsrf_token`):** Token proteksi formulir web Google Gemini.
- **`cfb2h` (`gemini_bl`):** Nomor build server Gemini terbaru.
- **`auth_user`:** Indeks pengguna aktif akun Google (contoh: `0` atau `1`).

Semua data ini disimpan secara lokal di komputer Anda dalam file bernama **`gemini-auth.json`**. Data tidak pernah dikirimkan ke server pihak ketiga mana pun.

---

## 🚀 Cara Memasang & Mengekspor

1. Buka browser berbasis Chromium (Google Chrome, Microsoft Edge, Brave, dll.).
2. Akses halaman ekstensi melalui URL: `chrome://extensions/`.
3. Aktifkan sakelar **Mode Pengembang (Developer mode)** di pojok kanan atas.
4. Klik tombol **Muat yang belum dibongkar (Load unpacked)**.
5. Arahkan dan pilih folder **`gemini-cookie-sync-extension`**.
6. Buka tab baru dan akses: [https://gemini.google.com/app](https://gemini.google.com/app).
7. Pastikan Anda telah login ke akun Google (disarankan akun Gemini Advanced jika ingin mengakses model Pro) lalu muat ulang (*refresh*) halaman.
8. Klik ikon puzzle ekstensi di toolbar browser, lalu buka **Gemini Cookie Sync**.
9. Klik tombol **Inspect session** untuk memeriksa kelengkapan sesi.
10. Pastikan status menampilkan tanda siap (*ready*), contoh:
    ```text
    XSRF / SNlM0e: present
    gemini_bl / cfb2h: present
    Session and XSRF are ready for export.
    ```
11. Klik tombol **Export gemini-auth.json**. File akan otomatis terunduh ke folder `Downloads` komputer Anda.

---

## ⚙️ Cara Menerapkan ke `gemini-web-to-api`

### 1. Pindahkan File ke Folder Proyek

Pindahkan file `gemini-auth.json` yang baru saja didownload ke folder utama proyek `gemini-web-to-api`:

- **Di Windows (File Explorer):**  
  Salin file `gemini-auth.json` dari folder `Downloads` ke folder proyek `gemini-web-to-api`.

- **Melalui Terminal (Bash / Git Bash):**
  ```bash
  cd /path/to/gemini-web-to-api
  cp ~/Downloads/gemini-auth.json ./gemini-auth.json
  ```

---

### 2. Hubungkan ke Konfigurasi (`config.json`)

Buka file `config.json` di folder utama proyek `gemini-web-to-api` dan atur parameter `cookie_file` ke file tersebut:

```json
{
  "port": 8081,
  "host": "127.0.0.1",
  "cookie_file": "gemini-auth.json",
  "auth_user": null,
  "xsrf_token": null,
  "default_model": "gemini-3.6-flash",
  "api_keys": [],
  "proxy": null,
  "log_requests": true,
  "temporary_chats": true
}
```

> **Catatan:** Server secara otomatis membaca cookie, `auth_user`, `xsrf_token`, dan `gemini_bl` langsung dari dalam `gemini-auth.json` jika nilainya belum ditentukan di `config.json`.

---

## 🧪 Menjalankan & Menguji Model Pro

1. **Jalankan server:**
   ```bash
   # Menggunakan executable portable:
   start-portable.bat

   # Atau menggunakan Python:
   python gemini_web2api.py --config config.json
   ```

2. **Uji coba pemanggilan model `gemini-3.1-pro`:**
   ```bash
   curl http://127.0.0.1:8081/v1/chat/completions      -H "Content-Type: application/json"      -d '{
       "model": "gemini-3.1-pro",
       "messages": [
         {"role": "user", "content": "Halo Gemini Pro, apakah autentikasi berhasil?"}
       ]
     }'
   ```

---

## 🛡️ Keamanan & Privasi

- File **`gemini-auth.json`** merepresentasikan sesi login Google asli Anda.
- **JANGAN** pernah membagikan isi file ini, mengunggahnya ke internet, atau melakukan commit ke Git publik.
- File `gemini-auth.json` telah secara otomatis didaftarkan di file `.gitignore` agar tidak sengaja terunggah ke repositori GitHub.
