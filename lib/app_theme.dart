import 'package:flutter/material.dart';

class AppTheme {
  // Palette mengikuti referensi: navy, ocean blue, cyan, dan putih.
  static const Color navy = Color(0xFF03045E);
  static const Color darkBlue = Color(0xFF023E8A);
  static const Color blue = Color(0xFF0077B6);
  static const Color cyanBlue = Color(0xFF0096C7);
  static const Color cyan = Color(0xFF00B4D8);
  static const Color skyBlue = Color(0xFF48CAE4);
  static const Color lightBlue = Color(0xFF90E0EF);
  static const Color paleBlue = Color(0xFFADE8F4);
  static const Color iceBlue = Color(0xFFCAF0F8);
  static const Color red = Color(0xFFD92D20); // khusus warning/hapus
  static const Color deepNavy = navy;

  static const LinearGradient gradient = LinearGradient(
    colors: [navy, darkBlue, blue, cyanBlue],
    stops: [0, 0.38, 0.72, 1],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData terang = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.fromSeed(
      seedColor: blue,
      brightness: Brightness.light,
      primary: blue,
      secondary: cyan,
      surface: Colors.white,
      error: red,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: navy,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: Colors.transparent,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: iceBlue,
      elevation: 3,
      labelTextStyle: WidgetStateProperty.resolveWith((states) =>
        TextStyle(fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
          color: states.contains(WidgetState.selected) ? darkBlue : const Color(0xFF64748B), fontSize: 12)),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFFE2EDF8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFD6E5F4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: blue, width: 1.7),
      ),
    ),
  );

  static ThemeData gelap = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: cyan,
      brightness: Brightness.dark,
      primary: skyBlue,
      secondary: cyan,
      surface: const Color(0xFF101C35),
      error: red,
    ),
    scaffoldBackgroundColor: const Color(0xFF071326),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF071326),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF101C35),
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Color(0xFF243650)),
      ),
    ),
  );
}
