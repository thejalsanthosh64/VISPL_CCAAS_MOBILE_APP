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

    return _dioClient.post(ApiEndpoints.setActivityLogs(id), data: body);
  }


   Future<void> updateAgentLiveStatus({
    required int smeId,
    required int agentId,
    required String status,
    int wrapUp = 0,
  }) async {
    await _dioClient.post(ApiEndpoints.updateAgentLiveStatus(smeId), data: {
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
    await _dioClient.post(ApiEndpoints.updateLiveCallStatus(smeId), data: {
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
    await _dioClient.post(ApiEndpoints.updateAgentActivityTime(smeId), data: {
      "agent_id": agentId,
      "status": status,
      "time": durationInSeconds,
      "currentDate": DateTime.now().toIso8601String().substring(0, 10),
    });
  }

    Future<void> updateUserOnlineOffline({
    required int smeId,
    required String onlineStatus,
    required String role,
    required int agentId,
    required String agentLiveStatus,
    required int callModePermission,
    required String agentLoginType,
    required String userName,



  }) async {
    await _dioClient.post(ApiEndpoints.updateUserOnlineOffline(userName), data: {
  "smeId":smeId,
 "onlineStatus": onlineStatus,
  "role": role,
  "agentId": agentId,
  "agentIds":agentId,
  "agentLiveStatus": agentLiveStatus,
  "callModePermission": callModePermission,
  "agentLoginType": agentLoginType,
    });
  }

     Future<void> updateAgentActivityTime({
    required int smeId,
    required int agentId,
    required String status,
        required int time,

  }) async {

    final now = DateTime.now();

final currentDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";


    await _dioClient.post(ApiEndpoints.updateAgentActivityTime(smeId), data: {
      "agent_id": agentId,
      "status": status,
      "time": time,
      "currentDate":currentDate,
    });
  }
  
Future<void> setIsAlive({
  required String username,
  required String mode,     
  String? role,           
  int? isWebrtcUser,        
}) async {

  final Map<String, dynamic> body = {
    "username": username,
    "mode": mode,
  };

  if (mode == "interval") {
    body["role"] = role;
    body["isWebrtcUser"] = isWebrtcUser ?? 0;
  }

  await _dioClient.post(
    ApiEndpoints.setIsAlive(username),
    data: body,
  );
}
Future<void> updateIsWrapUpTimeOver({
  required int smeId,
  required int agentId,
  required String sessionId,
  required int wrapupTime,
}) async {
  await _dioClient.post(
    ApiEndpoints.updateIsWrapUpTimeOver(smeId),
    data: {
      "agent_id": agentId,
      "session_id": sessionId,
      "wrapup_time": wrapupTime,
      "is_wrapup_time_over": 1,
    },
  );
}



}

