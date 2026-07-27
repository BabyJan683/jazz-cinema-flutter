class Song {
  final int id;
  final String title;
  final String artist;
  final String category;
  final String driveUrl;
  final String thumbnailUrl;
  final int releaseYear;
  final int durationSec;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.category,
    required this.driveUrl,
    required this.thumbnailUrl,
    required this.releaseYear,
    required this.durationSec,
  });

  factory Song.fromMap(Map<String, dynamic> m) => Song(
        id: _int(m['id']),
        title: _str(m['title']),
        artist: _str(m['artist']),
        category: _str(m['category']),
        driveUrl: _str(m['drive_url']),
        thumbnailUrl: _str(m['thumbnail_url']),
        releaseYear: _int(m['release_year']),
        durationSec: _int(m['duration_sec']),
      );

  String get durationLabel {
    if (durationSec <= 0) return '';
    final m = durationSec ~/ 60;
    final s = durationSec % 60;
    return '${m}:${s.toString().padLeft(2, '0')}';
  }

  static int _int(dynamic v) => v is int ? v : int.tryParse('$v') ?? 0;
  static String _str(dynamic v) => v?.toString().trim() ?? '';
}
