import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/channel.dart';
import '../providers/theme_provider.dart';

class LiveTvScreen extends StatefulWidget {
  const LiveTvScreen({super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> {
  String _selectedCategory = 'All';
  Channel? _activeChannel;
  VideoPlayerController? _videoCtrl;
  ChewieController? _chewieCtrl;
  bool _loading = false;

  List<String> get _categories => [
        'All',
        ...ChannelsData.categories,
      ];

  List<Channel> get _filteredChannels => _selectedCategory == 'All'
      ? ChannelsData.all
      : ChannelsData.byCategory(_selectedCategory);

  @override
  void dispose() {
    _chewieCtrl?.dispose();
    _videoCtrl?.dispose();
    super.dispose();
  }

  Future<void> _openChannel(Channel ch) async {
    setState(() { _activeChannel = ch; _loading = true; });
    try {
      _chewieCtrl?.dispose();
      _videoCtrl?.dispose();
      _videoCtrl = VideoPlayerController.networkUrl(Uri.parse(ch.streamUrl));
      await _videoCtrl!.initialize();
      _chewieCtrl = ChewieController(
        videoPlayerController: _videoCtrl!,
        autoPlay: true,
        looping: true,
        showControlsOnInitialize: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: context.read<ThemeProvider>().themeData.primary,
          handleColor: context.read<ThemeProvider>().themeData.primary,
          bufferedColor: Colors.white30,
          backgroundColor: Colors.white12,
        ),
      );
      setState(() => _loading = false);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.read<ThemeProvider>().themeData;
    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  Icon(Icons.live_tv_rounded, color: theme.primary, size: 24),
                  const SizedBox(width: 10),
                  const Text('Live TV',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.red.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, color: Colors.red, size: 8),
                        const SizedBox(width: 4),
                        const Text('LIVE',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Player
            if (_activeChannel != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _loading
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: theme.primary),
                              const SizedBox(height: 12),
                              Text(_activeChannel!.name,
                                  style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                        )
                      : _chewieCtrl != null
                          ? Chewie(controller: _chewieCtrl!)
                          : Center(
                              child: Text('Failed to load',
                                  style:
                                      const TextStyle(color: Colors.white54))),
                ),
              ).animate().fadeIn(),

            // Category filter
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (_, i) {
                  final cat = _categories[i];
                  final selected = cat == _selectedCategory;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: selected
                            ? theme.primary
                            : theme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected
                              ? Colors.transparent
                              : Colors.white12,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: selected ? theme.onPrimary : Colors.white60,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Channel list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredChannels.length,
                itemBuilder: (_, i) {
                  final ch = _filteredChannels[i];
                  final isActive = _activeChannel?.id == ch.id;
                  return GestureDetector(
                    onTap: () => _openChannel(ch),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isActive
                            ? theme.primary.withOpacity(0.15)
                            : theme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? theme.primary.withOpacity(0.5)
                              : Colors.white10,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: ch.logoUrl,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Container(
                                width: 48,
                                height: 48,
                                color: Colors.white10,
                                child: Icon(Icons.tv_rounded,
                                    color: Colors.white30, size: 24),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(ch.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    )),
                                Text(ch.category,
                                    style: const TextStyle(
                                        color: Colors.white38, fontSize: 12)),
                              ],
                            ),
                          ),
                          Icon(
                            isActive
                                ? Icons.stop_circle_rounded
                                : Icons.play_circle_rounded,
                            color:
                                isActive ? theme.primary : Colors.white38,
                            size: 28,
                          ),
                        ],
                      ),
                    ).animate(delay: (i * 30).ms).fadeIn().slideX(begin: 0.05),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
