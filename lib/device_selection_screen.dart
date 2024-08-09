import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'home_screen.dart';

class DeviceSelectionScreen extends StatefulWidget {
  @override
  _DeviceSelectionScreenState createState() => _DeviceSelectionScreenState();
}

class _DeviceSelectionScreenState extends State<DeviceSelectionScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> connectedDevices = [];
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    startScan();
    fetchConnectedDevices();
  }

  Future<void> fetchConnectedDevices() async {
    var devices = await flutterBlue.connectedDevices;
    setState(() {
      connectedDevices = devices;
    });
  }

  Future<void> startScan() async {
    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    flutterBlue.startScan(timeout: Duration(seconds: 5)).then((_) {
      if (mounted) {
        setState(() {
          isScanning = false;
        });
      }
    });

    flutterBlue.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          scanResults = results;
        });
      }
    });

    await Future.delayed(Duration(seconds: 5));
    if (mounted) {
      flutterBlue.stopScan();
      setState(() {
        isScanning = false;
      });
    }
  }

  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(device: device)),
      );
    }
  }

  @override
  void dispose() {
    flutterBlue.stopScan(); // Stop scanning when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select a Device'),
        backgroundColor: Colors.red[700], // Red app bar background color
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await startScan(); // Refresh the scan
          await fetchConnectedDevices(); // Refresh the connected devices
        },
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            if (connectedDevices.isNotEmpty) ...[
              Text(
                'Connected Devices',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildConnectedDeviceList(),
              SizedBox(height: 20),
            ],
            Text(
              'New Devices',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildNewDeviceList(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedDeviceList() {
    return Column(
      children: connectedDevices.map((device) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Icon(Icons.devices, color: Colors.green),
            title: Text(
              device.name.isNotEmpty ? device.name : "Unnamed Device",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(device.id.toString()),
            trailing: Icon(Icons.check_circle, color: Colors.green),
            onTap: () {
              connectToDevice(device);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNewDeviceList() {
    if (isScanning && scanResults.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return Column(
      children: scanResults.map((result) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Icon(Icons.bluetooth, color: Colors.blue),
            title: Text(
              result.device.name.isNotEmpty ? result.device.name : "Unnamed Device",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(result.device.id.toString()),
            trailing: Icon(Icons.add_circle_outline, color: Colors.blue),
            onTap: () {
              connectToDevice(result.device);
            },
          ),
        );
      }).toList(),
    );
  }
}
