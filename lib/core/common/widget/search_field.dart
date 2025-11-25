import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/common/widget/app_text_field.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.onChanged,
    this.hintText,
    this.controller,
    this.onTapOutside,
  });

  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final TapRegionCallback? onTapOutside;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      hintText: hintText ?? AppLocalizations.of(context)!.search,
      prefixIconConstraints: const BoxConstraints(minWidth: 25),
      suffixIconConstraints: const BoxConstraints(minWidth: 50),
      prefixIcon: const SizedBox(),
      textInputAction: TextInputAction.done,
      onTapOutside: onTapOutside,
      onChanged: onChanged,
      suffixIcon: const Padding(
        padding: EdgeInsets.only(right: 5, left: 5),
        child: AppAvatar(
          child: Icon(
            Icons.search,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
