import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'remote_control_screen.dart';  // Import the Remote Control screen
import 'community_screen.dart';  // Import the Community screen
import 'Traing_screen.dart';
import 'profile_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  final BluetoothDevice device;  // Add a constructor parameter for the device

  HomeScreen({required this.device});  // Require the device parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8BBBD9),
        elevation: 4,
        shadowColor: Color(0xFF5F97B4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.account_circle_rounded,
                  size: 40.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView( 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Afternoon',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            /*
            Row(
              children: [
                _buildStatCard('Training Level', 'Expert', Color(0xFFDEE7F0)),
                SizedBox(width: 8),
                _buildStatCard('Sessions', '15', Color(0xFFDEE7F0)),
                SizedBox(width: 8),
                _buildStatCard('Pets', '3', Color(0xFFDEE7F0)),
              ],
            ),
            */
            
            SizedBox(height: 10),
            _buildTrainingCard(context),
            SizedBox(height: 20)
            
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF8BBBD9),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Training',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Community",
          ),
          /*
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          */
        ],
        onTap: (index) {
          if (index == 1) {  // Navigate to the Training screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrainingScreen(device: device)),
            );
          } else if (index == 2) {  // Navigate to the Community screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CommunityScreen()),
            );
          }
          else if (index == 3) {  // Navigate to the Community screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 13, color: Colors.black87),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrainingCard(BuildContext context) {
    return Card(
      color: Color(0xFF8BBBD9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Obedience',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Next Session: Sit Command',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RemoteControlScreen(device: device)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xFF8BBBD9),
                    ),
                    child: Text('Start Training'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProfileCard('Gee', 'Active', true),
        _buildProfileCard('Sonny', 'Inactive', false),
        _buildProfileCard('Luna', 'Inactive', false),
      ],
    );
  }

  Widget _buildProfileCard(String name, String status, bool selected) {
    return Expanded(
      child: Card(
        color: selected ? Color(0xFF8BBBD9) : Color(0xFFDEE7F0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 14,
                  color: selected ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
