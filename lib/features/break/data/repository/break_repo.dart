import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/features/break/data/model/break_in_request_model.dart';
import 'package:kommuno/features/break/data/model/break_out_request_model.dart';

final class BreakRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> getBreakDetails() async {
    try {
      final res = await _dioClient.post(ApiEndpoints.breakList(
          UserLoginInfoManager.userLoginInfoModel!.userId));
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> breakIn(
      {required BreakInRequestModel breakInRequestData}) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.breakIn(UserLoginInfoManager.userLoginInfoModel!.userId),
          data: breakInRequestData.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> breakOut(
      {required BreakOutRequestModel breakOutRequestData}) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.breakOut(
              UserLoginInfoManager.userLoginInfoModel!.userId),
          data: breakOutRequestData.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
