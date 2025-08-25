package com.kommuno.kommuno

import android.Manifest
import android.app.ActivityManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.kommuno"


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, channel
        ).setMethodCallHandler { call, result ->
            if (call.method == "makePhoneCall") {
                val phoneNumber: String? = call.arguments<String?>()
                if (phoneNumber != null) {
                    makePhoneCall(phoneNumber)
                    result.success("Phone call started")
                } else {
                    result.error("INVALID_ARGUMENT", "Phone number is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
//        requestOverlayPermissions()
//        startOverlayService()
    }

    private fun makePhoneCall(phoneNumber: String) {
        val callIntent = Intent(Intent.ACTION_CALL)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            callIntent.setPackage("com.android.server.telecom")
        } else {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.DONUT) {
                callIntent.setPackage("com.android.phone")
            }
        }
        val uri = if (phoneNumber.startsWith("+")) {
            Uri.parse("tel:$phoneNumber")
        } else {
            Uri.parse("tel:+$phoneNumber")
        }
        callIntent.data = uri
        startActivity(callIntent)
    }


    private fun requestOverlayPermissions() {
        val requestCode = 5469
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(this)) {
                val intent = Intent(
                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:com.kommuno.kommuno")
                )
                startActivityForResult(intent, requestCode)
            }
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            ActivityCompat.requestPermissions(
                this, arrayOf(
                    Manifest.permission.READ_PHONE_STATE,
                    Manifest.permission.SYSTEM_ALERT_WINDOW,
                    Manifest.permission.INTERNET
                ), requestCode
            )
        }
    }

    private fun startOverlayService() {
        if (!isForegroundServiceRunning()) {
            val overlayIntent: Intent = Intent(this, AppForegroundService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(overlayIntent)
            } else {
                startService(overlayIntent)
            }
        }
    }


    private fun isForegroundServiceRunning(): Boolean {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        return activityManager.getRunningServices(Int.MAX_VALUE).any {
            AppForegroundService::class.java.name == it.service.className
        }
    }
}