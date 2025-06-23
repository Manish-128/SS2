//package com.shield_sister.shield_sister_2
//
//import io.flutter.embedding.android.FlutterActivity
//
//class MainActivity: FlutterActivity()
package com.shield_sister.shield_sister_2

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.media.MediaPlayer
import android.util.Log
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.shield_sister.shield_sister_2/audio"
    private val TAG = "MainActivity"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "playBuzzer") {
                Log.d(TAG, "Received playBuzzer call from Flutter")
                playBuzzer()
                result.success("Buzzer played")
            } else {
                result.notImplemented()
            }
        }
    }

    private fun playBuzzer() {
        val mediaPlayer = MediaPlayer()
        try {
            val afd = resources.openRawResourceFd(R.raw.buzzer)
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