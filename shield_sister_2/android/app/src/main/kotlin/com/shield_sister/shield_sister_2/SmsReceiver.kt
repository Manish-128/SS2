package com.shield_sister.shield_sister_2

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.SmsMessage
import android.media.MediaPlayer
import android.util.Log
import java.io.IOException

class SmsReceiver : BroadcastReceiver() {
    companion object {
        private const val TAG = "SmsReceiver"
    }

    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d(TAG, "onReceive triggered, action: ${intent?.action}")
        val bundle = intent?.extras
        if (bundle != null && intent.action == "android.provider.Telephony.SMS_RECEIVED") {
            val pdus = bundle.get("pdus") as Array<*>?
            Log.d(TAG, "PDUs received: ${pdus?.size ?: 0}")
            pdus?.forEach { pdu ->
                val sms = SmsMessage.createFromPdu(pdu as ByteArray, "3gpp")
                val messageBody = sms.messageBody
                Log.d(TAG, "Message body: $messageBody")
                if (messageBody?.toLowerCase()?.contains("sos") == true) {
                    Log.d(TAG, "SOS detected, playing buzzer natively")
                    playBuzzer(context)
                } else {
                    Log.d(TAG, "No SOS in message")
                }
            }
        } else {
            Log.d(TAG, "Bundle null or wrong action")
        }
    }

    private fun playBuzzer(context: Context?) {
        val mediaPlayer = MediaPlayer()
        try {
            val afd = context?.resources?.openRawResourceFd(R.raw.buzzer)
            if (afd != null) {
                mediaPlayer.setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
                afd.close()
                mediaPlayer.prepare()
                mediaPlayer.start()
                Log.d(TAG, "Buzzer playing")
                mediaPlayer.setOnCompletionListener {
                    mediaPlayer.release()
                    Log.d(TAG, "Buzzer playback completed")
                }
            } else {
                Log.e(TAG, "Raw resource 'buzzer' not found")
            }
        } catch (e: IOException) {
            Log.e(TAG, "Error playing buzzer: ${e.message}")
            mediaPlayer.release()
        }
    }
}