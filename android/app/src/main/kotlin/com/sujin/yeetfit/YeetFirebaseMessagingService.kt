package com.sujin.yeetfit

import android.app.NotificationManager
import android.os.Build
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import com.sujin.yeetfit.call.AppState
import com.sujin.yeetfit.call.CallNotificationManager

/// Incoming / cancelled calls use [CallNotificationManager]. Token events are
/// forwarded to firebase_messaging via reflection.
class YeetFirebaseMessagingService : FirebaseMessagingService() {
    override fun onCreate() {
        super.onCreate()
        deleteStaleCallChannel()
    }

    override fun onNewToken(token: String) {
        // Mirror FlutterFirebaseMessagingService so Dart still receives token updates.
        forwardFlutterLiveData("FlutterFirebaseTokenLiveData", "postToken", token)
    }

    override fun onMessageReceived(message: RemoteMessage) {
        val type = message.data["type"]
        val data = message.data
        Log.d(TAG, "FCM received | type=$type")

        if (type == "incoming_call") {
            val callId = data["callId"].orEmpty()
            if (callId.isEmpty()) {
                Log.e(TAG, "incoming_call without callId")
                return
            }
            val foreground = AppState.isForeground(this)
            CallNotificationManager.showIncomingCall(
                context = this,
                callId = callId,
                callerId = data["callerId"].orEmpty(),
                callerName = data["callerName"].orEmpty().ifBlank { "Incoming Call" },
                callerPhoto = data["callerPhotoUrl"].orEmpty(),
                callType = data["callType"] ?: "audio",
                appInForeground = foreground,
            )
            return
        }

        if (type == "call_cancelled") {
            val callId = data["callId"].orEmpty()
            Log.d(TAG, "FCM call_cancelled for $callId reason=${data["reason"]}")
            CallNotificationManager.dismissIncomingCall(this, callId.ifEmpty { null })
            if (callId.isNotEmpty() && !callId.startsWith("test_")) {
                CallNotificationManager.showMissedCall(
                    context = this,
                    callId = callId,
                    callerName = data["callerName"].orEmpty().ifBlank { "your coach" },
                    callType = data["callType"] ?: "audio",
                )
            }
            return
        }

        Log.d(TAG, "Non-call FCM — FlutterFirebaseMessagingReceiver handles Dart delivery")
    }

    /// Removes an old CallKit channel that may block heads-up behavior.
    private fun deleteStaleCallChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val nm = getSystemService(NotificationManager::class.java) ?: return
        for (channelId in listOf(LEGACY_CALLKIT_CHANNEL_V2, LEGACY_CALLKIT_CHANNEL)) {
            val existing = nm.getNotificationChannel(channelId) ?: continue
            if (existing.sound == null) {
                nm.deleteNotificationChannel(channelId)
                Log.d(TAG, "Deleted soundless call channel $channelId")
            }
        }
    }

    private fun forwardFlutterLiveData(
        simpleClassName: String,
        postMethod: String,
        value: String,
    ) {
        try {
            val clazz = Class.forName(
                "io.flutter.plugins.firebase.messaging.$simpleClassName",
            )
            val instance = clazz.getMethod("getInstance").invoke(null)
            clazz.getMethod(postMethod, String::class.java).invoke(instance, value)
        } catch (e: Exception) {
            Log.w(TAG, "Could not forward $postMethod to $simpleClassName: ${e.message}")
        }
    }

    companion object {
        private const val TAG = "YeetCall"
        private const val LEGACY_CALLKIT_CHANNEL_V2 = "callkit_incoming_channel_id_v2"
        private const val LEGACY_CALLKIT_CHANNEL = "callkit_incoming_channel_id"
    }
}
