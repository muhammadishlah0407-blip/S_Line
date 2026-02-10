# S_Line Beauty Care 💄

**S_Line Beauty Care** adalah aplikasi mobile berbasis **Flutter** yang dirancang sebagai platform katalog interaktif untuk produk kosmetik dan perawatan kulit (*skincare*). Aplikasi ini memudahkan pengguna untuk menelusuri berbagai merek kecantikan, melihat detail produk, serta mengelola daftar keinginan (*wishlist*) pribadi.

Proyek ini dikembangkan dan dipublikasikan secara *Open Source* sebagai syarat penyelesaian mata kuliah **Teknologi Open Source** di **Sekolah Tinggi Teknologi Payakumbuh**.

---

## 👨‍💻 Tentang Pengembang

| Informasi | Detail |
| :--- | :--- |
| **Nama** | Novri Ananda Saputra |
| **NIM** | 221013005 |
| **Program Studi** | S-1 Informatika |
| **Kampus** | Sekolah Tinggi Teknologi Payakumbuh |
| **Mata Kuliah** | Teknologi Open Source |

---

## 🚀 Fitur Utama

Aplikasi ini memiliki berbagai fitur yang dirancang untuk memberikan pengalaman pengguna yang optimal:

* **🔐 Autentikasi Pengguna:** Sistem Login dan Registrasi yang aman menggunakan Supabase Auth.
* **🏠 Dashboard Interaktif:** Menampilkan produk unggulan (*featured*) dan navigasi yang intuitif.
* **💄 Katalog Produk:** Daftar lengkap produk kecantikan dengan tampilan *grid*, menampilkan gambar, nama, brand, dan harga.
* **🔍 Pencarian Pintar (*Smart Search*):** Fitur pencarian responsif untuk menemukan produk berdasarkan nama atau kata kunci tertentu.
* **📂 Koleksi Berdasarkan Brand:** Memudahkan pengguna melihat produk spesifik dari merek favorit mereka (misal: Almay, Revlon, dll).
* **❤️ Manajemen Wishlist:** Pengguna dapat menyimpan produk ke daftar favorit (*Likes*) dan menghapusnya kapan saja.
* **👤 Profil Pengguna:** Halaman untuk mengelola informasi akun dan sesi login.

---

## 🛠️ Teknologi yang Digunakan

* **Frontend:** [Flutter](https://flutter.dev/) (Dart SDK)
* **Backend:** [Supabase](https://supabase.com/) (PostgreSQL & Auth)
* **State Management:** `Provider` / `setState`
* **Dependensi Utama:**
    * `supabase_flutter`: Koneksi ke backend.
    * `google_fonts`: Tipografi aplikasi.
    * `flutter_svg`: Rendering aset vektor.

---

## ⚙️ Panduan Instalasi

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di komputer lokal Anda:

### 1. Prasyarat Sistem
Pastikan Anda telah menginstal:
* **Flutter SDK** (Versi Stable terbaru)
* **Git**
* **Visual Studio Code** atau Android Studio
* Akun **Supabase** aktif

### 2. Kloning Repositori
Buka terminal dan jalankan perintah:

```bash
git clone [https://github.com/username-anda/s_line_beauty_care.git](https://github.com/username-anda/s_line_beauty_care.git)
cd s_line_beauty_care
(Catatan: Ganti username-anda dengan username GitHub Anda)

3. Instalasi Dependensi
Unduh semua pustaka yang dibutuhkan:

Bash
flutter pub get
4. Konfigurasi Database (Supabase)
Buat proyek baru di Supabase Dashboard.

Masuk ke menu SQL Editor.

Salin dan jalankan kode dari file sline_schema.sql yang ada di dalam folder proyek ini.

File ini akan membuat tabel users, products, brands, dan favorites serta mengatur kebijakan keamanan (Row Level Security).

5. Konfigurasi Environment
Buat file baru bernama .env di folder utama proyek, lalu isi dengan kredensial Supabase Anda:

Code snippet
SUPABASE_URL=[https://id-proyek-anda.supabase.co](https://id-proyek-anda.supabase.co)
SUPABASE_ANON_KEY=kunci-anon-publik-anda
6. Jalankan Aplikasi
Hubungkan perangkat Android/iOS atau gunakan Emulator, lalu ketik:

Bash
flutter run
🤝 Cara Berkontribusi
Proyek ini terbuka untuk kontribusi! Jika Anda ingin memperbaiki bug atau menambahkan fitur baru (seperti Payment Gateway atau Dark Mode), silakan ikuti langkah berikut:

Fork repositori ini.

Buat Branch baru (git checkout -b fitur-baru).

Lakukan perubahan dan Commit (git commit -m 'Menambahkan fitur X').

Push ke branch Anda (git push origin fitur-baru).

Buat Pull Request di GitHub.

📄 Lisensi
Proyek ini didistribusikan di bawah MIT License. Anda bebas menggunakan, memodifikasi, dan mendistribusikan kode sumber ini untuk keperluan pendidikan maupun komersial.

Dibuat dengan ❤️ oleh Novri Ananda Saputra
