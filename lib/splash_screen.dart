import 'package:flutter/material.dart';
import 'device_selection_screen.dart'; // Import the Device Selection screen

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[700], // Red background color
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Device Selection Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeviceSelectionScreen()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // White button background color
            foregroundColor: Colors.red[700], // Red text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
          child: Text(
            'Start',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
