package com.sujin.yeetfit

import android.app.NotificationManager
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.view.WindowManager
import com.sujin.yeetfit.call.AppState
import com.sujin.yeetfit.call.CallConstants
import com.sujin.yeetfit.call.CallNotificationManager
import com.sujin.yeetfit.call.CallReadiness
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity: the health plugin requests Health Connect
// permissions through registerForActivityResult, which needs a ComponentActivity.
class MainActivity : FlutterFragmentActivity() {
    private var callChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PERMISSIONS_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "canUseFullScreenIntent" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        val nm = getSystemService(NotificationManager::class.java)
                        val granted = nm?.canUseFullScreenIntent() == true
                        Log.d(TAG, "canUseFullScreenIntent=$granted")
                        result.success(granted)
                    } else {
                        result.success(true)
                    }
                }
                "requestFullScreenIntent" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        val nm = getSystemService(NotificationManager::class.java)
                        if (nm?.canUseFullScreenIntent() != true) {
                            startActivity(
                                Intent(
                                    Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT,
                                    Uri.parse("package:$packageName"),
                                ),
                            )
                            Log.d(TAG, "Opened full-screen intent settings")
                        }
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        callChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CALL_CHANNEL,
        ).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "consumePendingAcceptedCall" -> {
                        val id = pendingAcceptedCallId
                        pendingAcceptedCallId = null
                        Log.d(TAG, "consumePendingAcceptedCall -> $id")
                        result.success(id)
                    }
                    "dismissIncomingCall" -> {
                        val callId = call.arguments as? String
                        CallNotificationManager.dismissIncomingCall(this, callId)
                        result.success(null)
                    }
                    "getActiveRingingCallId" -> {
                        result.success(CallNotificationManager.getActiveCallId(this))
                    }
                    "clearLockScreenFlags" -> {
                        clearLockScreenFlags()
                        result.success(null)
                    }
                    "getCallReadiness" -> {
                        result.success(CallReadiness.status(this))
                    }
                    "openCallSetting" -> {
                        val which = call.arguments as? String ?: ""
                        result.success(CallReadiness.open(this, which))
                    }
                    "scheduleTestCall" -> {
                        val delayMs = when (val arg = call.arguments) {
                            is Int -> arg.toLong()
                            is Long -> arg
                            is Number -> arg.toLong()
                            else -> 10_000L
                        }
                        CallReadiness.scheduleTestCall(this, delayMs)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleCallIntent(intent)
    }

    override fun onResume() {
        super.onResume()
        AppState.mainActivityResumed = true
    }

    override fun onPause() {
        AppState.mainActivityResumed = false
        super.onPause()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleCallIntent(intent)
    }

    private fun handleCallIntent(intent: Intent?) {
        if (intent?.action != CallConstants.ACTION_ACCEPT) return
        val callId = intent.getStringExtra(CallConstants.EXTRA_CALL_ID).orEmpty()
        if (callId.isEmpty()) {
            Log.d(TAG, "handleCallIntent: empty callId — ignoring")
            return
        }
        Log.d(TAG, "handleCallIntent: ACTION_ACCEPT callId=$callId")
        CallNotificationManager.dismissIncomingCall(this, callId)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED)
        }

        pendingAcceptedCallId = callId
        callChannel?.invokeMethod("callAccepted", callId)
        intent.action = null
    }

    private fun clearLockScreenFlags() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(false)
            setTurnScreenOn(false)
        } else {
            @Suppress("DEPRECATION")
            window.clearFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
            )
        }
        Log.d(TAG, "clearLockScreenFlags")
    }

    companion object {
        private const val TAG = "YeetCall"
        private const val PERMISSIONS_CHANNEL = "com.yeetfit/permissions"
        private const val CALL_CHANNEL = "com.yeetfit/call"

        @Volatile
        var pendingAcceptedCallId: String? = null
    }
}
