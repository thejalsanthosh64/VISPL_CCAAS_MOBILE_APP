import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_text_field.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class LeadsDatePicker extends StatelessWidget {
  const LeadsDatePicker({
    super.key,
    this.value,
    required this.hinText,
    required this.onSelectDateRange,
  });

  final String? value;
  final String hinText;
  final void Function(DateTimeRange dateRange) onSelectDateRange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: AppConstant.leadsFieldTitleWidth,
            child: Text(
              AppLocalizations.of(context)!.selectDate,
              style: AppTextStyle.white16,
            )),
        Expanded(
          child: AppTextField(
            hintText: hinText,
            readOnly: true,
            onTap: () async {
              final dateRange = await appDateRangePicker(
                context: context,
                currentDate: DateTime.now(),
                firstDate: DateTime.now().subtract(const Duration(days: 90)),
                lastDate: DateTime.now(),
              );
              if (dateRange != null) {
                onSelectDateRange(dateRange);
              }
            },
            maxLines: 2,
            minLines: 1,
            initialValue: value,
          ),
        ),
      ],
    );
  }
}
