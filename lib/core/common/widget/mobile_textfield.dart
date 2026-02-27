import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'app_text_field.dart';

class MobileTextField extends StatelessWidget {
  const MobileTextField({
    super.key,
    this.controller,
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.autofocus = false,
    this.readOnly = false,
    this.onChanged,
    this.contextMenuBuilder,
  });

  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final bool autofocus;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final EditableTextContextMenuBuilder? contextMenuBuilder;


  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hintText: AppLocalizations.of(context)!.mobileNumber,
      textInputAction: textInputAction,
      prefixIconConstraints: const BoxConstraints(maxWidth: 90),
      suffixIconConstraints: suffixIconConstraints,
      keyboardType: keyboardType ?? TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      readOnly: readOnly,
      autofocus: autofocus,
      suffixIcon: suffixIcon,
      controller: controller,
      onChanged: onChanged,
      contextMenuBuilder: contextMenuBuilder,
      prefixIcon: Row(
        children: [
          const SizedBox(width: AppConstant.kSized15),
           Icon(
            Icons.phone,
            color: AppColors.appColor,
          ),
          const SizedBox(width: AppConstant.kSized10),
          Padding(
            padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
            child:  Text(
              AppConstant.countryCodeWithoutPlus,
              style: TextStyle(color: AppColors.appColor),
            ),
          ),
          const SizedBox(width: AppConstant.kSized5),
           SizedBox(
            height: 28,
            child: VerticalDivider(
              width: 0,
              thickness: 1.5,
              color: AppColors.appColor,
            ),
          )
        ],
      ),
    );
  }
}
