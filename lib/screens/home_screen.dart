import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/movie.dart';
import '../providers/app_provider.dart';
import '../providers/theme_provider.dart';
import '../config/themes.dart';
import '../widgets/movie_card.dart';
import '../widgets/section_header.dart';
import 'movie_detail_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  bool _isSearching = false;
  final _scrollCtrl = ScrollController();
  int _bannerIndex = 0;
  List<Movie> _bannerMovies = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadMovies();
    });
    _startBannerCycle();
  }

  void _startBannerCycle() {
    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;
      setState(() {
        _bannerIndex = (_bannerIndex + 1) % (_bannerMovies.isEmpty ? 1 : _bannerMovies.length);
      });
      _startBannerCycle();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final theme = context.read<ThemeProvider>().themeData;

    if (appProvider.moviesState == LoadState.loaded && _bannerMovies.isEmpty) {
      final recent = appProvider.movies['🆕 Recently Added'];
      if (recent != null && recent.isNotEmpty) {
        _bannerMovies = recent.take(8).toList();
      }
    }

    return Scaffold(
      backgroundColor: theme.background,
      body: Column(
        children: [
          // Top bar
          _buildTopBar(context, theme, appProvider),
          Expanded(
            child: _isSearching
                ? _buildSearchResults(appProvider, theme)
                : _buildContent(appProvider, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, AppThemeData theme, AppProvider provider) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 8,
      ),
      child: Row(
        children: [
          if (!_isSearching) ...[
            Icon(Icons.movie_creation_rounded,
                color: theme.primary, size: 28),
            const SizedBox(width: 8),
            const Text('JAZZ CINEMA',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.5,
                )),
            const Spacer(),
            // Trial badge
            if (provider.authState.isTrialMode)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.accent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.accent.withOpacity(0.4)),
                ),
                child: Text(
                  '${provider.authState.trialMoviesLeft} left',
                  style: TextStyle(
                    color: theme.accent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen())),
              icon: const Icon(Icons.settings_rounded, color: Colors.white70),
            ),
          ],
          // Search field
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: TextField(
                controller: _searchCtrl,
                onTap: () => setState(() => _isSearching = true),
                onChanged: (q) => context.read<AppProvider>().setSearch(q),
                style: const TextStyle(color: Colors.white, fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon:
                      Icon(Icons.search_rounded, color: theme.primary, size: 20),
                  suffixIcon: _isSearching
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: () {
                            _searchCtrl.clear();
                            context.read<AppProvider>().clearSearch();
                            setState(() => _isSearching = false);
                            FocusScope.of(context).unfocus();
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(AppProvider provider, AppThemeData theme) {
    final results = provider.searchResults;
    if (_searchCtrl.text.isEmpty) {
      return Center(
        child: Text('Start typing to search...',
            style: TextStyle(color: Colors.white38)),
      );
    }
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: Colors.white.withOpacity(0.2)),
            const SizedBox(height: 12),
            Text('No results for "${_searchCtrl.text}"',
                style: TextStyle(color: Colors.white38)),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: results.length,
      itemBuilder: (ctx, i) => MovieCard(
        movie: results[i],
        onTap: () => _openMovie(results[i]),
      ),
    );
  }

  Widget _buildContent(AppProvider provider, AppThemeData theme) {
    if (provider.moviesState == LoadState.loading && provider.movies.isEmpty) {
      return _buildShimmer(theme);
    }
    if (provider.moviesState == LoadState.error && provider.movies.isEmpty) {
      return _buildError(provider, theme);
    }
    return RefreshIndicator(
      color: theme.primary,
      onRefresh: () => provider.loadMovies(forceRefresh: true),
      child: CustomScrollView(
        controller: _scrollCtrl,
        slivers: [
          // Banner
          SliverToBoxAdapter(child: _buildBanner(theme)),
          // Category rows
          ...provider.movies.entries.map(
            (entry) => SliverToBoxAdapter(
              child: _buildCategoryRow(entry.key, entry.value, theme),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildBanner(AppThemeData theme) {
    if (_bannerMovies.isEmpty) return const SizedBox.shrink();
    final movie = _bannerMovies[_bannerIndex % _bannerMovies.length];
    return GestureDetector(
      onTap: () => _openMovie(movie),
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600),
            child: CachedNetworkImage(
              key: ValueKey(movie.id),
              imageUrl: movie.thumbnailUrl,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                height: 240,
                color: theme.surface,
              ),
              errorWidget: (_, __, ___) => Container(
                height: 240,
                color: theme.surface,
                child: Icon(Icons.movie_rounded, size: 60, color: Colors.white.withOpacity(0.2)),
              ),
            ),
          ),
          // Gradient overlay
          Container(
            height: 240,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  theme.background.withOpacity(0.5),
                  theme.background,
                ],
              ),
            ),
          ),
          // Title
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    movie.category,
                    style: TextStyle(
                      color: theme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  movie.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: () => _openMovie(movie),
                    icon: const Icon(Icons.play_arrow_rounded, size: 18),
                    label: const Text('Watch Now'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Banner dots
          Positioned(
            right: 16,
            bottom: 24,
            child: Row(
              children: List.generate(
                _bannerMovies.length.clamp(0, 8),
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: i == _bannerIndex % _bannerMovies.length ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _bannerIndex % _bannerMovies.length
                        ? theme.primary
                        : Colors.white30,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String title, List<Movie> movies, AppThemeData theme) {
    if (movies.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeader(
            title: title,
            onSeeAll: () {}, // TODO: see all screen
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 185,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: movies.length.clamp(0, 30),
            itemBuilder: (ctx, i) {
              return Padding(
                padding: EdgeInsets.only(right: i < movies.length - 1 ? 10 : 0),
                child: MovieCard(
                  movie: movies[i],
                  onTap: () => _openMovie(movies[i]),
                ).animate(delay: (i * 40).ms).fadeIn().slideX(begin: 0.1),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer(AppThemeData theme) {
    return Shimmer.fromColors(
      baseColor: theme.surface,
      highlightColor: theme.surfaceVariant,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(height: 220, decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          )),
          const SizedBox(height: 24),
          ...List.generate(3, (_) => Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 18, width: 140, color: Colors.white),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 4,
                    itemBuilder: (_, __) => Container(
                      width: 110,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildError(AppProvider provider, AppThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 60, color: Colors.white.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(provider.moviesError,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white54)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => provider.loadMovies(forceRefresh: true),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _openMovie(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MovieDetailScreen(movie: movie)),
    );
  }
}
