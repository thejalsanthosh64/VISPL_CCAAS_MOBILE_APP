
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/network_manager/alive_set_service.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/auth/data/model/login_request_model.dart';

final class AuthRepo {
  final _dioClient = DioClient();

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
    required int waitingsec
    
    
  }) async {
    try {


      final res = await _dioClient.post(
          ApiEndpoints.logout(UserLoginInfoManager.userLoginInfoModel!.userId),
          data: {
            "mode": mode,
            "token": "",
            "username": username,
          });

if(res.isSuccess){

final user = UserLoginInfoManager.userLoginInfoModel!;
AliveService().stop();

await ActivityHelperRepo().setActivityLogs(
user.smeId,
  userRole: user.role,
  moduleName: "auth",
  action: "logout",
  message: "${user.username} Successfully Logged Out",
  agentId: user.userId,
);

await ActivityHelperRepo().updateUserOnlineOffline(
  smeId: user.smeId,
  onlineStatus: "Offline",
  userName: user.username,
  role: user.role,
  agentId: user.userId,
  agentLiveStatus: "Logout",
  callModePermission: 1,
  agentLoginType: "self_sign_in",
);



await ActivityHelperRepo().updateAgentActivityTime(
        smeId: user.smeId,
        agentId: user.userId ,
        time: waitingsec,
        status: "Waiting",
      );
 }

      return res;
    } catch (e) {
      rethrow;
    }
  }


Future<CommonResponseModel> checkIsAlive({
    required String username,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.checkIsAlive(username),
        data: {
          "username": username,
          "mode": "login",
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
Future<CommonResponseModel> updateReadyToTakeCall({
  required int agentId,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.updateReadyToTakeCall(agentId),
      data: {
        "agent_id": agentId,
      },
    );
    return res;
  } catch (e) {
    rethrow;
  }
}

}
