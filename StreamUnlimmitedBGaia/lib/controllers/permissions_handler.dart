// controllers/permissions_handler.dart

import 'package:permission_handler/permission_handler.dart';

class PermissionsHandler {
  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
    ].request();

    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        print('Permission $permission not granted: $status');
      } else {
        print('Permission $permission granted');
      }
    });
  }

  Future<bool> checkAllPermissionsGranted() async {
    bool locationGranted = await Permission.location.isGranted;
    bool bluetoothGranted = await Permission.bluetooth.isGranted;
    bool bluetoothScanGranted = await Permission.bluetoothScan.isGranted;
    bool bluetoothConnectGranted = await Permission.bluetoothConnect.isGranted;
    bool bluetoothAdvertiseGranted = await Permission.bluetoothAdvertise.isGranted;



    //testttss
    print('Location granted: $locationGranted');
    print('Bluetooth granted: $bluetoothGranted');
    print('Bluetooth Scan granted: $bluetoothScanGranted');
    print('Bluetooth Connect granted: $bluetoothConnectGranted');
    print('Bluetooth Advertise granted: $bluetoothAdvertiseGranted');


    return locationGranted && bluetoothGranted && bluetoothScanGranted &&
        bluetoothConnectGranted && bluetoothAdvertiseGranted;
  }
}
