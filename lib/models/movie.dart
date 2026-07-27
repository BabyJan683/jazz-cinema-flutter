class Movie {
  final int id;
  final String category;
  final String title;
  final String thumbnailUrl;
  final String driveUrl;
  final String playUrl;
  final int releaseYear;
  final String createdAt;
  final bool isSeries;

  Movie({
    required this.id,
    required this.category,
    required this.title,
    required this.thumbnailUrl,
    required this.driveUrl,
    required this.playUrl,
    required this.releaseYear,
    required this.createdAt,
    this.isSeries = false,
  });

  factory Movie.fromMap(Map<String, dynamic> m) => Movie(
        id: _int(m['id']),
        category: _str(m['category']),
        title: _str(m['title']),
        thumbnailUrl: _str(m['thumbnail_url']),
        driveUrl: _str(m['drive_url']),
        playUrl: _str(m['play_url']),
        releaseYear: _int(m['release_year']),
        createdAt: _str(m['created_at']),
        isSeries: _str(m['category']).toLowerCase().contains('series') ||
            _str(m['title']).toLowerCase().contains('s01') ||
            _str(m['title']).toLowerCase().contains('season'),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'title': title,
        'thumbnail_url': thumbnailUrl,
        'drive_url': driveUrl,
        'play_url': playUrl,
        'release_year': releaseYear,
        'created_at': createdAt,
      };

  static int _int(dynamic v) => v is int ? v : int.tryParse('$v') ?? 0;
  static String _str(dynamic v) => v?.toString().trim() ?? '';
}
