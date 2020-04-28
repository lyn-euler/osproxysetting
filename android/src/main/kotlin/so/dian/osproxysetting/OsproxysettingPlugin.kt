package so.dian.osproxysetting

import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** OsproxysettingPlugin */
public class OsproxysettingPlugin: FlutterPlugin, MethodCallHandler {
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "osproxysetting")
    channel.setMethodCallHandler(OsproxysettingPlugin());
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "osproxysetting")
      channel.setMethodCallHandler(OsproxysettingPlugin())
    }
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "settings") {
      val settings = getProxySettings()
      result.success(settings)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {

  }


  private  fun getProxySettings(): Map<String, Any> {
    val settings = HashMap<String, Any>()
    try {
      val proxyHost = System.getProperty("http.proxyHost")?.toString()

      if(!proxyHost.isNullOrEmpty()) {
        settings["HTTPProxy"] = proxyHost
      }
      val proxyPort = System.getProperty("http.proxyPort")
      if (!proxyPort.isNullOrEmpty()) {
        settings["HTTPPort"] = proxyPort
      }
      settings["HTTPEnable"] = !(proxyHost.isNullOrEmpty() || proxyPort.isNullOrEmpty())
      settings["HTTPSEnable"] = !(proxyHost.isNullOrEmpty() || proxyPort.isNullOrEmpty())
    }catch (e: Exception) {

    }
    return settings
  }


}
