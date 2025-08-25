import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/core/utilities/shortcuts/cubit/shortcuts_cubit.dart';
import 'package:kommuno/core/utilities/shortcuts/enum/shortcuts_enum.dart';

class AppShortcutButton extends StatelessWidget {
  const AppShortcutButton({super.key});

  ShortcutsCubit _shortcutsCubit(BuildContext context) => context.read<ShortcutsCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShortcutsCubit, ShortcutsState>(
      builder: (context, state) {
        return PopupMenuButton<ShortcutsEnum>(
          padding: EdgeInsets.zero,
          initialValue: state.selectedShortcut,

          ///  For all types
          // offset: const Offset(0, -360),
          offset: const Offset(0, -270),
          position: PopupMenuPosition.over,
          onOpened: () {
            _shortcutsCubit(context).onOpenMenu();
          },
          onCanceled: () {
            _shortcutsCubit(context).onCloseMenu();
          },
          onSelected: (selectedShortcut) {
            _shortcutsCubit(context).onCloseMenu();
            if (state.selectedShortcut != selectedShortcut) {
              _onShortCutChange(selectedShortcut: selectedShortcut, context: context);
            }
          },
          itemBuilder: (__) {
            final values = [...ShortcutsEnum.values]
              ..remove(ShortcutsEnum.assignedCalls)
              ..remove(ShortcutsEnum.leads);
            return values.map<PopupMenuEntry<ShortcutsEnum>>((e) {
              return PopupMenuItem(
                value: e,
                child: Row(
                  children: [
                    AppSvgPicture(
                      assetName: e.assetName,
                      color: AppColors.appColor,
                      width: 20,
                      height: 20,
                    ),
                    const SizedBox(width: AppConstant.kSized5),
                    Text(
                      e.text,
                      style: AppTextStyle.appColor16,
                    ),
                  ],
                ),
              );
            }).toList();
          },
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.appColor),
            child: AnimatedRotation(
              turns: state.isOpened ? 1 : 0.50,
              duration: const Duration(milliseconds: 250),
              child: const Icon(
                Icons.format_list_bulleted,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  void _onShortCutChange({required ShortcutsEnum selectedShortcut, required BuildContext context}) {
    String name;
    switch (selectedShortcut) {
      case ShortcutsEnum.assignedCalls:
        name = AppRouteNames.assignedCalls;
        break;
      case ShortcutsEnum.dial:
        name = AppRouteNames.dialScreen;
        break;
      case ShortcutsEnum.insights:
        name = AppRouteNames.inSights;
        break;
      case ShortcutsEnum.recentCalls:
        name = AppRouteNames.recentCalls;
        break;
      case ShortcutsEnum.followUp:
        name = AppRouteNames.followUp;
        break;
      case ShortcutsEnum.contacts:
        name = AppRouteNames.contactList;
        break;
      case ShortcutsEnum.leads:
        name = AppRouteNames.leads;
        break;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.of(context).pushNamed(name);
  }
}
