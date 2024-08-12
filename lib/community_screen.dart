import 'package:flutter/material.dart';
import 'communityPages/training_tips_screen.dart';  // Import the Training Tips screen
import 'communityPages/nutrition_advice_screen.dart';  // Import the Nutrition Advice screen
import 'communityPages/setting_up_your_device_screen.dart';  // Import the Setting Up Your Device screen
import 'communityPages/how_to_calibrate_screen.dart';  // Import the How to Calibration screen

class CommunityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF8BBBD9),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to the Community!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            _buildSectionTitle('Blog'),
            _buildBlogSection(context),  // Pass context to the method
            SizedBox(height: 30),
            _buildSectionTitle('User Tutorials'),
            _buildTutorialsSection(context),  // Pass context to the method
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {
            // Handle 'See All' action
          },
          child: Text(
            '',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF8BBBD9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlogSection(BuildContext context) {
    return Column(
      children: [
        _buildBlogPostCard(
          'Training Tips',
          'Learn the best training practices...',
          Icons.article,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrainingTipsScreen()),  // Navigate to TrainingTipsScreen
            );
          },
        ),
        SizedBox(height: 10),
        _buildBlogPostCard(
          'Nutrition Advice',
          'Healthy meals for your pets...',
          Icons.article,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NutritionAdviceScreen()),  // Navigate to NutritionAdviceScreen
            );
          },
        ),
      ],
    );
  }

  Widget _buildBlogPostCard(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          icon,
          color: Color(0xFF8BBBD9),
          size: 40,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        onTap: onTap,  // Use the passed callback
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTutorialsSection(BuildContext context) {  // Ensure context is passed
    return Column(
      children: [
        _buildTutorialCard(
          'Setting Up Your Device',
          'Step-by-step guide to setting up...',
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingUpYourDeviceScreen()),  // Navigate to SettingUpYourDeviceScreen
            );
          },
        ),
        SizedBox(height: 10),
        _buildTutorialCard('How to Calibrate Device', 'Learn how to properly calibrate your device...', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HowToCalibrateScreen()),  // Navigate to HowToCalibrationScreen
          );
        }),
      ],
    );
  }

  Widget _buildTutorialCard(String title, String subtitle, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          Icons.school,
          color: Color(0xFF8BBBD9),
          size: 40,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        onTap: onTap,
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
