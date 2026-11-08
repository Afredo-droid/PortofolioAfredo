import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';
import '../widgets/page_header.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.deepNavy;
    final mutedColor = isDark ? Colors.white70 : Colors.blueGrey;
    final cardColor = Theme.of(context).colorScheme.surface;
    final borderColor = isDark ? Colors.white12 : const Color(0xFFDCEAF6);

    return Scaffold(
      appBar: const StickyPageHeader(
        title: 'Profil Saya',
        subtitle: 'Identitas, pendidikan, dan keahlian',
        icon: Icons.person_rounded,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
          children: [
            const SizedBox(height: 8),

            // Kartu Identitas dengan Banner Gradient Selaras Header
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  // Area Banner Gradient & Foto Profil Overlay
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // Banner Gradient disamakan dengan arah dan warna Header
                      Container(
                        height: 95,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    const Color(0xFF0F172A),
                                    const Color(0xFF1E3A8A),
                                  ]
                                : [
                                    AppTheme.darkBlue,
                                    AppTheme.blue,
                                  ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      // Lingkaran Foto Profil yang Menumpuk di Atas Banner
                      Positioned(
                        top: 35,
                        child: Container(
                          width: 118,
                          height: 118,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  cardColor, // Border tebal mengikuti warna latar kartu
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/profile.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppTheme.lightBlue,
                                  alignment: Alignment.center,
                                  child: const Icon(
                                    Icons.person_rounded,
                                    size: 65,
                                    color: AppTheme.darkBlue,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 65), // Spasi penyeimbang posisi foto
                  Text(
                    'Afredo Hidayatulloh',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'Mahasiswa Teknik Informatika',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: mutedColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightBlue.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'D4 Teknik Informatika',
                      style: TextStyle(
                        color: AppTheme.darkBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                ],
              ),
            ),

            const SizedBox(height: 25),
            _sectionTitle('Tentang Saya', textColor),
            const SizedBox(height: 12),

            _flatCard(
              color: cardColor,
              borderColor: borderColor,
              child: Text(
                'Saya adalah mahasiswa D4 Teknik Informatika di '
                'Politeknik Negeri Jember yang tertarik pada '
                'pengembangan aplikasi, teknologi web, dan desain '
                'antarmuka. Melalui berbagai proyek, saya terus '
                'mengembangkan kemampuan teknis, kreativitas, dan '
                'pemecahan masalah.',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.8,
                  color: textColor,
                ),
              ),
            ),

            const SizedBox(height: 25),
            _sectionTitle('Informasi Pendidikan', textColor),
            const SizedBox(height: 12),

            _flatCard(
              color: cardColor,
              borderColor: borderColor,
              child: Column(
                children: [
                  _infoRow(
                    icon: Icons.school_outlined,
                    label: 'Perguruan Tinggi',
                    value: 'Politeknik Negeri Jember',
                    textColor: textColor,
                    mutedColor: mutedColor,
                  ),
                  Divider(height: 25, color: borderColor),
                  _infoRow(
                    icon: Icons.computer_outlined,
                    label: 'Program Studi',
                    value: 'D4 Teknik Informatika',
                    textColor: textColor,
                    mutedColor: mutedColor,
                  ),
                  Divider(height: 25, color: borderColor),
                  _infoRow(
                    icon: Icons.badge_outlined,
                    label: 'NIM',
                    value: 'E41251212',
                    textColor: textColor,
                    mutedColor: mutedColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            _sectionTitle('Minat dan Kemampuan', textColor),
            const SizedBox(height: 12),

            _flatCard(
              color: cardColor,
              borderColor: borderColor,
              child: Wrap(
                spacing: 9,
                runSpacing: 10,
                children: [
                  _skillChip('Flutter'),
                  _skillChip('PHP'),
                  _skillChip('MySQL'),
                  _skillChip('UI/UX Design'),
                  _skillChip('Web Development'),
                ],
              ),
            ),

            const SizedBox(height: 25),
            _sectionTitle('Kontak & Sosial Media', textColor),
            const SizedBox(height: 12),

            _flatCard(
              color: cardColor,
              borderColor: borderColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Temukan dan hubungi saya melalui:',
                    style: TextStyle(
                      color: mutedColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _socialTile(
                    context,
                    icon: Icons.camera_alt_rounded,
                    label: 'Instagram',
                    subtitle: '@afredobarcelo',
                    color: const Color(0xFFE1306C),
                    url: 'https://www.instagram.com/afredobarcelo/',
                  ),
                  const SizedBox(height: 12),
                  _socialTile(
                    context,
                    icon: Icons.code_rounded,
                    label: 'GitHub',
                    subtitle: 'Lihat proyek dan kode program',
                    color: isDark ? Colors.white : const Color(0xFF24292F),
                    url: 'https://github.com/',
                  ),
                  const SizedBox(height: 12),
                  _socialTile(
                    context,
                    icon: Icons.work_rounded,
                    label: 'LinkedIn',
                    subtitle: 'Profil profesional',
                    color: const Color(0xFF0A66C2),
                    url: 'https://www.linkedin.com/',
                  ),
                  const SizedBox(height: 12),
                  _socialTile(
                    context,
                    icon: Icons.email_rounded,
                    label: 'Email Mahasiswa',
                    subtitle: 'e41251212@student.polije.ac.id',
                    color: AppTheme.blue,
                    url: 'mailto:e41251212@student.polije.ac.id',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
            Center(
              child: Text(
                'Terus belajar, berkarya, dan berkembang.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kartu sosial media
  static Widget _socialTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required String url,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF5FAFF),
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () async {
          final uri = Uri.parse(url);

          try {
            final launched = await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );

            if (!launched && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tidak dapat membuka $label'),
                ),
              );
            }
          } catch (_) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tidak dapat membuka $label'),
                ),
              );
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark ? Colors.white12 : const Color(0xFFDCEAF6),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppTheme.deepNavy,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.blueGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                color: isDark ? AppTheme.lightBlue : AppTheme.blue,
                size: 19,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _sectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  static Widget _flatCard({
    required Widget child,
    required Color color,
    required Color borderColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  static Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color textColor,
    required Color mutedColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppTheme.lightBlue.withOpacity(0.35),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.blue,
            size: 22,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: mutedColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _skillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: AppTheme.lightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.lightBlue),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.darkBlue,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
