import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/song.dart';
import '../services/auth_service.dart';
import '../services/config_service.dart';
import '../services/movie_service.dart';

enum LoadState { idle, loading, loaded, error }

class AppProvider extends ChangeNotifier {
  // Auth
  AuthState _authState = const AuthState(
    status: AuthStatus.loggedOut,
    isTrialMode: false,
    trialWatchCount: 0,
  );
  AuthState get authState => _authState;

  // Remote config
  AppRemoteConfig get config => ConfigService.current;

  // Movies
  Map<String, List<Movie>> _movies = {};
  Map<String, List<Movie>> get movies => _movies;
  LoadState _moviesState = LoadState.idle;
  LoadState get moviesState => _moviesState;
  String _moviesError = '';
  String get moviesError => _moviesError;

  // Search
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  List<Movie> _searchResults = [];
  List<Movie> get searchResults => _searchResults;

  // Songs
  List<Song> _songs = [];
  List<Song> get songs => _songs;
  LoadState _songsState = LoadState.idle;
  LoadState get songsState => _songsState;

  Future<void> init() async {
    await ConfigService.fetch();
    _authState = await AuthService.getState();
    notifyListeners();
  }

  Future<void> refreshAuth() async {
    _authState = await AuthService.getState();
    notifyListeners();
  }

  Future<void> loadMovies({bool forceRefresh = false}) async {
    if (_moviesState == LoadState.loading) return;
    _moviesState = LoadState.loading;
    _moviesError = '';
    notifyListeners();
    try {
      _movies = await MovieService.fetchMovies(forceRefresh: forceRefresh);
      _moviesState = LoadState.loaded;
    } catch (e) {
      _moviesError = e.toString();
      _moviesState = LoadState.error;
    }
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    if (query.trim().isEmpty) {
      _searchResults = [];
    } else {
      _searchResults = MovieService.search(_movies, query);
    }
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _searchResults = [];
    notifyListeners();
  }
}
