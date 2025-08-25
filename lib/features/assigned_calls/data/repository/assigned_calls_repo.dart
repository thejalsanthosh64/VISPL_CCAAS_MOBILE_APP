import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';

final class AssignedCallsRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> getAssignedCalls({
    required int initialRecord,
    required int batchSize,
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.getAssignedCalls(
              UserLoginInfoManager.userLoginInfoModel!.userId),
          data: {
            "initialRecord": initialRecord,
            "batchSize": batchSize,
            "smeId": smeId
          });
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
