import 'package:flutter/material.dart';

class SettingUpYourDeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setting Up Your Device',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF8BBBD9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            Expanded(child: _buildSetupStepsList()), // Makes the list scrollable
          ],
        ),
      ),
    );
  }

  // Header section with an introduction
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Getting Started with Your Device',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Follow these steps to set up your device quickly and efficiently. Ensure everything is configured properly for optimal performance.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // List of setup steps
  Widget _buildSetupStepsList() {
    return ListView(
      children: [
        _buildStepCard(
          'Step 1: Unbox and Inspect',
          'Carefully unbox your device and inspect it for any damage. Ensure all components are included as per the manual.',
        ),
        SizedBox(height: 10),
        _buildStepCard(
          'Step 2: Charge the Device',
          'Fully charge your device before first use to ensure optimal battery performance. Use the provided charger and cable.',
        ),
        SizedBox(height: 10),
        _buildStepCard(
          'Step 3: Install the App',
          'Download and install the companion app on your smartphone. This will allow you to control and monitor the device.',
        ),
        SizedBox(height: 10),
        _buildStepCard(
          'Step 4: Pair the Device',
          'Follow the instructions in the app to pair your device via Bluetooth. Ensure the device is within range and Bluetooth is enabled on your phone.',
        ),
        SizedBox(height: 10),
        _buildStepCard(
          'Step 5: Configure Settings',
          'Customize the device settings through the app to suit your needs. This includes adjusting sensitivity, notifications, and more.',
        ),
        // Add more steps as needed
      ],
    );
  }

  // Individual setup step card layout
  Widget _buildStepCard(String title, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, color: Color(0xFF8BBBD9), size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
