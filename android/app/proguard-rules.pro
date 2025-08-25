# --- Razorpay ---
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }
-keep @proguard.annotation.Keep class * { *; }
-keep @proguard.annotation.KeepClassMembers class * { *; }
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# --- Firebase ---
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# --- Flutter core ---
-keep class io.flutter.** { *; }

# --- SharedPreferences plugin ---
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# --- Google Pay (UPI) ---
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**

# --- Play Core SplitCompat / SplitInstall ---
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-dontwarn com.google.android.play.core.**
