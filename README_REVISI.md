# POLIJE Student Portfolio — UI Refresh

Pembaruan visual:
- Palet navy–biru–cyan mengikuti referensi pengguna dengan putih sebagai dasar.
- Logo `assets/logo_aplikasi.png` didaftarkan di `pubspec.yaml` dan digunakan pada header halaman.
- Slider karya di beranda tetap bisa digeser, tombol panah kiri/kanan dihapus.
- Aksi utama memakai biru; merah disisakan untuk aksi berbahaya/peringatan.

Struktur sumber disusun sebagai proyek Flutter (`lib/`, `assets/`, `pubspec.yaml`).

Catatan:
- Folder backend PHP/API tidak termasuk pada berkas yang dikirim. CRUD tetap mengarah ke API yang dikonfigurasi di `lib/services/portfolio_service.dart`.
- Jalankan `flutter pub get`, lalu `flutter analyze` dan uji aplikasi di perangkat/emulator. Flutter SDK tidak tersedia di lingkungan penyuntingan ini sehingga build tidak dapat diverifikasi di sini.
