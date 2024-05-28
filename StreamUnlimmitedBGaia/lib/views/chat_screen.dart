import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

//

class ChatScreen extends StatelessWidget {
  final BluetoothDevice device;

  ChatScreen({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${device.name}'),
      ),
      body: Center(
        child: Text('Connected to ${device.name}'),
      ),
    );
  }
}
