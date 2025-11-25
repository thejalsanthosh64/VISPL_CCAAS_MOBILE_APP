import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/features/remarks/data/model/request/remarks_request_model.dart';
import 'package:kommuno/features/remarks/data/model/request/send_remarks_request_model.dart';

final class RemarksRepo {
  final _dioClient = DioClient();

  Future<CommonResponseModel> getRemarksList(
      {required RemarksRequestModel remarksRequestModel,required int smeId}) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.getListRemarks(
              smeId),
          data: remarksRequestModel.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> setRemarks(
      {required SendRemarksRequestModel sendRemarksRequestModel,required int smeId}) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.setRemarks(
             smeId),
          data: sendRemarksRequestModel.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
