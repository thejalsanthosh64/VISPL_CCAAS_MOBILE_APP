package com.kommuno.kommuno

import android.annotation.TargetApi
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.telephony.PhoneStateListener
import android.telephony.TelephonyManager
import android.util.Log
import java.util.Date


class AppPhoneCallReceiver : BroadcastReceiver() {
    @TargetApi(Build.VERSION_CODES.CUPCAKE)
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == "android.intent.action.NEW_OUTGOING_CALL") {
            savedNumber = intent.extras!!.getString("android.intent.extra.PHONE_NUMBER")
        } else {
            if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) {
                val stateStr = intent.extras!!.getString(TelephonyManager.EXTRA_STATE)
                val number = intent.extras!!.getString(TelephonyManager.EXTRA_INCOMING_NUMBER)
                var state = 0
                when (stateStr) {
                    TelephonyManager.EXTRA_STATE_IDLE -> {
                        state = TelephonyManager.CALL_STATE_IDLE
                    }

                    TelephonyManager.EXTRA_STATE_OFFHOOK -> {
                        state = TelephonyManager.CALL_STATE_OFFHOOK
                    }

                    TelephonyManager.EXTRA_STATE_RINGING -> {
                        state = TelephonyManager.CALL_STATE_RINGING
                    }
                }
                onCustomCallStateChanged(context, state, number)
            } else {
                // Android 9+
                val telephony =
                    context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
                telephony.listen(object : PhoneStateListener() {
                    override fun onCallStateChanged(state: Int, number: String) {
                        onCustomCallStateChanged(context, state, number)
                    }
                }, PhoneStateListener.LISTEN_CALL_STATE)
            }
        }
    }


    fun onCustomCallStateChanged(context: Context?, state: Int, number: String?) {
        if (lastState == state) {
            return
        }
        when (state) {
            TelephonyManager.CALL_STATE_RINGING -> {
                isIncoming = true
                callStartTime = Date()
                savedNumber = number
                onIncomingCallStarted(context, number, callStartTime)
            }

            TelephonyManager.CALL_STATE_OFFHOOK ->                 // Transition of ringing->offhook are pickups of incoming calls. Nothing done on them
                if (lastState != TelephonyManager.CALL_STATE_RINGING) {
                    isIncoming = false
                    callStartTime = Date()
                    onOutgoingCallStarted(context, savedNumber, callStartTime)
                }

            TelephonyManager.CALL_STATE_IDLE -> {
                // Went to idle - this is the end of a call.  What type depends on previous state(s)
                if (lastState == TelephonyManager.CALL_STATE_RINGING) {
                    // Ring but no pickup - a miss
                    onMissedCall(context, savedNumber, callStartTime)
                } else if (isIncoming) {
                    onIncomingCallEnded(context, savedNumber, callStartTime, Date())
                } else {
                    onOutgoingCallEnded(context, savedNumber, callStartTime, Date())
                }
                closeOverlayWindow(context)
            }
        }
        lastState = state
    }


    private fun onIncomingCallStarted(ctx: Context?, incomingNumber: String?, start: Date?) {
        if (incomingNumber != null) {
            openOverlayWindow(incomingNumber, ctx)
        }
    }

    private fun onOutgoingCallStarted(ctx: Context?, number: String?, start: Date?) {
    }

    private fun onIncomingCallEnded(ctx: Context?, number: String?, start: Date?, end: Date?) {
    }

    private fun onOutgoingCallEnded(ctx: Context?, number: String?, start: Date?, end: Date?) {
    }

    private fun onMissedCall(ctx: Context?, number: String?, missed: Date?) {
    }

    private fun openOverlayWindow(incomingNumber: String, ctx: Context?) {
        return
        try {
            val overlay = ctx?.let { OverlayWindowManager(it, incomingNumber) }
            overlay?.openOverlay();
        } catch (e: Exception) {
            Log.e("AppPhoneCallReceiver", "openOverlayWindow => $e")
        }
    }

    private fun closeOverlayWindow(context: Context?) {
        return
        try {
            val overlay = context?.let { OverlayWindowManager(it, "") }
            overlay?.closeOverlay();
        } catch (e: Exception) {
            Log.e("AppPhoneCallReceiver", "closeOverlayWindow => $e")
        }
    }

    companion object {
        private var lastState = -1
        private var callStartTime: Date? = null
        private var isIncoming = false
        private var savedNumber: String? =
            null
    }
}


