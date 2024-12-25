import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _direction = 0.0;

  @override
  void initState() {
    super.initState();
    _startCompass();
  }

  @override
  void dispose() {
    super.dispose();
    FlutterCompass.events!.listen(null);
  }

  void _startCompass() {
    FlutterCompass.events!.listen((double direction) {
      setState(() {
        _direction = direction;
      });
    } as void Function(CompassEvent event)?);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background with subtle compass rose
            Transform.rotate(
              angle: _direction * (3.14159 / 180), // Convert degrees to radians
              child: Image.asset(
                'assets/images/rose.png', // Replace with your compass rose image
                width: 250,
                height: 250,
              ),
            ),
            // Compass needle
            Transform.rotate(
              angle: _direction * (3.14159 / 180),
              child: Image.asset(
                'assets/images/compass_needle.png', // Replace with your compass needle image
                width: 150,
                height: 150,
              ),
            ),
            // Cardinal directions (N, E, S, W)
            Positioned(
              bottom: 20,
              child: Text(
                'N',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: 20,
              child: Text(
                'E',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              top: 20,
              child: Text(
                'S',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              left: 20,
              child: Text(
                'W',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Current direction (optional)
            Positioned(
              bottom: 80,
              child: Text(
                '${_direction.toStringAsFixed(0)}°',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
