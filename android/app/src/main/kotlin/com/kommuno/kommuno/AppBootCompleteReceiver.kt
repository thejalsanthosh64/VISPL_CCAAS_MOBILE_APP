package com.kommuno.kommuno

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build

class AppBootCompleteReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_BOOT_COMPLETED) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val overlayIntent = Intent(context, AppForegroundService::class.java)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context.startForegroundService(overlayIntent)
                } else {
                    context.startService(overlayIntent)
                }
            }
        }
    }
}
