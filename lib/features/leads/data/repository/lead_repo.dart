import 'package:flutter/cupertino.dart';
import 'package:kommuno/core/network_manager/common_response_model.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/local_storage/hive_service.dart';
import 'package:kommuno/features/leads/data/enum/lead_filter_enum.dart';
import 'package:kommuno/features/leads/data/model/request/add_customer_note_request.dart';
import 'package:kommuno/features/leads/data/model/request/add_lead_request_model.dart';
import 'package:kommuno/features/leads/data/model/request/edit_lead_request_data.dart';
import 'package:kommuno/features/leads/data/model/request/leads_filter_request_model.dart';

final class LeadRepo {
  final _dioClient = DioClient(mountPoint: ApiEndpoints.authMountPoint);

  Future<CommonResponseModel> getLeadsUniqueCalls({
    List<LeadsFilterRequestModel>? leadsFilterRequestModel,
    required int smeId,
    required int batchSize,
    required int initialRecord,
  }) async {
    try {
      try {
        HiveService.putData(
            hiveKeysEnum: HiveKeysEnum.leadsFilterData,
            value: leadsFilterRequestModel);
      } catch (e, s) {
        debugPrint("HiveService leadsFilterData $e");
        debugPrint("$s");
      }

      final res = await _dioClient.post(
        ApiEndpoints.getUniqueCalls(smeId),
        data: {
          if (leadsFilterRequestModel != null)
            "filterList": leadsFilterRequestModel.map((e) {
              if ([LeadFilterEnum.startDate, LeadFilterEnum.endDate]
                  .contains(e.leadFilterEnum)) {
                return e
                    .copyWith(
                        val: DateUtility.getDateYMDOnly(
                      date: DateTime.parse(e.val).toUtc(),
                    ))
                    .toJson();
              } else {
                return e.toJson();
              }
            }).toList(),
          "batchSize": batchSize,
          "initialRecord": initialRecord,
        },
      );
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> addManualLead({
    required AddMannualLeadRequestModel addLeadRequestModel,
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(ApiEndpoints.addManualLead(smeId),
          data: addLeadRequestModel.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> addCustomerNote({
    required AddCustomerNoteRequest addCustomerNoteRequest,
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(ApiEndpoints.addCustomerNote(smeId),
          data: addCustomerNoteRequest.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> getSourceCityProductStatus(
      {required int smeId}) async {
    try {
      final res =
          await _dioClient.post(ApiEndpoints.getSourceCityProductStatus(smeId));
      return res.copyWith(data: {
        "leadStatus": [
          {
            "id": 457,
            "leadStatus": "Hot",
            "description": "",
            "insert_date_time": "2023-01-04 00:00:00",
            "created_by": 10001060
          },
          {
            "id": 458,
            "leadStatus": "Warm",
            "description": "",
            "insert_date_time": "2023-01-04 00:00:00",
            "created_by": 10001060
          },
          {
            "id": 459,
            "leadStatus": "Cold",
            "description": "",
            "insert_date_time": "2023-01-04 00:00:00",
            "created_by": 10001060
          },
          {
            "id": 460,
            "leadStatus": "Closed-Won",
            "description": "",
            "insert_date_time": "2023-01-04 00:00:00",
            "created_by": 10001060
          },
          {
            "id": 461,
            "leadStatus": "Closed-Lost",
            "description": "",
            "insert_date_time": "2023-01-04 00:00:00",
            "created_by": 10001060
          },
          {
            "id": 462,
            "leadStatus": "Invalid",
            "description": "",
            "insert_date_time": "2023-01-04 00:00:00",
            "created_by": 10001060
          },
          {
            "id": 463,
            "leadStatus": "Important",
            "description": "",
            "insert_date_time": "2023-01-04 00:00:00",
            "created_by": 10001060
          },
          {
            "id": 464,
            "leadStatus": "Negotiation",
            "description": "",
            "insert_date_time": "2023-01-04 00:00:00",
            "created_by": 10001060
          },
          {
            "id": 505,
            "leadStatus": "Dynamic Status",
            "description": "Dynamic Description",
            "insert_date_time": "2023-01-12 10:50:05",
            "created_by": 10001060
          },
          {
            "id": 558,
            "leadStatus": "Not Applicable",
            "description": "",
            "insert_date_time": "2023-01-20 11:28:42",
            "created_by": 10001060
          }
        ],
        "leadSource": [
          {
            "id": 128,
            "source": "Direct Marketing",
            "description": "Lead from Direct Marketing",
            "insert_date_time": "2022-10-06 15:04:09",
            "created_by": 10001060
          },
          {
            "id": 129,
            "source": "Outbound Call",
            "description": "Lead from Outbound Call",
            "insert_date_time": "2022-10-06 15:04:09",
            "created_by": 10001060
          },
          {
            "id": 130,
            "source": "Raferral",
            "description": "Lead from Raferral",
            "insert_date_time": "2022-10-06 15:04:09",
            "created_by": 10001060
          },
          {
            "id": 131,
            "source": "Social Media",
            "description": "Lead from Social Media",
            "insert_date_time": "2022-10-06 15:04:09",
            "created_by": 10001060
          },
          {
            "id": 132,
            "source": "Imported",
            "description": "Lead from CSV",
            "insert_date_time": "2022-10-06 16:23:06",
            "created_by": 10001060
          },
          {
            "id": 133,
            "source": "Incoming Call",
            "description": "Lead from Incoming Call",
            "insert_date_time": "2022-10-06 16:58:30",
            "created_by": 10001060
          },
          {
            "id": 499,
            "source": "Campaign",
            "description": "From Campaign",
            "insert_date_time": "2023-01-20 11:02:31",
            "created_by": 10001060
          }
        ],
        "cities": [
          {
            "city_id": 14,
            "sme_id": "10001060",
            "city_name": "Chandigarh",
            "status": 0,
            "date_time": "2022-08-16T06:29:11.000Z"
          },
          {
            "city_id": 2,
            "sme_id": "10001060",
            "city_name": "Delhi",
            "status": 0,
            "date_time": "2022-08-16T06:29:11.000Z"
          },
          {
            "city_id": 123,
            "sme_id": "10001060",
            "city_name": "Hoshiarpur",
            "status": 0,
            "date_time": "2022-08-16T06:29:11.000Z"
          },
          {
            "city_id": 13,
            "sme_id": "10001060",
            "city_name": "Mohali",
            "status": 0,
            "date_time": "2022-08-16T06:29:11.000Z"
          },
          {
            "city_id": 26,
            "sme_id": "10001060",
            "city_name": "Agra",
            "status": 0,
            "date_time": "2022-08-25T06:33:54.000Z"
          },
          {
            "city_id": 131,
            "sme_id": "10001060",
            "city_name": "Abohar",
            "status": 0,
            "date_time": "2022-08-26T05:26:39.000Z"
          }
        ],
        "products": [
          {
            "id": 21,
            "sme_id": "10001060",
            "product_name": "IVR-A",
            "status": 0,
            "date_time": "2022-08-16T06:28:18.000Z"
          },
          {
            "id": 22,
            "sme_id": "10001060",
            "product_name": "IVR-ABC",
            "status": 0,
            "date_time": "2022-08-16T06:28:18.000Z"
          },
          {
            "id": 83,
            "sme_id": "10001060",
            "product_name": "IVR-C",
            "status": 0,
            "date_time": "2022-09-09T07:27:22.000Z"
          },
          {
            "id": 105,
            "sme_id": "10001060",
            "product_name": "Herbs type 1",
            "status": 0,
            "date_time": "2022-09-23T06:45:23.000Z"
          },
          {
            "id": 111,
            "sme_id": "10001060",
            "product_name": "Test 1",
            "status": 0,
            "date_time": "2022-10-10T11:27:26.000Z"
          }
        ]
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> updateUniqueCalls({
    required EditLeadRequestData editLeadRequestData,
    required int smeId,
  }) async {
    try {
      final res = await _dioClient.post(ApiEndpoints.updateUniqueCalls(smeId),
          data: editLeadRequestData.toJson());
      return res;
    } catch (e) {
      rethrow;
    }
  }
}
