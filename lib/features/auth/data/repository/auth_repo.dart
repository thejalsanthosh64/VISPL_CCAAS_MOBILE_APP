import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/auth/data/model/login_request_model.dart';

final class AuthRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> loginUser(
      {required LoginRequestModel loginRequestModel}) async {
    try {
      final res = await _dioClient.post(ApiEndpoints.login,
          data: loginRequestModel.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> forgotPassword({required String userName}) async {
    try {
      final res = await _dioClient.post(ApiEndpoints.forgotPassword(userName));
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> verifyOtp(
      {required String userName, required String otp}) async {
    try {
      final res = await _dioClient
          .post(ApiEndpoints.verifyOtp(userName), data: {"oneTimeCode": otp});
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> changePassword(
      {required String userName, required String newPassword}) async {
    try {
      final res =
          await _dioClient.post(ApiEndpoints.changePassword(userName), data: {
        "newPassword": newPassword,
      });
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> logoutUser({
    required String username,
    required String mode,
  }) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.logout(UserLoginInfoManager.userLoginInfoModel!.userId),
          data: {
            "mode": mode,
            "token": "",
            "username": username,
          });
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
