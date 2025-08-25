import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

import 'app_icon_button.dart';

class SlidableIconButton extends StatelessWidget {
  const SlidableIconButton(
      {super.key, required this.slidableController, this.padding});

  final SlidableController slidableController;

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      padding: padding ??
          EdgeInsets.only(
            top: AppIconButton.iconPadding,
            bottom: AppIconButton.iconPadding,
            left: AppIconButton.iconPadding,
          ),
      onTap: () {
        if (slidableController.actionPaneType.value == ActionPaneType.end) {
          slidableController.close();
        } else {
          slidableController.openEndActionPane();
        }
      },
      icon: const Icon(
        Icons.more_vert,
        color: AppColors.appColor,
      ),
    );
  }
}
