import 'dart:math';

import 'package:flutter/material.dart';

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

  late final _majorTicks = _layoutScale(majorTickerCount);
  late final _minorTicks = _layoutScale(minorTickerCount);
  late final _angleDegree = _layoutAngleScale(_majorTicks);

  late final majorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = color
    ..strokeWidth = 2.0;

  late final minorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = color.withAlpha(178)
    ..strokeWidth = 1.0;

  late final majorScaleStyle = TextStyle(
    color: color,
    fontSize: 12,
  );
  late final cardinalityStyle = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 20,
  );
  @override
  void paint(Canvas canvas, Size size) {
    const origin = Offset.zero;
    final center = size.center(origin);
    final radius = size.width / 2.2;
    final majorTickLength = size.width * 0.08;
    final minorTickLength = size.width * 0.055;

    canvas.save();

    // Create major ticks
    for (final angel in _majorTicks) {
      final tickStart = center +
          Offset.fromDirection(_correctAngel(angel).toRadians(), radius);
      final tickEnd = center +
          Offset.fromDirection(
              _correctAngel(angel).toRadians(), radius - majorTickLength);
      canvas.drawLine(tickStart, tickEnd, majorScalePaint);
    }

    // Create minor ticks
    for (final angel in _minorTicks) {
      final tickStart = center +
          Offset.fromDirection(_correctAngel(angel).toRadians(), radius);
      final tickEnd = center +
          Offset.fromDirection(
              _correctAngel(angel).toRadians(), radius - minorTickLength);
      canvas.drawLine(tickStart, tickEnd, minorScalePaint);
    }

    // Create Angle Degree
    for (final angel in _angleDegree) {
      final textPainter =
          TextSpan(text: angel.toStringAsFixed(0), style: majorScaleStyle)
              .toPainter()
            ..layout();

      final layoutOffset = Offset.fromDirection(
          _correctAngel(angel).toRadians(),
          radius - majorTickLength - size.width * 0.02);
      final offset = center + layoutOffset;
      canvas.restore();
      canvas.save();
      canvas.rotate(angel.toRadians());
      canvas.translate(offset.dx, offset.dy);
      textPainter.paint(canvas, Offset(offset.dx, offset.dy));
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }

  List<double> _layoutScale(int ticks) {
    final scale = 360 / ticks;
    return List.generate(ticks, (index) => index * scale);
  }

  List<double> _layoutAngleScale(List<double> ticks) {
    List<double> angles = [];
    for (var i = 0; i < ticks.length; i++) {
      if (i == ticks.length - 1) {
        double degree = (ticks[i] + 360) / 2;
        angles.add(degree);
      } else {
        double degree = (ticks[i] + ticks[i + 1]) / 2;
        angles.add(degree);
      }
    }
    return angles;
  }

  double _correctAngel(double angle) => angle - 90;
}

typedef CardinalityMap = Map<num, String>;

extension on num {
  double toRadians() => this * pi / 100;
}

extension on TextSpan {
  TextPainter toPainter({TextDirection textDirection = TextDirection.ltr}) =>
      TextPainter(text: this, textDirection: textDirection);
}
