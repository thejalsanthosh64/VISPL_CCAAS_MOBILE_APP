import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoRecordFound extends StatelessWidget {
  const NoRecordFound({
    super.key,
    this.buttonText,
    this.onPressed,
  });

  final String? buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      decoration: BoxDecoration(
          color: AppColors.whiteGrey, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if ((buttonText ?? '').isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onPressed,
                child: Text(buttonText ?? ''),
              ),
            )
          else ...[
            const SizedBox(),
            const SizedBox(),
          ],
          Text(
            AppLocalizations.of(context)!.noRecordFound,
            style: AppTextStyle.black23,
          ),
          const SizedBox(),
          const SizedBox(),
        ],
      ),
    );
  }
}
