import 'package:compass/pages/widgets/neumorphism.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'widgets/compass_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _heading;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events?.listen((CompassEvent event) {
      setState(() {
        _heading = event.heading;
      });
    });
  }

  @override
  void dispose() {
    FlutterCompass.events!.listen(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 25, 25, 25),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Neumorphism(
            child: CustomPaint(
              size: size,
              painter: CompassViewPainter(
                color: Theme.of(context).colorScheme.primary,
                heading: _heading,
              ),
            ),
          ),
        ));
  }
}
