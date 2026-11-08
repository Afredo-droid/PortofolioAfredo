import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class PortfolioService {
  // IP Wi-Fi laptop saat diuji di HP Fisik
  static const String localIp = '10.242.114.56';

  // Mengatur URL API otomatis berdasarkan platform
  static String get apiUrl {
    // 1. Jika di-run di Web (Chrome)
    if (kIsWeb) {
      return 'http://localhost/portfolio_api';
    }

    // 2. Jika di-run di Mobile (Android/iOS)
    // Gunakan localIp Wi-Fi agar HP Fisik bisa mengakses server Laragon
    // Catatan: Jika menguji di EMULATOR Android, ubah 'localIp' di atas menjadi '10.0.2.2'
    return 'http://$localIp/portfolio_api';
  }

  // Mengolah URL gambar agar memanggil folder uploads dengan benar
  static String imageUrl(String? image) {
    if (image == null || image.trim().isEmpty) return '';

    final cleanedImage = image.trim();

    if (cleanedImage.startsWith('http://') ||
        cleanedImage.startsWith('https://')) {
      return cleanedImage;
    }

    if (cleanedImage.startsWith('uploads/') ||
        cleanedImage.startsWith('/uploads/')) {
      final path = cleanedImage.startsWith('/')
          ? cleanedImage.substring(1)
          : cleanedImage;
      return '$apiUrl/$path';
    }

    return '$apiUrl/uploads/$cleanedImage';
  }

  // Mengambil daftar portofolio dari database
  static Future<List<Map<String, dynamic>>> getPortfolios() async {
    final response = await http
        .get(Uri.parse('$apiUrl/tampil.php'))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil data. Status: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }

    if (decoded is Map && decoded['data'] is List) {
      return (decoded['data'] as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    }

    throw Exception('Format respons API tidak sesuai');
  }

  // Menambahkan portofolio baru beserta gambar
  Future<bool> tambahPortfolio({
    required String name,
    required String category,
    required String year,
    required String technology,
    required String description,
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/tambah.php'),
    );

    request.fields.addAll({
      'name': name,
      'category': category,
      'year': year,
      'technology': technology,
      'description': description,
    });

    if (imageBytes != null && imageBytes.isNotEmpty) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName ??
              'portfolio_${DateTime.now().millisecondsSinceEpoch}.png',
        ),
      );
    } else if (imageFile != null && await imageFile.exists()) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    final streamedResponse =
        await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Mengedit portofolio
  Future<bool> editPortfolio({
    required String id,
    required String name,
    required String category,
    required String year,
    required String technology,
    required String description,
    File? imageFile,
    Uint8List? imageBytes,
    String? imageName,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$apiUrl/edit.php'),
    );

    request.fields.addAll({
      'id': id,
      'name': name,
      'category': category,
      'year': year,
      'technology': technology,
      'description': description,
    });

    if (imageBytes != null && imageBytes.isNotEmpty) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName ??
              'portfolio_${DateTime.now().millisecondsSinceEpoch}.png',
        ),
      );
    } else if (imageFile != null && await imageFile.exists()) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );
    }

    final streamedResponse =
        await request.send().timeout(const Duration(seconds: 30));
    final response = await http.Response.fromStream(streamedResponse);

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // Menghapus portofolio
  Future<bool> deletePortfolio(String id) async {
    final response = await http.post(
      Uri.parse('$apiUrl/hapus.php'),
      body: {'id': id},
    ).timeout(const Duration(seconds: 20));

    return response.statusCode == 200;
  }
}
