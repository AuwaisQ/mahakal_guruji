# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# WorkManager (flutter_downloader)
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**

# Flutter Downloader
-keep class vn.hunghd.flutterdownloader.** { *; }
-dontwarn vn.hunghd.flutterdownloader.**

# Fluttertoast
-keep class io.github.ponnamkarthik.toast.fluttertoast.** { *; }

-keepattributes *Annotation*
-keepattributes Signature
-keepattributes Exceptions

# Razorpay Flutter
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**
