import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import the necessary package
import 'splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized

  // Lock orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(DogHarnessApp());
  });
}

class DogHarnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Harness Controller',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.red,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
