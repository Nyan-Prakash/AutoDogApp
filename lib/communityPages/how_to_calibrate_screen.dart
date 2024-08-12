import 'package:flutter/material.dart';

class HowToCalibrateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'How to Calibrate',
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
            Expanded(child: _buildCalibrationStepsList()), // Makes the list scrollable
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
          'Calibrate Your Device',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Follow these steps to ensure your device is properly calibrated for optimal performance.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // List of calibration steps
  Widget _buildCalibrationStepsList() {
    return ListView(
      children: [
        _buildStepCard(
          'Step 1: Power On the Device',
          'Ensure that your device is fully charged and power it on. Make sure it’s placed on a flat, stable surface.',
        ),
        SizedBox(height: 10),
        _buildStepCard(
          'Step 2: Open the Calibration Mode',
          'Navigate to the calibration settings in your app or device menu. Follow the on-screen instructions to enter calibration mode.',
        ),
        SizedBox(height: 10),
        _buildStepCard(
          'Step 3: Begin Calibration',
          'Start the calibration process. Your device may require you to place it in different orientations or locations. Follow the instructions carefully.',
        ),
        SizedBox(height: 10),
        _buildStepCard(
          'Step 4: Verify Calibration',
          'Once the calibration is complete, verify the results by testing your device. If necessary, repeat the process for better accuracy.',
        ),
        SizedBox(height: 10),
        _buildStepCard(
          'Step 5: Save Settings',
          'After successful calibration, save the settings and exit calibration mode. Your device is now ready to use.',
        ),
        // Add more steps as needed
      ],
    );
  }

  // Individual calibration step card layout
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
                Icon(Icons.build, color: Color(0xFF8BBBD9), size: 30),
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
