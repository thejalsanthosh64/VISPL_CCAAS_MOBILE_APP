import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class SocialAppLauncher {
  static Future<void> openWhatsApp(
      {required String number, String? message}) async {
    try {
      number = addByIndiaCountryCode(number: number);
      message = message ??
          AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.helloWorld;
      final uri = Platform.isAndroid
          ? Uri.parse("whatsapp://send?phone=$number&text=$message")
          : Uri.parse("https://wa.me/$number?text=$message");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseInstallWhatsAppFirst);
      }
    } catch (e) {
      if (e is PlatformException) {
        FToastManager().showToast(
            message: e.message ??
                AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                    .somethingWentWrong);
      } else {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .somethingWentWrong);
      }
    }
  }
}
