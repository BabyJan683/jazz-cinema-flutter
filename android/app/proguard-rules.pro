-keep class io.flutter.** { *; }
-keep class com.cinema.jazz.** { *; }
-dontwarn com.mysql.**
-keep class com.mysql.** { *; }

# Play Core — referenced by Flutter deferred components loader
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }
