import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.controller,
    this.textInputAction,
  });

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        border: _border,
        focusedBorder: _border,
        enabledBorder: _border,
        prefixIconColor: Theme.of(context)
            .inputDecorationTheme
            .copyWith(prefixIconColor: AppColors.appColor)
            .prefixIconColor,
        suffixIconColor: Theme.of(context)
            .inputDecorationTheme
            .copyWith(suffixIconColor: AppColors.appColor)
            .suffixIconColor,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(right: 20), child: prefixIcon)
            : null,
        prefixIconConstraints: prefixIcon != null
            ? const BoxConstraints(maxWidth: 40, maxHeight: 40)
            : null,
        hintText: hintText ?? "",
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 5), child: suffixIcon)
            : null,
        suffixIconConstraints: suffixIcon != null
            ? const BoxConstraints(maxWidth: 40, maxHeight: 40)
            : null,
      ),
    );
  }

  UnderlineInputBorder get _border {
    return const UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.appColor));
  }
}
