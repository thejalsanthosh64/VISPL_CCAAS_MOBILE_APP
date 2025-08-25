import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/utilities/app_methods.dart';

class DurationInfoContainer extends StatelessWidget {
  const DurationInfoContainer(
      {super.key, this.count, this.color, required this.title});

  final String title;
  final int? count;
  final Color? color;

  static const radius = 80.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: radius,
            height: radius,
            alignment: Alignment.center,
            padding: EdgeInsets.only(
                bottom: AppConstant.kCenterPadding,
                left: AppConstant.kCenterPadding,
                right: AppConstant.kCenterPadding),
            decoration: BoxDecoration(
                color: color,
                border: Border.all(color: AppColors.appColor),
                shape: BoxShape.circle),
            child: FittedBox(
              child: Text(
                count != null
                    ? getDurationFromSeconds(duration: count!, isShowText: true)
                    : "00m 00s",
                style: color != null
                    ? AppTextStyle.whiteNormal
                    : AppTextStyle.appColorNormal,
              ),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
