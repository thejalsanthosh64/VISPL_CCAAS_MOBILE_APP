import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';

class AppSlidableAction extends StatelessWidget {
  const AppSlidableAction(
      {super.key,
      this.iconName = '',
      this.text = '',
      required this.onPressed,
      this.backgroundColor});

  final String iconName;
  final String text;
  final void Function(BuildContext context) onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomSlidableAction(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      autoClose: true,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? AppColors.appColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconName.isNotEmpty) ...[
            AppSvgPicture(
              assetName: iconName,
              height: 25,
              width: 25,
              color: AppColors.white,
            ),
            const SizedBox(height: 2)
          ],
          if (text.isNotEmpty)
            Text(
              text,
              style: AppTextStyle.white11,
              maxLines: 1,
            )
        ],
      ),
    );
  }
}
