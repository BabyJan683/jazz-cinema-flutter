import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

class DbConfig {
  final String host;
  final int port;
  final String dbName;
  final String user;
  final String password;

  const DbConfig({
    required this.host,
    required this.port,
    required this.dbName,
    required this.user,
    required this.password,
  });

  static const DbConfig defaults = DbConfig(
    host: 'sql12.freesqldatabase.com',
    port: 3306,
    dbName: 'sql12824264',
    user: 'sql12824264',
    password: 'zx2faqegWz',
  );
}

class AppRemoteConfig {
  final bool isActive;
  final bool maintenanceMode;
  final bool forceUpdate;
  final DbConfig movieDb;
  final List<DbConfig> movieDbBackups;
  final String tiktokTable;
  final int offlineCacheHours;
  final String noticeUrl;
  final String blockedMessage;
  final String maintenanceMsg;
  final String updateMessage;

  const AppRemoteConfig({
    required this.isActive,
    required this.maintenanceMode,
    required this.forceUpdate,
    required this.movieDb,
    required this.movieDbBackups,
    required this.tiktokTable,
    required this.offlineCacheHours,
    required this.noticeUrl,
    required this.blockedMessage,
    required this.maintenanceMsg,
    required this.updateMessage,
  });

  static AppRemoteConfig get defaults => AppRemoteConfig(
        isActive: true,
        maintenanceMode: false,
        forceUpdate: false,
        movieDb: DbConfig.defaults,
        movieDbBackups: [],
        tiktokTable: 'Tiktok',
        offlineCacheHours: 48,
        noticeUrl: '',
        blockedMessage: 'Your account has been blocked. Contact support.',
        maintenanceMsg: 'Jazz Cinema is under maintenance.',
        updateMessage: 'A new version is available. Please update.',
      );
}

class ConfigService {
  static AppRemoteConfig _current = AppRemoteConfig.defaults;
  static AppRemoteConfig get current => _current;

  static Future<AppRemoteConfig> fetch({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now().millisecondsSinceEpoch;
    final cached = prefs.getString(AppConstants.prefCachedConfig);
    final cacheTime = prefs.getInt(AppConstants.prefConfigTime) ?? 0;
    final cacheAge = (now - cacheTime) / 60000; // minutes

    if (!forceRefresh && cacheAge < AppConstants.configCacheMinutes && cached != null) {
      try {
        _current = _parse(jsonDecode(cached));
        return _current;
      } catch (_) {}
    }

    try {
      final url =
          'https://raw.githubusercontent.com/${AppConstants.configRepoOwner}/${AppConstants.configRepoName}/main/${AppConstants.configFile}';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Cache-Control': 'no-cache',
          if (AppConstants.githubToken.isNotEmpty)
            'Authorization': 'token ${AppConstants.githubToken}',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        await prefs.setString(AppConstants.prefCachedConfig, response.body);
        await prefs.setInt(AppConstants.prefConfigTime, now);
        _current = _parse(json);
        return _current;
      }
    } catch (_) {}

    // Fallback to cached
    if (cached != null) {
      try {
        _current = _parse(jsonDecode(cached));
        return _current;
      } catch (_) {}
    }

    _current = AppRemoteConfig.defaults;
    return _current;
  }

  static AppRemoteConfig _parse(Map<String, dynamic> j) {
    DbConfig primaryDb;
    try {
      final db = j['database'] as Map<String, dynamic>?;
      if (db != null) {
        primaryDb = DbConfig(
          host: db['host'] ?? j['db_host'] ?? DbConfig.defaults.host,
          port: db['port'] ?? j['db_port'] ?? DbConfig.defaults.port,
          dbName: db['name'] ?? j['db_name'] ?? DbConfig.defaults.dbName,
          user: db['user'] ?? j['db_user'] ?? DbConfig.defaults.user,
          password: db['password'] ?? j['db_password'] ?? DbConfig.defaults.password,
        );
      } else {
        primaryDb = DbConfig(
          host: j['db_host'] ?? DbConfig.defaults.host,
          port: j['db_port'] ?? DbConfig.defaults.port,
          dbName: j['db_name'] ?? DbConfig.defaults.dbName,
          user: j['db_user'] ?? DbConfig.defaults.user,
          password: j['db_password'] ?? DbConfig.defaults.password,
        );
      }
    } catch (_) {
      primaryDb = DbConfig.defaults;
    }

    final backups = <DbConfig>[];
    try {
      final arr = j['db_backups'] as List?;
      if (arr != null) {
        for (final b in arr) {
          final m = b as Map<String, dynamic>;
          backups.add(DbConfig(
            host: m['db_host'] ?? m['host'] ?? '',
            port: m['db_port'] ?? m['port'] ?? 3306,
            dbName: m['db_name'] ?? m['name'] ?? '',
            user: m['db_user'] ?? m['user'] ?? '',
            password: m['db_password'] ?? m['password'] ?? '',
          ));
        }
      }
    } catch (_) {}

    return AppRemoteConfig(
      isActive: j['is_active'] ?? true,
      maintenanceMode: j['maintenance_mode'] ?? false,
      forceUpdate: j['force_update'] ?? false,
      movieDb: primaryDb,
      movieDbBackups: backups,
      tiktokTable: j['tiktok_table'] ?? 'Tiktok',
      offlineCacheHours: j['offline_cache_hours'] ?? 48,
      noticeUrl: j['notice_url'] ?? '',
      blockedMessage: j['blocked_message'] ?? '',
      maintenanceMsg: j['maintenance_msg'] ?? '',
      updateMessage: j['update_message'] ?? '',
    );
  }
}
