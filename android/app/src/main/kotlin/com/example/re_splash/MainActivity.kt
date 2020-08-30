package dev.khanhle.re_splash

import android.app.WallpaperManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channel = "dev.khanhle.re_splash/wallpaper";
    private val authorities = "dev.khanhle.re_splash.flutter_downloader.provider";

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            if (call.method == "setWallpaper") {
                val filePath = call.argument<String>("filePath")

                if (filePath == null) {
                    result.error("ERROR", "Missing file path", null)
                } else {
                    try {
                        setWallpaper(filePath)
                        result.success(null)
                    } catch (error: Exception) {
                        result.error("ERROR", error.message, null)
                    }
                }
            }
        }
    }

    private fun setWallpaper(path: String) {
        val wallpaperManager = WallpaperManager.getInstance(this)

        if (!wallpaperManager.isWallpaperSupported || !wallpaperManager.isWallpaperSupported) {
            throw Error("Device doesn't support changing wallpaper")
        }

        try {
            val file = File(path)
            val uri = FileProvider.getUriForFile(this, this.authorities, file)
            val intent = wallpaperManager.getCropAndSetWallpaperIntent(uri)
            startActivity(intent)
        } catch (error: Exception) {
            Log.d("KOTLIN", error.message);
            throw Error("Failed to change wallpaper")
        }
    }
}
