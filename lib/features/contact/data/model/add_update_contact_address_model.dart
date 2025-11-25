import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class AddUpdateContactsRequestModel extends Equatable {
  const AddUpdateContactsRequestModel({
    required this.customerNumber,
    required this.customerName,
    this.customerNumberSecondary = defaultCustomerNumberSecondary,
    this.addressBookId = defaultAddressBookId,
    required this.agentNumber,
    required this.companyName,
    required this.createdBy,
    required this.emailId,
    this.mode = defaultMode,
    required this.insertDateTime,
    required this.updatedDateTime,
    this.visibilityFlag = defaultVisibilityFlag,
    required this.smeId,
  });

  final String customerNumber;
  final String customerName;
  final List<String> customerNumberSecondary;
  final int addressBookId;
  final String agentNumber;
  final String companyName;
  final int createdBy;
  final String emailId;
  final String mode;
  final DateTime insertDateTime;
  final DateTime? updatedDateTime;
  final String visibilityFlag;
  final String smeId;

  static const int defaultAddressBookId = 0;
  static const String defaultMode = "0";
  static const String defaultVisibilityFlag = "1";
  static const List<String> defaultCustomerNumberSecondary = [];

  AddUpdateContactsRequestModel copyWith({
    String? customerNumber,
    String? customerName,
    List<String>? customerNumberSecondary,
    int? addressBookId,
    String? agentNumber,
    String? companyName,
    int? createdBy,
    String? emailId,
    String? mode,
    DateTime? insertDateTime,
    DateTime? updatedDateTime,
    String? visibilityFlag,
    String? smeId,
  }) {
    return AddUpdateContactsRequestModel(
      customerNumber: customerNumber ?? this.customerNumber,
      customerName: customerName ?? this.customerName,
      customerNumberSecondary:
          customerNumberSecondary ?? this.customerNumberSecondary,
      addressBookId: addressBookId ?? this.addressBookId,
      agentNumber: agentNumber ?? this.agentNumber,
      companyName: companyName ?? this.companyName,
      createdBy: createdBy ?? this.createdBy,
      emailId: emailId ?? this.emailId,
      mode: mode ?? this.mode,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      updatedDateTime: updatedDateTime ?? this.updatedDateTime,
      visibilityFlag: visibilityFlag ?? this.visibilityFlag,
      smeId: smeId ?? this.smeId,
    );
  }

factory AddUpdateContactsRequestModel.fromJson(Map<String, dynamic> json) {
  return AddUpdateContactsRequestModel(
    customerNumber: json["customer_number_primary"] ?? "",
    customerName: json["customer_name"] ?? "",
    customerNumberSecondary: json["customer_number_secondary"] == null
        ? []
        : [json["customer_number_secondary"].toString()],
    addressBookId: 0, // backend does not return this
    agentNumber: json["agent_number"]?.toString() ?? "",
    companyName: json["company_name"] ?? "",
    createdBy: json["created_by"] ?? 0,
    emailId: json["email_id"] ?? "",
    mode: json["mode"]?.toString() ?? "0",
    insertDateTime: json["insert_date_time"] != null
        ? DateTime.parse(json["insert_date_time"])
        : DateTime.now(),
    updatedDateTime: json["updated_date_time"] != null
        ? DateTime.tryParse(json["updated_date_time"])
        : null,
    visibilityFlag: json["visibility_flag"]?.toString() ?? "1",
    smeId: json["sme_id"]?.toString() ?? "",
  );
}


 Map<String, dynamic> toJson() {
  return {
    "sme_id": int.tryParse(smeId) ?? 0,
    "customer_name": customerName,
    "customer_number_primary":
        addByIndiaCountryCode(number: customerNumber).replaceAll("+", ""),
    "customer_number_secondary":
        customerNumberSecondary.isNotEmpty ? customerNumberSecondary.first : null,
    "company_name": companyName,
    "email_id": emailId,
    "created_by": createdBy,
    "mode": int.tryParse(mode) ?? 0,
    "visibility_flag": int.tryParse(visibilityFlag) ?? 1,
    "insert_date_time": DateUtility.sendRequestDateTimeFormat(
        date: insertDateTime.toUtc()),
    "updated_date_time": updatedDateTime != null
        ? DateUtility.sendRequestDateTimeFormat(
            date: updatedDateTime!.toUtc())
        : null,
  };
}


  @override
  String toString() {
    return "$customerNumber, $customerName, $customerNumberSecondary, $addressBookId, $agentNumber, $companyName, $createdBy, $emailId, $mode, $insertDateTime, $updatedDateTime, $visibilityFlag, $smeId";
  }

  @override
  List<Object?> get props => [
        customerNumber,
        customerName,
        customerNumberSecondary,
        addressBookId,
        agentNumber,
        companyName,
        createdBy,
        emailId,
        mode,
        insertDateTime,
        updatedDateTime,
        visibilityFlag,
        smeId,
      ];
}
