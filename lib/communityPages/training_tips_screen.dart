import 'package:flutter/material.dart';

class TrainingTipsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Training Tips',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF8BBBD9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            Expanded(child: _buildTipList()), // Makes the list scrollable
          ],
        ),
      ),
    );
  }

  // Header section with an introduction
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enhance Your Training',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Here are some tips to help you train your pet effectively. These tips are designed to improve communication and ensure successful training outcomes.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // List of tips with better structuring
  Widget _buildTipList() {
    return ListView(
      children: [
        _buildTipCard(
          'Consistency is Key',
          'Ensure that your training commands and routines are consistent to avoid confusing your pet. Use the same words, tone, and signals each time.',
        ),
        SizedBox(height: 10),
        _buildTipCard(
          'Positive Reinforcement',
          'Reward good behavior with treats, affection, or playtime to reinforce the behavior. Avoid negative reinforcement, which can cause stress.',
        ),
        SizedBox(height: 10),
        _buildTipCard(
          'Short, Frequent Sessions',
          'Keep training sessions short but frequent to maintain your pet\'s interest and avoid fatigue. 5-10 minutes, 2-3 times a day is ideal.',
        ),
        SizedBox(height: 10),
        _buildTipCard(
          'Understand Your Pet’s Limits',
          'Recognize when your pet is getting tired or frustrated. Stop the session if needed and end on a positive note.',
        ),
        SizedBox(height: 10),
        _buildTipCard(
          'Socialization is Important',
          'Expose your pet to different environments, people, and other animals in a controlled manner to build their confidence and adaptability.',
        ),
        // Add more tips as needed
      ],
    );
  }

  // Individual tip card layout
  Widget _buildTipCard(String title, String description) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFF8BBBD9), size: 30),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
