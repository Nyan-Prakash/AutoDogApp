import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class RemoteControlScreen extends StatelessWidget {
  final BluetoothDevice device;

  RemoteControlScreen({required this.device});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Control'),
        backgroundColor: Colors.red[700]!,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildControlButton(Icons.arrow_upward, 'Move Forward', Colors.red[700]!),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildControlButton(Icons.arrow_back, 'Move Left', Colors.red[700]!),
                _buildControlButton(Icons.stop, 'Stop', Colors.grey[600]!),
                _buildControlButton(Icons.arrow_forward, 'Move Right', Colors.red[700]!),
              ],
            ),
            SizedBox(height: 20),
            _buildControlButton(Icons.arrow_downward, 'Move Backward', Colors.red[700]!),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: () {
            // Implement control logic
          },
          backgroundColor: color,
          child: Icon(icon, size: 36),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
