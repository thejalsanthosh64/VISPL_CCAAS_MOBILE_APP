import 'package:equatable/equatable.dart';

class LeadsUniqueCallsModel extends Equatable {
  const LeadsUniqueCallsModel({
    required this.id,
    required this.smeId,
    required this.updateDateTime,
    required this.insertDateTime,
    required this.recentDuration,
    required this.recentViaLongcode,
    required this.callType,
    required this.leadsUniqueCallsModelCustomerNumber,
    required this.customerNumber,
    required this.whattsappNumber,
    required this.serverIpAddress,
    required this.recentPatchedAgentId,
    this.agentName,
    this.agentMobile,
    this.agentId,
    required this.answer,
    this.addressBookId,
    this.customerName,
    this.companyName,
    required this.recentRemarks,
    required this.totalIncomingCalls,
    required this.totalOutgoingCalls,
    required this.leadType,
    required this.cityId,
    this.cityName,
    required this.productId,
    this.productName,
    required this.productPrice,
    required this.assignedTo,
    required this.stickyType,
    this.leadAssignedAgentName,
    this.leadAssignedAgentNumber,
    required this.assignedAgentId,
    required this.blacklistStatus,
    this.leadSource,
    required this.sourceId,
    required this.leadStatus,
    this.remarks,
    this.leadStatusName,
    this.emailId,
  });

  final int id;
  final int smeId;
  final DateTime updateDateTime;
  final DateTime insertDateTime;
  final int recentDuration;
  final int recentViaLongcode;
  final String callType;
  final String leadsUniqueCallsModelCustomerNumber;
  final String customerNumber;
  final String whattsappNumber;
  final String serverIpAddress;
  final int recentPatchedAgentId;
  final String? agentName;
  final String? agentMobile;
  final int? agentId;
  final int answer;
  final int? addressBookId;
  final String? customerName;
  final String? companyName;
  final int recentRemarks;
  final int totalIncomingCalls;
  final int totalOutgoingCalls;
  final String leadType;
  final int cityId;
  final String? cityName;
  final int productId;
  final String? productName;
  final int productPrice;
  final dynamic assignedTo;
  final int stickyType;
  final String? leadAssignedAgentName;
  final String? leadAssignedAgentNumber;
  final int assignedAgentId;
  final dynamic blacklistStatus;
  final String? leadSource;
  final int sourceId;
  final int leadStatus;
  final String? remarks;
  final String? leadStatusName;
  final String? emailId;

  LeadsUniqueCallsModel copyWith({
    int? id,
    int? smeId,
    DateTime? updateDateTime,
    DateTime? insertDateTime,
    int? recentDuration,
    int? recentViaLongcode,
    String? callType,
    String? leadsUniqueCallsModelCustomerNumber,
    String? customerNumber,
    String? whattsappNumber,
    String? serverIpAddress,
    int? recentPatchedAgentId,
    String? agentName,
    String? agentMobile,
    int? agentId,
    int? answer,
    int? addressBookId,
    String? customerName,
    String? companyName,
    int? recentRemarks,
    int? totalIncomingCalls,
    int? totalOutgoingCalls,
    String? leadType,
    int? cityId,
    String? cityName,
    int? productId,
    String? productName,
    int? productPrice,
    dynamic assignedTo,
    int? stickyType,
    String? leadAssignedAgentName,
    String? leadAssignedAgentNumber,
    int? assignedAgentId,
    dynamic blacklistStatus,
    String? leadSource,
    int? sourceId,
    int? leadStatus,
    String? remarks,
    String? leadStatusName,
    String? emailId,
  }) {
    return LeadsUniqueCallsModel(
      id: id ?? this.id,
      smeId: smeId ?? this.smeId,
      updateDateTime: updateDateTime ?? this.updateDateTime,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      recentDuration: recentDuration ?? this.recentDuration,
      recentViaLongcode: recentViaLongcode ?? this.recentViaLongcode,
      callType: callType ?? this.callType,
      leadsUniqueCallsModelCustomerNumber:
          leadsUniqueCallsModelCustomerNumber ??
              this.leadsUniqueCallsModelCustomerNumber,
      customerNumber: customerNumber ?? this.customerNumber,
      whattsappNumber: whattsappNumber ?? this.whattsappNumber,
      serverIpAddress: serverIpAddress ?? this.serverIpAddress,
      recentPatchedAgentId: recentPatchedAgentId ?? this.recentPatchedAgentId,
      agentName: agentName ?? this.agentName,
      agentMobile: agentMobile ?? this.agentMobile,
      agentId: agentId ?? this.agentId,
      answer: answer ?? this.answer,
      addressBookId: addressBookId ?? this.addressBookId,
      customerName: customerName ?? this.customerName,
      companyName: companyName ?? this.companyName,
      recentRemarks: recentRemarks ?? this.recentRemarks,
      totalIncomingCalls: totalIncomingCalls ?? this.totalIncomingCalls,
      totalOutgoingCalls: totalOutgoingCalls ?? this.totalOutgoingCalls,
      leadType: leadType ?? this.leadType,
      cityId: cityId ?? this.cityId,
      cityName: cityName ?? this.cityName,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productPrice: productPrice ?? this.productPrice,
      assignedTo: assignedTo ?? this.assignedTo,
      stickyType: stickyType ?? this.stickyType,
      leadAssignedAgentName:
          leadAssignedAgentName ?? this.leadAssignedAgentName,
      leadAssignedAgentNumber:
          leadAssignedAgentNumber ?? this.leadAssignedAgentNumber,
      assignedAgentId: assignedAgentId ?? this.assignedAgentId,
      blacklistStatus: blacklistStatus ?? this.blacklistStatus,
      leadSource: leadSource ?? this.leadSource,
      sourceId: sourceId ?? this.sourceId,
      leadStatus: leadStatus ?? this.leadStatus,
      remarks: remarks ?? this.remarks,
      leadStatusName: leadStatusName ?? this.leadStatusName,
      emailId: emailId ?? this.emailId,
    );
  }

  factory LeadsUniqueCallsModel.fromJson(Map<String, dynamic> json) {
    return LeadsUniqueCallsModel(
      id: json["id"],
      smeId: json["sme_id"],
      updateDateTime:
          DateTime.parse(json["update_date_time"] ?? DateTime.now().toString())
              .toLocal(),
      insertDateTime:
          DateTime.parse(json["insert_date_time"] ?? DateTime.now().toString())
              .toLocal(),
      recentDuration: json["recent_duration"],
      recentViaLongcode: json["recent_via_longcode"],
      callType: json["call_type"],
      leadsUniqueCallsModelCustomerNumber: json["customer_number"],
      customerNumber: json["customerNumber"],
      whattsappNumber: json["whattsappNumber"],
      serverIpAddress: json["server_ip_address"],
      recentPatchedAgentId: json["recent_patched_agent_id"],
      agentName: json["agent_name"],
      agentMobile: json["agent_mobile"],
      agentId: json["agent_id"],
      answer: json["answer"],
      addressBookId: json["address_book_id"],
      customerName: json["customer_name"],
      companyName: json["company_name"],
      recentRemarks: json["recent_remarks"],
      totalIncomingCalls: json["total_incoming_calls"],
      totalOutgoingCalls: json["total_outgoing_calls"],
      leadType: json["lead_type"],
      cityId: json["city_id"],
      cityName: json["city_name"],
      productId: json["product_id"],
      productName: json["product_name"],
      productPrice: json["product_price"],
      assignedTo: json["assigned_to"],
      stickyType: json["sticky_type"],
      leadAssignedAgentName: json["lead_assigned_agent_name"],
      leadAssignedAgentNumber: json["lead_assigned_agent_number"],
      assignedAgentId: json["assigned_agent_id"],
      blacklistStatus: json["blacklist_status"],
      leadSource: json["lead_source"],
      sourceId: json["source_id"],
      leadStatus: json["lead_status"],
      remarks: json["remarks"],
      leadStatusName: json["lead_status_name"],
      emailId: json["email_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "sme_id": smeId,
        "update_date_time": updateDateTime.toUtc(),
        "insert_date_time": insertDateTime.toUtc(),
        "recent_duration": recentDuration,
        "recent_via_longcode": recentViaLongcode,
        "call_type": callType,
        "customer_number": leadsUniqueCallsModelCustomerNumber,
        "customerNumber": customerNumber,
        "whattsappNumber": whattsappNumber,
        "server_ip_address": serverIpAddress,
        "recent_patched_agent_id": recentPatchedAgentId,
        "agent_name": agentName,
        "agent_mobile": agentMobile,
        "agent_id": agentId,
        "answer": answer,
        "address_book_id": addressBookId,
        "customer_name": customerName,
        "company_name": companyName,
        "recent_remarks": recentRemarks,
        "total_incoming_calls": totalIncomingCalls,
        "total_outgoing_calls": totalOutgoingCalls,
        "lead_type": leadType,
        "city_id": cityId,
        "city_name": cityName,
        "product_id": productId,
        "product_name": productName,
        "product_price": productPrice,
        "assigned_to": assignedTo,
        "sticky_type": stickyType,
        "lead_assigned_agent_name": leadAssignedAgentName,
        "lead_assigned_agent_number": leadAssignedAgentNumber,
        "assigned_agent_id": assignedAgentId,
        "blacklist_status": blacklistStatus,
        "lead_source": leadSource,
        "source_id": sourceId,
        "lead_status": leadStatus,
        "remarks": remarks,
        "lead_status_name": leadStatusName,
        "email_id": emailId,
      };

  @override
  String toString() {
    return "$id, $smeId, $updateDateTime, $insertDateTime, $recentDuration, $recentViaLongcode, $callType, $leadsUniqueCallsModelCustomerNumber, $customerNumber, $whattsappNumber, $serverIpAddress, $recentPatchedAgentId, $agentName, $agentMobile, $agentId, $answer, $addressBookId, $customerName, $companyName, $recentRemarks, $totalIncomingCalls, $totalOutgoingCalls, $leadType, $cityId, $cityName, $productId, $productName, $productPrice, $assignedTo, $stickyType, $leadAssignedAgentName, $leadAssignedAgentNumber, $assignedAgentId, $blacklistStatus, $leadSource, $sourceId, $leadStatus, $remarks, $leadStatusName, $emailId, ";
  }

  @override
  List<Object?> get props => [
        id,
        smeId,
        updateDateTime,
        insertDateTime,
        recentDuration,
        recentViaLongcode,
        callType,
        leadsUniqueCallsModelCustomerNumber,
        customerNumber,
        whattsappNumber,
        serverIpAddress,
        recentPatchedAgentId,
        agentName,
        agentMobile,
        agentId,
        answer,
        addressBookId,
        customerName,
        companyName,
        recentRemarks,
        totalIncomingCalls,
        totalOutgoingCalls,
        leadType,
        cityId,
        cityName,
        productId,
        productName,
        productPrice,
        assignedTo,
        stickyType,
        leadAssignedAgentName,
        leadAssignedAgentNumber,
        assignedAgentId,
        blacklistStatus,
        leadSource,
        sourceId,
        leadStatus,
        remarks,
        leadStatusName,
        emailId,
      ];
}
