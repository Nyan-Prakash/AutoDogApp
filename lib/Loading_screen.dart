import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:lottie/lottie.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  final BluetoothDevice device;

  LoadingScreen({required this.device});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  BluetoothCharacteristic? writeCharacteristic;
  BluetoothCharacteristic? notifyCharacteristic;

  @override
  void initState() {
    super.initState();
    _connectToDevice();
  }

  void _connectToDevice() async {
    final targetServiceUUID = Guid("12345678-1234-1234-1234-123456789abc");
    final targetReadCharacteristicUUID = Guid("abcd1234-5678-1234-5678-abcdef123456");
    final targetWriteCharacteristicUUID = Guid("56781234-5678-1234-5678-abcdef654321");

    try {
      List<BluetoothService> services = await widget.device.discoverServices();

      for (BluetoothService service in services) {
        if (service.uuid == targetServiceUUID) {
          for (BluetoothCharacteristic char in service.characteristics) {
            if (char.uuid == targetWriteCharacteristicUUID && char.properties.write) {
              writeCharacteristic = char;
            } else if (char.uuid == targetReadCharacteristicUUID && char.properties.read) {
              notifyCharacteristic = char;
            }
          }
        }
      }

      if (writeCharacteristic != null && notifyCharacteristic != null) {
        // Navigate to the HomeScreen with the connected characteristics
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              device: widget.device,
              writeCharacteristic: writeCharacteristic!,
              notifyCharacteristic: notifyCharacteristic!,
            ),
          ),
        );
      } else {
        _showFeedback('Required characteristics not found!');
      }
    } catch (e) {
      _showFeedback('Error discovering services: $e');
    }
  }

  void _showFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context); // Go back to the device selection screen if there's an error
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8BBBD9), Color(0xFF5F97B4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Dog Walking Animation
          Center(
            child: Lottie.asset(
              'assets/animations/au.json',  // Path to your Lottie JSON file
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
          // Loading Text
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Connecting to your device...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}