import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class RemoteControlScreen extends StatelessWidget {
  final BluetoothDevice device;

  const RemoteControlScreen({Key? key, required this.device}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Control: ${device.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow, size: 50),
              onPressed: () {
                // Implement play functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.pause, size: 50),
              onPressed: () {
                // Implement pause functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop, size: 50),
              onPressed: () {
                // Implement stop functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_next, size: 50),
              onPressed: () {
                // Implement next functionality
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous, size: 50),
              onPressed: () {
                // Implement previous functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
