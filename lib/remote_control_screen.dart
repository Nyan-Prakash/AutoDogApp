import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class RemoteControlScreen extends StatefulWidget {
  final BluetoothDevice device;

  RemoteControlScreen({required this.device});

  @override
  _RemoteControlScreenState createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends State<RemoteControlScreen> {
  BluetoothCharacteristic? targetCharacteristic;

  @override
  void initState() {
    super.initState();
    connectToCharacteristic();
  }

  void connectToCharacteristic() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic char in service.characteristics) {
        if (char.properties.write) {
          setState(() {
            targetCharacteristic = char;
          });
          return;
        }
      }
    }
    if (targetCharacteristic == null) {
      _showFeedback('No writable characteristic found!');
    }
  }

  void sendCommand(int value) async {
    if (targetCharacteristic != null) {
      await targetCharacteristic!.write([value]);
      _showFeedback('Sent command $value');
    } else {
      _showFeedback('Characteristic not found!');
    }
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1), // Message stays for 1 second
      ),
    );
  }

  Widget buildCommandButton(String label, int command) {
    return ElevatedButton(
      onPressed: () {
        sendCommand(command);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Rounded corners
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30), // Adjust padding for button size
        backgroundColor: Color(0xFF8BBBD9), // Updated background color to match the color scheme
        foregroundColor: Colors.white, // Text color
        shadowColor: Colors.black.withOpacity(0.2), // Shadow color
        elevation: 5, // Elevation for shadow
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remote Control',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8BBBD9), // Updated background color to match the color scheme
        elevation: 4,
        shadowColor: Color(0xFF5F97B4), // Updated shadow color for consistency
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0), // Add padding around the remote layout
          decoration: BoxDecoration(
            color: Color(0xFFDEE7F0), // Light background color for remote area
            borderRadius: BorderRadius.circular(20.0), // Rounded corners for the remote area
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // First column with three buttons: Sit, Free, Come
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCommandButton("Free", 1),
                  SizedBox(height: 20), // Space between buttons
                  buildCommandButton("Down", 4),
                  SizedBox(height: 20), // Space between buttons
                  buildCommandButton("Come", 6),
                ],
              ),
              SizedBox(width: 30), // Space between columns
              // Second column with three buttons: Manual, Down, Heel
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCommandButton("Sit", 3),
                  SizedBox(height: 20), // Space between buttons
                  buildCommandButton("Heel", 5),
                  SizedBox(height: 20), // Space between buttons
                  buildCommandButton("Manual", 2),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
