import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/generated/assets.dart';

class CommonForgotPasswordBg extends StatelessWidget {
  const CommonForgotPasswordBg({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return HideKeyboardWidget(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration:  BoxDecoration(
            image: DecorationImage(
              image: const AssetImage(Assets.imagesForgotPasswordBg),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppColors.appColor,
                BlendMode.lighten,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
