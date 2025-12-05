import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/features/schedule_call/data/model/request/add_schedule_call_request_model.dart';

class ScheduleCallRepo {
  final _dioClient = DioClient();

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
          addScheduleCallRequestModel,    required int smeId,
}) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.addScheduleCall(
              smeId),
          data: addScheduleCallRequestModel.toJson());
          print("📥 Add Schedule Call RESPONSE → ${res.data}");

      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> nearTimeScheduleCalls({
  required int smeId,
  required int agentId,
  required String time,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.nearTimeScheduleCalls(smeId),
      data: {
        "agentId": agentId,
        "time": time,
      },
    );
    return res;
  } catch (e) {
    rethrow;
  }
}

}
