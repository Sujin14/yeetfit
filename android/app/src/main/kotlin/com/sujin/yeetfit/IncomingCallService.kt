package com.sujin.yeetfit

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log

/// A phone-call foreground service may start an activity while the screen is on.
/// A full-screen intent does that only while the screen is off or the device is locked.
class IncomingCallService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val callId = intent?.getStringExtra(EXTRA_CALL_ID)
        if (callId.isNullOrEmpty()) {
            stopSelf(startId)
            return START_NOT_STICKY
        }
        val title = intent.getStringExtra(EXTRA_TITLE) ?: "Incoming call"
        val body = intent.getStringExtra(EXTRA_BODY) ?: "Your coach is calling you"
        rememberCallId(callId)
        val notification = buildNotification(callId, title, body)
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(
                    NOTIFICATION_ID,
                    notification,
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_PHONE_CALL,
                )
            } else {
                startForeground(NOTIFICATION_ID, notification)
            }
        } catch (error: Exception) {
            Log.e(TAG, "Could not enter the foreground for the incoming call", error)
        }
        val caller = intent.getStringExtra(EXTRA_CALLER).orEmpty().ifBlank { "Coach" }
        val placed = IncomingCallTelecom.place(this, callId, caller)
        if (!placed) IncomingCallLauncher.open(this, callId)
        Handler(Looper.getMainLooper()).postDelayed({
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                stopForeground(STOP_FOREGROUND_DETACH)
            } else {
                @Suppress("DEPRECATION")
                stopForeground(false)
            }
            stopSelf(startId)
        }, FOREGROUND_HOLD_MS)
        return START_NOT_STICKY
    }

    /// Splash reads this after a cold start. Commit so the new process sees it.
    private fun rememberCallId(callId: String) {
        getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(PREFS_KEY, callId)
            .commit()
    }

    private fun buildNotification(callId: String, title: String, body: String): Notification {
        val manager = getSystemService(NotificationManager::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Incoming calls",
                NotificationManager.IMPORTANCE_HIGH,
            ).apply {
                description = "Rings when a coach calls"
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                setSound(
                    RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE),
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build(),
                )
            }
            manager.createNotificationChannel(channel)
        }
        val open = PendingIntent.getActivity(
            this,
            callId.hashCode(),
            Intent(this, MainActivity::class.java).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
                putExtra(EXTRA_CALL_ID, callId)
            },
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val builder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, CHANNEL_ID)
        } else {
            @Suppress("DEPRECATION")
            Notification.Builder(this)
        }
        return builder
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(body)
            .setCategory(Notification.CATEGORY_CALL)
            .setOngoing(true)
            .setAutoCancel(false)
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setContentIntent(open)
            .setFullScreenIntent(open, true)
            .build()
    }

    companion object {
        const val EXTRA_CALL_ID = "incoming_call_id"
        const val EXTRA_CALLER = "incoming_call_caller"
        const val EXTRA_TITLE = "incoming_call_title"
        const val EXTRA_BODY = "incoming_call_body"
        const val CHANNEL_ID = "yeetfit_calls"
        const val NOTIFICATION_ID = 2002

        private const val TAG = "IncomingCallService"
        private const val PREFS_NAME = "FlutterSharedPreferences"
        private const val PREFS_KEY = "flutter.pending_call_id"
        private const val FOREGROUND_HOLD_MS = 5000L
    }
}
