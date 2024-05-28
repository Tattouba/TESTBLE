import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import 'package:testuntitled/controllers/permissions_handler.dart';
import 'bluetooth_controllers.dart';

class BluetoothController extends GetxController {
  final FlutterBlue ble = FlutterBlue.instance;
  Rx<BluetoothDevice?> connectDevice = Rx<BluetoothDevice?>(null);
  final PermissionsHandler permissionsHandler = PermissionsHandler();
  RxString connectionStatus = RxString('disconnected');
  static const paring = MethodChannel('com.example.my_paringDevices_plugin');


  Future<void> scanDevices() async {
    if (await permissionsHandler.checkAllPermissionsGranted()) {
      print('All permissions granted. Starting scan...');
      ble.startScan(timeout: const Duration(seconds: 20));
      await Future.delayed(const Duration(seconds: 20));
      ble.stopScan();
    } else {
      print('Permissions not granted. Requesting permissions...');
      await permissionsHandler.requestPermissions();
      scanDevices();
    }
  }

  Stream<List<ScanResult>> get scanResult => ble.scanResults;


  /***************************/
  /*Future<bool> isDevicePaired(BluetoothDevice device) async {
    final bondedDevices = await FlutterBlue.instance.bondedDevices; //attends native file
    return bondedDevices.any((bondedDevice) => bondedDevice.id == device.id);
  }

  Future<void> pairDevice(BluetoothDevice device) async {
    try {
      await paring.invokeMethod('pairDevice', {'address': device.id.toString()});
    } on PlatformException catch (e) {
      print("Failed to pair device: '${e.message}'.");
    }
  }*/

  /*Future<void> openBluetoothSettings() async {
    try {
      await platform.invokeMethod('openBluetoothSettings');
    } on PlatformException catch (e) {
      print("Failed to open Bluetooth settings: '${e.message}'.");
    }
  }*/
  /*****************************/




  Future<void> connectToDevice(BluetoothDevice device) async {
    print(device);
    if (connectDevice.value != null) {
      await disconnectFromDevice(connectDevice.value!);
    }
    try {
      connectionStatus.value = 'connecting';
      update(); // Ensure UI updates
      await device.connect(timeout: const Duration(seconds: 40));
      connectDevice.value = device;
      connectionStatus.value = 'connected';
      update(); // Ensure UI updates
      device.state.listen((isConnected) {
        switch (isConnected) {
          case BluetoothDeviceState.connecting:
            print("Device connecting to ${device.name}");
            connectionStatus.value = 'connecting';
            break;
          case BluetoothDeviceState.connected:
            print("Device connected to ${device.name}");
            connectionStatus.value = 'connected';
            break;
          case BluetoothDeviceState.disconnected:
            print("Device Disconnected");
            connectionStatus.value = 'disconnected';
            connectDevice.value = null;
            break;
          default:
            print("Device state: $isConnected");
        }
        update(); // Ensure UI updates on state changes
      }).onError((error) {
        print("Error in connection state stream: $error");
        connectionStatus.value = 'failed';
        update(); // Ensure UI updates
        ble.stopScan();
      });
    } catch (e) {
      print("Error connecting to device: $e");
      connectionStatus.value = 'failed';
      update(); // Ensure UI updates
      ble.stopScan();
    }
  }

  Future<void> disconnectFromDevice(BluetoothDevice device) async {
    try {
      await device.disconnect();
      print("Device disconnected from ${device.name}");
      connectDevice.value = null;
      connectionStatus.value = 'disconnected';
      update(); // Ensure UI updates
    } catch (e) {
      print("Error disconnecting from device: $e");
    }
  }



  @override
  void onClose() {
    super.onClose();
    if (connectDevice.value != null) {
      disconnectFromDevice(connectDevice.value!);
    }
  }
}
