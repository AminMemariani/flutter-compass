import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

import 'widgets/compass_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    //_startCompass();
//    _fetchPermissionStatus();
  }

  @override
  void dispose() {
    super.dispose();
    FlutterCompass.events!.listen(null);
  }

/*   void _startCompass() {
    FlutterCompass.events!.listen((double direction) {
      setState(() {});
    } as void Function(CompassEvent event)?);
  } */

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: CustomPaint(
      size: size,
      painter: CompassPainterWidget(
        color: Theme.of(context).colorScheme.primary,
      ),
    ));
  }
}
