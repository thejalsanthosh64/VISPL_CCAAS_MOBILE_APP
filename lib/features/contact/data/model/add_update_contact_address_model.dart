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
      customerNumber: json["customerNumber"],
      customerName: json["customerName"],
      customerNumberSecondary: json["customerNumberSecondary"] == null
          ? []
          : List<String>.from(json["customerNumberSecondary"]!.map((x) => x)),
      addressBookId: json["addressBookId"],
      agentNumber: json["agentNumber"],
      companyName: json["companyName"],
      createdBy: json["createdBy"],
      emailId: json["emailId"],
      mode: json["mode"],
      insertDateTime: DateTime.parse(json["insertDateTime"] ?? "").toLocal(),
      updatedDateTime: DateTime.parse(json["updatedDateTime"] ?? "").toLocal(),
      visibilityFlag: json["visibilityFlag"],
      smeId: json["smeId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "customerNumber": addByIndiaCountryCode(number: customerNumber),
        "customerName": customerName,
        "customerNumberSecondary":
            customerNumberSecondary.map((x) => x).toList(),
        "addressBookId": addressBookId,
        "agentNumber": agentNumber,
        "companyName": companyName,
        "createdBy": createdBy,
        "emailId": emailId,
        "mode": mode,
        "insertDateTime":
            DateUtility.sendRequestDateTimeFormat(date: insertDateTime.toUtc()),
        if (updatedDateTime != null)
          "updatedDateTime": DateUtility.sendRequestDateTimeFormat(
              date: updatedDateTime!.toUtc()),
        "visibilityFlag": visibilityFlag,
        "smeId": smeId,
      };

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
