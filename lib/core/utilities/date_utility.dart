import 'package:intl/intl.dart';

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
}
