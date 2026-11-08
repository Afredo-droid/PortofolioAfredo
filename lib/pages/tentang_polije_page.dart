import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app_theme.dart';
import '../widgets/page_header.dart';

class TentangPolijePage extends StatefulWidget {
  const TentangPolijePage({super.key});

  @override
  State<TentangPolijePage> createState() => _TentangPolijePageState();
}

class _TentangPolijePageState extends State<TentangPolijePage> {
  // Jurusan yang terpilih secara default
  String _selectedJurusan = 'Teknologi Informasi';

  final PageController _facilityController =
      PageController(viewportFraction: 0.86);
  int _facilityIndex = 0;

  // Data struktur Jurusan dan daftar Program Studi di dalamnya
  final Map<String, Map<String, dynamic>> _dataJurusan = const {
    'Teknologi Informasi': {
      'prodi': [
        'D4 Teknik Informatika',
        'D3 Manajemen Informatika',
        'D3 Teknik Komputer',
        'D4 Teknologi Rekayasa Komputer',
        'D4 Bisnis Digital',
      ],
      'deskripsi':
          'Fokus pada pengembangan perangkat lunak, sistem informasi, jaringan komputer, multimedia, serta teknologi digital terapan.',
    },
    'Produksi Pertanian': {
      'prodi': [
        'D3 Produksi Tanaman Hortikultura',
        'D3 Produksi Tanaman Perkebunan',
        'D4 Teknik Produksi Benih',
        'D4 Budidaya Tanaman Perkebunan',
      ],
      'deskripsi':
          'Mengembangkan keahlian di bidang budidaya tanaman, inovasi perbenihan, serta pengelolaan perkebunan modern.',
    },
    'Teknologi Pertanian': {
      'prodi': [
        'D3 Teknologi Industri Pangan',
        'D4 Keteknikan Pertanian',
        'D4 Teknologi Rekayasa Pangan',
      ],
      'deskripsi':
          'Mempelajari pengolahan hasil pertanian, rekayasa pangan, alat dan mesin pertanian, serta pengendalian mutu industri.',
    },
    'Manajemen Agribisnis': {
      'prodi': [
        'D3 Manajemen Agribisnis',
        'D4 Manajemen Agroindustri',
        'D4 Akuntansi Sektor Publik',
      ],
      'deskripsi':
          'Mengintegrasikan ilmu bisnis, tata kelola keuangan, dan manajemen rantai pasok dalam bidang industri dan agribisnis.',
    },
    'Kesehatan': {
      'prodi': [
        'D4 Gizi Klinik',
        'D3 Manajemen Informasi Kesehatan',
        'D4 Rekam Medis',
      ],
      'deskripsi':
          'Mendidik tenaga ahli di bidang pelayanan gizi terapan, analisis kesehatan, dan manajemen sistem informasi medis.',
    },
    'Teknik': {
      'prodi': [
        'D4 Teknik Energi Terbarukan',
        'D3 Teknik Mesin Otomotif',
        'D4 Mesin Otomotif',
      ],
      'deskripsi':
          'Berfokus pada rekayasa energi terbarukan, konversi energi, dan teknologi perawatan serta inovasi otomotif.',
    },
    'Peternakan': {
      'prodi': [
        'D3 Produksi Ternak',
        'D4 Teknologi Produksi Ternak',
        'D4 Manajemen Bisnis Unggas',
      ],
      'deskripsi':
          'Mengembangkan ilmu peternakan terapan, manajemen budidaya ternak, formulasi pakan, dan industri perunggasan.',
    },
    'Bahasa, Komunikasi, dan Pariwisata': {
      'prodi': [
        'D3 Bahasa Inggris',
        'D4 Destinasi Pariwisata',
      ],
      'deskripsi':
          'Mengasah kemampuan komunikasi internasional, kebahasaan bisnis, serta pengelolaan destinasi wisata profesional.',
    },
  };

  final List<Map<String, dynamic>> _facilities = const [
    {
      'icon': Icons.computer_rounded,
      'title': 'Laboratorium & Praktik',
      'description':
          'Ruang praktik membantu mahasiswa menerapkan teori sesuai bidang keahlian.',
      'color': Color(0xFF0077B6),
      'bg': Color(0xFFE4F5FC),
    },
    {
      'icon': Icons.menu_book_rounded,
      'title': 'Pembelajaran Vokasi',
      'description':
          'Pembelajaran terapan melalui tugas, proyek, praktik, dan studi kasus.',
      'color': Color(0xFF6C45D9),
      'bg': Color(0xFFF0EAFE),
    },
    {
      'icon': Icons.groups_rounded,
      'title': 'Kegiatan Mahasiswa',
      'description':
          'Kembangkan kerja sama, kepemimpinan, dan kreativitas lewat kegiatan mahasiswa.',
      'color': Color(0xFF00866A),
      'bg': Color(0xFFE2F8F0),
    },
    {
      'icon': Icons.handshake_rounded,
      'title': 'Kolaborasi Industri',
      'description':
          'Pendidikan vokasi mendorong kesiapan kerja dan pengalaman terapan.',
      'color': Color(0xFFB56A00),
      'bg': Color(0xFFFFF2D9),
    },
  ];

  @override
  void dispose() {
    _facilityController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tautan tidak dapat dibuka saat ini.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppTheme.deepNavy;
    final mutedColor = isDark ? Colors.white70 : const Color(0xFF63758B);

    final selectedData = _dataJurusan[_selectedJurusan]!;
    final List<String> prodiList = List<String>.from(selectedData['prodi']);
    final String jurusanDescription = selectedData['deskripsi'];

    return Scaffold(
      appBar: const StickyPageHeader(
        title: 'Tentang POLIJE',
        subtitle: 'Kenali kampus vokasi dan kehidupan mahasiswa',
        icon: Icons.account_balance_rounded,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          _heroCard(),
          const SizedBox(height: 24),

          // Section Jelajahi Jurusan dan Program Studi
          _sectionHeading(
              'Jelajahi Jurusan & Program Studi',
              'Pilih jurusan untuk melihat daftar program studi',
              Icons.school_rounded,
              textColor),
          const SizedBox(height: 12),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown Pilih Jurusan
                  DropdownButtonFormField<String>(
                    value: _selectedJurusan,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Pilih Jurusan',
                      prefixIcon: Icon(Icons.account_tree_outlined),
                    ),
                    items: _dataJurusan.keys
                        .map((jurusan) => DropdownMenuItem<String>(
                              value: jurusan,
                              child: Text(
                                jurusan,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedJurusan = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Card Biru Gradient Menampilkan Detail Jurusan & List Program Studi
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      key: ValueKey(_selectedJurusan),
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  const Color(0xFF152E50),
                                  const Color(0xFF173C60)
                                ]
                              : [
                                  const Color(0xFFE8F7FC),
                                  const Color(0xFFF1F0FF)
                                ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.blue.withOpacity(0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: AppTheme.blue.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.school_rounded,
                                  color: AppTheme.blue,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Jurusan $_selectedJurusan',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${prodiList.length} Program Studi',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            jurusanDescription,
                            style: TextStyle(
                              height: 1.4,
                              fontSize: 12,
                              color: mutedColor,
                            ),
                          ),
                          const Divider(height: 24),
                          Text(
                            'Daftar Program Studi:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // List Program Studi yang Muncul Berdasarkan Jurusan
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: prodiList.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.06)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isDark
                                        ? Colors.white10
                                        : Colors.black.withOpacity(0.05),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppTheme.blue,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        prodiList[index],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () =>
                        _openUrl('https://polije.ac.id/program-studi/'),
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: const Text('Lihat daftar resmi program studi'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          _sectionHeading(
              'Fasilitas & Kegiatan Kampus',
              'Geser kartu untuk menjelajahi informasi',
              Icons.explore_rounded,
              textColor),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: PageView.builder(
              controller: _facilityController,
              itemCount: _facilities.length,
              onPageChanged: (index) => setState(() => _facilityIndex = index),
              itemBuilder: (context, index) {
                final item = _facilities[index];
                final color = item['color'] as Color;
                final bg = item['bg'] as Color;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: color.withOpacity(0.18)),
                      boxShadow: [
                        BoxShadow(
                            color: color.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 6)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Icon(item['icon'] as IconData,
                                  color: color, size: 26),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: bg,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text('${index + 1}/${_facilities.length}',
                                  style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(item['title'] as String,
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: textColor)),
                        const SizedBox(height: 6),
                        Expanded(
                            child: Text(item['description'] as String,
                                style: TextStyle(
                                    color: mutedColor,
                                    height: 1.35,
                                    fontSize: 12))),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_facilities.length, (index) {
              final selected = index == _facilityIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: selected ? 22 : 7,
                height: 7,
                decoration: BoxDecoration(
                  color: selected ? AppTheme.blue : AppTheme.lightBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          _sectionHeading(
              'Informasi Kampus',
              'Informasi umum Politeknik Negeri Jember',
              Icons.info_outline_rounded,
              textColor),
          const SizedBox(height: 12),
          _infoCard(
            icon: Icons.location_on_rounded,
            title: 'Lokasi Kampus',
            value: 'Jl. Mastrip PO BOX 164, Jember, Jawa Timur, Indonesia.',
            color: const Color(0xFF0077B6),
            background: const Color(0xFFE4F5FC),
          ),
          const SizedBox(height: 10),
          _infoCard(
            icon: Icons.phone_rounded,
            title: 'Telepon',
            value: '+62 331 333533 / +62 331 333531',
            color: const Color(0xFF00866A),
            background: const Color(0xFFE2F8F0),
          ),
          const SizedBox(height: 10),
          _infoCard(
            icon: Icons.email_rounded,
            title: 'Email',
            value: 'politeknik@polije.ac.id',
            color: const Color(0xFF6C45D9),
            background: const Color(0xFFF0EAFE),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppTheme.gradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.public_rounded, color: Colors.white, size: 30),
                const SizedBox(height: 10),
                const Text('Cari informasi resmi POLIJE?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                    'Buka kanal resmi untuk informasi terbaru mengenai kampus dan program studi.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.9), height: 1.4)),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.darkBlue),
                      onPressed: () => _openUrl('https://polije.ac.id/'),
                      icon: const Icon(Icons.open_in_new_rounded),
                      label: const Text('Situs POLIJE'),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70)),
                      onPressed: () =>
                          _openUrl('https://polije.ac.id/program-studi/'),
                      icon: const Icon(Icons.menu_book_rounded),
                      label: const Text('Program Studi'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.gradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: AppTheme.blue.withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white30)),
                child: Image.asset('assets/logo_.png',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.account_balance_rounded,
                        color: Colors.white,
                        size: 30)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text('Politeknik Negeri Jember',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Icon(Icons.location_on_outlined, color: Colors.white, size: 18),
              SizedBox(width: 5),
              Expanded(
                  child: Text('Jember, Jawa Timur, Indonesia',
                      style: TextStyle(color: Colors.white, fontSize: 12))),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Perguruan tinggi vokasi yang mengutamakan pembelajaran terapan, praktik, dan pengembangan kompetensi profesional.',
            style:
                TextStyle(color: Colors.white.withOpacity(0.93), height: 1.5),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _HeroTag(icon: Icons.school_rounded, label: 'Pendidikan Vokasi'),
              _HeroTag(
                  icon: Icons.build_circle_rounded,
                  label: 'Pembelajaran Praktik'),
              _HeroTag(icon: Icons.lightbulb_rounded, label: 'Inovasi'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionHeading(
      String title, String subtitle, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: AppTheme.iceBlue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(13)),
          child: Icon(icon, color: AppTheme.blue),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(height: 3),
              Text(subtitle,
                  style:
                      TextStyle(fontSize: 11, color: color.withOpacity(0.68))),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required Color background,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                  color: background, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(value,
                      style: const TextStyle(height: 1.4, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroTag({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
