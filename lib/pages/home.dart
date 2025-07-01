import 'package:compass/pages/widgets/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets/compass_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _heading;
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) {
      if (mounted) {
        setState(() => _hasPermissions = (status == PermissionStatus.granted));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        body: Builder(
          builder: (context) {
            if (_hasPermissions) {
              return _buildCompass();
            } else {
              return _buildPermissionSheet();
            }
          },
        ));
  }

  Widget _buildCompass() {
    return StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.hasError) {
            return const Text("Error reading heading");
          }
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          _heading = asyncSnapshot.data?.heading;
          if (_heading == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      "Device does not have sensors or permission denied"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Permission.locationWhenInUse.request().then((ignored) {
                        _fetchPermissionStatus();
                      });
                    },
                    child: const Text("Try Again"),
                  ),
                ],
              ),
            );
          }
          return Stack(
            children: [
              Neumorphism(
                margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.1),
                child: Transform.rotate(
                  angle: (_heading! * (90 / 120) * -1),
                  child: CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: CompassViewPainter(
                      color: Theme.of(context).colorScheme.primary,
                      heading: _heading,
                    ),
                  ),
                ),
              ),
              Neumorphism(
                margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.4),
                distance: 0,
                blur: 0,
                child: Container(),
              ),
            ],
          );
        });
  }

  Widget _buildPermissionSheet() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text('Location Permission Required'),
          ElevatedButton(
            child: const Text('Request Permissions'),
            onPressed: () {
              Permission.locationWhenInUse.request().then((ignored) {
                _fetchPermissionStatus();
              });
            },
          ),
        ],
      ),
    );
  }
}
