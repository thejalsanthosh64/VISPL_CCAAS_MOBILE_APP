import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class DaysChip extends StatelessWidget {
  const DaysChip({
    super.key,
    required this.isSelected,
    required this.text,
    this.onTap,
  });

  final bool isSelected;
  final String text;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
      onTap: isSelected ? null : onTap,
      child: Container(
        height: 40,
        width: 100,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
        margin: const EdgeInsets.only(right: AppConstant.kSized5),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.appColor : AppColors.white,
            borderRadius:
                BorderRadius.circular(AppConstant.kFieldAndButtonRadius),
            border: Border.all(color: AppColors.appColor)),
        child: Text(
          text,
          style: isSelected
              ? AppTextStyle.whiteNormal
              : AppTextStyle.appColorNormal,
        ),
      ),
    );
  }
}
