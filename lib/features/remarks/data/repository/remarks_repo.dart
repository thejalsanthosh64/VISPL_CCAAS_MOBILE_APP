import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';

final class RemarksRepo {
  final _dioClient = DioClient();

  // Future<CommonResponseModel> getRemarksList(
  //     {required RemarksRequestModel remarksRequestModel,required int smeId}) async {
  //   try {
  //     final res = await _dioClient.post(
  //         ApiEndpoints.getListRemarks(
  //             smeId),
  //         data: remarksRequestModel.toJson());
  //     return res;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // Future<CommonResponseModel> setRemarks(
  //     {required SendRemarksRequestModel sendRemarksRequestModel,required int smeId}) async {
  //   try {
  //     final res = await _dioClient.post(
  //         ApiEndpoints.setRemarks(
  //            smeId),
  //         data: sendRemarksRequestModel.toJson());
  //     return res;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<CommonResponseModel> getListRemarks({
    required Map<String, dynamic> payload,
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.getListRemarks(smeId),
        data: payload,
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> setRemarks({
    required Map<String, dynamic> payload,
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.setRemarks(smeId),
        data: payload,
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> updateRemark({
    required Map<String, dynamic> payload,
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.updateRemark(smeId), 
        data: payload,
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
