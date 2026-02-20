import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';

final class DialRepo {
  final _dioClient = DioClient();

  Future<CommonResponseModel> setDialerStatus({
    required int agentId,
    required bool isOn,
    required int smeId
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.setDialerStatus(smeId),
        data: {
          "agent_id": agentId,
          "auto_dialer_calls_status": isOn ? 1 : 0,
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
