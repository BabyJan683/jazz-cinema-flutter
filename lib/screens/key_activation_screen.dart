import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';

class KeyActivationScreen extends StatefulWidget {
  const KeyActivationScreen({super.key});

  @override
  State<KeyActivationScreen> createState() => _KeyActivationScreenState();
}

class _KeyActivationScreenState extends State<KeyActivationScreen> {
  final _keyCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _keyCtrl.dispose();
    super.dispose();
  }

  Future<void> _activate() async {
    setState(() { _loading = true; _error = null; });
    final err = await AuthService.activateKey(_keyCtrl.text);
    if (!mounted) return;
    if (err != null) {
      setState(() { _error = err; _loading = false; });
    } else {
      await context.read<AppProvider>().refreshAuth();
      _goMain();
    }
  }

  Future<void> _startTrial() async {
    setState(() { _loading = true; });
    await AuthService.startTrial();
    if (!mounted) return;
    await context.read<AppProvider>().refreshAuth();
    _goMain();
  }

  void _goMain() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeProvider>().themeData;
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: theme.primary.withOpacity(0.4)),
                      ),
                      child: Icon(Icons.movie_creation_rounded,
                          size: 40, color: theme.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Jazz Cinema Pro',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Activate your license key',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2),

              const SizedBox(height: 48),

              // Key input card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('License Key',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _keyCtrl,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                      decoration: InputDecoration(
                        hintText: 'JAZZ-XXXXX-XXXXX-XXXXX',
                        prefixIcon:
                            Icon(Icons.vpn_key_rounded, color: theme.primary),
                        errorText: _error,
                      ),
                      onChanged: (_) => setState(() => _error = null),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _activate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: theme.onPrimary,
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5, color: Colors.white))
                            : const Text(
                                'Activate Key',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.2),

              const SizedBox(height: 24),

              // Divider
              Row(children: [
                Expanded(child: Divider(color: Colors.white12)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('OR',
                      style: TextStyle(color: Colors.white38, fontSize: 12)),
                ),
                Expanded(child: Divider(color: Colors.white12)),
              ]).animate(delay: 300.ms).fadeIn(),

              const SizedBox(height: 24),

              // Trial button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: _loading ? null : _startTrial,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Try for Free',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '4 movies/day • No registration',
                        style: TextStyle(fontSize: 11, color: Colors.white38),
                      ),
                    ],
                  ),
                ),
              ).animate(delay: 400.ms).fadeIn(),

              const SizedBox(height: 32),

              // Key info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: theme.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Keys are in format: JAZZ-XXXXX-XXXXX-XXXXX\nActivated keys grant 30 days full access.',
                        style:
                            TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}
