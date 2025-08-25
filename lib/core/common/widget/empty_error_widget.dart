import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_outline_button.dart';

import 'app_button.dart';

class EmptyErrorWidget extends StatelessWidget {
  const EmptyErrorWidget({
    super.key,
    required this.text,
    this.showButton = true,
    this.onTap,
    this.style,
    this.isOutlined = false,
  });

  final String text;
  final VoidCallback? onTap;
  final bool showButton;
  final TextStyle? style;
  final bool isOutlined;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: style ?? AppTextStyle.black18,
          ),
          if (showButton) ...[
            const SizedBox(height: AppConstant.kSized20),
            if (isOutlined)
              AppOutlineButton(
                text: AppLocalizations.of(context)!.tryAgain,
                width: 100,
                height: 50,
                onTap: onTap,
              )
            else
              AppButton(
                height: 50,
                text: AppLocalizations.of(context)!.tryAgain,
                width: 100,
                onTap: onTap,
              )
          ]
        ],
      ),
    );
  }
}
