import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/generated/assets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnBoardConatiner extends StatelessWidget {
  const OnBoardConatiner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.appColor, borderRadius: BorderRadius.circular(8)),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Positioned(
                        height: 70,
                        child: Image.asset(
                          Assets.imagesRobert,
                        ),
                      ),
                      Positioned.fill(
                        child: Text(
                          AppLocalizations.of(context)!
                              .bestWayConnectedCustomers,
                          style: AppTextStyle.white16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppConstant.kSized15),
                Image.asset(Assets.imagesHomeIntro)
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(
                  bottom: AppConstant.kSized5,
                  right: AppConstant.kSized5,
                  left: AppConstant.kSized5),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  border: Border.all(color: AppColors.orange)),
              child: FittedBox(
                  child: Text(AppLocalizations.of(context)!.twentyFourSeven,
                      style: AppTextStyle.orangeNormal)),
            ),
          ),
        ],
      ),
    );
  }
}
