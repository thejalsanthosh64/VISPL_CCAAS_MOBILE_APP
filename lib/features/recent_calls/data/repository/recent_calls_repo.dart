import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/features/recent_calls/data/model/request/recent_calls_request_model.dart';

final class RecentCallsRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> getRecentCalls({
    List<RecentCallsRequestModel>? recentCallsRequestModel,
    required int smeId,
    required int batchSize,
    required int initialRecord,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.getRecentCalls(
            UserLoginInfoManager.userLoginInfoModel!.userId),
        data: {
          if (recentCallsRequestModel != null)
            "filterList":
                recentCallsRequestModel.map((e) => e.toJson()).toList(),
          "batchSize": batchSize,
          "initialRecord": initialRecord,
          "smeId": smeId,
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
