import 'package:flutter/material.dart';

final lightColorScheme = ColorScheme.light(
  primary: Color(0xFF303030),
  secondary: Color(0xFF2573D5),
  surface: Color(0xFFE8E8E8),
  onPrimary: Color(0xFFFDFDFD),
  onSurface: Color(0xFF2E2E2E),
);

final underSurface = Color(0xFFA5A5A5);

final lightTheme = ThemeData(
  colorScheme: lightColorScheme,
  useMaterial3: true,
  scaffoldBackgroundColor: lightColorScheme.background,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorScheme.primary,
    foregroundColor: lightColorScheme.onPrimary,
  ),
);