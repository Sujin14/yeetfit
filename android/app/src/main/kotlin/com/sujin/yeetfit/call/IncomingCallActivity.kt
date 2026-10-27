package com.sujin.yeetfit.call

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.AudioAttributes
import android.media.AudioManager
import android.media.MediaPlayer
import android.media.RingtoneManager
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.util.Log
import android.view.WindowManager
import android.widget.ImageButton
import android.widget.TextView
import androidx.activity.ComponentActivity
import androidx.activity.OnBackPressedCallback
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.sujin.yeetfit.MainActivity
import com.sujin.yeetfit.R

class IncomingCallActivity : ComponentActivity() {
    private val tag = "YeetCall"
    private val mainHandler = Handler(Looper.getMainLooper())
    private var callId: String = ""
    private var callerId: String = ""
    private var callerName: String = ""
    private var callerPhoto: String = ""
    private var callType: String = ""
    private var playRingtone: Boolean = false

    private var mediaPlayer: MediaPlayer? = null
    private var vibrator: Vibrator? = null

    private lateinit var avatarInitial: TextView
    private lateinit var callerNameView: TextView
    private lateinit var callTypeView: TextView

    private val ringTimeout = Runnable {
        Log.d(tag, "IncomingCallActivity: ring timeout — finishing $callId")
        stopRinging()
        finish()
    }

    private val dismissReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val dismissedId = intent?.getStringExtra(CallConstants.EXTRA_CALL_ID)
            if (dismissedId == null || dismissedId == callId) {
                Log.d(tag, "IncomingCallActivity: dismissed $callId")
                stopRinging()
                finish()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        applyLockScreenFlags()
        super.onCreate(savedInstanceState)

        if (!readExtras(intent)) {
            Log.d(tag, "IncomingCallActivity: empty callId — finishing")
            finish()
            return
        }
        if (!passesStaleGuard(callId)) {
            finish()
            return
        }

        setContentView(R.layout.activity_incoming_call)
        bindViews()
        updateUi()

        ContextCompat.registerReceiver(
            this,
            dismissReceiver,
            IntentFilter(CallConstants.ACTION_DISMISS),
            ContextCompat.RECEIVER_NOT_EXPORTED,
        )

        onBackPressedDispatcher.addCallback(
            this,
            object : OnBackPressedCallback(true) {
                override fun handleOnBackPressed() {
                    Log.d(tag, "IncomingCallActivity: back pressed — ignored")
                }
            },
        )

        if (playRingtone) {
            startRinging()
        }

        mainHandler.postDelayed(ringTimeout, CallConstants.RING_TIMEOUT_MS)
        Log.d(
            tag,
            "IncomingCallActivity: shown for $callId ($callerName) playRingtone=$playRingtone",
        )
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val previousId = callId
        if (!readExtras(intent)) {
            Log.d(tag, "IncomingCallActivity: onNewIntent empty callId — finishing")
            stopRinging()
            finish()
            return
        }
        if (callId != previousId) {
            Log.d(tag, "IncomingCallActivity: onNewIntent new callId=$callId (was $previousId)")
            if (!passesStaleGuard(callId)) {
                stopRinging()
                finish()
                return
            }
            updateUi()
            stopRinging()
            if (playRingtone) {
                startRinging()
            }
            mainHandler.removeCallbacks(ringTimeout)
            mainHandler.postDelayed(ringTimeout, CallConstants.RING_TIMEOUT_MS)
        }
    }

    override fun onDestroy() {
        mainHandler.removeCallbacks(ringTimeout)
        stopRinging()
        try {
            unregisterReceiver(dismissReceiver)
        } catch (_: IllegalArgumentException) {
            // Already unregistered or never registered.
        }
        super.onDestroy()
    }

    private fun startRinging() {
        val audioManager = getSystemService(AudioManager::class.java) ?: return
        when (audioManager.ringerMode) {
            AudioManager.RINGER_MODE_NORMAL -> {
                startMediaRingtone()
                startVibration()
            }
            AudioManager.RINGER_MODE_VIBRATE -> {
                startVibration()
            }
            AudioManager.RINGER_MODE_SILENT -> {
                Log.d(tag, "IncomingCallActivity: silent mode — no ring/vibrate")
            }
            else -> {
                Log.d(tag, "IncomingCallActivity: unknown ringerMode=${audioManager.ringerMode}")
            }
        }
    }

    private fun startMediaRingtone() {
        try {
            stopMediaPlayerOnly()
            val uri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE)
            val player = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build(),
                )
                setDataSource(this@IncomingCallActivity, uri)
                isLooping = true
                prepare()
                start()
            }
            mediaPlayer = player
            Log.d(tag, "IncomingCallActivity: ringtone started")
        } catch (e: Exception) {
            Log.e(tag, "IncomingCallActivity: MediaPlayer failed: ${e.message}", e)
            mediaPlayer = null
        }
    }

    private fun startVibration() {
        try {
            val pattern = longArrayOf(0, 1000, 1000)
            val vib = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                getSystemService(VibratorManager::class.java)?.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Vibrator::class.java)
            }
            vibrator = vib
            if (vib == null) {
                Log.d(tag, "IncomingCallActivity: no vibrator available")
                return
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                vib.vibrate(VibrationEffect.createWaveform(pattern, 0))
            } else {
                @Suppress("DEPRECATION")
                vib.vibrate(pattern, 0)
            }
            Log.d(tag, "IncomingCallActivity: vibration started")
        } catch (e: Exception) {
            Log.e(tag, "IncomingCallActivity: vibration failed: ${e.message}", e)
        }
    }

    private fun stopRinging() {
        stopMediaPlayerOnly()
        try {
            vibrator?.cancel()
        } catch (e: Exception) {
            Log.e(tag, "IncomingCallActivity: vibrator cancel failed: ${e.message}", e)
        }
        vibrator = null
    }

    private fun stopMediaPlayerOnly() {
        try {
            mediaPlayer?.let { player ->
                if (player.isPlaying) {
                    player.stop()
                }
                player.release()
            }
        } catch (e: Exception) {
            Log.e(tag, "IncomingCallActivity: MediaPlayer stop failed: ${e.message}", e)
        }
        mediaPlayer = null
    }

    private fun applyLockScreenFlags() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                    WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON,
            )
        }
        window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
    }

    private fun readExtras(source: Intent): Boolean {
        callId = source.getStringExtra(CallConstants.EXTRA_CALL_ID).orEmpty()
        callerId = source.getStringExtra(CallConstants.EXTRA_CALLER_ID).orEmpty()
        callerName = source.getStringExtra(CallConstants.EXTRA_CALLER_NAME).orEmpty()
            .ifBlank { "Incoming Call" }
        callerPhoto = source.getStringExtra(CallConstants.EXTRA_CALLER_PHOTO).orEmpty()
        callType = source.getStringExtra(CallConstants.EXTRA_CALL_TYPE).orEmpty()
            .ifBlank { "audio" }
        playRingtone = source.getBooleanExtra(CallConstants.EXTRA_PLAY_RINGTONE, false)
        return callId.isNotEmpty()
    }

    private fun passesStaleGuard(id: String): Boolean {
        val active = CallNotificationManager.getActiveCallId(this)
        if (active != id) {
            Log.d(tag, "IncomingCallActivity: stale launch for $id — finishing")
            return false
        }
        return true
    }

    private fun bindViews() {
        avatarInitial = findViewById(R.id.avatarInitial)
        callerNameView = findViewById(R.id.callerName)
        callTypeView = findViewById(R.id.callType)
        findViewById<ImageButton>(R.id.acceptButton).setOnClickListener { onAccept() }
        findViewById<ImageButton>(R.id.declineButton).setOnClickListener { onDecline() }
    }

    private fun updateUi() {
        callerNameView.text = callerName
        callTypeView.text = if (callType == "video") {
            "Incoming video call"
        } else {
            "Incoming audio call"
        }
        val initial = callerName.trim().firstOrNull()?.uppercaseChar()?.toString() ?: "?"
        avatarInitial.text = initial
    }

    private fun putCallExtras(intent: Intent) {
        intent.putExtra(CallConstants.EXTRA_CALL_ID, callId)
        intent.putExtra(CallConstants.EXTRA_CALLER_ID, callerId)
        intent.putExtra(CallConstants.EXTRA_CALLER_NAME, callerName)
        intent.putExtra(CallConstants.EXTRA_CALLER_PHOTO, callerPhoto)
        intent.putExtra(CallConstants.EXTRA_CALL_TYPE, callType)
    }

    private fun onAccept() {
        Log.d(tag, "IncomingCallActivity: accept $callId")
        stopRinging()
        val intent = Intent(this, MainActivity::class.java).apply {
            action = CallConstants.ACTION_ACCEPT
            putCallExtras(this)
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP,
            )
        }
        NotificationManagerCompat.from(this).cancel(CallConstants.NOTIFICATION_ID)
        startActivity(intent)
        finish()
    }

    private fun onDecline() {
        Log.d(tag, "IncomingCallActivity: decline $callId")
        stopRinging()
        val intent = Intent(this, CallActionReceiver::class.java).apply {
            action = CallConstants.ACTION_DECLINE
            putCallExtras(this)
        }
        sendBroadcast(intent)
        finish()
    }
}
