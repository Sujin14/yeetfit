package com.sujin.yeetfit.call

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.firebase.firestore.FieldValue
import com.google.firebase.firestore.FirebaseFirestore
import java.util.concurrent.atomic.AtomicBoolean

class CallActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action != CallConstants.ACTION_DECLINE) return
        val callId = intent.getStringExtra(CallConstants.EXTRA_CALL_ID).orEmpty()
        if (callId.isEmpty()) {
            Log.d(TAG, "CallActionReceiver: decline with empty callId — ignoring")
            return
        }

        Log.d(TAG, "CallActionReceiver: decline $callId")
        CallNotificationManager.dismissIncomingCall(context, callId)

        if (callId.startsWith("test_")) {
            Log.d(TAG, "CallActionReceiver: test call — skip Firestore")
            return
        }

        val pending = goAsync()
        val finished = AtomicBoolean(false)
        fun finishOnce(reason: String) {
            if (!finished.compareAndSet(false, true)) return
            Log.d(TAG, "CallActionReceiver: pending.finish ($reason) callId=$callId")
            pending.finish()
        }

        Handler(Looper.getMainLooper()).postDelayed(
            { finishOnce("timeout") },
            SAFETY_NET_MS,
        )

        val callRef = FirebaseFirestore.getInstance().collection("calls").document(callId)
        FirebaseFirestore.getInstance().runTransaction { transaction ->
            val snapshot = transaction.get(callRef)
            val status = snapshot.getString("status")
            if (status == "ringing") {
                transaction.update(
                    callRef,
                    mapOf(
                        "status" to "declined",
                        "endedAt" to FieldValue.serverTimestamp(),
                    ),
                )
                Log.d(TAG, "CallActionReceiver: transaction set declined for $callId")
            } else {
                Log.d(
                    TAG,
                    "CallActionReceiver: skip decline update — status=$status for $callId",
                )
            }
            null
        }.addOnSuccessListener {
            Log.d(TAG, "CallActionReceiver: decline transaction success for $callId")
            finishOnce("success")
        }.addOnFailureListener { e ->
            Log.e(TAG, "CallActionReceiver: decline transaction failed for $callId: ${e.message}", e)
            finishOnce("failure")
        }
    }

    companion object {
        private const val TAG = "YeetCall"
        private const val SAFETY_NET_MS = 8_000L
    }
}
