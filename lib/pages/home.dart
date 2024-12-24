import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      body: Center(
        child: CompassScreen(),
      ),
    );
  }
}

class CompassScreen extends StatelessWidget {
  static const double _size = 300;

  const CompassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _size,
      height: _size,
      child: CustomPaint(
        painter: CompassPainter(),
      ),
    );
  }
}

class CompassPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintCircle = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final Paint paintNeedle = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    // Draw the compass circle
    canvas.drawCircle(
        size.center(Offset.zero), size.width / 2 - 20, paintCircle);

    // Draw the compass needle
    final double needleLength = size.width / 2 - 40;
    final double angle = 0; // You can change this to rotate the needle
    final Offset needleStart = size.center(Offset.zero);
    final Offset needleEnd = Offset(
      needleStart.dx + needleLength * math.cos(angle),
      needleStart.dy + needleLength * math.sin(angle),
    );

    canvas.drawLine(needleStart, needleEnd, paintNeedle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
