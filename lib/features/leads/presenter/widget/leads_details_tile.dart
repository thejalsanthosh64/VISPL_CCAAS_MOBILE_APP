import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class LeadsDetailsTile extends StatelessWidget {
  const LeadsDetailsTile({
    super.key,
    required this.leading,
    required this.title,
    this.children = const [],
    this.trailing = const [],
  });

  final List<Widget> children;
  final List<Widget> trailing;
  final Widget leading;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(
          horizontal: AppConstant.kBodyHorizontalPadding),
      shape: InputBorder.none,
      dense: true,
      backgroundColor: AppColors.whiteGrey,
      maintainState: true,
      leading: leading,
      title: Text(title, style: AppTextStyle.appColor18),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...trailing,
          const Icon(
            Icons.more_vert,
            color: AppColors.appColor,
          ),
        ],
      ),
      children: children,
    );
  }
}
