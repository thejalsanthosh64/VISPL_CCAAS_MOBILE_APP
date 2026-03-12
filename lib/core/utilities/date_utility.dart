import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/utilities/app_methods.dart';

abstract interface class DateUtility {
  static String sendRequestDateTimeFormat({required DateTime date}) {
    final dateFormatter = DateFormat("yyyy-MM-dd HH:mm:ss");
    String formattedDate = dateFormatter.format(date);
    return formattedDate;
  }

  static String scheduleCallRequestDateTimeFormat({required DateTime date}) {
    final dateFormatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    String formattedDate = dateFormatter.format(date);
    return formattedDate;
  }

  static String getDisplayDateTimeWithMonthName({required DateTime date}) {
    final dateFormatter = DateFormat(
      "dd MMMM, yyyy  hh:mm a",
    );
    String formattedDate = dateFormatter.format(date);
    return formattedDate;
  }

  static String getDisplayDateTimeWithoutMonthName({required DateTime date}) {
    final dateFormatter = DateFormat("dd/MM/yyyy HH:mm a");
    String formattedDate = dateFormatter.format(date);
    return formattedDate;
  }

  static String getDateYMDOnly({required DateTime date}) {
    final dateFormatter = DateFormat("yyyy-MM-dd");
    String formattedDate = dateFormatter.format(date);
    return formattedDate;
  }

  static DateTime getTimeSinceLastBreak({required String date, bool parseUtc = true}) {
    final dateFormatter = DateFormat('yyyy-M-d H:m:s');
    DateTime formattedDate = parseUtc ? dateFormatter.parseUtc(date) : dateFormatter.parse(date);
    return formattedDate;
  }

  static Future<void> selectDateRangeWithLimit({
  required BuildContext context,
  required int maxDays,
  required Function(DateTimeRange) onSelected,
}) async {
  final dateRange = await appDateRangePicker(
    context: context,
    currentDate: DateTime.now(),
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now(),
  );

  if (dateRange != null) {
    // .inDays gives the difference in full 24h periods. 
    // Jan 1 to Jan 31 = 30 full days (which is 31 calendar dates).
    final difference = dateRange.end.difference(dateRange.start).inDays;

    if (difference >= maxDays) { 
      FToastManager().showToast(
        message: "Maximum $maxDays days range allowed",
      );
    } else {
      onSelected(dateRange);
    }
  }
}
}
