import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class CustomFieldDecoration extends StatelessWidget {
  const CustomFieldDecoration({
    super.key,
    this.value,
    this.hinText,
    this.onTap,
    this.suffixIcon,
    this.prefixIcon,
    this.style,
    this.alignment,
  });

  final String? value;
  final String? hinText;
  final VoidCallback? onTap;
  final List<Widget>? suffixIcon;
  final List<Widget>? prefixIcon;
  final TextStyle? style;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        AppConstant.kFieldAndButtonRadius,
      ),
      child: Container(
        height: AppConstant.kSized55,
        alignment: alignment ?? Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 13, right: 13),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.appColor),
          borderRadius: BorderRadius.circular(
            AppConstant.kFieldAndButtonRadius,
          ),
        ),
        child: Row(
          children: [
            if (suffixIcon != null) ...[
              ...suffixIcon!,
              const SizedBox(width: 12)
            ],
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
                child: (value ?? '').isEmpty
                    ? Text(hinText ?? '', style: AppTextStyle.greyNormal)
                    : SingleChildScrollView(
                        child: Text(
                          value ?? '',
                          style: style,
                        ),
                      ),
              ),
            ),
            if (prefixIcon != null) ...[
              const SizedBox(width: 12),
              ...prefixIcon!,
            ],
          ],
        ),
      ),
    );
  }
}
