import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_dropdown.dart';

class LeadsDropdown<T> extends StatelessWidget {
  const LeadsDropdown({
    super.key,
    required this.title,
    this.onChanged,
    required this.items,
    this.value,
    required this.onBuildText,
    required this.onBuildValue,
    this.enableDefaultBorder = true,
  });

  final String title;
  final ValueChanged<T?>? onChanged;
  final List<T> items;
  final T? value;
  final String Function(T value) onBuildText;
  final T? Function(T? value) onBuildValue;
  final bool enableDefaultBorder;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: AppConstant.leadsFieldTitleWidth,
            child: Text(title, style: AppTextStyle.white16)),
        Expanded(
          child: AppDropdown<T>(
            onChanged: onChanged,
            hintText: title,
            onBuildText: onBuildText,
            onBuildValue: onBuildValue,
            value: value,
            items: items,
            enableDefaultBorder: enableDefaultBorder,
          ),
        )
      ],
    );
  }
}
