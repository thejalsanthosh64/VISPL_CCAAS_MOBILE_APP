import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class EditLeadRequestData extends Equatable {
  const EditLeadRequestData({
    this.addressBookId,
    this.agentNumber,
    this.cityId,
    required this.id,
    this.leadAssignedAgent,
    this.recentPatchedAgentId,
    this.leadSource,
    this.leadStatus,
    this.productId,
    this.sourceId,
    this.customerName,
    this.companyName,
    this.emailId,
    this.customerNumber,
    this.customerNumberPrimary,
    required this.insertDateTime,
    this.leadType,
    this.productPrice,
  });

  final int? addressBookId;
  final String? agentNumber;
  final int? cityId;
  final int id;
  final int? leadAssignedAgent;
  final int? recentPatchedAgentId;
  final int? leadSource;
  final int? leadStatus;
  final int? productId;
  final int? sourceId;
  final String? customerName;
  final String? companyName;
  final String? emailId;
  final String? customerNumber;
  final String? customerNumberPrimary;
  final DateTime insertDateTime;
  final String? leadType;
  final String? productPrice;

  EditLeadRequestData copyWith({
    int? addressBookId,
    String? agentNumber,
    int? cityId,
    int? id,
    int? leadAssignedAgent,
    int? recentPatchedAgentId,
    int? leadSource,
    int? leadStatus,
    int? productId,
    int? sourceId,
    String? customerName,
    String? companyName,
    String? emailId,
    String? customerNumber,
    String? customerNumberPrimary,
    DateTime? insertDateTime,
    String? leadType,
    String? productPrice,
  }) {
    return EditLeadRequestData(
      addressBookId: addressBookId ?? this.addressBookId,
      agentNumber: agentNumber ?? this.agentNumber,
      cityId: cityId ?? this.cityId,
      id: id ?? this.id,
      leadAssignedAgent: leadAssignedAgent ?? this.leadAssignedAgent,
      recentPatchedAgentId: recentPatchedAgentId ?? this.recentPatchedAgentId,
      leadSource: leadSource ?? this.leadSource,
      leadStatus: leadStatus ?? this.leadStatus,
      productId: productId ?? this.productId,
      sourceId: sourceId ?? this.sourceId,
      customerName: customerName ?? this.customerName,
      companyName: companyName ?? this.companyName,
      emailId: emailId ?? this.emailId,
      customerNumber: customerNumber ?? this.customerNumber,
      customerNumberPrimary:
          customerNumberPrimary ?? this.customerNumberPrimary,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      leadType: leadType ?? this.leadType,
      productPrice: productPrice ?? this.productPrice,
    );
  }

  factory EditLeadRequestData.fromJson(Map<String, dynamic> json) {
    return EditLeadRequestData(
      addressBookId: json["addressBookId"],
      agentNumber: json["agentNumber"],
      cityId: json["cityId"],
      id: json["id"],
      leadAssignedAgent: json["leadAssignedAgent"],
      recentPatchedAgentId: json["recentPatchedAgentId"],
      leadSource: json["leadSource"],
      leadStatus: json["leadStatus"],
      productId: json["productId"],
      sourceId: json["sourceId"],
      customerName: json["customer_name"],
      companyName: json["company_name"],
      emailId: json["email_id"],
      customerNumber: json["customerNumber"],
      customerNumberPrimary: json["customer_number_primary"],
      insertDateTime: DateTime.parse(json["insertDateTime"] ?? "").toLocal(),
      leadType: json["leadType"],
      productPrice: json["productPrice"],
    );
  }

  Map<String, dynamic> toJson() => {
        "addressBookId": addressBookId,
        "agentNumber": agentNumber,
        "cityId": cityId,
        "id": id,
        "leadAssignedAgent": leadAssignedAgent,
        "recentPatchedAgentId": recentPatchedAgentId,
        "leadSource": leadSource,
        "leadStatus": leadStatus,
        "productId": productId,
        "sourceId": sourceId,
        "customer_name": customerName,
        "company_name": companyName,
        "email_id": emailId,
        "customerNumber": customerNumber,
        "customer_number_primary": customerNumberPrimary,
        "insertDateTime":
            DateUtility.sendRequestDateTimeFormat(date: insertDateTime.toUtc()),
        "leadType": leadType,
        "productPrice": productPrice,
      };

  @override
  String toString() {
    return "$addressBookId, $agentNumber, $cityId, $id, $leadAssignedAgent, $recentPatchedAgentId, $leadSource, $leadStatus, $productId, $sourceId, $customerName, $companyName, $emailId, $customerNumber, $customerNumberPrimary, $insertDateTime, $leadType, $productPrice, ";
  }

  @override
  List<Object?> get props => [
        addressBookId,
        agentNumber,
        cityId,
        id,
        leadAssignedAgent,
        recentPatchedAgentId,
        leadSource,
        leadStatus,
        productId,
        sourceId,
        customerName,
        companyName,
        emailId,
        customerNumber,
        customerNumberPrimary,
        insertDateTime,
        leadType,
        productPrice,
      ];
}
