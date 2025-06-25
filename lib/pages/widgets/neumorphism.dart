import 'package:flutter/material.dart';

class Neumorphism extends StatelessWidget {
  const Neumorphism({
    super.key,
    required this.child,
    this.distance = 30,
    this.blur = 50,
    this.margin,
    this.padding,
    this.isReverse = false,
    this.innerShadow = false,
  });

  final Widget child;
  final double distance;
  final double blur;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool isReverse;
  final bool innerShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: isReverse
              ? [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: blur,
                      offset: Offset(-distance, -distance)),
                  BoxShadow(
                      color: Colors.white,
                      blurRadius: blur,
                      offset: Offset(distance, distance)),
                ]
              : [
                  BoxShadow(
                      color: Colors.white,
                      blurRadius: blur,
                      offset: Offset(distance, distance)),
                  BoxShadow(
                      color: Theme.of(context).colorScheme.primary,
                      blurRadius: blur,
                      offset: Offset(-distance, -distance)),
                ]),
      child: innerShadow
          ? Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                    Theme.of(context).colorScheme.primary,
                    Colors.white
                  ])),
            )
          : child,
    );
  }
}
