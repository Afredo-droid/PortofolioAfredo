import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'pages/profil_page.dart';
import 'pages/beranda_page.dart';
import 'pages/portfolio_page.dart';
import 'pages/tentang_polije_page.dart';
import 'pages/pengaturan_page.dart';
import 'pages/tambah_portfolio_page.dart';

void main() {
  runApp(const MyPortfolioApp());
}

class MyPortfolioApp extends StatefulWidget {
  const MyPortfolioApp({super.key});

  @override
  State<MyPortfolioApp> createState() => _MyPortfolioAppState();
}

class _MyPortfolioAppState extends State<MyPortfolioApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _ubahTema(bool gelap) {
    setState(() {
      _themeMode = gelap ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'POLIJE Student Portfolio',
      theme: AppTheme.terang,
      darkTheme: AppTheme.gelap,
      themeMode: _themeMode,
      home: MainPage(themeMode: _themeMode, onThemeChanged: _ubahTema),
    );
  }
}

class MainPage extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeChanged;

  const MainPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  void _pindahHalaman(int index) {
    if (index < 0 || index > 4) return;

    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _bukaTambah() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const TambahPortfolioPage()),
    );

    if (result == true && mounted) {
      setState(() {
        _currentIndex = 2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      BerandaPage(onMenuTap: _pindahHalaman),
      const ProfilPage(),
      PortfolioPage(onAddRequested: _bukaTambah),
      const TentangPolijePage(),
      PengaturanPage(
        isDarkMode: widget.themeMode == ThemeMode.dark,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _pindahHalaman,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline_rounded),
            selectedIcon: Icon(Icons.work_rounded),
            label: 'Portofolio',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_outlined),
            selectedIcon: Icon(Icons.account_balance_rounded),
            label: 'POLIJE',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
