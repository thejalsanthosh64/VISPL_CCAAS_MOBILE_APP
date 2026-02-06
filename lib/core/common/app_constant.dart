import 'dart:io' show Platform;

abstract class AppConstant {
  /// Strings
  // static const applicationName = "Kommuno";
  static const applicationName = "Smartping";
  static const fontFamily = "Futura";
  static const loginDeviceType = "APP";
  static const noRouteDefined = "No route defined for";
  static const countryCode = "+91";
  static const countryCodeWithoutPlus = "91";
  static const breakDefaultTime = "00:00:00";

  /// double
  static const kBodyHorizontalPadding = 20.0;
  static const kFieldAndButtonRadius = 50.0;
  static final kCenterPadding = Platform.isAndroid ? 5.0 : 0.0;

  static const kSized5 = 5.0;
  static const kSized10 = 10.0;
  static const kSized15 = 15.0;
  static const kSized20 = 20.0;
  static const kSized55 = 55.0;

  static const leadsFieldTitleWidth = 100.0;

  static const kTilesBottomPadding = 10.0;
static const int defaultWrapUpFallbackSeconds = 300;

}
