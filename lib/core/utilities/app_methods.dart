import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/utilities/auto_logout_manager.dart';
import 'package:kommuno/core/utilities/logout_manager.dart';
import 'package:kommuno/core/utilities/secure_storage/secure_storage.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';

import 'campaign_manager.dart';
import 'local_storage/hive_service.dart';

void hideKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

Future<void> checkLogin(BuildContext context) async {
  try {
    await UserLoginInfoManager.getLoginUserInfo();
    try {
      await CampaignManager.getCampaignInfo();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRouteNames.homeMiddleware);
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRouteNames.assignCampaign);
      }
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(AppRouteNames.loginScreen);
    }
  }
}

Future<bool> goBackAlertDialog({required BuildContext context}) async {
  final result = await appDialog<bool>(
    context: context,
    alertText: AppLocalizations.of(context)!.goBackAlert,
    actions: (ctx) => [
      TextButton(
        onPressed: () async {
          Navigator.of(ctx).pop(false);
        },
        child: Text(AppLocalizations.of(ctx)!.no),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(ctx).pop(true);
        },
        child: Text(AppLocalizations.of(ctx)!.yes),
      )
    ],
  );
  return result ?? false;
}

Future<bool> exitAppDialog({
  required BuildContext context,
}) async {
  final result = await appDialog<bool>(
    context: context,
    constraints: const BoxConstraints(maxHeight: 110, maxWidth: 250),
    alertText: AppLocalizations.of(context)!.exitAppAlert,
    actions: (ctx) => [
      TextButton(
        onPressed: () async {
          Navigator.of(ctx).pop(false);
        },
        child: Text(AppLocalizations.of(ctx)!.no),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(ctx).pop(true);
        },
        child: Text(AppLocalizations.of(ctx)!.yes),
      )
    ],
  );
  return result ?? false;
}

Future<T?> appDialog<T>({
  required BuildContext context,
  BoxConstraints? constraints,
  String alertText = '',
  Widget? customBody,
  List<Widget> Function(BuildContext context)? actions,
  List<Widget> Function(BuildContext context)? prefixActions,
  Color? backgroundColor,
  EdgeInsets? insetPadding,
}) async {
  return await showDialog<T>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (ctx) {
      return PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: backgroundColor,
          insetPadding: insetPadding,
          child: ConstrainedBox(
            constraints: constraints ?? const BoxConstraints(maxHeight: 130, maxWidth: 250),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (customBody != null)
                  Expanded(child: customBody)
                else
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(alertText),
                    ),
                  ),
                Row(
                  children: [
                    if (prefixActions != null) ...prefixActions(ctx),
                    const Spacer(),
                    if (actions != null) ...actions(ctx),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      );
    },
  );
}

String splitByIndiaCountryCode({required String number}) {
  if (number.length > 10) {
    final numberList = number.split('');
    return numberList.skip(numberList.length - 10).join();
  } else {
    return number.split(AppConstant.countryCode).last;
  }
}

String addByIndiaCountryCode({required String number}) {
  return "${AppConstant.countryCode}${splitByIndiaCountryCode(number: number)}";
}

String addByIndiaCountryCodeWithoutPlus({required String number}) {
  return "${AppConstant.countryCodeWithoutPlus}${splitByIndiaCountryCode(number: number)}";
}

/// If using scaffold as child then background color should be transparent
Future<T?> appBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext ctx) child,
  double? height,
  Color? backgroundColor,
}) async {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: false,
    isDismissible: false,
    enableDrag: false,
    isScrollControlled: true,
    backgroundColor: AppColors.transparent,
    builder: (ctx) {
      return PopScope(
        canPop: false,
        child: Container(
          height: height ?? MediaQuery.sizeOf(context).height * 0.5,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(40),
              topLeft: Radius.circular(40),
            ),
            color: backgroundColor ?? AppColors.appColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: child(ctx),
        ),
      );
    },
  );
}

Future<DateTimeRange?> appDateRangePicker({
  required BuildContext context,
  DateTime? currentDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  return showDateRangePicker(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    helpText: AppLocalizations.of(context)!.selectDate,
    currentDate: currentDate,
    firstDate: firstDate,
    lastDate: lastDate,
    saveText: AppLocalizations.of(context)!.select,
  );
}

Future<List<T>?> multiSelectionDialog<T>({
  required BuildContext context,
  required String Function(T value) onBuildText,
  required String Function(T value) onBuildId,
  required List<T> items,
  required List<T> selectedItems,
  BoxConstraints? constraints,
  String? title,
}) async {
  final localSelected = ValueNotifier<List<T>>([...selectedItems]);
  final selected = await appDialog<bool>(
    context: context,
    constraints: items.isEmpty ? const BoxConstraints(maxHeight: 180) : constraints ?? const BoxConstraints(maxHeight: 400),
    customBody: ValueListenableBuilder(
        valueListenable: localSelected,
        builder: (context, selected, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((title ?? '').isNotEmpty) ...[
                const SizedBox(height: AppConstant.kSized20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    title ?? '',
                    style: AppTextStyle.appColor23,
                  ),
                )
              ],
              SizedBox(height: (title ?? '').isNotEmpty ? AppConstant.kSized10 : AppConstant.kSized20),
              if (items.isEmpty)
                Center(
                  child: Text(
                    AppLocalizations.of(context)!.noItemsFound,
                    style: AppTextStyle.black25,
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (__, index) {
                      bool isSelected = selected.map((e) => onBuildId(e)).contains(onBuildId(items[index]));
                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          final list = [...localSelected.value];
                          if (isSelected) {
                            list.removeWhere((e1) => onBuildId(e1) == onBuildId(items[index]));
                          } else {
                            list.add(items[index]);
                          }
                          localSelected.value = list;
                        },
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(onBuildText(items[index])),
                      );
                    },
                  ),
                ),
            ],
          );
        }),
    prefixActions: (ctx) => [
      if (items.isNotEmpty)
        TextButton(
          onPressed: () async {
            localSelected.value = [];
          },
          child: Text(AppLocalizations.of(ctx)!.clearAll),
        ),
    ],
    actions: (ctx) => [
      TextButton(
        onPressed: () async {
          Navigator.of(ctx).pop(false);
        },
        child: Text(AppLocalizations.of(ctx)!.cancel),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(ctx).pop(true);
        },
        child: Text(AppLocalizations.of(ctx)!.ok),
      )
    ],
  );
  localSelected.dispose();
  if (selected ?? false) {
    return localSelected.value;
  }
  return null;
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate;
  lastDate ??= firstDate.add(const Duration(days: 30));

  final DateTime? selectedDate =
      await showDatePicker(context: context, initialDate: initialDate, firstDate: firstDate, lastDate: lastDate, barrierDismissible: false);

  if (selectedDate == null) {
    return null;
  }

  if (!context.mounted) {
    return selectedDate;
  }

  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
    barrierDismissible: false,
  );

  return selectedTime == null
      ? null
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}

String getDurationFromSeconds({required int duration, bool isShowText = true}) {
  int p1 = duration % 60;
  int p2 = duration ~/ 60;
  int p3 = p2 % 60;
  p2 = p2 ~/ 60;
  if (p2 == 0) {
    return '${p3.toString().padLeft(2, '0')}${isShowText ? "m " : ":"}${p1.toString().padLeft(2, '0')}${isShowText ? "s" : ""}';
  } else {
    return '${p2.toString().padLeft(2, '0')}${isShowText ? "h " : ":"}${p3.toString().padLeft(2, '0')}${isShowText ? "m " : ":"}${p1.toString().padLeft(2, '0')}${isShowText ? "s" : ""}';
  }
}
