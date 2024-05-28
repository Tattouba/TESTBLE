import 'package:testuntitled/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'controllers/permissions_handler.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure widgets binding is initialized
  final permissionsHandler = PermissionsHandler();

  // Ensure permissions are requested on app start
  permissionsHandler.requestPermissions().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const platform = MethodChannel('my_gaia_plugin'); // Define the MethodChannel

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
