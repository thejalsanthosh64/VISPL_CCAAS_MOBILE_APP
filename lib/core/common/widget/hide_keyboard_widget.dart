import 'package:flutter/material.dart';
import 'package:kommuno/core/utilities/app_methods.dart';

class HideKeyboardWidget extends StatelessWidget {
  const HideKeyboardWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        hideKeyboard();
      },
      child: child,
    );
  }
}
