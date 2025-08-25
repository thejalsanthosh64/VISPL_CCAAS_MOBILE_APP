import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/features/remarks/data/model/request/remarks_request_model.dart';
import 'package:kommuno/features/remarks/data/model/request/send_remarks_request_model.dart';

final class RemarksRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> getRemarksList(
      {required RemarksRequestModel remarksRequestModel}) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.getListRemarks(
              UserLoginInfoManager.userLoginInfoModel!.userId),
          data: remarksRequestModel.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> setRemarks(
      {required SendRemarksRequestModel sendRemarksRequestModel}) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.setRemarks(
              UserLoginInfoManager.userLoginInfoModel!.userId),
          data: sendRemarksRequestModel.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
