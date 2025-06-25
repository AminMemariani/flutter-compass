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
    final baseColor = Colors.grey.shade300;

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: baseColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-distance, -distance),
            blurRadius: blur,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.grey.shade500,
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
                  Colors.grey.shade500
                      .withValues(alpha: 0.35), // top-left inner shadow
                  Colors.transparent,
                    Colors.white
                      .withValues(alpha: 0.3), // bottom-right inner highlight
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
