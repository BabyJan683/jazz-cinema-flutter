import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

enum AuthStatus { loggedOut, trial, active, expired }

class AuthState {
  final AuthStatus status;
  final String? activeKey;
  final DateTime? activationDate;
  final bool isTrialMode;
  final int trialWatchCount;

  const AuthState({
    required this.status,
    this.activeKey,
    this.activationDate,
    required this.isTrialMode,
    required this.trialWatchCount,
  });

  bool get isLoggedIn =>
      status == AuthStatus.trial || status == AuthStatus.active;
  bool get canWatch {
    if (status == AuthStatus.active) return true;
    if (status == AuthStatus.trial) {
      return trialWatchCount < AppConstants.trialDailyLimit;
    }
    return false;
  }

  int get trialMoviesLeft =>
      (AppConstants.trialDailyLimit - trialWatchCount).clamp(0, 999);
}

class AuthService {
  static Set<String>? _validKeys;

  static Future<Set<String>> _loadValidKeys() async {
    if (_validKeys != null) return _validKeys!;
    try {
      final raw = await rootBundle.loadString('assets/valid_keys.txt');
      _validKeys = raw
          .split('\n')
          .map((l) => l.trim().toUpperCase())
          .where((l) => l.isNotEmpty)
          .toSet();
    } catch (_) {
      _validKeys = {};
    }
    return _validKeys!;
  }

  static Future<AuthState> getState() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getString(AppConstants.prefKeyStatus) ?? '';
    final key = prefs.getString(AppConstants.prefActiveKey);
    final dateStr = prefs.getString(AppConstants.prefActivationDate);

    DateTime? activationDate;
    if (dateStr != null) {
      try {
        activationDate = DateTime.parse(dateStr);
      } catch (_) {}
    }

    AuthStatus authStatus;
    switch (status) {
      case 'active':
        // Check expiry
        if (activationDate != null) {
          final days = DateTime.now().difference(activationDate).inDays;
          authStatus = days >= AppConstants.keyValidDays
              ? AuthStatus.expired
              : AuthStatus.active;
        } else {
          authStatus = AuthStatus.active;
        }
        break;
      case 'trial':
        authStatus = AuthStatus.trial;
        break;
      default:
        authStatus = AuthStatus.loggedOut;
    }

    final trialCount = _getTrialCount(prefs);

    return AuthState(
      status: authStatus,
      activeKey: key,
      activationDate: activationDate,
      isTrialMode: authStatus == AuthStatus.trial,
      trialWatchCount: trialCount,
    );
  }

  static int _getTrialCount(SharedPreferences prefs) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(AppConstants.prefTrialWatchDate) ?? '';
    if (savedDate != today) return 0;
    return prefs.getInt(AppConstants.prefTrialWatchCount) ?? 0;
  }

  static Future<void> startTrial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefKeyStatus, 'trial');
    await prefs.setBool(AppConstants.prefIsTrialMode, true);
  }

  static Future<String?> activateKey(String rawKey) async {
    final key = rawKey.trim().toUpperCase();
    final regex = RegExp(AppConstants.keyPattern);
    if (!regex.hasMatch(key)) {
      return 'Invalid key format. Example: JAZZ-AB12C-DE34F-GH56J';
    }

    final validKeys = await _loadValidKeys();
    if (!validKeys.contains(key)) {
      return 'This key is not valid. Please check and try again.';
    }

    final prefs = await SharedPreferences.getInstance();
    final usedRaw = prefs.getStringList(AppConstants.prefUsedKeys) ?? [];
    final used = usedRaw.toSet();
    if (used.contains(key)) {
      return 'This key has already been used. Each key can only be activated once.';
    }

    used.add(key);
    await prefs.setStringList(AppConstants.prefUsedKeys, used.toList());
    await prefs.setString(AppConstants.prefActiveKey, key);
    await prefs.setString(AppConstants.prefActivationDate,
        DateTime.now().toIso8601String().substring(0, 10));
    await prefs.setString(AppConstants.prefKeyStatus, 'active');
    await prefs.setBool(AppConstants.prefIsTrialMode, false);
    return null; // success
  }

  static Future<void> recordWatch() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString(AppConstants.prefTrialWatchDate) ?? '';
    int count = savedDate == today
        ? (prefs.getInt(AppConstants.prefTrialWatchCount) ?? 0)
        : 0;
    await prefs.setString(AppConstants.prefTrialWatchDate, today);
    await prefs.setInt(AppConstants.prefTrialWatchCount, count + 1);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefKeyStatus);
    await prefs.remove(AppConstants.prefActiveKey);
    await prefs.remove(AppConstants.prefActivationDate);
    await prefs.remove(AppConstants.prefIsTrialMode);
  }
}
