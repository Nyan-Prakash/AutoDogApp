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
  TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    connectToCharacteristic();
  }

  void connectToCharacteristic() async {
    // Discover services and characteristics
    List<BluetoothService> services = await widget.device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic char in service.characteristics) {
        if (char.properties.write) {  // Automatically select the first writable characteristic
          setState(() {
            targetCharacteristic = char;
          });
          return;  // Exit the loop once a characteristic is found
        }
      }
    }
    if (targetCharacteristic == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No writable characteristic found!')),
      );
    }
  }

  void sendInteger(int value) async {
    if (targetCharacteristic != null) {
      await targetCharacteristic!.write([value]);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sent value $value')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Characteristic not found!')),
      );
    }
  }

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
          children: [
            TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter an integer',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                int value = int.parse(_textController.text);
                sendInteger(value);
              },
              child: Text('Send Integer'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.device.disconnect();
                setState(() {
                  targetCharacteristic = null;
                });
              },
              child: Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
