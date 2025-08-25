package com.kommuno.kommuno

import android.annotation.TargetApi
import androidx.core.app.NotificationCompat
import androidx.annotation.Nullable
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder


class AppForegroundService : Service() {

    private val appForegroundServiceChannelId = "AppForegroundServiceChannelId"

    @TargetApi(Build.VERSION_CODES.O)
    private fun createNotificationChannel() {
        val serviceChannel = NotificationChannel(
            appForegroundServiceChannelId,
            appForegroundServiceChannelId,
            NotificationManager.IMPORTANCE_DEFAULT
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(serviceChannel)
    }

    @TargetApi(Build.VERSION_CODES.ECLAIR)
    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        createNotificationChannel()
        val notification = NotificationCompat.Builder(this, appForegroundServiceChannelId)
            .setContentTitle("AppForegroundService")
            .setContentText("AppForegroundService is Running")
            .setAutoCancel(false)
            .build()
        startForeground(102, notification)
        return super.onStartCommand(intent, flags, startId)
    }

    @Nullable
    override fun onBind(intent: Intent): IBinder? {
        return null
    }
}