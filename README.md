# POLIJE Student Portfolio — Limited Edition

## Pembaruan UI
- Palet navy–biru–cyan dengan latar putih dan teks berkontras tinggi.
- Header gradasi dengan `assets/logo_aplikasi.png` yang berada di `Scaffold.appBar`, sehingga tetap terlihat saat konten digulir.
- Beranda memakai `PageView` untuk banner, indikator titik, dan slider karya tanpa tombol panah kiri/kanan.
- Menu beranda memakai `Wrap` agar tidak mudah overflow pada layar sempit.
- Halaman Profil, Portofolio, Tentang POLIJE, Pengaturan, dan form Tambah/Edit menggunakan header konsisten.
- Halaman Tentang POLIJE menampilkan dropdown contoh program studi dan tautan ke situs resmi.
- Aksi hapus memakai warna merah; tombol aksi utama tetap biru.
- Lima contoh karya lokal ditampilkan agar tampilan awal tidak kosong. Silakan sesuaikan dua karya contoh terakhir dengan karya nyata sebelum dikumpulkan.

## Menjalankan
1. Pastikan Flutter SDK yang sesuai dengan `environment.sdk` pada `pubspec.yaml` sudah terpasang.
2. Jalankan `flutter pub get`.
3. Jalankan `flutter analyze`.
4. Jalankan `flutter run`.

## Catatan backend
`lib/services/portfolio_service.dart` masih menggunakan endpoint API lokal `http://localhost/portfolio_api` (Android emulator menggunakan `10.0.2.2`). Backend PHP/database tidak termasuk dalam arsip sumber yang dikirim, jadi pastikan backend asli dijalankan dan alamat API sesuai perangkat sebelum menguji CRUD. Jangan menganggap CRUD sudah terverifikasi hanya dari perubahan UI.

## Sumber resmi POLIJE
- https://polije.ac.id/
- https://polije.ac.id/program-studi/
- https://polije.ac.id/pmb/

## Dokumen pengujian
Lihat `docs/TESTING.md` untuk 10 test case manual, 5 test case black-box, dan tabel pencatatan bug. Hasil aktual perlu diisi setelah aplikasi dijalankan dengan backend.


Kompatibilitas: penggunaan `Color.withOpacity()` dipilih agar kompatibel dengan versi Flutter yang lebih luas. Batas Dart pada pubspec dilonggarkan ke >=3.3.0 <4.0.0.
