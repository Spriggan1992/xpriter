package com.xprinter.xprinter

import android.content.Context
import android.graphics.BitmapFactory
import android.os.StrictMode

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel

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
class XprinterPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  private lateinit var channel : MethodChannel

  private lateinit var context: Context
  private var curConnect: IDeviceConnection? = null
  private var tscPrinter  : TSCPrinter? = null

  private var eventSink: EventChannel.EventSink? = null
  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    val policy = StrictMode.ThreadPolicy.Builder().permitAll().build()
    StrictMode.setThreadPolicy(policy)

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "xprinter")
    EventChannel(flutterPluginBinding.binaryMessenger, "xprinter_event").setStreamHandler(this)

    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
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
      "print_from_file" -> {
        val arguments = call.arguments as HashMap<*, *>
        val isValid = arguments.containsKey("path") && arguments.containsKey("amount")
        if (isValid) {
          val path = arguments["path"] as String
          val amount = arguments["amount"] as Int
          printBitmapFromPath(path, amount)
          result.success(true)
        } else {
          result.error("invalid_argument", "argument 'bitmapBytes' and 'amount' not found", null)
          disconnect()
        }
      }
      "disconnect"-> {
        disconnect()
      }
      else -> result.notImplemented()
    }
  }
  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    // Handle stream cancellation
    eventSink = null
  }

  private fun connectTSC(ip: String) {
    POSConnect.init(context)
    curConnect = POSConnect.createDevice(3)

    curConnect!!.connect(ip) { code, _ ->
      when (code) {
        POSConnect.CONNECT_SUCCESS -> {
          eventSink?.success(1)
        }
        POSConnect.CONNECT_FAIL -> {
          eventSink?.success(2)
        }
        POSConnect.SEND_FAIL -> {
          eventSink?.success(3)
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
      .bitmap(0, 0, TSCConst.BMP_MODE_XOR, 590, bitmap)
      .print(amount)
  }
  private fun printBitmapFromPath(path: String, amount: Int) {
    val bitmap = BitmapFactory.decodeFile(path)

    tscPrinter!!.sizeMm (70.0, 120.0)
      .gapMm(0.0, 0.0)
      .cls()
      .bitmap(0, 0, TSCConst.BMP_MODE_XOR, 600, bitmap)
      .print(amount)
  }
  private fun disconnect() {
    tscPrinter = null
    curConnect?.close()
  }
}



