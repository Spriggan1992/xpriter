package com.xprinter.xprinter

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import net.posprinter.IDeviceConnection
import net.posprinter.IPOSListener
import net.posprinter.POSConnect
import net.posprinter.ZPLPrinter


/** XprinterPlugin */
class XprinterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  var curConnect: IDeviceConnection? = null
  private var zplPrinter : ZPLPrinter? = null
  

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "xprinter")
    channel.setMethodCallHandler(this)
  }


  override fun onMethodCall(call: MethodCall, result: Result) {
    when(call.method){
      "connect" -> {
        curConnect?.close()
        curConnect = POSConnect.createDevice(3)
        val arguments = call.arguments as HashMap<*,*>

        if (arguments.containsKey("ip")) {
          val ip = arguments["ip"] as String
          
          curConnect!!.connect(ip) { code, _ ->
            when (code) {
                POSConnect.CONNECT_SUCCESS -> {
                  zplPrinter = ZPLPrinter(curConnect)
                  result.success(true);
                }

            }
        }
        } else {
          result.error("invalid_argument", "argument 'ip' and 'port' not found", null)
        }
      }

      "disconnect" -> {
        // val isDisconnect: Boolean = mGtsplWIFICmdTest.GTSPL_closePort();
        // result.success(isDisconnect);
      }

      "status" -> {
        // val status: String = mGtsplWIFICmdTest.GTSPL_printersStatus(100);
        // result.success(status);
      }

      "send_command" -> {
        // val arguments = call.arguments as HashMap<*,*>
        // if (arguments.containsKey("command")) {
        //   val template = arguments["command"] as String
        //   val res = mGtsplWIFICmdTest.sendToPrinter(template);
        //   result.success(res);
        // }else {
        //   result.error("invalid_argument", "argument 'command' not found", null)
        // }
      }

      "send_command_and_file" -> {
        // val arguments = call.arguments as HashMap<*,*>
        // if (arguments.containsKey("command") && arguments.containsKey("filepath")) {
        //   val fis = FileInputStream(arguments["filepath"] as String);
        //   val data = ByteArray(fis.available())
        //   val res = mGtsplWIFICmdTest.fileSendToPrinter(fis,arguments["command"] as String, data);
        //   result.success(res);
        // }else {
        //   result.error("invalid_argument", "argument 'command' and 'filepath' not found", null)
        // }
      }

      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
