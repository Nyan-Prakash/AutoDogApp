import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class TrainingScreen extends StatefulWidget {
  final BluetoothDevice device;

  TrainingScreen({required this.device});

  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _dogName;
  String? _dogAge;
  String? _dogBreed;
  bool _isObedience = false;
  bool _isSocialization = false;
  bool _isBehaviorCorrection = false;

  String? _trainingPlan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Custom Training Plan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8BBBD9),
        elevation: 4,
        shadowColor: Color(0xFF8BBBD9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextInput('Dog Name', (value) => _dogName = value),
                    SizedBox(height: 16),
                    _buildTextInput('Dog Age', (value) => _dogAge = value, keyboardType: TextInputType.number),
                    SizedBox(height: 16),
                    _buildTextInput('Dog Breed', (value) => _dogBreed = value),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Select Training Focus:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF264653),
                ),
              ),
              SizedBox(height: 10),
              _buildCard(
                child: Column(
                  children: [
                    _buildCheckbox('Obedience', _isObedience, (value) {
                      setState(() {
                        _isObedience = value!;
                      });
                    }),
                    _buildCheckbox('Socialization', _isSocialization, (value) {
                      setState(() {
                        _isSocialization = value!;
                      });
                    }),
                    _buildCheckbox('Behavior Correction', _isBehaviorCorrection, (value) {
                      setState(() {
                        _isBehaviorCorrection = value!;
                      });
                    }),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _generateTrainingPlan,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Color(0xFF8BBBD9),
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: Color(0xFF264653),
                  ),
                  child: Text('Generate Training Plan', style: TextStyle(fontSize: 16)),
                ),
              ),
              SizedBox(height: 30),
              if (_trainingPlan != null) _buildTrainingPlanDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(String label, Function(String?) onSaved,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
      onSaved: (value) => onSaved(value),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: TextStyle(fontSize: 15, color: Color(0xFF8BBBD9))),
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Color(0xFF8BBBD9),
      checkColor: Colors.white,
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 4,
      shadowColor: Color(0xFF264653).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
      color: Colors.white,
    );
  }

  void _generateTrainingPlan() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      String plan = 'Training Plan for $_dogName:\n\n';

      if (_isObedience) {
        plan += '- Obedience Training: Focus on commands like Sit, Stay, and Come.\n';
      }
      if (_isSocialization) {
        plan += '- Socialization: Introduce $_dogName to different environments and dogs.\n';
      }
      if (_isBehaviorCorrection) {
        plan += '- Behavior Correction: Address specific issues like barking or aggression.\n';
      }

      setState(() {
        _trainingPlan = plan;
      });
    }
  }

  Widget _buildTrainingPlanDisplay() {
    return Card(
      elevation: 4,
      shadowColor: Color(0xFF8BBBD9).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Color(0xFF2A9D8F),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          _trainingPlan!,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
