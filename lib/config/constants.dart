class AppConstants {
  // App info
  static const String appName = 'Jazz Cinema Pro';
  static const String appVersion = '11.0.0';

  // Config
  static const String configRepoOwner = 'BabyJan683';
  static const String configRepoName = 'jazzcinema-config';
  static const String configFile = 'config.json';
  static const String githubToken = ''; // Set via RemoteConfig

  // Key auth
  static const String keyPattern = r'^JAZZ-[A-Z0-9]{5}-[A-Z0-9]{5}-[A-Z0-9]{5}$';
  static const int keyValidDays = 30;
  static const int trialDailyLimit = 4;

  // SharedPrefs keys
  static const String prefTheme = 'app_theme';
  static const String prefActiveKey = 'active_key';
  static const String prefActivationDate = 'activation_date';
  static const String prefIsTrialMode = 'is_trial_mode';
  static const String prefKeyStatus = 'key_status';
  static const String prefTrialWatchDate = 'trial_watch_date';
  static const String prefTrialWatchCount = 'trial_watch_count';
  static const String prefUsedKeys = 'used_keys';
  static const String prefParentalPin = 'parental_pin';
  static const String prefParentalEnabled = 'parental_enabled';
  static const String prefSearchHistory = 'search_history';
  static const String prefCachedConfig = 'cached_config';
  static const String prefConfigTime = 'config_time';
  static const String prefCachedMovies = 'cached_movies';

  // Themes
  static const String themeNetflixRed = 'netflix_red';
  static const String themeOceanBlue = 'ocean_blue';
  static const String themeRoyalPurple = 'royal_purple';
  static const String themeNightTeal = 'night_teal';
  static const String themeCinemaAmber = 'cinema_amber';

  // Movie categories order
  static const List<String> categoryOrder = [
    '🆕 Recently Added',
    '🏆 Latest Movies',
    'South',
    'Bollywood',
    'Hollywood',
    'Pakistani',
    'Turkish',
    'Urdu Dubbed',
    'Trending',
  ];

  // Cache settings
  static const int configCacheMinutes = 15;
  static const int movieCacheHours = 48;
  static const int maxSearchHistory = 20;
}
