import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/calls/data/model/new_call_request_model.dart';

final class CallsRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> makeNewCall({required NewCallRequestModel newCallRequestData}) async {
    try {
      final res = await _dioClient.post(ApiEndpoints.clickToCall, data: newCallRequestData.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> getLongCodesForCall({
    required String smeId,
    required String campaignId,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.getLongCodesForCall(UserLoginInfoManager.userLoginInfoModel!.userId),
        data: {
          "smeId" : smeId,
          "campaignId" : campaignId,
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> makeNewCallV2({required NewCallRequestModel newCallRequestData}) async {
    try {
      final res = await _dioClient.post(ApiEndpoints.clickToCallLiveCall, data: newCallRequestData.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
