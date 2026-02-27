import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.onTap,
  });

  final String text;

  final VoidCallback? onTap;

  final String iconPath;

  static const width = 120.0;

  static const height = 85.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side:  BorderSide(color: AppColors.appColor),
          ),
          color: AppColors.white,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              width: width,
              height: height,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
                  child: AppSvgPicture(
                    assetName: iconPath,
                    color: AppColors.appColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        FittedBox(
          child: Text(
            text,
            style: AppTextStyle.appColor16,
            textAlign: TextAlign.center,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
