import 'package:flutter/material.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';

class InSightsRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> getInsight({
    required DateTime startDate,
    required DateTime endDate,
    required int smeId,
  }) async {
    try {
      final startDateStr = DateUtility.getDateYMDOnly(date: DateUtils.dateOnly(startDate.toUtc()));
      final endDateStr = DateUtility.getDateYMDOnly(date: DateUtils.dateOnly(endDate.toUtc()));
      final res = await _dioClient.post(
        ApiEndpoints.getInsight(smeId),
        data: {
          "agentId": UserLoginInfoManager.userLoginInfoModel!.userId,
          "startDate": startDateStr,
          "endDate": endDateStr,
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
