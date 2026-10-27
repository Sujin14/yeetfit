package com.sujin.yeetfit.call

import android.app.NotificationManager
import android.content.ActivityNotFoundException
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.provider.Settings
import android.util.Log
import androidx.core.app.NotificationManagerCompat

object CallReadiness {
    private const val TAG = "YeetCall"

    private val oemManufacturers = setOf(
        "xiaomi", "redmi", "poco",
        "oppo", "realme", "oneplus",
        "vivo", "iqoo",
        "huawei", "honor",
        "infinix", "tecno", "itel",
        "asus",
    )

    fun status(context: Context): Map<String, Any> {
        CallNotificationManager.ensureChannel(context)
        val manufacturer = Build.MANUFACTURER.lowercase()
        val notificationsEnabled =
            NotificationManagerCompat.from(context).areNotificationsEnabled()
        val channelOk = isChannelHighImportance(context)
        val fullScreenOk = isFullScreenOk(context)
        val batteryOk = isBatteryOk(context)
        val needsOem = oemManufacturers.any { manufacturer.contains(it) }
        return mapOf(
            "notificationsEnabled" to notificationsEnabled,
            "channelOk" to channelOk,
            "fullScreenOk" to fullScreenOk,
            "batteryOk" to batteryOk,
            "manufacturer" to manufacturer,
            "needsOemSetup" to needsOem,
            "oemInstructions" to oemInstructions(manufacturer),
        )
    }

    fun open(context: Context, which: String): Boolean {
        return when (which) {
            "notifications" -> openNotifications(context)
            "channel" -> openChannel(context)
            "fullScreen" -> openFullScreen(context)
            "battery" -> openBattery(context)
            "oem" -> openOem(context)
            else -> {
                Log.d(TAG, "CallReadiness.open: unknown which=$which")
                false
            }
        }
    }

    fun scheduleTestCall(context: Context, delayMs: Long) {
        val appContext = context.applicationContext
        Log.d(TAG, "CallReadiness.scheduleTestCall delayMs=$delayMs")
        Handler(Looper.getMainLooper()).postDelayed({
            CallNotificationManager.showIncomingCall(
                context = appContext,
                callId = "test_${System.currentTimeMillis()}",
                callerId = "",
                callerName = "YeetFit test call",
                callerPhoto = "",
                callType = "audio",
                appInForeground = AppState.isForeground(appContext),
            )
        }, delayMs)
    }

    private fun isChannelHighImportance(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return true
        val nm = context.getSystemService(NotificationManager::class.java) ?: return false
        val channel = nm.getNotificationChannel(CallConstants.CHANNEL_ID) ?: return false
        return channel.importance >= NotificationManager.IMPORTANCE_HIGH
    }

    private fun isFullScreenOk(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) return true
        val nm = context.getSystemService(NotificationManager::class.java) ?: return false
        return nm.canUseFullScreenIntent()
    }

    private fun isBatteryOk(context: Context): Boolean {
        val pm = context.getSystemService(PowerManager::class.java) ?: return true
        return pm.isIgnoringBatteryOptimizations(context.packageName)
    }

    private fun oemInstructions(manufacturer: String): String = when {
        manufacturer.contains("xiaomi") ||
            manufacturer.contains("redmi") ||
            manufacturer.contains("poco") ->
            "1) In Other permissions, allow 'Show on lock screen' and " +
                "'Display pop-up windows while running in the background'. " +
                "2) Turn on Autostart. " +
                "3) In Notifications > Incoming calls, turn on " +
                "'Lock screen notifications' and 'Floating notifications'."
        manufacturer.contains("oppo") ||
            manufacturer.contains("realme") ||
            manufacturer.contains("oneplus") ->
            "Enable Auto launch, and allow 'Display over other apps' and " +
                "lock-screen display. In Notifications > Incoming calls, " +
                "turn on lock screen and pop-up/floating notifications."
        manufacturer.contains("vivo") || manufacturer.contains("iqoo") ->
            "Enable Background start-up / Auto start and 'Show on lock screen'. " +
                "In Notifications > Incoming calls, turn on lock screen and " +
                "pop-up/floating notifications."
        manufacturer.contains("huawei") || manufacturer.contains("honor") ->
            "Set YeetFit to 'Manage manually' in App launch and enable all " +
                "three toggles. In Notifications > Incoming calls, turn on " +
                "lock screen and pop-up/floating notifications."
        manufacturer.contains("infinix") ||
            manufacturer.contains("tecno") ||
            manufacturer.contains("itel") ->
            "Enable Auto-start in Phone Master."
        manufacturer.contains("asus") ->
            "Enable Auto-start."
        else -> ""
    }

    private fun openNotifications(context: Context): Boolean {
        val intent = Intent(Settings.ACTION_APP_NOTIFICATION_SETTINGS).apply {
            putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
        }
        return tryStart(context, intent, "notifications")
    }

    private fun openChannel(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            return openNotifications(context)
        }
        val intent = Intent(Settings.ACTION_CHANNEL_NOTIFICATION_SETTINGS).apply {
            putExtra(Settings.EXTRA_APP_PACKAGE, context.packageName)
            putExtra(Settings.EXTRA_CHANNEL_ID, CallConstants.CHANNEL_ID)
        }
        return tryStart(context, intent, "channel")
    }

    private fun openFullScreen(context: Context): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            Log.d(TAG, "CallReadiness.open fullScreen: not needed below API 34")
            return false
        }
        val intent = Intent(
            Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT,
            Uri.parse("package:${context.packageName}"),
        )
        return tryStart(context, intent, "fullScreen")
    }

    private fun openBattery(context: Context): Boolean {
        val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
        return tryStart(context, intent, "battery")
    }

    private fun openOem(context: Context): Boolean {
        val manufacturer = Build.MANUFACTURER.lowercase()
        val candidates = oemCandidates(context, manufacturer) +
            listOf(appDetailsIntent(context))
        for ((label, intent) in candidates) {
            if (!canResolve(context, intent)) {
                Log.d(TAG, "CallReadiness.oem skip (unresolvable): $label")
                continue
            }
            if (tryStart(context, intent, "oem:$label")) return true
        }
        Log.d(TAG, "CallReadiness.oem: nothing opened")
        return false
    }

    private fun oemCandidates(
        context: Context,
        manufacturer: String,
    ): List<Pair<String, Intent>> {
        val pkg = context.packageName
        return when {
            manufacturer.contains("xiaomi") ||
                manufacturer.contains("redmi") ||
                manufacturer.contains("poco") -> listOf(
                "miui_perm_editor" to Intent("miui.intent.action.APP_PERM_EDITOR").apply {
                    setClassName(
                        "com.miui.securitycenter",
                        "com.miui.permcenter.permissions.PermissionsEditorActivity",
                    )
                    putExtra("extra_pkgname", pkg)
                },
                "miui_autostart" to Intent().setClassName(
                    "com.miui.securitycenter",
                    "com.miui.permcenter.autostart.AutoStartManagementActivity",
                ),
            )
            manufacturer.contains("oppo") ||
                manufacturer.contains("realme") ||
                manufacturer.contains("oneplus") -> listOf(
                "oplus_float" to componentIntent(
                    "com.oplus.safecenter",
                    "com.oplus.safecenter.permission.floatwindow.FloatWindowListActivity",
                ),
                "coloros_sysfloat" to componentIntent(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.sysfloatwindow.FloatWindowListActivity",
                ),
                "coloros_float" to componentIntent(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.permission.floatwindow.FloatWindowListActivity",
                ),
                "oppo_float" to componentIntent(
                    "com.oppo.safe",
                    "com.oppo.safe.permission.floatwindow.FloatWindowListActivity",
                ),
                "coloros_startup" to componentIntent(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.permission.startup.StartupAppListActivity",
                ),
                "coloros_startupapp" to componentIntent(
                    "com.coloros.safecenter",
                    "com.coloros.safecenter.startupapp.StartupAppListActivity",
                ),
                "oppo_startup" to componentIntent(
                    "com.oppo.safe",
                    "com.oppo.safe.permission.startup.StartupAppListActivity",
                ),
                "oneplus_chain" to componentIntent(
                    "com.oneplus.security",
                    "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity",
                ),
            )
            manufacturer.contains("vivo") || manufacturer.contains("iqoo") -> listOf(
                "vivo_bg" to componentIntent(
                    "com.vivo.permissionmanager",
                    "com.vivo.permissionmanager.activity.BgStartUpManagerActivity",
                ),
                "iqoo_bg" to componentIntent(
                    "com.iqoo.secure",
                    "com.iqoo.secure.ui.phoneoptimize.BgStartUpManager",
                ),
                "iqoo_whitelist" to componentIntent(
                    "com.iqoo.secure",
                    "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity",
                ),
            )
            manufacturer.contains("huawei") -> listOf(
                "huawei_startup" to componentIntent(
                    "com.huawei.systemmanager",
                    "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity",
                ),
                "huawei_protect" to componentIntent(
                    "com.huawei.systemmanager",
                    "com.huawei.systemmanager.optimize.process.ProtectActivity",
                ),
            )
            manufacturer.contains("honor") -> listOf(
                "honor_startup" to componentIntent(
                    "com.hihonor.systemmanager",
                    "com.hihonor.systemmanager.startupmgr.ui.StartupNormalAppListActivity",
                ),
            )
            manufacturer.contains("infinix") ||
                manufacturer.contains("tecno") ||
                manufacturer.contains("itel") -> listOf(
                "transsion_autostart" to componentIntent(
                    "com.transsion.phonemaster",
                    "com.cyin.himgr.autostart.AutoStartActivity",
                ),
            )
            manufacturer.contains("asus") -> listOf(
                "asus_autostart" to componentIntent(
                    "com.asus.mobilemanager",
                    "com.asus.mobilemanager.autostart.AutoStartActivity",
                ),
            )
            else -> emptyList()
        }
    }

    private fun componentIntent(packageName: String, className: String): Intent {
        return Intent().setComponent(ComponentName(packageName, className))
    }

    private fun appDetailsIntent(context: Context): Pair<String, Intent> {
        return "app_details" to Intent(
            Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
            Uri.parse("package:${context.packageName}"),
        )
    }

    private fun canResolve(context: Context, intent: Intent): Boolean {
        return context.packageManager.resolveActivity(intent, 0) != null
    }

    private fun tryStart(context: Context, intent: Intent, label: String): Boolean {
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        return try {
            context.startActivity(intent)
            Log.d(TAG, "CallReadiness.open opened: $label")
            true
        } catch (e: ActivityNotFoundException) {
            Log.d(TAG, "CallReadiness.open failed ($label): ${e.message}")
            false
        } catch (e: SecurityException) {
            Log.d(TAG, "CallReadiness.open denied ($label): ${e.message}")
            false
        }
    }
}
