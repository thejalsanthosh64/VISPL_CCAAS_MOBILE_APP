import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class AppOutlinedAvatar extends StatelessWidget {
  const AppOutlinedAvatar({
    super.key,
    this.padding,
    this.child,
    this.radius = 40,
  });

  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: radius,
      width: radius,
      alignment: Alignment.center,
      padding: padding ?? const EdgeInsets.all(2),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.appColor)),
      child: child,
    );
  }
}
