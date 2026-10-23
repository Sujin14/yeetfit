package com.sujin.yeetfit

import android.content.Intent
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FlutterFragmentActivity: the health plugin requests Health Connect
// permissions through registerForActivityResult, which needs a ComponentActivity.
class MainActivity : FlutterFragmentActivity() {
    private var callChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        callChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CALL_CHANNEL)
        callChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "needsCallPopupPermission" -> result.success(CallPopupPermission.needsPrompt(this))
                "openCallPopupSettings" -> {
                    CallPopupPermission.openSettings(this)
                    result.success(null)
                }
                "consumeLaunchCall" -> result.success(consumeLaunchCall())
                "endIncomingCall" -> {
                    val callId = call.arguments as? String
                    if (!callId.isNullOrEmpty()) IncomingCallRegistry.end(callId)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        showOverLockScreen()
        super.onCreate(savedInstanceState)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        showOverLockScreen()
        dispatchIncomingCall(intent)
    }

    /// The process was already alive, so splash will not read the pending call again.
    private fun dispatchIncomingCall(intent: Intent?) {
        val callId = intent?.getStringExtra(IncomingCallService.EXTRA_CALL_ID) ?: return
        callChannel?.invokeMethod("incomingCall", callId)
    }

    private fun consumeLaunchCall(): String? {
        val callId = intent?.getStringExtra(IncomingCallService.EXTRA_CALL_ID) ?: return null
        intent?.removeExtra(IncomingCallService.EXTRA_CALL_ID)
        return callId
    }

    private fun showOverLockScreen() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        }
    }

    companion object {
        const val CALL_CHANNEL = "com.sujin.yeetfit/incoming_call"
    }
}
