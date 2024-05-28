import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    // Define the method channel name
    private val pairingChannel = "com.example.my_pairingDevices_plugin"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, pairingChannel).setMethodCallHandler { call, result ->
            if (call.method == "pairDevice") {
                val address: String? = call.argument("address")
                if (address != null) {
                    pairDevice(address, result)
                } else {
                    result.error("INVALID_ARGUMENT", "Address is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Function to pair a Bluetooth device given its address
    private fun pairDevice(address: String, result: MethodChannel.Result) {
        val bluetoothAdapter: BluetoothAdapter? = BluetoothAdapter.getDefaultAdapter()
        if (bluetoothAdapter == null) {
            result.error("UNAVAILABLE", "Bluetooth is not available.", null)
            return
        }

        val device: BluetoothDevice? = bluetoothAdapter.getRemoteDevice(address)
        if (device == null) {
            result.error("INVALID_ADDRESS", "Device not found.", null)
            return
        }

        try {
            device.createBond()
            result.success(null)
        } catch (e: Exception) {
            result.error("PAIRING_FAILED", "Failed to pair device.", e)
        }
    }
}
