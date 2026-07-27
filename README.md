# 🎬 Jazz Cinema Pro — Flutter v11

Beautiful Flutter-powered movie streaming app. Rebuilt from Jazz Cinema v10 (Java/Android) into a stunning Material Design 3 app.

## 🚀 Auto APK Build

Every push to `main` automatically builds and releases an APK:

👉 **[Download Latest APK →](../../releases/latest)**

## ✨ Features

| Feature | Status |
|---------|--------|
| 🎬 Movies & Series | ✅ Full browsing, banner, search |
| 📺 Live TV | ✅ 25+ channels with HLS player |
| ▶️ Video Player | ✅ Chewie-powered with controls |
| 🔐 Key Activation | ✅ JAZZ-XXXXX format, 30-day keys |
| 🆓 Trial Mode | ✅ 4 movies/day, device-level |
| 🎨 5 Themes | ✅ Netflix Red, Ocean Blue, Royal Purple, Night Teal, Cinema Amber |
| 📥 Downloads | 🔄 Coming in v11.1 |
| 🎵 Songs | 🔄 Coming in v11.1 |
| 📱 Shorts | 🔄 Coming in v11.1 |

## 📲 How to Install APK

1. Go to **[Releases](../../releases)**
2. Download `app-release.apk`
3. On Android: **Settings → Security → Allow unknown sources**
4. Open the APK and install

## 🎨 App Themes

| Theme | Colors |
|-------|--------|
| 🎬 Default | Netflix Red + Dark |
| 🌊 Ocean | Blue + Orange |
| 👑 Royal Cinema | Purple + Gold |
| 🌙 Night Mode | Teal + Dark |
| 🔥 Cinema Warm | Amber + Warm |

> Switch themes: **Settings → App Theme**

## 🔑 Key Activation

Keys are in format: `JAZZ-XXXXX-XXXXX-XXXXX`

- **Licensed**: 30 days unlimited access
- **Trial**: 4 movies per day (device-level, no registration needed)

## 🏗️ Build Locally

```bash
flutter pub get
flutter build apk --release
```

**Prerequisites:** Flutter 3.24+, JDK 17+

## 🔄 GitHub Actions

The workflow at `.github/workflows/build-apk.yml`:
1. Sets up Flutter + JDK 17
2. Generates a self-signed keystore
3. Builds signed release APK
4. Creates GitHub Release with download links

**For persistent signing** (APK updates without uninstall), set these GitHub Secrets:
- `KEYSTORE_BASE64` — your keystore file encoded in base64
- `KEYSTORE_PASSWORD` — keystore password
- `KEY_ALIAS` — key alias
- `KEY_PASSWORD` — key password

## 📦 Stack

- **Flutter 3.24** + Dart 3
- **Material Design 3** dark theme
- **Provider** state management
- **mysql_client** — direct MySQL connection (mirrors original Java app)
- **video_player + chewie** — video playback
- **cached_network_image** — fast image loading
- **flutter_animate** — smooth animations
- **Google Fonts (Poppins)**

---

*Built from Jazz Cinema v10 Android source. Rebuilt in Flutter v11.*
