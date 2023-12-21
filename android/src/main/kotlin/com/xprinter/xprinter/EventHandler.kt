import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import net.posprinter.utils.DataForSendToPrinterTSC.delay

class StatusPinterStreamHandler : EventChannel.StreamHandler {
    private val scope = CoroutineScope(Dispatchers.Default)
    private var isListening = false
    private var counter = 0

    // Code to set up and manage the event stream
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (events != null) {
            isListening = true
            scope.launch {
                while (isListening) {
                    val value = counter++
                    withContext(Dispatchers.Main) {
                        // Send the value to Flutter as a success event.
                        events.success(value)
                    }
                    delay(1000) // Send value every 1000 milliseconds
                }
            }
        }

    }

    override fun onCancel(arguments: Any?) {
        // Set isListening to false to stop generating events.
        isListening = false
    }

}