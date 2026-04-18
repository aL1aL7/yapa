package de.yapa.yapa

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.OpenableColumns
import android.view.WindowManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val shareChannel = "de.yapa.yapa/share"
    private var methodChannel: MethodChannel? = null

    /** URI from a share intent waiting to be consumed by Flutter. */
    private var pendingShareUri: Uri? = null

    /**
     * True when the app was cold-started specifically to handle a share intent.
     * False when a share intent arrived while the app was already running.
     * Flutter uses this to decide whether to finish() the activity after upload.
     */
    private var launchedViaShare = false

    override fun onCreate(savedInstanceState: Bundle?) {
        // Prevent screenshots and hide app content in the recents/app-switcher.
        window.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE
        )
        super.onCreate(savedInstanceState)
        if (intent?.action == Intent.ACTION_SEND) {
            launchedViaShare = true
        }
        handleShareIntent(intent)
    }

    /** Called when the app is already running (singleTop) and a new intent arrives. */
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        launchedViaShare = false   // app was already running — don't exit after upload
        handleShareIntent(intent)
        // Notify Flutter immediately so it can open the upload screen.
        methodChannel?.invokeMethod("onSharedFile", null)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            shareChannel
        )
        methodChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedFile" -> {
                    val uri = pendingShareUri
                    if (uri == null) {
                        result.success(null)
                        return@setMethodCallHandler
                    }
                    try {
                        val fileName = resolveFileName(uri)
                        val tempFile = java.io.File(cacheDir, fileName)
                        contentResolver.openInputStream(uri)?.use { input ->
                            tempFile.outputStream().use { output ->
                                input.copyTo(output)
                            }
                        }
                        val shouldFinish = launchedViaShare
                        pendingShareUri = null
                        launchedViaShare = false
                        result.success(
                            mapOf(
                                "path" to tempFile.absolutePath,
                                "name" to fileName,
                                "shouldFinish" to shouldFinish
                            )
                        )
                    } catch (e: Exception) {
                        result.error("SHARE_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private fun handleShareIntent(intent: Intent?) {
        if (intent?.action != Intent.ACTION_SEND) return
        val uri: Uri? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            @Suppress("DEPRECATION")
            intent.getParcelableExtra(Intent.EXTRA_STREAM)
        }
        if (uri != null) pendingShareUri = uri
    }

    /** Resolves a human-readable file name from a content URI. */
    private fun resolveFileName(uri: Uri): String {
        var name: String? = null
        if (uri.scheme == "content") {
            contentResolver.query(uri, null, null, null, null)?.use { cursor ->
                if (cursor.moveToFirst()) {
                    val idx = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                    if (idx >= 0) name = cursor.getString(idx)
                }
            }
        }
        return name?.takeIf { it.isNotBlank() }
            ?: uri.lastPathSegment
            ?: "shared_file"
    }
}
