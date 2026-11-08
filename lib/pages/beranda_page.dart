import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../services/portfolio_service.dart';
import '../widgets/page_header.dart';
import 'tambah_portfolio_page.dart';

class BerandaPage extends StatefulWidget {
  final Function(int)? onMenuTap;

  const BerandaPage({super.key, this.onMenuTap});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final ScrollController _projectController = ScrollController();

  int _projectIndex = 0;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _dummyProjects = [
    {
      'id': null,
      'name': 'E-Speed',
      'category': 'Website',
      'year': '2025',
      'technology': 'PHP',
      'description': 'Sistem pemesanan bengkel berbasis website.',
      'image': 'assets/e_speed.png',
      'isDummy': true,
    },
    {
      'id': null,
      'name': 'Djawara Go',
      'category': 'Mobile App',
      'year': '2026',
      'technology': 'Flutter',
      'description': 'Aplikasi pemesanan produk UMKM Djawara Dawet.',
      'image': 'assets/djawara_go.png',
      'isDummy': true,
    },
    {
      'id': null,
      'name': 'UI/UX Design',
      'category': 'UI/UX',
      'year': '2026',
      'technology': 'Flutter',
      'description': 'Perancangan antarmuka aplikasi modern.',
      'image': 'assets/portfolio_uiux.png',
      'isDummy': true,
    },
  ];

  List<Map<String, dynamic>> _projects = [];

  @override
  void initState() {
    super.initState();
    _projects = List<Map<String, dynamic>>.from(_dummyProjects);
    _loadProjects();

    _projectController.addListener(_updateProjectIndex);
  }

  void _updateProjectIndex() {
    if (!_projectController.hasClients || _projects.isEmpty) return;

    final index = (_projectController.offset / 244).round().clamp(
          0,
          _projects.length - 1,
        );

    if (index != _projectIndex && mounted) {
      setState(() => _projectIndex = index);
    }
  }

  @override
  void dispose() {
    _projectController.dispose();
    super.dispose();
  }

  Future<void> _loadProjects() async {
    try {
      final result = await PortfolioService.getPortfolios();

      if (!mounted) return;

      setState(() {
        _projects = [
          ..._dummyProjects,
          ...result.map((item) => Map<String, dynamic>.from(item)),
        ];
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _projects = List<Map<String, dynamic>>.from(_dummyProjects);
        _isLoading = false;
      });
    }
  }

  void _goToPage(int index) {
    widget.onMenuTap?.call(index);
  }

  Future<void> _bukaHalamanTambah() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TambahPortfolioPage(),
      ),
    );

    if (result == true) {
      _loadProjects();
    }
  }

  Widget _imagePlaceholder() {
    return Container(
      color: AppTheme.lightBlue.withOpacity(0.35),
      alignment: Alignment.center,
      child: const Icon(Icons.image_outlined, size: 42, color: AppTheme.blue),
    );
  }

  Widget _buildProjectImage(Map<String, dynamic> project) {
    final image = (project['image'] ?? project['foto'] ?? '').toString().trim();

    if (image.isEmpty) return _imagePlaceholder();

    final isDummy = project['isDummy'] == true || image.startsWith('assets/');

    if (isDummy) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    }

    final fullUrl = PortfolioService.imageUrl(image);

    return Image.network(
      fullUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('--------------------------------------------------');
        debugPrint('GAGAL MEMUAT GAMBAR!');
        debugPrint('URL dipanggil: $fullUrl');
        debugPrint('Error: $error');
        debugPrint('--------------------------------------------------');

        return Container(
          color: const Color(0xFFFEE2E2),
          padding: const EdgeInsets.all(6),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.broken_image_rounded,
                  color: Colors.red, size: 28),
              const SizedBox(height: 4),
              Text(
                'Gagal muat:\n$fullUrl',
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppTheme.darkBlue,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeroCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/logo_.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppTheme.darkBlue,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            Colors.black.withOpacity(0.85),
                            const Color(0xFF1E3A8A).withOpacity(0.80),
                            Colors.black.withOpacity(0.92),
                          ]
                        : [
                            const Color(0xFF0F172A).withOpacity(0.82),
                            const Color(0xFF1E40AF).withOpacity(0.75),
                            const Color(0xFF3B82F6).withOpacity(0.85),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white30),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.school_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Politeknik Negeri Jember',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Selamat datang di portofolio',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'AFREDO HIDAYATULLOH',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Mahasiswa D4 Teknik Informatika',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFFFFD700),
                        size: 15,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Terus belajar, berkarya, dan berkembang!',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              height: 54,
              width: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Icon(icon, color: color, size: 27),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project) {
    return Container(
      width: 230,
      margin: const EdgeInsets.only(right: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.lightBlue.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.blue.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 125,
            width: double.infinity,
            child: _buildProjectImage(project),
          ),
          Padding(
            padding: const EdgeInsets.all(13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (project['name'] ?? 'Tanpa Nama').toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _buildTag(
                      (project['category'] ?? 'Proyek').toString(),
                      AppTheme.lightBlue.withOpacity(0.35),
                      AppTheme.blue,
                    ),
                    _buildTag(
                      (project['technology'] ?? '-').toString(),
                      AppTheme.iceBlue.withOpacity(0.65),
                      AppTheme.darkBlue,
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                Text(
                  (project['year'] ?? '-').toString(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectSlider() {
    return Column(
      children: [
        SizedBox(
          height: 265,
          child: _isLoading && _projects.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  controller: _projectController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _projects.length,
                  itemBuilder: (context, index) {
                    return _buildProjectCard(_projects[index]);
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 2),
          child: Row(
            children: [
              const Icon(Icons.swipe_rounded, size: 20, color: AppTheme.blue),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  'Geser untuk melihat karya lainnya',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _projects.length.clamp(0, 8),
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _projectIndex == index ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _projectIndex == index
                    ? AppTheme.cyanBlue
                    : AppTheme.lightBlue,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StickyPageHeader(
        title: 'POLIJE Student Portfolio',
        subtitle: 'Profil, karya, dan informasi kampus',
        icon: Icons.home_rounded,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadProjects,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 18),
              _buildWelcomeHeroCard(),
              _sectionTitle('Jelajahi Menu', 'Akses informasi dengan mudah.'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  alignment: WrapAlignment.spaceAround,
                  runAlignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 18,
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_rounded,
                      title: 'Profil Saya',
                      onTap: () => _goToPage(1),
                      color: AppTheme.blue,
                    ),
                    _buildMenuItem(
                      icon: Icons.work_rounded,
                      title: 'Portofolio',
                      onTap: () => _goToPage(2),
                      color: AppTheme.cyanBlue,
                    ),
                    _buildMenuItem(
                      icon: Icons.add_circle_rounded,
                      title: 'Tambah',
                      onTap: _bukaHalamanTambah,
                      color: AppTheme.blue,
                    ),
                    _buildMenuItem(
                      icon: Icons.account_balance_rounded,
                      title: 'POLIJE',
                      onTap: () => _goToPage(3),
                      color: AppTheme.blue,
                    ),
                  ],
                ),
              ),
              _sectionTitle(
                'Projek dan Karya',
                'Jelajahi karya terbaik mahasiswa.',
              ),
              _buildProjectSlider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton.icon(
                    onPressed: () => _goToPage(2),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.darkBlue,
                      side: const BorderSide(color: AppTheme.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    icon: const Icon(Icons.work_outline_rounded),
                    label: const Text(
                      'Lihat Semua Portofolio',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
