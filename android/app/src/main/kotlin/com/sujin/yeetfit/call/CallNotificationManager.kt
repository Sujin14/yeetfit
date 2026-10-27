package com.sujin.yeetfit.call

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.Person
import com.sujin.yeetfit.MainActivity
import com.sujin.yeetfit.R

object CallNotificationManager {
    private const val TAG = "YeetCall"

    fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val nm = context.getSystemService(NotificationManager::class.java) ?: return
        if (nm.getNotificationChannel(CallConstants.CHANNEL_ID) != null) {
            Log.d(TAG, "Call channel already exists: ${CallConstants.CHANNEL_ID}")
            return
        }
        val sound = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
        val attrs = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
            .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
            .build()
        val channel = NotificationChannel(
            CallConstants.CHANNEL_ID,
            "Incoming calls",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            setSound(sound, attrs)
            enableVibration(true)
            vibrationPattern = longArrayOf(0, 1000, 1000)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
        }
        nm.createNotificationChannel(channel)
        Log.d(TAG, "Created call channel: ${CallConstants.CHANNEL_ID}")
    }

    fun showIncomingCall(
        context: Context,
        callId: String,
        callerId: String,
        callerName: String,
        callerPhoto: String,
        callType: String,
        appInForeground: Boolean,
    ) {
        Log.d(
            TAG,
            "showIncomingCall: callId=$callId name=$callerName type=$callType fg=$appInForeground",
        )
        ensureChannel(context)

        context.getSharedPreferences(CallConstants.PREFS_NAME, Context.MODE_PRIVATE)
            .edit()
            .putString(CallConstants.KEY_ACTIVE_CALL_ID, callId)
            .apply()
        Log.d(TAG, "Saved active call id: $callId")

        fun putCallExtras(intent: Intent) {
            intent.putExtra(CallConstants.EXTRA_CALL_ID, callId)
            intent.putExtra(CallConstants.EXTRA_CALLER_ID, callerId)
            intent.putExtra(CallConstants.EXTRA_CALLER_NAME, callerName)
            intent.putExtra(CallConstants.EXTRA_CALLER_PHOTO, callerPhoto)
            intent.putExtra(CallConstants.EXTRA_CALL_TYPE, callType)
        }

        if (appInForeground) {
            Log.d(TAG, "Foreground path — IncomingCallActivity only (no notification)")
            val activityIntent = Intent(context, IncomingCallActivity::class.java).apply {
                putCallExtras(this)
                putExtra(CallConstants.EXTRA_PLAY_RINGTONE, true)
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_NO_USER_ACTION)
            }
            try {
                context.startActivity(activityIntent)
                return
            } catch (e: Exception) {
                Log.e(TAG, "Failed to start IncomingCallActivity: ${e.message}", e)
                Log.d(TAG, "Falling back to notification path")
            }
        }

        Log.d(TAG, "Background path — posting notification with FSI")
        postIncomingCallNotification(
            context = context,
            callId = callId,
            callerName = callerName,
            callType = callType,
            putCallExtras = ::putCallExtras,
        )
    }

    private fun postIncomingCallNotification(
        context: Context,
        callId: String,
        callerName: String,
        callType: String,
        putCallExtras: (Intent) -> Unit,
    ) {
        val piFlags = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE

        val fullScreenIntent = Intent(context, IncomingCallActivity::class.java).apply {
            putCallExtras(this)
            putExtra(CallConstants.EXTRA_PLAY_RINGTONE, false)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_NO_USER_ACTION)
        }
        val fullScreenPI = PendingIntent.getActivity(
            context,
            callId.hashCode(),
            fullScreenIntent,
            piFlags,
        )

        val answerIntent = Intent(context, MainActivity::class.java).apply {
            action = CallConstants.ACTION_ACCEPT
            putCallExtras(this)
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP,
            )
        }
        val answerPI = PendingIntent.getActivity(
            context,
            callId.hashCode() + 1,
            answerIntent,
            piFlags,
        )

        val declineIntent = Intent(context, CallActionReceiver::class.java).apply {
            action = CallConstants.ACTION_DECLINE
            putCallExtras(this)
        }
        val declinePI = PendingIntent.getBroadcast(
            context,
            callId.hashCode() + 2,
            declineIntent,
            piFlags,
        )

        val caller = Person.Builder()
            .setName(callerName)
            .setImportant(true)
            .build()

        val contentText = if (callType == "video") {
            "Incoming video call"
        } else {
            "Incoming audio call"
        }

        val builder = NotificationCompat.Builder(context, CallConstants.CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_call)
            .setContentTitle(callerName)
            .setContentText(contentText)
            .setCategory(NotificationCompat.CATEGORY_CALL)
            .setPriority(NotificationCompat.PRIORITY_MAX)
            .setOngoing(true)
            .setAutoCancel(false)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setFullScreenIntent(fullScreenPI, true)
            .setTimeoutAfter(CallConstants.RING_TIMEOUT_MS)
            .setStyle(
                NotificationCompat.CallStyle.forIncomingCall(caller, declinePI, answerPI),
            )

        val n = builder.build()
        n.flags = n.flags or Notification.FLAG_INSISTENT

        try {
            NotificationManagerCompat.from(context).notify(CallConstants.NOTIFICATION_ID, n)
            Log.d(TAG, "Incoming call notification posted id=${CallConstants.NOTIFICATION_ID}")
        } catch (e: SecurityException) {
            Log.e(TAG, "Failed to post incoming call notification: ${e.message}", e)
        }
    }

    fun showMissedCall(
        context: Context,
        callId: String,
        callerName: String,
        callType: String,
    ) {
        ensureMissedChannel(context)

        val tapIntent = Intent(context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        val tapPI = PendingIntent.getActivity(
            context,
            callId.hashCode() + 3,
            tapIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        val kind = if (callType == "video") "video" else "audio"
        val builder = NotificationCompat.Builder(context, CallConstants.MISSED_CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_stat_call)
            .setContentTitle("Missed call")
            .setContentText("Missed $kind call from $callerName")
            .setCategory(NotificationCompat.CATEGORY_MISSED_CALL)
            .setAutoCancel(true)
            .setContentIntent(tapPI)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setWhen(System.currentTimeMillis())
            .setShowWhen(true)

        try {
            NotificationManagerCompat.from(context).notify(callId.hashCode(), builder.build())
            Log.d(TAG, "Missed call notification posted for $callId")
        } catch (e: SecurityException) {
            Log.e(TAG, "Failed to post missed call notification: ${e.message}", e)
        }
    }

    private fun ensureMissedChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val nm = context.getSystemService(NotificationManager::class.java) ?: return
        if (nm.getNotificationChannel(CallConstants.MISSED_CHANNEL_ID) != null) {
            return
        }
        val channel = NotificationChannel(
            CallConstants.MISSED_CHANNEL_ID,
            "Missed calls",
            NotificationManager.IMPORTANCE_HIGH,
        ).apply {
            setSound(
                RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION),
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build(),
            )
        }
        nm.createNotificationChannel(channel)
        Log.d(TAG, "Created missed-call channel: ${CallConstants.MISSED_CHANNEL_ID}")
    }

    fun dismissIncomingCall(context: Context, callId: String?) {
        val prefs = context.getSharedPreferences(CallConstants.PREFS_NAME, Context.MODE_PRIVATE)
        val activeId = prefs.getString(CallConstants.KEY_ACTIVE_CALL_ID, null)
        if (callId != null && activeId != null && callId != activeId) {
            Log.d(TAG, "dismissIncomingCall: id mismatch callId=$callId active=$activeId — noop")
            return
        }
        Log.d(TAG, "dismissIncomingCall: callId=$callId active=$activeId")
        NotificationManagerCompat.from(context).cancel(CallConstants.NOTIFICATION_ID)
        prefs.edit().remove(CallConstants.KEY_ACTIVE_CALL_ID).apply()
        val dismiss = Intent(CallConstants.ACTION_DISMISS).apply {
            setPackage(context.packageName)
            putExtra(CallConstants.EXTRA_CALL_ID, callId)
        }
        context.sendBroadcast(dismiss)
    }

    fun getActiveCallId(context: Context): String? {
        return context.getSharedPreferences(CallConstants.PREFS_NAME, Context.MODE_PRIVATE)
            .getString(CallConstants.KEY_ACTIVE_CALL_ID, null)
    }
}
