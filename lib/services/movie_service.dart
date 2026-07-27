import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../services/config_service.dart';
import '../config/constants.dart';

class MovieService {
  static Map<String, List<Movie>>? _cache;

  static Future<MySQLConnection?> _connect() async {
    final cfg = ConfigService.current;
    final dbs = [cfg.movieDb, ...cfg.movieDbBackups];
    for (final db in dbs) {
      if (db.host.isEmpty) continue;
      try {
        final conn = await MySQLConnection.createConnection(
          host: db.host,
          port: db.port,
          userName: db.user,
          password: db.password,
          databaseName: db.dbName,
          secure: false,
        );
        await conn.connect();
        return conn;
      } catch (_) {}
    }
    return null;
  }

  static Future<Map<String, List<Movie>>> fetchMovies({bool forceRefresh = false}) async {
    if (!forceRefresh && _cache != null) return _cache!;

    // Try loading from prefs cache first
    if (!forceRefresh) {
      final cached = await _loadFromCache();
      if (cached != null && cached.isNotEmpty) {
        _cache = cached;
      }
    }

    // Try live fetch
    try {
      final conn = await _connect();
      if (conn != null) {
        try {
          final result = await conn.execute(
            'SELECT id,category,title,thumbnail_url,drive_url,play_url,release_year,created_at FROM Movies ORDER BY created_at DESC',
          );
          final movies = result.rows.map((row) {
            return Movie(
              id: int.tryParse(row.colByName('id') ?? '0') ?? 0,
              category: row.colByName('category') ?? '',
              title: row.colByName('title') ?? '',
              thumbnailUrl: row.colByName('thumbnail_url') ?? '',
              driveUrl: row.colByName('drive_url') ?? '',
              playUrl: row.colByName('play_url') ?? '',
              releaseYear: int.tryParse(row.colByName('release_year') ?? '0') ?? 0,
              createdAt: row.colByName('created_at') ?? '',
            );
          }).toList();
          await conn.close();
          final map = _buildMap(movies);
          _cache = map;
          await _saveToCache(movies);
          return map;
        } catch (_) {
          await conn.close();
        }
      }
    } catch (_) {}

    return _cache ?? {};
  }

  static Map<String, List<Movie>> _buildMap(List<Movie> all) {
    final map = <String, List<Movie>>{};

    // Recently added — top 50 by created_at
    final byDate = [...all]
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    map['🆕 Recently Added'] = byDate.take(50).toList();

    // Latest by release year
    final byYear = [...all]
      ..sort((a, b) => b.releaseYear.compareTo(a.releaseYear));
    map['🏆 Latest Movies'] = byYear.take(30).toList();

    // Group by category
    for (final movie in all) {
      final cat = movie.category.trim();
      if (cat.isEmpty) continue;
      map.putIfAbsent(cat, () => []).add(movie);
    }

    // Sort by preferred order
    final ordered = <String, List<Movie>>{};
    for (final cat in AppConstants.categoryOrder) {
      if (map.containsKey(cat)) ordered[cat] = map[cat]!;
    }
    for (final entry in map.entries) {
      if (!ordered.containsKey(entry.key)) ordered[entry.key] = entry.value;
    }
    return ordered;
  }

  static Future<void> _saveToCache(List<Movie> movies) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(movies.map((m) => m.toMap()).toList());
      await prefs.setString(AppConstants.prefCachedMovies, encoded);
    } catch (_) {}
  }

  static Future<Map<String, List<Movie>>?> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(AppConstants.prefCachedMovies);
      if (raw == null) return null;
      final list = (jsonDecode(raw) as List)
          .map((m) => Movie.fromMap(m as Map<String, dynamic>))
          .toList();
      return _buildMap(list);
    } catch (_) {
      return null;
    }
  }

  static List<Movie> search(Map<String, List<Movie>> allMovies, String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return [];
    final seen = <int>{};
    final results = <Movie>[];
    for (final list in allMovies.values) {
      for (final m in list) {
        if (seen.contains(m.id)) continue;
        if (m.title.toLowerCase().contains(q) ||
            m.category.toLowerCase().contains(q)) {
          seen.add(m.id);
          results.add(m);
        }
      }
    }
    return results;
  }
}
