import 'package:flutter/material.dart';
import 'package:kommuno/core/utilities/social_app_launcher.dart';
import 'package:kommuno/generated/assets.dart';

import 'app_avatar.dart';
import 'app_svg_picture.dart';

class WhatsappLauncherButton extends StatelessWidget {
  const WhatsappLauncherButton({super.key, this.radius, required this.number});

  final double? radius;

  final String number;

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
    /*return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {
        SocialAppLauncher.openWhatsApp(number: number);
      },
      child: AppAvatar(
        radius: radius,
        child: const AppSvgPicture(
          assetName: Assets.iconsWhatsApp,
          height: 20,
          width: 20,
        ),
      ),
    );*/
  }
}
