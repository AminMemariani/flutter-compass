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
  bool _hasMagnetometer = false;

  double? _compassHeading; // from magnetometer
  double? _gpsHeading; // from GPS course
  double _gpsSpeed = 0.0; // m/s
  Position? _currentPosition;
  final List<Position> _positionHistory =
      []; // For calculating direction when stationary
  double _manualNorthOffset = 0.0; // Manual north calibration offset

  /* ────────── helpers ────────── */
  double _normalize(double raw) => (raw % 360 + 360) % 360;

  /// Calculate rhumb line bearing between two points
  double _rhumbBearingDeg(double lat1, double lon1, double lat2, double lon2) {
    final double lat1Rad = lat1 * math.pi / 180;
    final double lat2Rad = lat2 * math.pi / 180;
    final double lon1Rad = lon1 * math.pi / 180;
    final double lon2Rad = lon2 * math.pi / 180;

    double dLon = lon2Rad - lon1Rad;
    if (dLon > math.pi) dLon -= 2 * math.pi;
    if (dLon < -math.pi) dLon += 2 * math.pi;

    final double dPhi = math.log(math.tan(lat2Rad / 2 + math.pi / 4) /
        math.tan(lat1Rad / 2 + math.pi / 4));

    double bearing = math.atan2(dLon, dPhi) * 180 / math.pi;
    bearing = (bearing + 360) % 360;
    return bearing;
  }

  /// Calculate bearing to North Pole
  double? _bearingToNorthPole() {
    if (_currentPosition == null) return null;
    return _rhumbBearingDeg(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      90.0, // North Pole Latitude
      0.0, // North Pole Longitude
    );
  }

  /// Check if magnetometer is available
  Future<void> _checkMagnetometerAvailability() async {
    try {
      final compassEvents = FlutterCompass.events;
      if (compassEvents == null) {
        if (mounted) {
          setState(() => _hasMagnetometer = false);
        }
        return;
      }
      final compassData = await compassEvents.first.timeout(
        const Duration(seconds: 2), // Reduced timeout
      );
      if (mounted) {
        setState(() => _hasMagnetometer = compassData.heading != null);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _hasMagnetometer = false);
      }
    }
  }

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
    _checkMagnetometerAvailability();

    /* ----- compass sensor (if present) ----- */
    FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          _compassHeading = event.heading;
          _hasMagnetometer = event.heading != null;
        });
      }
    });

    /* ----- GPS position stream ----- */
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 1, // Update every 1 meter
      ),
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
          _gpsHeading = position.heading;
          _gpsSpeed = position.speed;
          // Keep position history for potential future use
          _positionHistory.add(position);
          if (_positionHistory.length > 10) {
            _positionHistory.removeAt(0);
          }
        });
      }
    });
  }

  /* ────────── UI helpers ────────── */
  double? get _activeHeading {
    // 1) prefer magnetometer if available
    if (_hasMagnetometer && _compassHeading != null) {
      return _compassHeading;
    }

    // 2) if no magnetometer, use GPS heading when moving (speed > 1.0 m/s)
    if (!_hasMagnetometer && _gpsHeading != null && _gpsSpeed > 1.0) {
      return _gpsHeading;
    }

    // 3) if no magnetometer and stationary, calculate bearing to North Pole
    if (!_hasMagnetometer && _currentPosition != null && _gpsSpeed <= 1.0) {
      final bearing = _bearingToNorthPole();
      if (bearing != null) return bearing;
    }

    // 4) fallback: manual calibration offset
    return _manualNorthOffset;
  }

  String get _compassMode {
    if (_hasMagnetometer && _compassHeading != null) {
      return 'Magnetometer';
    }
    if (!_hasMagnetometer && _gpsHeading != null && _gpsSpeed > 1.0) {
      return 'GPS Course';
    }
    if (!_hasMagnetometer && _currentPosition != null && _gpsSpeed <= 1.0) {
      return 'Bearing to North';
    }
    return 'GPS Mode'; // General GPS fallback
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

        /* status info ---------------------------------------- */
        Positioned(
          top: 50,
          left: 20,
          right: 20,
          child: Neumorphism(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_currentPosition != null) ...[
                  Text(
                    'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    'Lon: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  Text(
                    'Speed: ${(_gpsSpeed * 3.6).toStringAsFixed(1)} km/h',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
                Text(
                  'Mode: $_compassMode',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ),

        /* manual calibration buttons (when no magnetometer) --- */
        if (!_hasMagnetometer)
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _manualNorthOffset = (_manualNorthOffset - 15) % 360;
                    });
                  },
                  child: const Text('← 15°'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _manualNorthOffset = 0.0;
                    });
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _manualNorthOffset = (_manualNorthOffset + 15) % 360;
                    });
                  },
                  child: const Text('15° →'),
                ),
              ],
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
              _hasMagnetometer
                  ? 'Waiting for compass data...'
                  : (_currentPosition != null && _gpsSpeed <= 1.0)
                      ? 'No magnetometer detected\nShowing bearing to North'
                      : 'No magnetometer detected\nUsing GPS course when moving',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            if (_currentPosition != null) ...[
              Text(
                'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                'Lon: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                'Speed: ${(_gpsSpeed * 3.6).toStringAsFixed(1)} km/h',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _askForPermission,
              child: const Text('Retry permission'),
            ),
          ],
        ),
      );
}
