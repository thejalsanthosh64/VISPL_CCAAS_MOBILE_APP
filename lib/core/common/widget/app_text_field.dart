import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.suffixIconConstraints,
    this.suffixIcon,
    this.onChanged,
    this.textInputAction,
    this.autofocus = false,
    this.focusNode,
    this.maxLines = 1,
    this.readOnly = false,
    this.minLines,
    this.maxLength,
    this.onTap,
    this.initialValue,
    this.onTapOutside,
    this.contextMenuBuilder,
  });

  final TextEditingController? controller;
  final Widget? prefixIcon;
  final BoxConstraints? prefixIconConstraints;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final bool autofocus;
  final FocusNode? focusNode;
  final int maxLines;
  final bool readOnly;
  final int? minLines;
  final int? maxLength;
  final VoidCallback? onTap;
  final String? initialValue;
  final TapRegionCallback? onTapOutside;
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  InputBorder get _border {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide:  BorderSide(color: AppColors.appColor));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines == 1 ? AppConstant.kSized55 : null,
      child: TextFormField(
        initialValue: initialValue,
        focusNode: focusNode,
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscureText,
        onChanged: onChanged,
        autofocus: autofocus,
        textInputAction: textInputAction,
        maxLines: maxLines,
        readOnly: readOnly,
        minLines: minLines,
        onTap: onTap,
        maxLength: maxLength,
        onTapOutside: onTapOutside,
        contextMenuBuilder: contextMenuBuilder,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          prefixIconConstraints: prefixIconConstraints,
          suffixIcon: suffixIcon,
          suffixIconConstraints: suffixIconConstraints,
          focusedBorder: maxLines == 1 ? null : _border,
          border: maxLines == 1 ? null : _border,
          enabledBorder: maxLines == 1 ? null : _border,
          hintText: hintText ?? "",
          hintStyle: AppTextStyle.greyNormal,
        ),
      ),
    );
  }
}
