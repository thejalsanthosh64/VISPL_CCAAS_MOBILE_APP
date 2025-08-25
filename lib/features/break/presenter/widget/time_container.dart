import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class TimeContainer extends StatelessWidget {
  const TimeContainer({
    super.key,
    required this.title,
    required this.time,
  });

  final String title;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.appColorNormal,
        ),
        const SizedBox(height: AppConstant.kSized5),
        Container(
          width: 90,
          height: 30,
          alignment: Alignment.center,
          padding: Platform.isAndroid
              ? EdgeInsets.only(bottom: AppConstant.kCenterPadding)
              : const EdgeInsets.only(top: 3),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.appColor),
          ),
          child: FittedBox(
            child: Text(
              time,
              style: AppTextStyle.appColor16,
            ),
          ),
        ),
      ],
    );
  }
}
