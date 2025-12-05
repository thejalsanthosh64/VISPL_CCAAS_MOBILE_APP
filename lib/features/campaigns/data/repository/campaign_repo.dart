import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/features/campaigns/data/model/request/update_user_campaign_data.dart';

final class CampaignRepo {
  final _dioClient = DioClient();

  Future<CommonResponseModel> getCampaigns({required int smeId}) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.getLoginCampaigns(smeId),
data: {
  "agent_id": UserLoginInfoManager.userLoginInfoModel!.userId,
  "roles": UserLoginInfoManager.userLoginInfoModel!.role
},
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> updateUserCampaign({required UpdateUserCampaignData updateUserCampaign}) async {
    try {
      
      final res = await _dioClient.post(
        ApiEndpoints.updateAgentCurrentCampaign(UserLoginInfoManager.userLoginInfoModel!.userId),
        data: updateUserCampaign.toJson(),
      );
      
      return res;
    } catch (e) {
      rethrow;
    }
  }



  Future<CommonResponseModel> updateWebrtcAgentStatus({
  required int smeId,
  required int agentId,
}) async {
  final body = {
    "status": 0,
    "agentId": agentId,
    "insertDateTime": DateTime.now().toString().split(".").first,
    "readyToTakeCallStatus": 1,
    "agentLiveStatus": "Waiting",
    "liveStatusActivityMode": "LoginMode"
  };

  final res = await _dioClient.post(
    ApiEndpoints.updateWebrtcAgentStatus(smeId),
    data: body,
  );
  return res;
}
Future<CommonResponseModel> setIsAlive({
  required String username,
  required String role,
}) async {
  final body = {
    "username": username,
    "mode": "login",
    "role": role,            
    "isWebrtcUser": 0,
  };

  final res = await _dioClient.post(
    ApiEndpoints.setIsAlive(username),
    data: body,
  );
  return res;
}

}
