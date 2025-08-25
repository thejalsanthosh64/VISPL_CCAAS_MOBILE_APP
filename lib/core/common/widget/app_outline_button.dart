import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.textStyle,
    this.borderColor,
  });

  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
          side: BorderSide(color: borderColor ?? AppColors.white)),
      color: AppColors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
        child: SizedBox(
          width: width ?? double.infinity,
          height: height ?? AppConstant.kSized55,
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding + 3),
              child: Text(
                text,
                style: textStyle ?? AppTextStyle.whiteNormal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
