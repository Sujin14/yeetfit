package com.sujin.yeetfit

import android.app.AppOpsManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Process
import android.provider.Settings

/// ColorOS hides a third-party call screen while the phone is unlocked unless
/// the app may draw over other apps and open a window from the background.
object CallPopupPermission {
    fun needsPrompt(context: Context): Boolean {
        if (!isColorOs()) return false
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(context)) {
            return true
        }
        return !isBackgroundPopupAllowed(context)
    }

    fun openSettings(context: Context) {
        val candidates = listOf(
            ComponentName(
                "com.oplus.safecenter",
                "com.oplus.safecenter.permission.floatwindow.FloatWindowListActivity",
            ),
            ComponentName(
                "com.coloros.safecenter",
                "com.coloros.safecenter.sysfloatwindow.FloatWindowListActivity",
            ),
            ComponentName(
                "com.coloros.safecenter",
                "com.coloros.safecenter.permission.floatwindow.FloatWindowListActivity",
            ),
            ComponentName(
                "com.oppo.safe",
                "com.oppo.safe.permission.floatwindow.FloatWindowListActivity",
            ),
        )
        for (component in candidates) {
            val intent = Intent().setComponent(component)
            if (startIfResolvable(context, intent)) return
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && !Settings.canDrawOverlays(context)) {
            val overlay = Intent(
                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                Uri.parse("package:${context.packageName}"),
            )
            if (startIfResolvable(context, overlay)) return
        }
        startIfResolvable(
            context,
            Intent(
                Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                Uri.parse("package:${context.packageName}"),
            ),
        )
    }

    private fun startIfResolvable(context: Context, intent: Intent): Boolean {
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        val canResolve = intent.resolveActivity(context.packageManager) != null
        if (!canResolve) return false
        return try {
            context.startActivity(intent)
            true
        } catch (_: Exception) {
            false
        }
    }

    private fun isColorOs(): Boolean {
        val brand = Build.BRAND.lowercase()
        val manufacturer = Build.MANUFACTURER.lowercase()
        return listOf("oppo", "realme", "oneplus", "oplus").any {
            brand.contains(it) || manufacturer.contains(it)
        }
    }

    /// ColorOS keeps this as a hidden app-op. 10021 is the background pop-up op
    /// used by ColorOS. If the op cannot be read, do not keep prompting.
    private fun isBackgroundPopupAllowed(context: Context): Boolean {
        return try {
            val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val check = AppOpsManager::class.java.getMethod(
                "checkOpNoThrow",
                Int::class.javaPrimitiveType,
                Int::class.javaPrimitiveType,
                String::class.java,
            )
            val mode = check.invoke(appOps, BACKGROUND_POPUP_OP, Process.myUid(), context.packageName) as Int
            mode == AppOpsManager.MODE_ALLOWED
        } catch (_: Exception) {
            true
        }
    }

    private const val BACKGROUND_POPUP_OP = 10021
}
