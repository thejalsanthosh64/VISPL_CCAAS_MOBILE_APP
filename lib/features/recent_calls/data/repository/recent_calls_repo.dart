import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/features/recent_calls/data/model/request/recent_calls_request_model.dart';

final class RecentCallsRepo {
  final _dioClient = DioClient();

  // Future<CommonResponseModel> getRecentCalls({
  //   List<RecentCallsRequestModel>? recentCallsRequestModel,
  //   required int smeId,
  //   required int batchSize,
  //   required int initialRecord,
  // }) async {
  //   try {

  //     final body = {
  //       if (recentCallsRequestModel != null)
  //         "filterList":
  //             recentCallsRequestModel.map((e) => e.toJson()).toList(),
  //       "batchSize": batchSize,
  //       "initialRecord": initialRecord,
  //       "smeId": smeId,
  //     };

  //     // 👇 PRINT BODY HERE
  //     print("📤 Recent Calls Request Body → $body");

  //     final res = await _dioClient.post(
  //       ApiEndpoints.getRecentCalls(
  //           UserLoginInfoManager.userLoginInfoModel!.userId),
  //       data: {
  //         if (recentCallsRequestModel != null)
  //           "filterList":
  //               recentCallsRequestModel.map((e) => e.toJson()).toList(),
  //         "batchSize": batchSize,
  //         "initialRecord": initialRecord,
  //         "smeId": smeId,
  //       },
  //     );
  //     return res;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<CommonResponseModel> getRecentCalls({
  required RecentCallsRequestModel requestModel,
  required int smeId,
}) async {
  try {

    
    final body = requestModel.toJson();

    print("📤 Recent Calls Request Body → $body");

    final res = await _dioClient.post(
      ApiEndpoints.getRecentCalls(
          smeId),
      data: body,
    );
    return res;
  } catch (e) {
    rethrow;
  }
}

Future<CommonResponseModel> getSmsTemplates(int smeId) {
  return _dioClient.post(ApiEndpoints.getSmsTemplate(smeId));
}

Future<CommonResponseModel> getWhatsappTemplates(int smeId) {
  return _dioClient.post(ApiEndpoints.getWhatsappTemplate(smeId));
}

Future<CommonResponseModel> sendSms({
    required int smeId,
    required Map<String, dynamic> body,
  }) {
    return _dioClient.post(
      ApiEndpoints.sendEndCallSms(smeId),
      data: body,
    );
  }

  Future<CommonResponseModel> sendWhatsapp({
    required int smeId,
    required Map<String, dynamic> body,
  }) {
    return _dioClient.post(
      ApiEndpoints.sendWhatsapp(smeId),
      data: body,
    );
  }

}
