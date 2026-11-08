import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../widgets/page_header.dart';
import '../services/portfolio_service.dart';
import 'tambah_portfolio_page.dart';
import 'edit_portfolio_page.dart';

class PortfolioPage extends StatefulWidget {
  final Future<void> Function()? onAddRequested;

  const PortfolioPage({
    super.key,
    this.onAddRequested,
  });

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  bool _loading = true;
  String _search = '';
  String _technology = 'Semua';

  final PortfolioService _service = PortfolioService();

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
      'technology': 'Figma',
      'description': 'Perancangan antarmuka aplikasi modern.',
      'image': 'assets/portfolio_uiux.png',
      'isDummy': true,
    },
  ];

  List<Map<String, dynamic>> _projects = [];

  final List<String> _technologies = [
    'Semua',
    'Flutter',
    'Laravel',
    'React',
    'Python',
    'Java',
    'PHP',
    'Figma',
  ];

  @override
  void initState() {
    super.initState();
    _projects = List<Map<String, dynamic>>.from(_dummyProjects);
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    try {
      final result = await PortfolioService.getPortfolios();

      final apiProjects = result.where((item) {
        final name = (item['name'] ?? '').toString().toLowerCase();

        return !_dummyProjects.any(
          (dummy) => dummy['name'].toString().toLowerCase() == name,
        );
      }).map((item) {
        return <String, dynamic>{
          ...item,
          'isDummy': false,
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        _projects = [..._dummyProjects, ...apiProjects];
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _projects = List<Map<String, dynamic>>.from(_dummyProjects);
        _loading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredProjects {
    return _projects.where((project) {
      final name = (project['name'] ?? '').toString().toLowerCase();
      final technology = (project['technology'] ?? '').toString().toLowerCase();

      final matchesSearch = name.contains(_search.toLowerCase());

      final matchesTechnology =
          _technology == 'Semua' || technology == _technology.toLowerCase();

      return matchesSearch && matchesTechnology;
    }).toList();
  }

  Future<void> _addProject() async {
    if (widget.onAddRequested != null) {
      await widget.onAddRequested!();
      return;
    }

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const TambahPortfolioPage(),
      ),
    );

    if (result == true) {
      await _loadProjects();
    }
  }

  Future<void> _editProject(
    Map<String, dynamic> project,
  ) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => EditPortfolioPage(
          dataEdit: project,
        ),
      ),
    );

    if (!mounted || result == null) return;

    final isDummy = project['isDummy'] == true || project['id'] == null;

    if (isDummy) {
      if (result is Map) {
        final updated = Map<String, dynamic>.from(result);

        setState(() {
          final index = _projects.indexWhere(
            (item) => identical(item, project),
          );

          if (index >= 0) {
            _projects[index] = {
              ..._projects[index],
              ...updated,
              'isDummy': true,
            };
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Karya berhasil diperbarui.'),
          ),
        );
      }

      return;
    }

    if (result == true) {
      await _loadProjects();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Portofolio berhasil diperbarui.'),
        ),
      );
    }
  }

  Future<void> _deleteProject(
    Map<String, dynamic> project,
  ) async {
    final isDummy = project['isDummy'] == true || project['id'] == null;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Portofolio'),
        content: Text(
          'Yakin ingin menghapus "${project['name']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppTheme.red,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    if (isDummy) {
      setState(() {
        _projects.removeWhere(
          (item) => identical(item, project),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Karya dihapus dari tampilan ini.'),
        ),
      );

      return;
    }

    try {
      final success = await _service.deletePortfolio(
        project['id'].toString(),
      );

      if (!mounted) return;

      if (success) {
        await _loadProjects();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Portofolio berhasil dihapus.'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus portofolio.'),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
        ),
      );
    }
  }

  Widget _projectImage(Map<String, dynamic> project) {
    final imageBytes = project['imageBytes'];

    if (imageBytes is List<int>) {
      return Image.memory(
        Uint8List.fromList(imageBytes),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    }

    // Mendukung pembacaan dari field 'image' atau 'foto'
    final image = (project['image'] ?? project['foto'] ?? '').toString().trim();

    if (image.isEmpty) {
      return _imagePlaceholder();
    }

    if (project['isDummy'] == true || image.startsWith('assets/')) {
      return Image.asset(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _imagePlaceholder(),
      );
    }

    final fullUrl = PortfolioService.imageUrl(image);

    // Mencegah cache browser agar gambar baru selalu terbit langsung
    final urlNoCache = '$fullUrl?v=${DateTime.now().millisecondsSinceEpoch}';

    return Image.network(
      urlNoCache,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        debugPrint('--------------------------------------------------');
        debugPrint('GAGAL MEMUAT GAMBAR DI PORTFOLIO PAGE!');
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

  Widget _imagePlaceholder() {
    return Container(
      color: const Color(0xFFEAF4FF),
      alignment: Alignment.center,
      child: const Icon(
        Icons.image_outlined,
        size: 45,
        color: Color(0xFF0077B6),
      ),
    );
  }

  void _showDetail(Map<String, dynamic> project) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          (project['name'] ?? '').toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  height: 170,
                  child: _projectImage(project),
                ),
              ),
              const SizedBox(height: 16),
              _detailRow('Kategori', project['category']),
              _detailRow('Tahun', project['year']),
              _detailRow('Teknologi', project['technology']),
              const SizedBox(height: 10),
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                (project['description'] ?? '-').toString(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text((value ?? '-').toString()),
          ),
        ],
      ),
    );
  }

  Widget _tag(
    String label,
    Color background,
    Color foreground,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> project) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 125,
            width: double.infinity,
            child: _projectImage(project),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
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
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      _tag(
                        (project['category'] ?? '-').toString(),
                        const Color(0xFFE7F3FF),
                        const Color(0xFF2878B8),
                      ),
                      _tag(
                        (project['technology'] ?? '-').toString(),
                        const Color(0xFFE0F7FC),
                        const Color(0xFF006A91),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    (project['year'] ?? '-').toString(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 34,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF2563EB),
                                Color(0xFF06B6D4),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF2563EB).withOpacity(0.25),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => _showDetail(project),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.visibility_rounded,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'Detail',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      IconButton(
                        tooltip: 'Edit',
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 34,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () => _editProject(project),
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF0077B6),
                          size: 19,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Hapus',
                        visualDensity: VisualDensity.compact,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 34,
                        ),
                        padding: EdgeInsets.zero,
                        onPressed: () => _deleteProject(project),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppTheme.red,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = _filteredProjects;

    return Scaffold(
      appBar: StickyPageHeader(
        title: 'Portofolio',
        subtitle: 'Kumpulan proyek dan karya',
        icon: Icons.work_rounded,
        trailing: IconButton(
          tooltip: 'Muat ulang',
          onPressed: _loadProjects,
          icon: const Icon(
            Icons.refresh_rounded,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProject,
        backgroundColor: const Color(0xFF0878D1),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadProjects,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Cari portofolio...',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _technology,
              isExpanded: true,
              decoration: InputDecoration(
                labelText: 'Filter teknologi',
                prefixIcon: const Icon(Icons.filter_list_rounded),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              items: _technologies.map((technology) {
                return DropdownMenuItem<String>(
                  value: technology,
                  child: Text(technology),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;

                setState(() {
                  _technology = value;
                });
              },
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Daftar Portofolio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${projects.length} karya',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Padding(
                padding: EdgeInsets.all(35),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else if (projects.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 45),
                child: Column(
                  children: [
                    Icon(
                      Icons.folder_open_rounded,
                      size: 52,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Portofolio tidak ditemukan',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Coba ubah kata kunci atau filter teknologi.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;

                  final crossAxisCount = width >= 900
                      ? 4
                      : width >= 600
                          ? 3
                          : 2;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projects.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: 285,
                    ),
                    itemBuilder: (context, index) {
                      return _buildCard(projects[index]);
                    },
                  );
                },
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}