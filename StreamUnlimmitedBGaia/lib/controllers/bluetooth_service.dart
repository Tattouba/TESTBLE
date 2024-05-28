//classic bluetooth
/*import 'package:flutter/services.dart';

class BluetoothService {
  static const platform = MethodChannel('com.example.streamkit/bluetooth');

  Future<void> connectToDevice(String address) async {
    try {
      final String result = await platform.invokeMethod('connectToDevice', {'address': address});
      print(result);
    } on PlatformException catch (e) {
      print("Failed to connect to device: '${e.message}'.");
    }
  }
}*/
