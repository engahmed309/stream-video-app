# Keep Conscrypt classes used by okhttp
-keep class org.conscrypt.** { *; }
-dontwarn org.conscrypt.**

# Optional: Keep Stream Video Flutter internals
-keep class io.getstream.video.flutter.** { *; }
-dontwarn io.getstream.video.flutter.**
