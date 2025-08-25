import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:pinput/pinput.dart';

part 'app_colors.dart';

part 'app_text_style.dart';

abstract class AppTheme {
  static ThemeData appTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appColor),
      textTheme: Theme.of(context)
          .textTheme
          .copyWith(bodyMedium: AppTextStyle.blackNormal),
      inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
            hintStyle: AppTextStyle.greyNormal,
            border: _inputDecorationBorder,
            enabledBorder: _inputDecorationBorder,
            focusedBorder: _inputDecorationBorder,
            filled: true,
            fillColor: AppColors.white,
            prefixIconColor: AppColors.appColor,
            suffixIconColor: AppColors.appColor,
          ),
      dividerColor: AppColors.appColor,
      scaffoldBackgroundColor: AppColors.white,
      fontFamily: AppConstant.fontFamily,
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      iconTheme:
          Theme.of(context).iconTheme.copyWith(color: AppColors.appColor),
      appBarTheme: Theme.of(context)
          .appBarTheme
          .copyWith(titleTextStyle: AppTextStyle.white23),
      useMaterial3: true,
    );
  }

  static OutlineInputBorder get _inputDecorationBorder => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
      borderSide: const BorderSide(color: AppColors.appColor));

  static final otpPinTheme = PinTheme(
    width: 45,
    height: 45,
    padding: EdgeInsets.zero,
    decoration: BoxDecoration(
      color: AppColors.appColor.withValues(alpha: 0.2),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
  );
}
