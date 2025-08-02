import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets/compass_painter.dart';
import 'package:compass/pages/widgets/neumorphism.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /* ────────── state ────────── */
  bool _hasPermission = false;

  double? _compassHeading; // from magnetometer
  double? _gpsHeading; // from GPS course
  double _gpsSpeed = 0.0; // m/s

  /* ────────── helpers ────────── */
  double _normalize(double raw) => (raw % 360 + 360) % 360;

  Future<void> _askForPermission() async {
    // permission_handler
    final status = await Permission.locationWhenInUse.request();
    if (mounted) setState(() => _hasPermission = status.isGranted);
  }

  Future<void> _bootstrapPermissions() async {
    final status = await Permission.locationWhenInUse.status;
    if (!status.isGranted) {
      await _askForPermission();
    } else {
      setState(() => _hasPermission = true);
    }
  }

  /* ────────── init ────────── */
  @override
  void initState() {
    super.initState();
    _bootstrapPermissions();

    /* ----- compass sensor (if present) ----- */
    (FlutterCompass.events ?? const Stream<CompassEvent>.empty())
        .where((e) => e.heading != null)
        .distinct((a, b) => (a.heading! - b.heading!).abs() < 1)
        .listen((e) {
      if (mounted) {
        setState(() => _compassHeading = e.heading);
      }
    });

    /* ----- GPS course fallback ----- */
    final locSettings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1, // metres
    );

    Geolocator.getPositionStream(locationSettings: locSettings).listen((pos) {
      if (mounted) {
        setState(() {
          _gpsHeading = pos.heading.isNaN ? null : pos.heading;
          _gpsSpeed = pos.speed; // m/s
        });
      }
    });
  }

  /* ────────── UI helpers ────────── */
  double? get _activeHeading {
    // 1) prefer magnetometer
    if (_compassHeading != null) return _compassHeading;
    // 2) fallback to GPS heading only if moving > 1 m/s (~3.6 km/h)
    if (_gpsHeading != null && _gpsSpeed > 1.0) return _gpsHeading;
    // 3) none available
    return null;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF191919),
        body: _hasPermission ? _buildCompass() : _buildPermissionSheet(),
      );

  Widget _buildPermissionSheet() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Location permission required',
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
    final heading = _activeHeading;

    if (heading == null) {
      return _noHeadingWidget();
    }

    final normalized = _normalize(heading);

    return Stack(
      children: [
        /* dial ------------------------------------------------ */
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

        /* red indicator -------------------------------------- */
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

        /* numeric read-out ----------------------------------- */
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
  }

  Widget _noHeadingWidget() => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _gpsSpeed <= 1
                  ? 'Stand still → no GPS heading\n(no magnetometer on this device)'
                  : 'No compass sensor available',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
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
