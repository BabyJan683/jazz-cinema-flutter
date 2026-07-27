import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../services/auth_service.dart';
import 'key_activation_screen.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  String _statusText = 'Loading...';
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final appProvider = context.read<AppProvider>();
    await Future.delayed(const Duration(milliseconds: 600));

    _setStatus('Fetching config...', 0.2);
    await appProvider.init();

    _setStatus('Pre-loading posters...', 0.5);
    await Future.delayed(const Duration(milliseconds: 800));

    _setStatus('Checking access...', 0.8);
    await Future.delayed(const Duration(milliseconds: 400));

    _setStatus('Ready!', 1.0);
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    final state = appProvider.authState;
    if (state.isLoggedIn) {
      _navigate(const MainScreen());
    } else {
      _navigate(const KeyActivationScreen());
    }
  }

  void _setStatus(String text, double progress) {
    if (!mounted) return;
    setState(() {
      _statusText = text;
      _progress = progress;
    });
  }

  void _navigate(Widget screen) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeProvider>().themeData;
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Title
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: theme.primary.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.movie_creation_rounded,
                      size: 52,
                      color: theme.primary,
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.4, 0.4),
                        curve: Curves.elasticOut,
                        duration: 900.ms,
                      )
                      .fadeIn(duration: 400.ms),
                  const SizedBox(height: 24),
                  Text(
                    'JAZZ CINEMA',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  )
                      .animate(delay: 300.ms)
                      .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOut)
                      .fadeIn(duration: 600.ms),
                  const SizedBox(height: 6),
                  Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.primary,
                      letterSpacing: 8,
                    ),
                  )
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 500.ms),
                  const SizedBox(height: 48),

                  // Pulsing dot + status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PulsingDot(color: theme.primary),
                      const SizedBox(width: 10),
                      Text(
                        _statusText,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ).animate(delay: 600.ms).fadeIn(),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 48),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation(theme.primary),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: TextStyle(
                      color: theme.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ).animate(delay: 700.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _anim = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 8,
          height: 8,
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
