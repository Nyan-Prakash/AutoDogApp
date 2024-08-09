import 'package:flutter/material.dart';

class DiscoverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            SizedBox(height: 40),
            Text(
              'Discover Your Dog Type',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Tips and tricks to train a healthy dog',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Continue',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
