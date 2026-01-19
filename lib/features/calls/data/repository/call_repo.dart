import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/calls/data/model/attendeed_transfer_request_model.dart';
import 'package:kommuno/features/calls/data/model/tranfer_request_model.dart';

final class CallsRepo {
  final _dioClient = DioClient();

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

  Future<CommonResponseModel> makeNewCallV2({required Map<String, dynamic> newCallRequestData}) async {
    try {
      final res = await _dioClient.post(ApiEndpoints.clickToCallLiveCall, data: newCallRequestData);
      return res;
    } catch (e) {
      rethrow;
    }
  }


Future<CommonResponseModel> hold({
  required int smeId,
  required Map<String, dynamic> body,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.holdCall(smeId),
      data: body,
    );
    return res;
  } catch (e) {
    rethrow;
  }
}


Future<CommonResponseModel> unhold({
  required int smeId,
  required Map<String, dynamic> body,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.unHoldCall(smeId),
      data: body,
    );
    return res;
  } catch (e) {
    rethrow;
  }
}

Future<CommonResponseModel> mute({
  required int smeId,
  required Map<String, dynamic> body,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.muteCall(smeId),
      data: body,
    );
    return res;
  } catch (e) {
    rethrow;
  }
}


Future<CommonResponseModel> unmute({
  required int smeId,
  required  Map<String, dynamic> body,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.unMuteCall(smeId),
      data: body,
    );
    return res;
  } catch (e) {
    rethrow;
  }
}


Future<CommonResponseModel> drop({
  required int smeId,
  required Map<String, dynamic> body,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.dropCall(smeId),
      data: body,
    );
    return res;
  } catch (e) {
    rethrow;
  }
}


Future<CommonResponseModel> unattendedTransfer({
  required int smeId,
  required UnattendedTransferRequestModel body,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.transferCall(smeId),
      data: body.toJson(),
    );
    return res;
  } catch (e) {
    rethrow;
  }
}

Future<CommonResponseModel> attendedTransfer({
  required int smeId,
  required AttendedTransferRequestModel body,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.conferenceall(smeId),
      data: body.toJson(),
    );
    return res;
  } catch (e) {
    rethrow;
  }
}


Future<CommonResponseModel> getQueueAgents({
  required int smeId,
  required String queueId,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.getQueueAgent(smeId),
      data: {"queueId": queueId},
    );
    return res;
  } catch (e) {
    rethrow;
  }
}

Future<CommonResponseModel> getAgentStatus({
  required int smeId,
  required int agentId,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.getAgentStatusDetail(smeId),
      data: {"agent_id": agentId},
    );
    return res;
  } catch (e) {
    rethrow;
  }
}

  Future<CommonResponseModel> getAllAgents({
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.getAgentStatus(smeId),
        data: {"role": UserLoginInfoManager.userLoginInfoModel!.role},
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> getAllQueues({
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.getQueue(smeId),
        data: {"ignore": "Parallel Ringing"},
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> getTeamLeads({
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.getTeamLeads(smeId),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

Future<CommonResponseModel> saveRating({
  required int smeId,
  required Map<String, dynamic> body,
}) async {
  try {
    final res = await _dioClient.post(
       ApiEndpoints.saveRating(smeId),
      data: body,
    );
    return res;
  } catch (e) {
    rethrow;
  }
}

Future<CommonResponseModel> saveRatingCrm({
  required int smeId,
  required Map<String, dynamic> body,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.saveRatingInCrm(smeId),
      data: body,
    );
    return res;
  } catch (e) {
    rethrow;
  }
}



Future<CommonResponseModel> sendSurveyIVR({
  required int smeId,
  required String sessionId,
}) async {
  try {
    final res = await _dioClient.post(
      ApiEndpoints.surveyEndCall(smeId),   // create endpoint
      data: {
        "sessionId": sessionId,
      },
    );
    return res;
  } catch (e) {
    rethrow;
  }
}



}
