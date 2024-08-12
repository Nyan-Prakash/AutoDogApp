import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:convert';
import 'dart:math';

class RemoteControlScreen extends StatefulWidget {
  final BluetoothDevice device;

  RemoteControlScreen({required this.device});

  @override
  _RemoteControlScreenState createState() => _RemoteControlScreenState();
}

class _RemoteControlScreenState extends State<RemoteControlScreen> with SingleTickerProviderStateMixin {
  BluetoothCharacteristic? writeCharacteristic;
  BluetoothCharacteristic? notifyCharacteristic;
  String receivedString = "No command received yet";
  late AnimationController _controller;
  late List<ConfettiParticle> _particles;
  
  @override
  void initState() {
    super.initState();
    connectToCharacteristics();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    // Initialize particles
    _particles = List.generate(100, (index) => ConfettiParticle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void connectToCharacteristics() async {
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
        listenForCommands(); // Start listening immediately if both characteristics are found
      } else {
        _showFeedback('Required characteristics not found!');
      }

    } catch (e) {
      _showFeedback('Error discovering services: $e');
    }
  }

  void listenForCommands() async {
    if (notifyCharacteristic != null) {
      try {
        await notifyCharacteristic!.setNotifyValue(true);
        notifyCharacteristic!.value.listen((value) {
          if (value.isNotEmpty) {
            try {
              String newReceivedString = utf8.decode(value);
              setState(() {
                receivedString = newReceivedString;
              });
            } catch (e) {
              _showFeedback('Failed to decode string: $e');
            }
          }
        });
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
        List<int> data = utf8.encode(strValue);
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
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showTreatFeedback(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget buildCommandButton(String label, String command) {
    return ElevatedButton(
      onPressed: () {
        sendStringCommand(command);
        if (label == "Treat") {
          playConfettiAnimation();
          _showTreatFeedback("Give Treat");
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        backgroundColor: Color(0xFF8BBBD9),
        foregroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.2),
        elevation: 5,
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void playConfettiAnimation() {
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remote Control',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8BBBD9),
        elevation: 4,
        shadowColor: Color(0xFF5F97B4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFDEE7F0),
                    borderRadius: BorderRadius.circular(10.0),
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFDEE7F0),
                    borderRadius: BorderRadius.circular(20.0),
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
                          SizedBox(height: 20),
                          buildCommandButton("Treat", "7"),
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
          if (_controller.isAnimating)
            Positioned.fill(
              child: CustomPaint(
                painter: ConfettiPainter(_particles, _controller.value),
              ),
            ),
        ],
      ),
    );
  }
}

class ConfettiParticle {
  final double x;
  final double y;
  final double angle;
  final double speed;
  final Color color;

  ConfettiParticle()
      : x = Random().nextDouble() * 2 - 1,
        y = Random().nextDouble() * 2 - 1,
        angle = Random().nextDouble() * 2 * pi,
        speed = Random().nextDouble() * 5 + 2,
        color = Color.fromARGB(255, Random().nextInt(256), Random().nextInt(256), Random().nextInt(256));
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  ConfettiPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var particle in particles) {
      final xPos = size.width / 2 + particle.x * size.width * progress * particle.speed * cos(particle.angle);
      final yPos = size.height / 2 + particle.y * size.height *  progress * particle.speed * sin(particle.angle);

      paint.color = particle.color;

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(xPos, yPos),
          width: 5,
          height: 10,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

