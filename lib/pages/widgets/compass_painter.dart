import 'dart:math';
import 'package:flutter/material.dart';

typedef CardinalityMap = Map<num, String>;

class CompassPainterWidget extends CustomPainter {
  final Color color;
  final int majorTickerCount;
  final int minorTickerCount;
  final CardinalityMap cardinalityMap;

  CompassPainterWidget({
    required this.color,
    this.majorTickerCount = 18,
    this.minorTickerCount = 90,
    this.cardinalityMap = const {0: 'N', 90: 'E', 180: 'S', 270: 'W'},
  });

  late final List<double> _majorTicks = _layoutScale(majorTickerCount);
  late final List<double> _minorTicks = _layoutScale(minorTickerCount);

  static const double padding = 50.0;
  final double majorTickStrokeWidth = 2.0;
  final double minorTickStrokeWidth = 1.0;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = (size.shortestSide / 2) - padding;
    final double majorTickLength = radius * 0.12;
    final double minorTickLength = radius * 0.08;

    final Paint majorPaint = Paint()
      ..color = color
      ..strokeWidth = majorTickStrokeWidth
      ..style = PaintingStyle.stroke;

    final Paint minorPaint = Paint()
      ..color = color.withOpacity(0.7)
      ..strokeWidth = minorTickStrokeWidth
      ..style = PaintingStyle.stroke;

    final TextStyle degreeStyle = TextStyle(
      color: color,
      fontSize: 12,
    );

    final TextStyle cardinalStyle = const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    // Draw minor tick marks
    for (final angle in _minorTicks) {
      final double rad = _adjustAngle(angle).toRadians();
      final Offset start = center + Offset.fromDirection(rad, radius);
      final Offset end =
          center + Offset.fromDirection(rad, radius - minorTickLength);
      canvas.drawLine(start, end, minorPaint);
    }

    // Draw major tick marks
    for (final angle in _majorTicks) {
      final double rad = _adjustAngle(angle).toRadians();
      final Offset start = center + Offset.fromDirection(rad, radius);
      final Offset end =
          center + Offset.fromDirection(rad, radius - majorTickLength);
      canvas.drawLine(start, end, majorPaint);
    }

    // Draw degree labels just outside the major ticks
    for (final angle in _majorTicks) {
      final double rad = _adjustAngle(angle).toRadians();
      final Offset labelPos = center + Offset.fromDirection(rad, radius + 10);
      final textPainter = TextSpan(
        text: angle.round().toString(),
        style: degreeStyle,
      ).toPainter()
        ..layout();
      textPainter.paint(
        canvas,
        labelPos - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }

    // Draw cardinal directions further outside the degree labels
    for (final entry in cardinalityMap.entries) {
      final double angle = entry.key.toDouble();
      final String label = entry.value;
      final double rad = _adjustAngle(angle).toRadians();
      final Offset position = center + Offset.fromDirection(rad, radius + 28);
      final textPainter = TextSpan(
        text: label,
        style: cardinalStyle,
      ).toPainter()
        ..layout();
      textPainter.paint(
        canvas,
        position - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  List<double> _layoutScale(int count) {
    final double interval = 360 / count;
    return List.generate(count, (index) => index * interval);
  }

  double _adjustAngle(double angle) => angle - 90;
}

extension on num {
  double toRadians() => this * pi / 180;
}

extension on TextSpan {
  TextPainter toPainter({TextDirection textDirection = TextDirection.ltr}) =>
      TextPainter(text: this, textDirection: textDirection);
}
