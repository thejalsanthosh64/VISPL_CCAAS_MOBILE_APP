import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class AppRadioTile<T> extends StatelessWidget {
  const AppRadioTile(
      {super.key,
      required this.title,
      required this.value,
      required this.groupValue,
      this.onChanged});

  final String title;
  final T value;
  final T groupValue;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return RadioListTile<T>(
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(
        title,
        style: AppTextStyle.white16,
      ),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      fillColor: const WidgetStatePropertyAll(AppColors.white),
    );
  }
}
