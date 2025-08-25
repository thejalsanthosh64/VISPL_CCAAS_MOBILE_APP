import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/generated/assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(AppConstant.kBodyHorizontalPadding),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.imagesSplashScreen),
            fit: BoxFit.cover,
          ),
        ),
        child: CircleAvatar(
          backgroundColor: AppColors.white,
          radius: 80,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Image.asset(
              Assets.imagesAppLogo,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
