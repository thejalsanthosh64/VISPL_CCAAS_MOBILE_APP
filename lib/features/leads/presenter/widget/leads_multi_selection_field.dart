import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_text_field.dart';


class LeadsMultiSelectionField extends StatelessWidget {
  const LeadsMultiSelectionField({
    super.key,
    required this.title,
    this.value,
    this.onTap,
  });

  final String title;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: AppConstant.leadsFieldTitleWidth,
            child: Text(title, style: AppTextStyle.white16)),
        Expanded(
          child: AppTextField(
            hintText: title,
            readOnly: true,
            onTap: onTap,
            maxLines: 3,
            minLines: 1,
            initialValue: value,
          ),
        )
      ],
    );
  }
}
