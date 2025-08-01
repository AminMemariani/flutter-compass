import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets/compass_painter.dart';
import 'package:compass/pages/widgets/neumorphism.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasPermission = false;
  double? _heading;
  late final Stream<CompassEvent> _compassStream;

  /* ---------- helpers ---------- */

  double _normalize(double raw) => (raw % 360 + 360) % 360;

  Future<void> _askForPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (mounted) setState(() => _hasPermission = status.isGranted);
  }

  void _initPermission() async {
    final status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await _askForPermission();
    } else {
      setState(() => _hasPermission = true);
    }
  }

  /* ---------- lifecycle ---------- */

  @override
  void initState() {
    super.initState();

    // 1. permission bootstrap
    _initPermission();

    // 2. compass stream – make sure it's non-null, then filter & throttle
    _compassStream =
        (FlutterCompass.events ?? const Stream<CompassEvent>.empty())
            .where((e) => e.heading != null)
            .distinct((a, b) => (a.heading! - b.heading!).abs() < 1);
  }

  /* ---------- UI ---------- */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191919),
      body: _hasPermission ? _buildCompass() : _buildPermissionSheet(),
    );
  }

  Widget _buildPermissionSheet() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Location permission required for compass',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _askForPermission,
              child: const Text('Grant permission'),
            ),
          ],
        ),
      );

  Widget _buildCompass() {
    final size = MediaQuery.of(context).size;

    return StreamBuilder<CompassEvent>(
      stream: _compassStream,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        _heading = snap.data?.heading;
        if (_heading == null) {
          return _noSensorWidget();
        }

        final normalized = _normalize(_heading!);

        return Stack(
          children: [
            // dial
            Neumorphism(
              margin: EdgeInsets.all(size.width * 0.1),
              child: Transform.rotate(
                angle: -normalized * math.pi / 180,
                child: CustomPaint(
                  size: size,
                  painter: CompassViewPainter(
                    color: Theme.of(context).colorScheme.primary,
                    heading: normalized,
                  ),
                ),
              ),
            ),

            // red indicator
            Positioned.fill(
              top: size.height * 0.32,
              child: Column(
                children: [
                  Container(
                    height: 40,
                    width: 4,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),

            // numeric read-out
            Neumorphism(
              margin: EdgeInsets.all(size.width * 0.38),
              padding: const EdgeInsets.all(10),
              distance: 1,
              blur: 5,
              child: Center(
                child: Text(
                  '${normalized.toInt()}°',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _noSensorWidget() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'No compass sensor available',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _askForPermission,
              child: const Text('Retry permission'),
            ),
          ],
        ),
      );
}
