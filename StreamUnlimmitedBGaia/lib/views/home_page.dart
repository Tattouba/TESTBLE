import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import '../controllers/bluetooth_controllers.dart';
import 'remote_control.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart' as serial;

class HomePage extends StatelessWidget {
  static const paringChannel = MethodChannel('com.example.my_paringDevices_plugin');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.black87,
                      child: const Center(
                        child: Text(
                          "Burmester Harmony",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => controller.scanDevices(),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black87,
                          minimumSize: const Size(350, 55),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(0)),
                          ),
                          elevation: 5,
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        child: const Text("Scan"),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              StreamBuilder<List<ScanResult>>(
                stream: controller.scanResult,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final data = snapshot.data![index];
                          final isConnected = data.device ==
                              controller.connectDevice.value;
                          final status = controller.connectionStatus.value;

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            elevation: 2,
                            child: ListTile(
                              title: Text(data.device.name),
                              subtitle: Text(
                                isConnected ? 'Connected' : (status == 'failed'
                                    ? 'Failed'
                                    : data.device.id.toString()),
                                style: TextStyle(
                                  color: isConnected ? Colors.green : (status ==
                                      'failed' ? Colors.red : null),
                                ),
                              ),
                              trailing: isConnected
                                  ? IconButton( //still to fix
                                icon: Icon(Icons.settings_remote),
                                onPressed: () {
                                  Get.to(
                                      RemoteControlScreen(device: data.device));
                                },
                              )
                                  : Text(data.rssi.toString()),
                              onTap: () async {
                                if (!isConnected) {
                                  bool paired = await isDevicePaired(data.device); //nativefile
                                  if (!paired) {
                                    await pairDevice(data.device); //aussi native file
                                  }
                                  controller.connectToDevice(data.device).then((
                                      _) {
                                    if (controller.connectionStatus.value ==
                                        'failed') {
                                      Get.snackbar('Connection Failed',
                                          'Could not connect to ${data.device
                                              .name}');
                                    }
                                  });
                                }
                              },
                            ),
                          );
                        },
                        childCount: snapshot.data!.length,
                      ),
                    );
                  } else {
                    return const SliverFillRemaining(
                      child: Center(
                        child: Text("No devices found"),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }



  /*
  for manuelly option maybe
  Future<void> openBluetoothSettings() async {
    try {
      await platform.invokeMethod('openBluetoothSettings');
    } on PlatformException catch (e) {
      print("Failed to open Bluetooth settings: '${e.message}'.");
    }
  }*/


  Future<bool> isDevicePaired(BluetoothDevice device) async {
    final bondedDevices = await serial.FlutterBluetoothSerial.instance.getBondedDevices();
    return bondedDevices.any((bondedDevice) => bondedDevice.address == device.id.toString());
  }

  Future<void> pairDevice(BluetoothDevice device) async {
    try {
      await paringChannel.invokeMethod('pairDevice', {'address': device.id.toString()});
    } on PlatformException catch (e) {
      print("Failed to pair device: '${e.message}'.");
    }
  }
}