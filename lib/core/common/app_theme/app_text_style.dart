part of 'app_theme.dart';

abstract class AppTextStyle {
  static const black25 = TextStyle(fontSize: 25, color: AppColors.black);
  static final appColor25 = TextStyle(fontSize: 25, color: AppColors.appColor);
  static const white25 = TextStyle(fontSize: 25, color: AppColors.white);

  static const blackNormal = TextStyle(fontWeight: FontWeight.w500);
  static const whiteNormal =
      TextStyle(color: AppColors.white, fontWeight: FontWeight.w500);
  static final appColorNormal =
      TextStyle(color: AppColors.appColor, fontWeight: FontWeight.w500);
  static const greyNormal =
      TextStyle(color: AppColors.grey, fontWeight: FontWeight.w500);
  static const orangeNormal =
      TextStyle(color: AppColors.orange, fontWeight: FontWeight.w500);

  static const grey18 = TextStyle(fontSize: 18, color: AppColors.grey);
  static final appColor18 = TextStyle(fontSize: 18, color: AppColors.appColor);
  static const black18 = TextStyle(fontSize: 18, color: AppColors.black);
  static const white18 = TextStyle(fontSize: 18, color: AppColors.white);

  static final appColor16 = TextStyle(fontSize: 16, color: AppColors.appColor);
  static const black16 = TextStyle(fontSize: 16, color: AppColors.black);
  static const white16 = TextStyle(fontSize: 16, color: AppColors.white);

  static const white23 = TextStyle(fontSize: 23, color: AppColors.white);
  static final appColor23 = TextStyle(fontSize: 23, color: AppColors.appColor);
  static const black23 = TextStyle(fontSize: 23, color: AppColors.black);

  static const grey13 = TextStyle(
      color: AppColors.grey, fontSize: 13, fontWeight: FontWeight.w500);
  static const white11 = TextStyle(
      color: AppColors.white, fontSize: 11, fontWeight: FontWeight.w500);
}
