import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.height,
    this.textStyle,
    this.borderRadius,
    this.color,
  });

  final String text;

  final VoidCallback? onTap;

  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: borderRadius ??
          BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
      color: color ?? (onTap == null ? AppColors.grey : AppColors.appColor),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ??
            BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
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
