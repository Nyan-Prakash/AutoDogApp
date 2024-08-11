import 'package:flutter/material.dart';
import 'device_selection_screen.dart'; // Import the Device Selection screen
import 'dart:async'; // Import Timer for delay

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after a delay
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DeviceSelectionScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB0DFF7), // Background color
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Replace with your asset image path
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
