import 'package:flutter/material.dart';

class NutritionAdviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutrition Advice',
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
            Expanded(child: _buildAdviceList()), // Makes the list scrollable
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
          'Improve Your Pet’s Diet',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Explore these tips to ensure your pet is receiving the proper nutrition. A balanced diet is key to their overall health and well-being.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  // List of nutrition tips
  Widget _buildAdviceList() {
    return ListView(
      children: [
        _buildAdviceCard(
          'Balanced Diet',
          'Ensure your pet’s diet includes a balance of proteins, carbohydrates, fats, vitamins, and minerals. Consult with a vet to tailor it to your pet’s needs.',
        ),
        SizedBox(height: 10),
        _buildAdviceCard(
          'Hydration',
          'Always provide fresh, clean water. Hydration is essential for digestion, circulation, and overall health.',
        ),
        SizedBox(height: 10),
        _buildAdviceCard(
          'Portion Control',
          'Avoid overfeeding by sticking to recommended portion sizes. Obesity can lead to various health issues.',
        ),
        SizedBox(height: 10),
        _buildAdviceCard(
          'Avoid Human Food',
          'Many human foods, like chocolate or onions, can be toxic to pets. Stick to pet-friendly snacks and treats.',
        ),
        SizedBox(height: 10),
        _buildAdviceCard(
          'Regular Feeding Schedule',
          'Establish a consistent feeding schedule to regulate digestion and prevent overeating.',
        ),
        // Add more advice as needed
      ],
    );
  }

  // Individual advice card layout
  Widget _buildAdviceCard(String title, String description) {
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
                Icon(Icons.fastfood_outlined, color: Color(0xFF8BBBD9), size: 30),
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
