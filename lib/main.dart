import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'providers/theme_provider.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Prevent google_fonts from hitting the network on every cold launch.
  // Fonts already cached on disk are served from cache; first-run falls back
  // to system fonts.  This prevents a crash on Android 5-8 devices where
  // HTTPS/TLS cipher negotiation with fonts.gstatic.com can fail.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Global Flutter error handler — prevents red/black crash screens in release
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Don't rethrow; keep the app alive and show a graceful UI instead
  };

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  final themeProvider = ThemeProvider();
  try {
    await themeProvider.loadTheme();
  } catch (_) {
    // Keep default theme if prefs fail (rare on first install)
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const JazzCinemaApp(),
    ),
  );
}
