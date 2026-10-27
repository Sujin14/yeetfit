package com.sujin.yeetfit.call

import android.app.KeyguardManager
import android.content.Context
import android.os.PowerManager
import android.util.Log

object AppState {
    @Volatile
    var mainActivityResumed = false

    fun isForeground(context: Context): Boolean {
        val pm = context.getSystemService(PowerManager::class.java)
        val km = context.getSystemService(KeyguardManager::class.java)
        val result = mainActivityResumed &&
            pm.isInteractive &&
            !km.isKeyguardLocked
        Log.d(
            "YeetCall",
            "isForeground: resumed=$mainActivityResumed " +
                "interactive=${pm.isInteractive} locked=${km.isKeyguardLocked} -> $result",
        )
        return result
    }
}
