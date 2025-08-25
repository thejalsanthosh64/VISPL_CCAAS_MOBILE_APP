import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/features/contact/data/model/add_update_contact_address_model.dart';
import 'package:kommuno/features/contact/data/model/contact_list_request_model.dart';


final class ContactRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> getAllContacts(
      {required GetContactsRequestModel getContactsRequestModel}) async {
    try {
      final res = await _dioClient.post(
          ApiEndpoints.getAllContacts(UserLoginInfoManager.userLoginInfoModel!.userId),
          data: getContactsRequestModel.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> addContact({
    required AddUpdateContactsRequestModel addUpdateContactsRequest,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.addContacts(UserLoginInfoManager.userLoginInfoModel!.userId),
        data: addUpdateContactsRequest.toJson(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> updateContact({
    required AddUpdateContactsRequestModel addUpdateContactsRequest,
  }) async {
    try {
      final res = await _dioClient.post(
        ApiEndpoints.updateContacts(UserLoginInfoManager.userLoginInfoModel!.userId),
        data: addUpdateContactsRequest.toJson(),
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
