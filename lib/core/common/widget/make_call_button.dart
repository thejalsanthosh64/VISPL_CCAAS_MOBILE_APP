import 'package:flutter/material.dart';
import 'package:kommuno/core/utilities/call_manager/call_manager.dart';
import 'package:kommuno/generated/assets.dart';

import 'app_avatar.dart';
import 'app_svg_picture.dart';

class MakeCallButton extends StatelessWidget {
  const MakeCallButton(
      {super.key, this.backgroundColor, this.radius, required this.number});

  final Color? backgroundColor;
  final double? radius;
  final String number;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () {
        CallManager.makeNewCall(number: number);
      },
      child: AppAvatar(
        radius: radius,
        backgroundColor: backgroundColor,
        child: const AppSvgPicture(
          assetName: Assets.iconsPhoneOutlined,
        ),
      ),
    );
  }
}
