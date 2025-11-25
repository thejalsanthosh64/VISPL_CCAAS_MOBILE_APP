import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';

class ActivityHelperRepo {
  final _dioClient = DioClient();

  Future<CommonResponseModel> setActivityLogs(int id, {
    required String action,
    required String userRole,
    required String message,
    required int agentId,
    required String moduleName
  }) async {
    final body = {
      "action": action,
      "userRole": userRole,
      "message": message,
      "ip": "N/A",
      "moduleName": moduleName,
      "agentId": agentId,
      "insertDate": DateTime.now().toString().substring(0, 19),
    };

    return _dioClient.post("/common/$id/setActivityLogs", data: body);
  }


   Future<void> updateAgentLiveStatus({
    required int smeId,
    required int agentId,
    required String status,
    int wrapUp = 0,
  }) async {
    await _dioClient.post("/agent/$smeId/updateAgentLiveStatus", data: {
      "agent_id": agentId,
      "status": status,
      "wrap_up_time": wrapUp,
    });
  }

   Future<void> updateLiveCallStatus({
    required int smeId,
    required int agentId,
    required String sessionId,
    required String status,
  }) async {
    await _dioClient.post("/agent/$smeId/updateLiveCallStatus", data: {
      "agent_id": agentId,
      "status": status,
      "session_id": sessionId,
    });
  }

   Future<void> updateActivityTime({
    required int smeId,
    required int agentId,
    required String status,
    required int durationInSeconds,
  }) async {
    await _dioClient.post("/agent/$smeId/updateAgentActivityTime", data: {
      "agent_id": agentId,
      "status": status,
      "time": durationInSeconds,
      "currentDate": DateTime.now().toIso8601String().substring(0, 10),
    });
  }
}
