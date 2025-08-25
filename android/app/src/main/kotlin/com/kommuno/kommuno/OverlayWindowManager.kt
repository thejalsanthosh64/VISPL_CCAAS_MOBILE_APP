package com.kommuno.kommuno

import android.annotation.TargetApi
import android.content.Context
import android.graphics.PixelFormat
import android.os.Build
import android.os.*
import android.os.Looper
import android.util.Log
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.WindowManager
import android.widget.ImageButton
import android.widget.TextView
import org.json.JSONObject


@TargetApi(Build.VERSION_CODES.ECLAIR)
class OverlayWindowManager(
    context: Context, phoneNo: String
) {
    private val overlayView: View
    private var layoutParams: WindowManager.LayoutParams? = null
    private val layoutInflater: LayoutInflater
    private var incomingNumberTextView: TextView
    private var incomingNumberNameView: TextView

    companion object {
        private lateinit var mWindowManager: WindowManager
    }

    init {
        layoutParams = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.WRAP_CONTENT,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else WindowManager.LayoutParams.TYPE_PHONE,
            (WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON or WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED),
            PixelFormat.TRANSLUCENT
        )
        layoutInflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
        overlayView = layoutInflater.inflate(R.layout.overlay_layout, null)
        overlayView.findViewById<ImageButton>(R.id.close_button)?.setOnClickListener {
            closeOverlay()
        }
        incomingNumberTextView = overlayView.findViewById<TextView>(R.id.incoming_number_text_view)
        incomingNumberTextView.text = phoneNo
        incomingNumberNameView = overlayView.findViewById<TextView>(R.id.incoming_number_name_view)
        incomingNumberNameView.text = ""
        layoutParams!!.gravity = Gravity.CENTER
        mWindowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
    }


    fun openOverlay() {
        try {
//            initSocket()
            if (overlayView.windowToken == null) {
                if (overlayView.parent == null) {
                    mWindowManager.addView(overlayView, layoutParams)
                }
            }
        } catch (e: Exception) {
            Log.e("OverlayWindowManager", "openOverlay => $e")
        }
    }

    fun closeOverlay() {
        try {
//            closedSocket()
            mWindowManager.removeView(overlayView)
            overlayView.invalidate()
            (overlayView.parent as ViewGroup).removeAllViews()
        } catch (e: Exception) {
            Log.e("OverlayWindowManager", "closeOverlay => $e")
        }

    }

    private val mHandler = Handler(Looper.getMainLooper())


    private fun initSocket() {
        val mSocket = SocketHandler.getSocket()
        SocketHandler.setSocket()
        SocketHandler.establishConnection()
        mSocket.on("ringing_live_calls") { args ->
            mHandler.post {
                try {
                    Log.d("OverlayWindowManager", "ringing_live_calls => $args")
                    if (args.isNotEmpty()) {
                        val data = args[0] as JSONObject
                        val myData = data.getJSONArray("data").getJSONObject(0)
                        val customerNo: String? = myData.getString("customerNumber")
                        val customerName: String? = myData.getString("customerName")

                        if (!customerName.isNullOrEmpty() && !customerNo.isNullOrEmpty()) {
                            incomingNumberTextView.text = customerNo
                            incomingNumberNameView.text = customerName
                        } else {
                            incomingNumberTextView.text = "No data found..."
                        }
                    } else {
                        incomingNumberTextView.text = "No data found..."
                    }
                } catch (e: Exception) {
                    Log.d("OverlayWindowManager", "ringing_live_calls => $e")
                }
            }
        }
    }


    private fun closedSocket() {
        SocketHandler.closeConnection()
    }
}