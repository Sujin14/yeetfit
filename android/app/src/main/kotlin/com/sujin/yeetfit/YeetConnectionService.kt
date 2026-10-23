package com.sujin.yeetfit

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.telecom.Connection
import android.telecom.ConnectionRequest
import android.telecom.ConnectionService
import android.telecom.DisconnectCause
import android.telecom.PhoneAccount
import android.telecom.PhoneAccountHandle
import android.telecom.TelecomManager
import android.util.Log

/// Self-managed VoIP call. Telecom binds this service and then calls
/// [Connection.onShowIncomingCallUi], which is allowed to open an activity
/// while the screen is on. A full-screen intent is not.
class YeetConnectionService : ConnectionService() {
    override fun onCreateIncomingConnection(
        connectionManagerPhoneAccount: PhoneAccountHandle?,
        request: ConnectionRequest,
    ): Connection {
        val extras = request.extras ?: Bundle()
        val connection = YeetConnection(
            applicationContext,
            callId = extras.getString(IncomingCallService.EXTRA_CALL_ID).orEmpty(),
            callerName = extras.getString(IncomingCallService.EXTRA_CALLER).orEmpty().ifBlank { "Coach" },
        )
        IncomingCallRegistry.track(connection.callId, connection)
        return connection
    }

    override fun onCreateIncomingConnectionFailed(
        connectionManagerPhoneAccount: PhoneAccountHandle?,
        request: ConnectionRequest?,
    ) {
        val callId = request?.extras?.getString(IncomingCallService.EXTRA_CALL_ID) ?: return
        IncomingCallLauncher.open(this, callId)
    }
}

internal class YeetConnection(
    private val context: Context,
    val callId: String,
    callerName: String,
) : Connection() {
    private val mainHandler = Handler(Looper.getMainLooper())
    private var released = false
    private val ringTimeout = Runnable {
        if (state == STATE_RINGING) finish(DisconnectCause.MISSED)
    }

    init {
        connectionProperties = PROPERTY_SELF_MANAGED
        audioModeIsVoip = true
        setCallerDisplayName(callerName, TelecomManager.PRESENTATION_ALLOWED)
        val address = callId.ifBlank { "yeetfit" }
        setAddress(Uri.fromParts("sip", address, null), TelecomManager.PRESENTATION_ALLOWED)
        setRinging()
        mainHandler.postDelayed(ringTimeout, RING_TIMEOUT_MS)
    }

    override fun onShowIncomingCallUi() {
        if (callId.isNotEmpty()) IncomingCallLauncher.open(context, callId)
    }

    override fun onAnswer() {
        if (callId.isNotEmpty()) IncomingCallLauncher.open(context, callId)
        setActive()
    }

    override fun onReject() {
        finish(DisconnectCause.REJECTED)
    }

    override fun onDisconnect() {
        finish(DisconnectCause.LOCAL)
    }

    override fun onAbort() {
        finish(DisconnectCause.CANCELED)
    }

    fun finish(cause: Int) {
        mainHandler.post {
            if (released) return@post
            released = true
            mainHandler.removeCallbacks(ringTimeout)
            IncomingCallRegistry.untrack(callId)
            setDisconnected(DisconnectCause(cause))
            destroy()
        }
    }

    companion object {
        private const val RING_TIMEOUT_MS = 30_000L
    }
}

internal object IncomingCallRegistry {
    private val connections = mutableMapOf<String, YeetConnection>()

    internal fun track(callId: String, connection: YeetConnection) {
        if (callId.isEmpty()) return
        connections[callId] = connection
    }

    internal fun untrack(callId: String) {
        connections.remove(callId)
    }

    internal fun end(callId: String) {
        connections.remove(callId)?.finish(DisconnectCause.LOCAL)
    }
}

object IncomingCallTelecom {
    private const val TAG = "IncomingCallTelecom"
    private const val ACCOUNT_ID = "yeetfit_calls"

    fun place(context: Context, callId: String, callerName: String): Boolean {
        val telecom = context.getSystemService(TelecomManager::class.java) ?: return false
        val handle = PhoneAccountHandle(
            ComponentName(context, YeetConnectionService::class.java),
            ACCOUNT_ID,
        )
        val account = PhoneAccount.builder(handle, "Yeetfit")
            .setCapabilities(PhoneAccount.CAPABILITY_SELF_MANAGED)
            .build()
        return try {
            telecom.registerPhoneAccount(account)
            val extras = Bundle().apply {
                putString(IncomingCallService.EXTRA_CALL_ID, callId)
                putString(IncomingCallService.EXTRA_CALLER, callerName)
                putParcelable(
                    TelecomManager.EXTRA_INCOMING_CALL_ADDRESS,
                    Uri.fromParts("sip", callId, null),
                )
            }
            telecom.addNewIncomingCall(handle, extras)
            true
        } catch (error: Exception) {
            Log.e(TAG, "Telecom rejected the incoming call", error)
            false
        }
    }
}

object IncomingCallLauncher {
    fun open(context: Context, callId: String) {
        val launch = Intent(context, MainActivity::class.java).apply {
            addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_NO_USER_ACTION,
            )
            putExtra(IncomingCallService.EXTRA_CALL_ID, callId)
        }
        try {
            context.startActivity(launch)
        } catch (error: Exception) {
            Log.e("IncomingCallLauncher", "Could not open the call screen", error)
        }
    }
}
