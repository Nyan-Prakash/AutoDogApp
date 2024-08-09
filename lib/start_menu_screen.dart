import 'package:flutter/material.dart';
import 'device_selection_screen.dart';  // Import the Device Selection screen

class StartMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
         
              SizedBox(height: 40),
              
              // Description Text
              Text(
                'Please use the link below to verify your email and start your journey',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),

              // Verify Email Button
              ElevatedButton(
                onPressed: () {
                  // Navigate to Device Selection Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DeviceSelectionScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber[600], // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: Text(
                  'VERIFY EMAIL',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              SizedBox(height: 20),

              // Contact Info Text
              Text(
                'Do you have any Question?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                'contact@mail.com', // Replace with your contact email
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.amber[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
