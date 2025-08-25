import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  const AppAvatar(
      {super.key,
      this.radius,
      this.child,
      this.backgroundImage,
      this.backgroundColor});

  final double? radius;
  final Widget? child;
  final Color? backgroundColor;
  final ImageProvider? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      radius: radius,
      backgroundImage: backgroundImage,
      child: child,
    );
  }
}
