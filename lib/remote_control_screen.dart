import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';

class RemoteControlScreen extends StatefulWidget {
  final BluetoothDevice device;

  RemoteControlScreen({required this.device});

  @override
  _RemoteControlScreenState createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends State<RemoteControlScreen> {
  BluetoothCharacteristic? writeCharacteristic;
  BluetoothCharacteristic? notifyCharacteristic;
  String receivedString = "No command received yet"; // Initialize with a default message

  @override
  void initState() {
    super.initState();
    connectToCharacteristics();
  }

  void connectToCharacteristics() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    print("Services discovered: ${services.length}");
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic char in service.characteristics) {
        print("Characteristic UUID: ${char.uuid}");
        print("Properties: ${char.properties}");

        // Identify and set the write characteristic
        if (char.properties.write) {
          setState(() {
            writeCharacteristic = char;
          });
          _showFeedback('Write Characteristic found');
        }

        // Identify and set the notify characteristic
        if (char.properties.notify) {
          setState(() {
            notifyCharacteristic = char;
          });
          _showFeedback('Notify Characteristic found');
          listenForCommands(); // Start listening for notifications
        }
      }
    }
    if (writeCharacteristic == null || notifyCharacteristic == null) {
      _showFeedback('Required characteristics not found!');
    }
  }

  void listenForCommands() async {
    if (notifyCharacteristic != null) {
      try {
        bool isNotifying = await notifyCharacteristic!.setNotifyValue(true);
        if (isNotifying) {
          _showFeedback('Notifications enabled');
          notifyCharacteristic!.value.listen((value) {
            if (value.isNotEmpty) {
              try {
                String newReceivedString = utf8.decode(value);
                setState(() {
                  receivedString = newReceivedString;
                });
                _showFeedback('Received string: $newReceivedString');
              } catch (e) {
                _showFeedback('Failed to decode string: $e');
              }
            }
          });
        } else {
          _showFeedback('Failed to enable notifications');
        }
      } catch (e) {
        _showFeedback('Error enabling notifications: $e');
      }
    } else {
      _showFeedback('Notify Characteristic not found!');
    }
  }

  void sendStringCommand(String strValue) async {
    if (writeCharacteristic != null) {
      try {
        List<int> data = utf8.encode(strValue); // Convert the string to UTF-8 bytes
        await writeCharacteristic!.write(data);
        _showFeedback('Sent command: $strValue');
      } catch (e) {
        _showFeedback('Failed to send command: $e');
      }
    } else {
      _showFeedback('Write Characteristic not found!');
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

  Widget buildCommandButton(String label, String command) {
    return ElevatedButton(
      onPressed: () {
        sendStringCommand(command);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16.0), // Add padding around the displayed string
              decoration: BoxDecoration(
                color: Color(0xFFDEE7F0), // Light background color for the string display area
                borderRadius: BorderRadius.circular(10.0), // Rounded corners for the string display area
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                receivedString,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Text color
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30), // Space between the string display and the remote buttons
            Container(
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
                   Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCommandButton("Free", "1"),
                      SizedBox(height: 20),
                      buildCommandButton("Manual", "2"),
                      SizedBox(height: 20),
                      buildCommandButton("Heel", "5"),


                    ],
                   ),
                   SizedBox(width: 30),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCommandButton("Sit", "3"),
                        SizedBox(height: 20),
                        buildCommandButton("Down", "4"),
                        SizedBox(height: 20),
                        buildCommandButton("Come", "6"),


                    ],
                   ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
