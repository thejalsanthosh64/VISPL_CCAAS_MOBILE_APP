import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/gradient_circular_progress.dart';

class HomeProgress extends StatelessWidget {
  const HomeProgress({
    super.key,
    required this.progress
  });

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors.appColor),
              shape: BoxShape.circle),
          child:  RotatedBox(
            quarterTurns: 3,
            child: GradientCircularProgress(
              size: 50,
              gradient: AppColors.homeProgressGradient,
              progress: progress,
              strokeWidth: 15,
            ),
          ),
        ),
         Positioned(
          height: 60,
          width: 60,
          child: DecoratedBox(
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.appColor,
            ),
            child: Center(
              child: Padding(
                padding:  EdgeInsets.only(bottom: AppConstant.kCenterPadding),
                child: Text(
                  "${progress.toInt()}%",
                  style: AppTextStyle.white16,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
