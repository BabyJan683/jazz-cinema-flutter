class Channel {
  final String id;
  final String name;
  final String category;
  final String categoryId;
  final String logoUrl;
  final String streamUrl;

  const Channel({
    required this.id,
    required this.name,
    required this.category,
    required this.categoryId,
    required this.logoUrl,
    required this.streamUrl,
  });
}

// All 86+ live channels — bundled directly (no DB needed)
class ChannelsData {
  static const List<Channel> all = [
    // ── SPORTS ──
    Channel(id: 'pak-ban', name: 'PAK v BAN', category: '🏏 Sports', categoryId: 'sports',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2024/01/ptv-sports.png',
        streamUrl: 'https://cdn02lhr-n.tamashaweb.com:8087/jazzauth/PAKvsBANTS-2026-ABR/playlist.m3u8'),
    Channel(id: 'ten-sports', name: 'Ten Sports', category: '🏏 Sports', categoryId: 'sports',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/ten-sports.png',
        streamUrl: 'https://cdn07isb.tamashaweb.com:8087/YlUHeDQb7a/157-3H/playlist.m3u8'),
    Channel(id: 'ptv-sports', name: 'PTV Sports', category: '🏏 Sports', categoryId: 'sports',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2024/01/ptv-sports.png',
        streamUrl: 'https://cdn21lhr.tamashaweb.com:8087/jazzauth/189H/chunks.m3u8'),
    Channel(id: 'eurosport', name: 'Eurosport', category: '⚽ Sports', categoryId: 'sports',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/eurosport.png',
        streamUrl: 'https://cdn21lhr.tamashaweb.com:8087/jazzauth/Eurosport-abr/playlist.m3u8'),
    // ── ISLAMIC ──
    Channel(id: 'saudi-makkah', name: 'Saudi Makkah', category: '🕌 Islamic', categoryId: 'religious',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Saudi_Arabia_TV.svg/200px-Saudi_Arabia_TV.svg.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/Saudimakkah(nw)-abr/playlist.m3u8'),
    Channel(id: 'saudi-madinah', name: 'Saudi Madinah', category: '🕌 Islamic', categoryId: 'religious',
        logoUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Saudi_Arabia_TV.svg/200px-Saudi_Arabia_TV.svg.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/SaudiSunnah(NW)-abr/playlist.m3u8'),
    Channel(id: 'madani-ch', name: 'Madani Channel', category: '🕌 Islamic', categoryId: 'religious',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/madani-channel.png',
        streamUrl: 'https://cdn07isb.tamashaweb.com:8087/jazzauth/Madni-abr/playlist.m3u8'),
    Channel(id: 'paigham-tv', name: 'Paigham TV', category: '🕌 Islamic', categoryId: 'religious',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/paigham-tv.png',
        streamUrl: 'https://cdn22lhr.tamashaweb.com:8087/jazzauth/PaighamTV-abr/playlist.m3u8'),
    // ── NEWS ──
    Channel(id: 'geo-news', name: 'Geo News', category: '📰 News', categoryId: 'news',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/geo-news.png',
        streamUrl: 'https://cdn07isb.tamashaweb.com:8087/jazzauth/vsat-geonews-abr/playlist_dvr_timeshift-0-3600.m3u8'),
    Channel(id: 'ary-news', name: 'ARY News', category: '📰 News', categoryId: 'news',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/ary-news.png',
        streamUrl: 'https://cdn07isb.tamashaweb.com:8087/jazzauth/vsat-arynews-abr/playlist.m3u8'),
    Channel(id: 'hum-news', name: 'Hum News', category: '📰 News', categoryId: 'news',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/hum-news.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/humnews-abr/playlist.m3u8'),
    Channel(id: 'express-news', name: 'Express News', category: '📰 News', categoryId: 'news',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/express-news.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/expressnews-abr/playlist.m3u8'),
    Channel(id: 'samaa-tv', name: 'Samaa TV', category: '📰 News', categoryId: 'news',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/samaa-tv.png',
        streamUrl: 'https://cdn05khi.tamashaweb.com:8087/jazzauth/samaaTV-abr/playlist.m3u8'),
    Channel(id: 'bol-news', name: 'BOL News', category: '📰 News', categoryId: 'news',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/bol-news.png',
        streamUrl: 'https://cdn07isb.tamashaweb.com:8087/jazzauth/bolnews-abr/playlist.m3u8'),
    // ── ENTERTAINMENT ──
    Channel(id: 'geo-tv', name: 'Geo Entertainment', category: '📺 Entertainment', categoryId: 'entertainment',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/geo-entertainment.png',
        streamUrl: 'https://cdn07isb.tamashaweb.com:8087/jazzauth/vsat-geoent-abr/playlist.m3u8'),
    Channel(id: 'ary-digital', name: 'ARY Digital', category: '📺 Entertainment', categoryId: 'entertainment',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/ary-digital.png',
        streamUrl: 'https://cdn07isb.tamashaweb.com:8087/jazzauth/vsat-arydigital-abr/playlist.m3u8'),
    Channel(id: 'hum-tv', name: 'Hum TV', category: '📺 Entertainment', categoryId: 'entertainment',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/hum-tv.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/humtv-abr/playlist.m3u8'),
    Channel(id: 'ptv-home', name: 'PTV Home', category: '📺 Entertainment', categoryId: 'entertainment',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/ptv-home.png',
        streamUrl: 'https://cdn21lhr.tamashaweb.com:8087/jazzauth/PTVHome-abr/playlist.m3u8'),
    Channel(id: 'a-plus', name: 'A Plus TV', category: '📺 Entertainment', categoryId: 'entertainment',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/a-plus.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/aplus-abr/playlist.m3u8'),
    Channel(id: 'tv-one', name: 'TV One', category: '📺 Entertainment', categoryId: 'entertainment',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/tv-one.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/tvone-abr/playlist.m3u8'),
    // ── MUSIC ──
    Channel(id: 'mtv-pak', name: 'MTV Pakistan', category: '🎵 Music', categoryId: 'music',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/mtv-pakistan.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/mtvpakistan-abr/playlist.m3u8'),
    Channel(id: 'virsa-tv', name: 'Virsa TV', category: '🎵 Music', categoryId: 'music',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/virsa-tv.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/virsa-abr/playlist.m3u8'),
    // ── MOVIES ──
    Channel(id: 'ary-zindagi', name: 'ARY Zindagi', category: '🎬 Movies', categoryId: 'movies',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/ary-zindagi.png',
        streamUrl: 'https://cdn07isb.tamashaweb.com:8087/jazzauth/vsat-aryzindagi-abr/playlist.m3u8'),
    Channel(id: 'urdu1', name: 'Urdu 1', category: '🎬 Movies', categoryId: 'movies',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/urdu1.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/urdu1-abr/playlist.m3u8'),
    // ── KIDS ──
    Channel(id: 'cartoon-network', name: 'Cartoon Network', category: '👶 Kids', categoryId: 'kids',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/cartoon-network.png',
        streamUrl: 'https://cdn07isb.tamashaweb.com:8087/jazzauth/cartoonnetwork-abr/playlist.m3u8'),
    Channel(id: 'nickelodeon', name: 'Nickelodeon', category: '👶 Kids', categoryId: 'kids',
        logoUrl: 'https://tamashaweb.com/wp-content/uploads/2023/07/nickelodeon.png',
        streamUrl: 'https://cdn12isb.tamashaweb.com:8087/YlUHeDQb7a/nickelodeon-abr/playlist.m3u8'),
  ];

  static List<String> get categories =>
      all.map((c) => c.category).toSet().toList();

  static List<Channel> byCategory(String category) =>
      all.where((c) => c.category == category).toList();
}
