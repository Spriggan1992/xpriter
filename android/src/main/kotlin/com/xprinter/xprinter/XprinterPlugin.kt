package com.xprinter.xprinter

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.BitmapFactory
import android.os.StrictMode
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import net.posprinter.IDeviceConnection
import net.posprinter.IPOSListener
import net.posprinter.POSConnect
import net.posprinter.POSConst
import net.posprinter.POSPrinter
import net.posprinter.TSCConst
import net.posprinter.TSCPrinter
import net.posprinter.ZPLConst
import net.posprinter.ZPLPrinter
import java.io.FileInputStream


/** XprinterPlugin */
class XprinterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private var curConnect: IDeviceConnection? = null
  private var tscPrinter  : TSCPrinter? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
    StrictMode.setThreadPolicy(policy)
    
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "xprinter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  private fun connectTSC(ip: String) {
    POSConnect.init(context)
    curConnect = POSConnect.createDevice(3)
    curConnect!!.connect(ip) { a, b ->
    }
    tscPrinter = TSCPrinter(curConnect)
  }
  private fun printBitmap(bitmapBytes: ByteArray, amount: Int) {
    val bitmap = BitmapFactory.decodeByteArray(bitmapBytes, 0, bitmapBytes.size)
            tscPrinter!!.sizeMm (700.0, 1200.0)
              .gapMm(0.0, 0.0)
              .cls()
              .bitmap(0, 0, TSCConst.BMP_MODE_OVERWRITE, 1000, bitmap)
              .print(amount)
    }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "print" -> {
//        if (tscPrinter == null) {
//          result.success(false)
//        } else {
          val arguments = call.arguments as HashMap<*, *>
          val isValid = arguments.containsKey("bitmapBytes") && arguments.containsKey("amount") && arguments.containsKey("ip")
          if (isValid) {
            val bitmapBytes = arguments["bitmapBytes"] as ByteArray
            val amount = arguments["amount"] as Int
            val ip = arguments["ip"] as String
            connectTSC(ip)
            printBitmap(bitmapBytes, amount)
            result.success(true)
          } else {
            result.error("invalid_argument", "argument 'ip' and 'port' not found", null)
          }
        }
//      }
      else -> result.notImplemented()
    }
  }
}
