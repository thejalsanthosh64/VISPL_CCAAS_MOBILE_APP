import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.onBuildText,
    required this.onBuildValue,
    required this.items,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.hintText,
    this.onChanged,
    this.value,
    this.enableDefaultBorder = true,
  });

  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final String? hintText;
  final ValueChanged<T?>? onChanged;
  final List<T> items;
  final T? value;
  final String Function(T value) onBuildText;
  final T? Function(T? value) onBuildValue;
  final bool enableDefaultBorder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConstant.kSized55,
      child: DropdownButtonFormField<T>(
        value: value,
        items: items.map((e) {
          return DropdownMenuItem<T>(
            value: onBuildValue(e),
            child: Text(onBuildText(e)),
          );
        }).toList(),
        onChanged: onChanged,
        isDense: true,
        iconSize: 20,
        isExpanded: true,
        menuMaxHeight: 300,
        iconEnabledColor: AppColors.black,
        borderRadius: BorderRadius.circular(20),
        icon: const Icon(Icons.keyboard_arrow_down),
        hint: Text(hintText ?? '', style: AppTextStyle.greyNormal),
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixIconConstraints,
          suffixIcon: suffixIcon,
          suffixIconConstraints: suffixIconConstraints,
          focusedBorder: enableDefaultBorder ? null : _border,
          border: enableDefaultBorder ? null : _border,
          enabledBorder: enableDefaultBorder ? null : _border,
        ),
      ),
    );
  }

  InputBorder get _border {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide:  BorderSide(color: AppColors.appColor));
  }
}
