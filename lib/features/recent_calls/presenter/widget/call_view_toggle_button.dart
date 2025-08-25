import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';

class CallViewToggleButton extends StatelessWidget {
  const CallViewToggleButton({
    super.key,
    required this.isSelected,
    required this.text,
    required this.assetName,
    this.onTap,
  });

  final bool isSelected;
  final String text;
  final String assetName;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: isSelected ? null : onTap,
      child: Container(
        height: 40,
        width: 100,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
        decoration: BoxDecoration(
            color: isSelected ? AppColors.appColor : AppColors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.appColor)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: AppSvgPicture(
                assetName: assetName,
                color: isSelected ? AppColors.white : AppColors.appColor,
                height: 15,
                width: 20,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: isSelected
                  ? AppTextStyle.whiteNormal
                  : AppTextStyle.appColorNormal,
            ),
          ],
        ),
      ),
    );
  }
}
