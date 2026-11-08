# Rencana Manual Testing, Black-box Testing, dan Bug Tracking

> Status awal: **belum dijalankan** di perangkat pengguna. Tandai Pass/Fail berdasarkan hasil nyata setelah `flutter run` dan backend API aktif. Jangan mengisi hasil yang belum diuji sebagai keberhasilan.

## A. Manual Testing (minimal 10 test case)

| ID | Fitur | Langkah uji | Hasil yang diharapkan | Hasil aktual |
|---|---|---|---|---|
| MT-01 | Beranda | Buka aplikasi | Header biru, logo, banner, dan menu tampil | Belum diuji |
| MT-02 | Header sticky | Scroll beranda ke bawah | Header tetap berada di bagian atas | Belum diuji |
| MT-03 | Slider banner | Geser banner ke kiri/kanan | Banner berpindah dan indikator mengikuti | Belum diuji |
| MT-04 | Slider karya | Geser daftar karya secara horizontal | Karya dapat dijelajahi tanpa tombol panah | Belum diuji |
| MT-05 | Navigasi Profil | Pilih menu Profil | Halaman Profil tampil | Belum diuji |
| MT-06 | Navigasi Portofolio | Pilih menu Portofolio | Daftar karya tampil | Belum diuji |
| MT-07 | Dropdown POLIJE | Buka Tentang POLIJE dan pilih program studi | Pilihan dropdown berubah | Belum diuji |
| MT-08 | Tambah portofolio | Isi formulir valid dan simpan saat backend aktif | Data tersimpan dan muncul di daftar | Belum diuji |
| MT-09 | Edit portofolio | Edit karya dari backend | Perubahan tersimpan dan tampil | Belum diuji |
| MT-10 | Hapus portofolio | Pilih hapus dan konfirmasi | Dialog muncul; data terhapus setelah konfirmasi | Belum diuji |
| MT-11 | Pengaturan | Ubah mode terang/gelap | Tema aplikasi berubah | Belum diuji |
| MT-12 | Responsivitas | Uji layar sempit dan tablet | Tidak ada overflow horizontal; konten tetap terbaca | Belum diuji |

## B. Black-box Testing (minimal 5 test case)

| ID | Input | Proses yang terlihat | Output yang diharapkan | Hasil aktual |
|---|---|---|---|---|
| BB-01 | Ketuk menu Profil | Aplikasi berpindah halaman | Halaman Profil ditampilkan | Belum diuji |
| BB-02 | Geser banner | PageView berpindah | Banner dan indikator berubah bersama | Belum diuji |
| BB-03 | Pilih program studi di dropdown | Nilai pilihan berubah | Nama pilihan baru tampil di kartu informasi | Belum diuji |
| BB-04 | Simpan form dengan field wajib kosong | Validasi form dijalankan | Data tidak dikirim dan pesan validasi muncul | Belum diuji |
| BB-05 | Konfirmasi hapus data backend | Aplikasi mengirim permintaan delete | Data hilang dari daftar jika API berhasil | Belum diuji |

## C. Bug Tracking

Isi bagian ini berdasarkan bug yang benar-benar ditemukan saat pengujian. Jangan mengklaim bug telah ditemukan atau diperbaiki tanpa reproduksi dan pengujian ulang.

| Bug ID | Fitur | Deskripsi & langkah reproduksi | Severity | Perbaikan | Retest/status |
|---|---|---|---|---|---|
| BUG-001 |  |  |  |  | Belum diuji |
| BUG-002 |  |  |  |  | Belum diuji |
| BUG-003 |  |  |  |  | Belum diuji |
| BUG-004 |  |  |  |  | Belum diuji |
| BUG-005 |  |  |  |  | Belum diuji |

Catat minimal lima bug nyata beserta severity, langkah reproduksi, perubahan yang dilakukan, dan hasil retest sesuai instruksi tugas.
