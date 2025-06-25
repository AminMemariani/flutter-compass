import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:compass/pages/widgets/compass_painter.dart';

typedef PaintCallback = void Function(Canvas, Size);

void main() {
  group('CompassPainterWidget', () {
    test('can be constructed with default values', () {
      final painter = CompassViewPainter(color: Colors.red);
      expect(painter.color, Colors.red);
      expect(painter.majorTickerCount, 18);
      expect(painter.minorTickerCount, 90);
      expect(painter.cardinalityMap, {0: 'N', 90: 'E', 180: 'S', 270: 'W'});
    });

    test('shouldRepaint always returns true', () {
      final painter = CompassViewPainter(color: Colors.blue);
      expect(painter.shouldRepaint(painter), true);
    });

    test('paint does not throw', () {
      final painter = CompassViewPainter(color: Colors.green);
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      final size = const Size(200, 200);
      expect(() => painter.paint(canvas, size), returnsNormally);
    });

    test('can be constructed with custom values', () {
      final painter = CompassViewPainter(
        color: Colors.purple,
        majorTickerCount: 4,
        minorTickerCount: 8,
        cardinalityMap: {0: 'N', 180: 'S'},
      );
      expect(painter.color, Colors.purple);
      expect(painter.majorTickerCount, 4);
      expect(painter.minorTickerCount, 8);
      expect(painter.cardinalityMap, {0: 'N', 180: 'S'});
    });
  });
}
