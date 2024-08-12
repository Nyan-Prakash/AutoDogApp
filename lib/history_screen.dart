import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'Training History',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF8BBBD9),
        elevation: 4,
        shadowColor: Color(0xFF264653),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: SingleChildScrollView(  // Make the entire content scrollable
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Training Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF264653),
              ),
            ),
            SizedBox(height: 20),
            _buildProgressChart(),
            SizedBox(height: 30),
            Text(
              'Training Sessions Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF264653),
              ),
            ),
            SizedBox(height: 10),
            _buildSessionsOverview(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressChart() {
    return Card(
      elevation: 4,
      shadowColor: Color(0xFF264653).withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 200,
          child: CustomPaint(
            painter: _LineChartPainter(),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionsOverview() {
    final sessions = [
      SessionOverview('Sit Command', 'Completed', '7/10'),
      SessionOverview('Stay Command', 'Completed', '7/12'),
      SessionOverview('Heel Command', 'Pending', '7/15'),
      SessionOverview('Fetch Command', 'Pending', '7/18'),
    ];

    return Column(
      children: sessions.map((session) {
        return Card(
          elevation: 4,
          shadowColor: Color(0xFF264653).withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: ListTile(
            title: Text(
              session.command,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF264653),
              ),
            ),
            subtitle: Text(
              'Status: ${session.status}',
              style: TextStyle(color: Color(0xFF264653)),
            ),
            trailing: Text(
              session.date,
              style: TextStyle(color: Color(0xFF264653)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF8BBBD9)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width * 0.25, size.height * 0.7);
    path.lineTo(size.width * 0.5, size.height * 0.4);
    path.lineTo(size.width * 0.75, size.height * 0.2);
    path.lineTo(size.width, size.height * 0.1);

    canvas.drawPath(path, paint);

    // Drawing circles on the points
    final points = [
      Offset(0, size.height),
      Offset(size.width * 0.25, size.height * 0.7),
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width, size.height * 0.1),
    ];

    for (var point in points) {
      canvas.drawCircle(point, 6, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SessionOverview {
  final String command;
  final String status;
  final String date;

  SessionOverview(this.command, this.status, this.date);
}
