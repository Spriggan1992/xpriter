package com.xprinter.xprinter

import android.content.Context
import android.graphics.BitmapFactory
import android.os.StrictMode

import io.flutter.embedding.engine.plugins.FlutterPlugin

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import net.posprinter.IDeviceConnection
import net.posprinter.POSConnect
import net.posprinter.TSCConst
import net.posprinter.TSCPrinter
import net.posprinter.utils.BitmapProcess


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
  private  var isConnected : Boolean? = null

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
    curConnect!!.connect(ip) { code, _ ->
      when (code) {
        POSConnect.CONNECT_SUCCESS -> {
          isConnected = true
        }
        POSConnect.CONNECT_FAIL -> {
          isConnected = true
        }
      }
    }
    tscPrinter = TSCPrinter(curConnect)
  }

  private fun printBitmap(bitmapBytes: ByteArray, amount: Int) {
    val bitmap = BitmapFactory.decodeByteArray(bitmapBytes, 0, bitmapBytes.size)

    tscPrinter!!.sizeMm (70.0, 120.0)
      .gapMm(0.0, 0.0)
      .cls()
      .bitmap(0, 0, TSCConst.BMP_MODE_XOR, 400, bitmap)
      .print(amount)
//    disconnect()
    }
  private fun disconnect() {
    tscPrinter = null
    curConnect?.close()
    isConnected = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "connect"-> {
        val arguments = call.arguments as HashMap<*, *>
        if(arguments.containsKey("ip")){
          val ip = arguments["ip"] as String
          connectTSC(ip)
          result.success(true)
        }else{
          result.error("invalid_argument", "argument 'ip' not found", null)
        }
      }
      "check_connection"-> {
        result.success(tscPrinter != null)
      }
      "print" -> {
          val arguments = call.arguments as HashMap<*, *>
          val isValid = arguments.containsKey("bitmapBytes") && arguments.containsKey("amount")
          if (isValid) {
            val bitmapBytes = arguments["bitmapBytes"] as ByteArray
            val amount = arguments["amount"] as Int
            printBitmap(bitmapBytes, amount)
            result.success(true)
          } else {
            result.error("invalid_argument", "argument 'bitmapBytes' and 'amount' not found", null)
            disconnect()
          }
        }
      else -> result.notImplemented()
    }
  }
  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

