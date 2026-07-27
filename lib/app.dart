import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';

class JazzCinemaApp extends StatelessWidget {
  const JazzCinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'Jazz Cinema Pro',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.theme,
      home: const SplashScreen(),
    );
  }
}
