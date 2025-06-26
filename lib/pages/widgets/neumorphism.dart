import 'package:flutter/material.dart';

class Neumorphism extends StatelessWidget {
  const Neumorphism({
    super.key,
    required this.child,
    this.distance = 5,
    this.blur = 30,
    this.margin,
    this.padding,
  });

  final Widget child;
  final double distance;
  final double blur;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.grey.shade900;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade800,
            offset: Offset(-distance, -distance),
            blurRadius: blur,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black,
            offset: Offset(distance, distance),
            blurRadius: blur,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Container(
              decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                center: const Alignment(-0.3, -0.3),
                radius: 1.0,
                colors: [
                  Colors.black.withValues(alpha: 0.4), // top-left inner shadow
                  Colors.transparent,
                  Colors.grey.shade700
                      .withValues(alpha: 0.2), // bottom-right inner highlight
                ],
                stops: const [0.0, 0.7, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
