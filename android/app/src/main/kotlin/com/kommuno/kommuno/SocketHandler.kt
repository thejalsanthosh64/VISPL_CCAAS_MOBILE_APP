package com.kommuno.kommuno

import android.util.Log
import io.socket.client.IO
import io.socket.client.Socket
import java.net.URISyntaxException

object SocketHandler {
    private lateinit var mSocket: Socket

    @Synchronized
    fun setSocket() {
        try {
            mSocket = IO.socket("https://newdevsio.kommuno.com")
        } catch (e: URISyntaxException) {
            Log.e("SOCKET_LOG", "$e")
        }
    }

    @Synchronized
    fun getSocket(): Socket {
        return mSocket
    }

    @Synchronized
    fun establishConnection() {
        mSocket.connect()
    }

    @Synchronized
    fun isConnected(): Boolean {
        return mSocket.connected()
    }

    @Synchronized
    fun closeConnection() {
        mSocket.disconnect()
    }

}