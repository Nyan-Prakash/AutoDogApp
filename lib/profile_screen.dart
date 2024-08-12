import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.account_circle_rounded,
                size: 100.0,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Name: John Doe',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Email: john.doe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add edit functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8BBBD9),
                foregroundColor: Colors.white,
              ),
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Add logout functionality here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
