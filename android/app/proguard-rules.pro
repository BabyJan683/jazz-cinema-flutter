# ── Flutter core ──────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.plugin.** { *; }
-dontwarn io.flutter.**

# ── App classes ───────────────────────────────────────────────────────────────
-keep class com.cinema.jazz.** { *; }

# ── Kotlin stdlib (required by Kotlin-based plugins) ─────────────────────────
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}
-keepclassmembers class kotlin.Metadata {
    public <methods>;
}

# ── Kotlin coroutines ─────────────────────────────────────────────────────────
-keepnames class kotlinx.coroutines.internal.MainDispatcherFactory {}
-keepnames class kotlinx.coroutines.CoroutineExceptionHandler {}
-keepclassmembernames class kotlinx.** {
    volatile <fields>;
}
-dontwarn kotlinx.coroutines.**

# ── Play Core (required by Flutter deferred component loader) ─────────────────
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# ── video_player / ExoPlayer ──────────────────────────────────────────────────
-keep class com.google.android.exoplayer2.** { *; }
-dontwarn com.google.android.exoplayer2.**
-keep class androidx.media3.** { *; }
-dontwarn androidx.media3.**

# ── cached_network_image / okhttp (used by image cache) ──────────────────────
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep class okio.** { *; }

# ── shared_preferences ────────────────────────────────────────────────────────
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# ── mysql_client (pure Dart — dart:io TCP socket, no Java/Kotlin native code)
# No rules needed; R8 doesn't touch Dart code.  The dontwarn below silences
# any spurious warnings from older AGP versions scanning the AAR manifest.
-dontwarn com.mysql.**

# ── Prevent R8 from removing Dart-VM JNI bridge symbols ──────────────────────
-keep class io.flutter.view.** { *; }
-keep class io.flutter.util.** { *; }

# ── Suppress common spurious warnings from AndroidX & Jetpack ────────────────
-dontwarn androidx.**
-dontwarn android.support.**
-dontwarn com.android.support.**
