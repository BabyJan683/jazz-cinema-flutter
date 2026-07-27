import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/movie.dart';
import '../providers/theme_provider.dart';
import '../providers/app_provider.dart';
import '../services/auth_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  VideoPlayerController? _videoCtrl;
  ChewieController? _chewieCtrl;
  bool _playing = false;
  bool _loadingPlayer = false;

  @override
  void dispose() {
    _chewieCtrl?.dispose();
    _videoCtrl?.dispose();
    super.dispose();
  }

  Future<void> _startWatch() async {
    final provider = context.read<AppProvider>();
    final auth = provider.authState;

    if (!auth.canWatch) {
      _showTrialLimitDialog();
      return;
    }

    if (auth.isTrialMode) {
      await AuthService.recordWatch();
      await provider.refreshAuth();
    }

    final url = widget.movie.playUrl.isNotEmpty
        ? widget.movie.playUrl
        : widget.movie.driveUrl;

    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No stream URL available')),
      );
      return;
    }

    setState(() => _loadingPlayer = true);
    try {
      _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(url));
      await _videoCtrl!.initialize();
      _chewieCtrl = ChewieController(
        videoPlayerController: _videoCtrl!,
        autoPlay: true,
        looping: false,
        showControlsOnInitialize: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: context.read<ThemeProvider>().themeData.primary,
          handleColor: context.read<ThemeProvider>().themeData.primary,
          bufferedColor: Colors.white30,
          backgroundColor: Colors.white12,
        ),
      );
      setState(() { _playing = true; _loadingPlayer = false; });
    } catch (e) {
      setState(() => _loadingPlayer = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading video: $e')),
        );
      }
    }
  }

  void _showTrialLimitDialog() {
    final theme = context.read<ThemeProvider>().themeData;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Daily Limit Reached',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Free trial allows 4 movies per day.\nGet a license key for unlimited access.',
          style: TextStyle(color: Colors.white60),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeProvider>().themeData;
    final movie = widget.movie;

    return Scaffold(
      backgroundColor: theme.background,
      body: CustomScrollView(
        slivers: [
          // App bar with poster
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: theme.background,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: movie.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: theme.surface),
                    errorWidget: (_, __, ___) => Container(
                      color: theme.surface,
                      child: Icon(Icons.movie_rounded,
                          size: 80, color: Colors.white20),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          theme.background,
                        ],
                      ),
                    ),
                  ),
                  // Play button overlay
                  if (!_playing && !_loadingPlayer)
                    Center(
                      child: GestureDetector(
                        onTap: _startWatch,
                        child: Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Icon(Icons.play_arrow_rounded,
                              color: theme.onPrimary, size: 38),
                        ),
                      ).animate().scale(curve: Curves.elasticOut),
                    ),
                  if (_loadingPlayer)
                    Center(
                      child: CircularProgressIndicator(color: theme.primary),
                    ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Player
                  if (_playing && _chewieCtrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Chewie(controller: _chewieCtrl!),
                      ),
                    ).animate().fadeIn(),

                  // Title
                  Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 8),

                  // Meta row
                  Row(
                    children: [
                      _MetaChip(label: movie.category, icon: Icons.category_rounded),
                      const SizedBox(width: 8),
                      if (movie.releaseYear > 0)
                        _MetaChip(
                            label: '${movie.releaseYear}',
                            icon: Icons.calendar_today_rounded),
                    ],
                  ).animate(delay: 200.ms).fadeIn(),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _loadingPlayer ? null : _startWatch,
                          icon: Icon(_playing
                              ? Icons.replay_rounded
                              : Icons.play_arrow_rounded),
                          label: Text(_playing ? 'Restart' : 'Watch Now'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: () {
                          // TODO: download
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Download started')),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(14),
                        ),
                        child: const Icon(Icons.download_rounded),
                      ),
                    ],
                  ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _MetaChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white54),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }
}
