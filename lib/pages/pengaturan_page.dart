import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../widgets/page_header.dart';

class PengaturanPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const PengaturanPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: const StickyPageHeader(title: 'Pengaturan', subtitle: 'Preferensi tampilan aplikasi', icon: Icons.tune_rounded),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          const SizedBox(height: 8),

          const Text(
            'Tampilan',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            clipBehavior: Clip.antiAlias,
            child: SwitchListTile(
              value: isDarkMode,
              onChanged: onThemeChanged,
              secondary: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTheme.lightBlue.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  isDarkMode
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: AppTheme.blue,
                ),
              ),
              title: const Text(
                'Mode Gelap',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                isDarkMode
                    ? 'Tampilan gelap sedang aktif'
                    : 'Tampilan terang sedang aktif',
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Text(
            'Tentang Aplikasi',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.gradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.code_rounded, color: Colors.white),
              ),
              title: const Text(
                'My Portfolio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Aplikasi portofolio mahasiswa Teknik Informatika '
                  'untuk menampilkan profil dan hasil karya.',
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Center(
            child: Text(
              'MY PORTFOLIO • TEKNIK INFORMATIKA',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor.withOpacity(0.6),
                fontSize: 11,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
