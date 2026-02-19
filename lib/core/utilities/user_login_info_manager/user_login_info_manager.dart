import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/secure_storage/secure_storage.dart';

part 'user_login_info_model.dart';

abstract interface class UserLoginInfoManager {
  const UserLoginInfoManager();

  static UserLoginInfoModel? _userLoginInfoModel;

  static UserLoginInfoModel? get userLoginInfoModel => _userLoginInfoModel;

  static Future<void> setLoginUserInfo({Object? userInfo}) async {
    try {
      if (userInfo != null) {
        final userLoginInfo =
            UserLoginInfoModel.fromJson(userInfo as Map<String, dynamic>);
        await SecureStorage().writeData(
            key: StorageEnum.userLoginInfo.name, value: userLoginInfo.toJson());
        _userLoginInfoModel = userLoginInfo;
      } else {
        _userLoginInfoModel = null;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> getLoginUserInfo() async {
    try {
      final data =
          await SecureStorage().readData(key: StorageEnum.userLoginInfo.name);
      _userLoginInfoModel =
          UserLoginInfoModel.fromJson(data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
   static Future<void> clearLoginUserInfo() async {
    try {
      await SecureStorage().deleteData(key: StorageEnum.userLoginInfo.name);
      _userLoginInfoModel = null;
    } catch (e) {
      rethrow;
    }
  }
}
