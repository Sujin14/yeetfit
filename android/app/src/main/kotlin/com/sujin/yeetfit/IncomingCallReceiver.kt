package com.sujin.yeetfit

import android.app.ActivityManager
import android.app.KeyguardManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.firebase.messaging.RemoteMessage

/// High-priority incoming-call pushes arrive here even when the process is dead.
/// ColorOS turns a full-screen intent into a notification while the screen is on,
/// so the call is handed to Telecom, which is allowed to open the call screen.
class IncomingCallReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val extras = intent.extras ?: return
        val message = try {
            RemoteMessage(extras)
        } catch (error: Exception) {
            Log.w(TAG, "Ignoring push that is not a RemoteMessage", error)
            return
        }
        val data = message.data
        if (data["type"] != "incoming_call") return
        val callId = data["callId"]
        if (callId.isNullOrEmpty()) return
        if (isApplicationForeground(context)) return

        rememberCallId(context, callId)
        val caller = data["callerName"].orEmpty().ifBlank { "Coach" }
        val title = data["title"].orEmpty().ifBlank { "Incoming call" }
        val body = data["body"].orEmpty().ifBlank { "$caller is calling you" }
        // Telecom may open the screen while the phone is unlocked. The direct
        // launch is the fallback once ColorOS allows background pop-ups.
        val placed = IncomingCallTelecom.place(context, callId, caller)
        if (!placed) {
            try {
                context.startForegroundService(
                    Intent(context, IncomingCallService::class.java).apply {
                        putExtra(IncomingCallService.EXTRA_CALL_ID, callId)
                        putExtra(IncomingCallService.EXTRA_CALLER, caller)
                        putExtra(IncomingCallService.EXTRA_TITLE, title)
                        putExtra(IncomingCallService.EXTRA_BODY, body)
                    },
                )
            } catch (error: Exception) {
                Log.e(TAG, "Could not start the incoming call service", error)
            }
        }
        IncomingCallLauncher.open(context, callId)
    }

    private fun rememberCallId(context: Context, callId: String) {
        context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(PREFS_KEY, callId)
            .commit()
    }

    private fun isApplicationForeground(context: Context): Boolean {
        val keyguard = context.getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
        if (keyguard?.isKeyguardLocked == true) return false
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager
            ?: return false
        val packageName = context.packageName
        return activityManager.runningAppProcesses.orEmpty().any { process ->
            process.importance == ActivityManager.RunningAppProcessInfo.IMPORTANCE_FOREGROUND &&
                process.processName == packageName
        }
    }

    companion object {
        private const val TAG = "IncomingCallReceiver"
        private const val PREFS_NAME = "FlutterSharedPreferences"
        private const val PREFS_KEY = "flutter.pending_call_id"
    }
}
