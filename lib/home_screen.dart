import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'remote_control_screen.dart';  // Import the Remote Control screen

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
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/dog_profile.jpg'), // Replace with your asset
            ),
          ),
        ],
      ),
      body: SingleChildScrollView( // Wrap with SingleChildScrollView to avoid overflow
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting and Quick Stats
            Text(
              'Good Afternoon',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard('Training Level', 'Advanced', Color(0xFFDEE7F0)),
                SizedBox(width: 8),
                _buildStatCard('Sessions Completed', '15', Color(0xFFDEE7F0)),
                SizedBox(width: 8),
                _buildStatCard('Active Profiles', '3', Color(0xFFDEE7F0)),
              ],
            ),
            SizedBox(height: 20),

            // Training Cards
            Text(
              'Current Training Session',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            _buildTrainingCard(context),
            SizedBox(height: 20),

            // User Profile Selection
            Text(
              'Change Dog Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            _buildProfileSelection(),
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
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Build Stat Card
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
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
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

  // Build Training Card
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
                      // Navigate to remote control screen
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

  // Build Profile Selection
  Widget _buildProfileSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildProfileCard('Buddy', 'Active', true),
        _buildProfileCard('Max', 'Inactive', false),
        _buildProfileCard('Bella', 'Inactive', false),
      ],
    );
  }

  // Build Profile Card
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
