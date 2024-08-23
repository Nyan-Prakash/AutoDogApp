import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'dart:math';
import 'services/SoundService.dart';

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

  SoundService soundService = SoundService();
  
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
            String jsonString = utf8.decode(value);
            List<dynamic> jsonData = jsonDecode(jsonString);
            CommandData receivedCommand = CommandData.fromJson(jsonData);

            setState(() {
              if(receivedCommand.currentMode == 1)
              {
                receivedString = "Free";
              }
              else if(receivedCommand.currentMode == 2)
              {
                receivedString = "Manual";
              }
              else if(receivedCommand.currentMode == 3)
              {
                receivedString = "Sit";
              }
              else if(receivedCommand.currentMode == 4)
              {
                receivedString = "Down";
              }
              else if(receivedCommand.currentMode == 5)
              {
                receivedString = "Heel";
              }
              else if(receivedCommand.currentMode == 6)
              {
                receivedString = "Come";
              }
              if(receivedCommand.isDogABadBoy == true)
              {
                _showCorrectionFeedback("Applying Correction");
              }
              if(receivedCommand.doesDogDeservedAReward == true)
              {
                soundService.setVolume(20.0);
                soundService.playSound('sounds/positive.mp3');
                _showTreatFeedback("Give Treat");
              }


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
  void sendCommandData(CommandData commandData) async {
    bool isSure;
    if(commandData.currentMode == 77)
    {
      isSure = await _showConfirmationDialog(context, 'send this command');
    }
    else
    {
      isSure = true;
    }
  if(isSure)
  {
    if (writeCharacteristic != null) {
    try {
      String jsonString = jsonEncode(commandData.toJson());
      List<int> data = utf8.encode(jsonString);
      await writeCharacteristic!.write(data);
      _showFeedback('Sent command: $jsonString');
    } catch (e) {
      _showFeedback('Failed to send command: $e');
    }
  } else {
    _showFeedback('Write Characteristic not found!');
  }
  }
}
  Future<bool> _showConfirmationDialog(BuildContext context, String actionName) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,  // Prevent dismissing the dialog by tapping outside of it
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm $actionName'),
        content: Text('Are you sure you want to $actionName?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);  // Return false when "No" is pressed
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);  // Return true when "Yes" is pressed
            },
          ),
        ],
      );
    },
  ) ?? false;  // Return false if the dialog is dismissed without pressing Yes or No
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

  void _showCorrectionFeedback(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget buildCommandButton(String label, int command) {
    return ElevatedButton(
      onPressed: () {
        sendCommandData(CommandData(currentMode: command, isDogABadBoy: false, doesDogDeservedAReward: false));

        
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
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0), // Adjust this value to control how high it shifts
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                          buildCommandButton("Free", 1),
                          SizedBox(height: 20),
                          buildCommandButton("Manual", 2),
                          SizedBox(height: 20),
                          buildCommandButton("Calibrate", 7),
                        ],
                      ),
                      SizedBox(width: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCommandButton("Sit", 3),
                          SizedBox(height: 20),
                          buildCommandButton("Down", 4),
                          SizedBox(height: 20),
                          buildCommandButton("Reset", 77),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
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

class CommandData {
  final int currentMode;
  final bool doesDogDeservedAReward;
  final bool isDogABadBoy;

  CommandData({required this.currentMode, required this.doesDogDeservedAReward, required this.isDogABadBoy});

  // Convert a CommandData object into a list of values.
  List<dynamic> toJson() => [currentMode, doesDogDeservedAReward, isDogABadBoy];

  // Create a CommandData object from a list of values.
  factory CommandData.fromJson(List<dynamic> json) {
    return CommandData(
      currentMode: json[0] as int,
      doesDogDeservedAReward: json[1] as bool,
      isDogABadBoy: json[2] as bool,
    );
  }
}

