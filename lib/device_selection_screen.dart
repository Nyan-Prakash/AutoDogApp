import 'package:flutter/material.dart';
import 'package:flutter_application_1/Loading_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'home_screen.dart';
import 'Loading_screen.dart';

class DeviceSelectionScreen extends StatefulWidget {
  @override
  _DeviceSelectionScreenState createState() => _DeviceSelectionScreenState();
}

class _DeviceSelectionScreenState extends State<DeviceSelectionScreen> {
  FlutterBluePlus flutterBlue = FlutterBluePlus();
  List<BluetoothDevice> connectedDevices = [];
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndStart();
  }

  Future<void> checkPermissionsAndStart() async {
    // Check Bluetooth permissions
    if (await _checkPermissions()) {
      fetchConnectedDevices();
      startScan();
    } else {
      // Handle the case where permissions are not granted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bluetooth permissions are required to use this feature.')),
      );
    }
  }

  Future<bool> _checkPermissions() async {
    if (await Permission.bluetooth.isGranted &&
        await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted) {
      return true;
    } else {
      // Request permissions
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetooth,
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,  // Needed for Bluetooth scanning in some cases
      ].request();

      return statuses[Permission.bluetooth]!.isGranted &&
             statuses[Permission.bluetoothScan]!.isGranted &&
             statuses[Permission.bluetoothConnect]!.isGranted &&
             statuses[Permission.location]!.isGranted;
    }
  }

  Future<void> fetchConnectedDevices() async {
    // Retrieve connected devices
    var devices = await FlutterBluePlus.systemDevices;
    setState(() {
      connectedDevices = devices;
    });
  }

  Future<void> startScan() async {
    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    // Listen for scan results
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    });

    // Start scanning
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5)).whenComplete(() {
      setState(() {
        isScanning = false;
      });
    });
  }

  void connectToDevice(BluetoothDevice device) async {
    setState(() {
      isScanning = true; // Indicate that a connection attempt is ongoing
    });

    try {
      // Check if the device is already connected
      BluetoothConnectionState connectionState = await device.connectionState.first;
      if (connectionState == BluetoothConnectionState.connected) {
        // Device is already connected, go to LoadingScreen
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoadingScreen(device: device))
          );
        }
      } else {
        // Device is not connected, attempt to connect
        await device.connect();
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoadingScreen(device: device)),
          );
        }
      } 
    } catch (e) {
      // Handle any errors here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to the device: ${device.name}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          isScanning = false; // Reset the scanning indicator
        });
      }
    }
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan(); // Stop scanning when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select a Device',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF8BBBD9),
        elevation: 4,
        shadowColor: const Color(0xFF5F97B4),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await startScan(); // Refresh the scan
          await fetchConnectedDevices(); // Refresh the connected devices
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            if (connectedDevices.isNotEmpty) ...[
              const Text(
                'Connected Devices',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildConnectedDeviceList(),
              const SizedBox(height: 20),
            ],
            const Text(
              'New Devices',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.devices, color: Colors.green),
            title: Text(
              device.name.isNotEmpty ? device.name : "Unnamed Device",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(device.remoteId.toString()),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
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
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: scanResults.map((result) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.bluetooth, color: Colors.blue),
            title: Text(
              result.device.name.isNotEmpty ? result.device.name : "Unnamed Device",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(result.device.remoteId.toString()),
            trailing: const Icon(Icons.add_circle_outline, color: Colors.blue),
            onTap: () {
              connectToDevice(result.device);
            },
          ),
        );
      }).toList(),
    );
  }
}
