import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class RemarksListTile extends StatelessWidget {
  const RemarksListTile(
      {super.key, required this.dateTime, required this.remarks});

  final DateTime dateTime;
  final String remarks;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 18),
      decoration: BoxDecoration(
          color: AppColors.appColor, borderRadius: BorderRadius.circular(50)),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: Text(
              DateUtility.getDisplayDateTimeWithMonthName(date: dateTime),
              style: AppTextStyle.white11,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              remarks,
              style: AppTextStyle.white18,
            ),
          ),
        ],
      ),
    );
  }
}
