import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';

// final class FollowUpRepo {
//   final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

//   Future<CommonResponseModel> followUpDetails({
//     required int initialRecord,
//     required int batchSize,
//     required int smeId,
//   }) async {
//     try {
//       final res = await _dioClient.post(
//           ApiEndpoints.getFollowUpCall(
//               UserLoginInfoManager.userLoginInfoModel!.userId),
//           data: {
//             "initialRecord": initialRecord,
//             "batchSize": batchSize,
//             "sme_id": smeId
//           });
//       return res;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   Future<CommonResponseModel> changeScheduleStatus({
//     required String scheduleId,
//     required int status,
//     required int smeId,
//   }) async {
//     try {
//       final res = await _dioClient
//           .post(ApiEndpoints.changeScheduleStatus(smeId), data: {
//         "scheduleId": scheduleId,
//         "status": status,
//         "sme_Id": smeId,
//       });
//       return res;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }


final class FollowUpRepo {
  final _dioClient = DioClient();

  Future<CommonResponseModel> getPastScheduledCalls({
    required int smeId,
    required int agentId,
    required int initialRecord,
    required int batchSize,
    required DateTime pastDate,
  }) async {
    try {
      final body = {
        "initialRecord": initialRecord,
        "batchSize": batchSize,
        "agentId": agentId,
        "idsArray": null,
        "filterList": [
          {
            "name": "insertDateTime",
            "val": pastDate.toString().split(" ").first + " 00:00:00",
            "op": 33
          }
        ]
      };

      final res = await _dioClient.post(
        ApiEndpoints.getPastScheduledCalls(smeId),
        data: body,
      );

      return res;

    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> getTodayScheduledCalls({
    required int smeId,
    required int agentId,
    required int initialRecord,
    required int batchSize,
    required DateTime todayDate,
  }) async {
    try {
      final body = {
        "initialRecord": initialRecord,
        "batchSize": batchSize,
        "agentId": agentId,
        "idsArray": null,
        "filterList": [
          {
            "name": "insertDateTime",
            "val": todayDate.toString().split(" ").first,
            "op": 33
          }
        ]
      };


      final res = await _dioClient.post(
        ApiEndpoints.getTodayScheduledCalls(smeId),
        data: body,
      );

      return res;

    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> getUpcomingScheduledCalls({
    required int smeId,
    required int agentId,
    required int initialRecord,
    required int batchSize,
    required DateTime upcomingDate,
  }) async {
    try {
      final body = {
        "initialRecord": initialRecord,
        "batchSize": batchSize,
        "agentId": agentId,
        "idsArray": null,
        "filterList": [
          {
            "name": "insertDateTime",
            "val": upcomingDate.toString().split(" ").first + " 00:00:00",
            "op": 33
          }
        ]
      };

      final res = await _dioClient.post(
        ApiEndpoints.getUpcomingScheduledCalls(smeId),
        data: body,
      );

      return res;

    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> changeScheduleStatus({
    required int smeId,
    required String scheduleId,
    required int status,
  }) async {
    try {
      final body = {
        "scheduleId": scheduleId,
        "status": status,
      };

  
      final res = await _dioClient.post(
        ApiEndpoints.changeScheduleStatus(smeId),
        data: body,
      );

      return res;

    } catch (e) {
      rethrow;
    }
  }

Future<CommonResponseModel> deleteFollowUp({
    required int smeId,
    required String followUpId,
  }) async {
    try {
      final res = await _dioClient.delete(
        ApiEndpoints.deleteFollowUp(smeId, followUpId),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }


}
