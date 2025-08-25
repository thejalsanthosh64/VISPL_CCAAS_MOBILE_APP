import 'secure_storage/secure_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/core/common/app_keys.dart';

abstract interface class AutoLogoutManager {
  const AutoLogoutManager();

/*  static Future<void> setLoginTimestamp() async {
    try {
      await SecureStorage().writeData(
          key: "loginTimestamp2",
          value: DateTime.now().toLocal().millisecondsSinceEpoch);
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool> isSessionExpired({required bool isLogin}) async {
    try {
      final loginTimestamp =
          await SecureStorage().readData(key: "loginTimestamp2");
      if (loginTimestamp is int) {
        final now = DateTime.now().toLocal();
        final loginDate = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
        final difference = now.difference(loginDate);
        return difference.inDays >= 7;
      } else {
        if (!isLogin) {
          setLoginTimestamp();
        }
      }
      return false;
    } catch (e) {
      if (!isLogin &&
          e ==
              AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                  .dataNotFound) {
        setLoginTimestamp();
      }
      return false;
    }
  }*/
}
