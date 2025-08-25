import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({super.key, this.title = '', this.titleWidget});

  final String title;
  final Widget? titleWidget;

  static const titleStyle = AppTextStyle.white25;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: titleWidget ??
              Text(
                title,
                style: titleStyle,
              ),
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          iconSize: 40,
          color: AppColors.white,
          icon: const Icon(Icons.highlight_off_rounded),
        ),
      ],
    );
  }
}
