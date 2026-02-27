import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:pinput/pinput.dart';

part 'app_colors.dart';

part 'app_text_style.dart';

abstract class AppTheme {
  static ThemeData appTheme(BuildContext context ,{
  Color? primaryColor,
  Color? secondaryColor  }) {
    final Color mainColor = primaryColor ?? AppColors.appColor;

    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appColor),
    // colorScheme: ColorScheme.fromSeed(
    //     seedColor: mainColor,
    //     primary: mainColor,
    //     secondary: secondaryColor ?? mainColor,
    //   ),

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

//  inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
//             hintStyle: AppTextStyle.greyNormal,
//             border: _inputDecorationBorder(mainColor),
//             enabledBorder: _inputDecorationBorder(mainColor),
//             focusedBorder: _inputDecorationBorder(mainColor),
//             filled: true,
//             fillColor: AppColors.white,
//             prefixIconColor: mainColor,
//             suffixIconColor: mainColor,
//           ),
      dividerColor: AppColors.appColor,
      // dividerColor: mainColor,

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
// iconTheme: Theme.of(context).iconTheme.copyWith(color: mainColor),

//       appBarTheme: Theme.of(context).appBarTheme.copyWith(
//             // backgroundColor: mainColor,
//             // iconTheme: const IconThemeData(color: Colors.white),
//             titleTextStyle: AppTextStyle.white23,
//           ),

      useMaterial3: true,
    );
  }
  // static OutlineInputBorder _inputDecorationBorder(Color color) =>
  //     OutlineInputBorder(
  //       borderRadius:
  //           BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
  //       borderSide: BorderSide(color: color),
  //     );
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

