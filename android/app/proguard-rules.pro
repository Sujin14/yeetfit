# --- Firebase ---
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- Flutter core ---
-keep class io.flutter.** { *; }

# Native incoming-call / FCM entry points.
-keep class com.sujin.yeetfit.YeetFirebaseMessagingService { *; }
-keep class com.sujin.yeetfit.MainActivity { *; }
-keep class com.sujin.yeetfit.call.** { *; }

# --- SharedPreferences plugin ---
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# --- Play Core SplitCompat / SplitInstall ---
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.**
