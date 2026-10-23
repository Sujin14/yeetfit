# --- Firebase ---
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- Flutter core ---
-keep class io.flutter.** { *; }

# Incoming-call Telecom components are started from the manifest.
-keep class com.sujin.yeetfit.IncomingCallReceiver { *; }
-keep class com.sujin.yeetfit.IncomingCallService { *; }
-keep class com.sujin.yeetfit.YeetConnectionService { *; }
-keep class com.sujin.yeetfit.MainActivity { *; }

# --- SharedPreferences plugin ---
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# --- Play Core SplitCompat / SplitInstall ---
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.**
