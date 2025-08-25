import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/schedule_call/data/model/request/add_schedule_call_request_model.dart';

class ScheduleCallRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> getScheduleCalls({
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.getScheduledCalls(smeId),
        data: {"sme_id": smeId},
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> addScheduleCall(
      {required AddScheduleCallRequestModel
          addScheduleCallRequestModel}) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.addScheduleCall(
              UserLoginInfoManager.userLoginInfoModel!.userId),
          data: addScheduleCallRequestModel.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
