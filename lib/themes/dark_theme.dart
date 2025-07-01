import 'package:flutter/material.dart';

final darkColorScheme = ColorScheme.dark(
  primary: Color(0xFF323232),
  secondary: Colors.amber,
  surface: Color(0xff2b2b2b),
  onPrimary: Colors.white,
  onSurface: Colors.white70,
);

final ThemeData DarkTheme = ThemeData(
  colorScheme: darkColorScheme,
  useMaterial3: true,
  scaffoldBackgroundColor: darkColorScheme.surface,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.primary,
    foregroundColor: darkColorScheme.onPrimary,
  )
);