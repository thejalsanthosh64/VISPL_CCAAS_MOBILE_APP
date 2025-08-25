import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    this.onTap,
    this.onLongPress,
    required this.icon,
    this.padding,
  });

  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget icon;
  final EdgeInsetsGeometry? padding;

  static double iconPadding = 6.0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: padding ?? EdgeInsets.all(iconPadding),
        child: icon,
      ),
    );
  }
}
