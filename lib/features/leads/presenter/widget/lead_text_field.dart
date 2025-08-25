import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_text_field.dart';

class LeadTextField extends StatelessWidget {
  const LeadTextField({
    super.key,
    required this.title,
    this.controller,
    this.keyboardType,
    this.inputFormatters,
    this.textInputAction,
    this.hintText,
    this.maxLines = 1,
    this.autofocus = false,
  });

  final String title;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: AppConstant.leadsFieldTitleWidth,
            child: Text(title, style: AppTextStyle.white16)),
        const SizedBox(width: AppConstant.kSized5),
        Expanded(
          child: AppTextField(
            hintText: hintText ?? title,
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textInputAction: textInputAction,
            maxLines: maxLines,
            autofocus: autofocus,
          ),
        )
      ],
    );
  }
}
