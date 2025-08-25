// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:collection/collection.dart';

class HomeMenuButton extends StatelessWidget {
  const HomeMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      position: PopupMenuPosition.under,
      menuPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      onSelected: (value) {
        switch (value) {
          case 0:
            Navigator.of(context).pushNamed(AppRouteNames.switchCampaign);
            break;
        }
      },
      itemBuilder: (__) {
        return ["Switch campaign"].mapIndexed<PopupMenuEntry<int>>(
          (index, e) {
            return PopupMenuItem(
              value: index,
              child: Text(
                e,
                style: AppTextStyle.appColor16,
              ),
            );
          },
        ).toList();
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.appColor),
        child: const Icon(
          Icons.format_list_bulleted,
          color: Colors.white,
        ),
      ),
    );
  }
}
