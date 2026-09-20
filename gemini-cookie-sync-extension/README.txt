Gemini Cookie Sync v1.0

Tujuan:
- Membaca cookie sesi aktif Google Gemini di browser.
- Mengekstrak token XSRF (SNlM0e) dari halaman Gemini.
- Mengekstrak build number gemini_bl (cfb2h) dari halaman web.
- Mengekspor data tersebut ke file lokal `gemini-auth.json`.

Instalasi:
1. Buka chrome://extensions di browser Chrome/Chromium.
2. Aktifkan Mode Pengembang (Developer mode).
3. Klik tombol 'Load unpacked' (Muat yang belum dibongkar).
4. Pilih folder ini (gemini-cookie-sync-extension).
5. Buka https://gemini.google.com/app, login ke akun Google, dan refresh halaman.
6. Buka ekstensi ini lalu klik 'Inspect session'.
7. Klik 'Export gemini-auth.json'.

Keamanan:
File `gemini-auth.json` yang dihasilkan berisi sesi autentikasi Google asli Anda.
Jaga kerahasiaan file tersebut. Jangan pernah membagikan, mencetak, atau mengunggahnya ke Git.
