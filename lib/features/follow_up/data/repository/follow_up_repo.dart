import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';

final class FollowUpRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> followUpDetails({
    required int initialRecord,
    required int batchSize,
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.getFollowUpCall(
              UserLoginInfoManager.userLoginInfoModel!.userId),
          data: {
            "initialRecord": initialRecord,
            "batchSize": batchSize,
            "sme_id": smeId
          });
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> changeScheduleStatus({
    required String scheduleId,
    required int status,
    required int smeId,
  }) async {
    try {
      final res = await _dioClient
          .post(ApiEndpoints.changeScheduleStatus(smeId), data: {
        "scheduleId": scheduleId,
        "status": status,
        "sme_Id": smeId,
      });
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
