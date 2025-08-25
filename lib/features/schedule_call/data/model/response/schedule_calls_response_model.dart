import 'package:equatable/equatable.dart';

class ScheduleCallsResponseModel extends Equatable {
  const ScheduleCallsResponseModel({
    required this.pastSchedule,
    required this.todaySchedule,
    required this.upcomingSchedule,
  });

  final List<ScheduleDetails> pastSchedule;
  final List<ScheduleDetails> todaySchedule;
  final List<ScheduleDetails> upcomingSchedule;

  ScheduleCallsResponseModel copyWith({
    List<ScheduleDetails>? pastSchedule,
    List<ScheduleDetails>? todaySchedule,
    List<ScheduleDetails>? upcomingSchedule,
  }) {
    return ScheduleCallsResponseModel(
      pastSchedule: pastSchedule ?? this.pastSchedule,
      todaySchedule: todaySchedule ?? this.todaySchedule,
      upcomingSchedule: upcomingSchedule ?? this.upcomingSchedule,
    );
  }

  factory ScheduleCallsResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleCallsResponseModel(
      pastSchedule: json["pastSchedule"] == null
          ? []
          : List<ScheduleDetails>.from(
              json["pastSchedule"]!.map((x) => ScheduleDetails.fromJson(x))),
      todaySchedule: json["todaySchedule"] == null
          ? []
          : List<ScheduleDetails>.from(
              json["todaySchedule"]!.map((x) => ScheduleDetails.fromJson(x))),
      upcomingSchedule: json["upcomingSchedule"] == null
          ? []
          : List<ScheduleDetails>.from(json["upcomingSchedule"]!
              .map((x) => ScheduleDetails.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "pastSchedule": pastSchedule.map((x) => x.toJson()).toList(),
        "todaySchedule": todaySchedule.map((x) => x.toJson()).toList(),
        "upcomingSchedule": upcomingSchedule.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$pastSchedule, $todaySchedule, $upcomingSchedule, ";
  }

  @override
  List<Object?> get props => [
        pastSchedule,
        todaySchedule,
        upcomingSchedule,
      ];
}

class ScheduleDetails extends Equatable {
  const ScheduleDetails({
    this.customerName,
    this.companyName,
    required this.agentName,
    required this.id,
    required this.scheduleCustomerNumber,
    required this.customerNumber,
    required this.scheduleDateTime,
    required this.smeId,
    required this.createdBy,
    required this.message,
    required this.status,
    this.recentDuration,
    this.recentViaLongcode,
    this.serverIpAddress,
    this.recentPatchedAgentId,
    this.totalIncomingCalls,
    this.totalOutgoingCalls,
    this.leadType,
    this.leadStatus,
    this.cityId,
    this.productId,
    this.productPrice,
    this.assignedAgentId,
    this.connectedCallDuration,
    this.stickyType,
    this.insertDateTime,
    this.updateDateTime,
    this.callType,
    this.answer,
  });

  final String? customerName;
  final String? companyName;
  final String agentName;
  final int id;
  final String scheduleCustomerNumber;
  final String customerNumber;
  final DateTime scheduleDateTime;
  final int smeId;
  final int createdBy;
  final String message;
  final int status;
  final int? recentDuration;
  final int? recentViaLongcode;
  final String? serverIpAddress;
  final int? recentPatchedAgentId;
  final int? totalIncomingCalls;
  final int? totalOutgoingCalls;
  final String? leadType;
  final int? leadStatus;
  final int? cityId;
  final int? productId;
  final int? productPrice;
  final int? assignedAgentId;
  final int? connectedCallDuration;
  final int? stickyType;
  final DateTime? insertDateTime;
  final DateTime? updateDateTime;
  final String? callType;
  final int? answer;

  ScheduleDetails copyWith({
    String? customerName,
    String? companyName,
    String? agentName,
    int? id,
    String? scheduleCustomerNumber,
    String? customerNumber,
    DateTime? scheduleDateTime,
    int? smeId,
    int? createdBy,
    String? message,
    int? status,
    int? recentDuration,
    int? recentViaLongcode,
    String? serverIpAddress,
    int? recentPatchedAgentId,
    int? totalIncomingCalls,
    int? totalOutgoingCalls,
    String? leadType,
    int? leadStatus,
    int? cityId,
    int? productId,
    int? productPrice,
    int? assignedAgentId,
    int? connectedCallDuration,
    int? stickyType,
    DateTime? insertDateTime,
    DateTime? updateDateTime,
    String? callType,
    int? answer,
  }) {
    return ScheduleDetails(
      customerName: customerName ?? this.customerName,
      companyName: companyName ?? this.companyName,
      agentName: agentName ?? this.agentName,
      id: id ?? this.id,
      scheduleCustomerNumber:
          scheduleCustomerNumber ?? this.scheduleCustomerNumber,
      customerNumber: customerNumber ?? this.customerNumber,
      scheduleDateTime: scheduleDateTime ?? this.scheduleDateTime,
      smeId: smeId ?? this.smeId,
      createdBy: createdBy ?? this.createdBy,
      message: message ?? this.message,
      status: status ?? this.status,
      recentDuration: recentDuration ?? this.recentDuration,
      recentViaLongcode: recentViaLongcode ?? this.recentViaLongcode,
      serverIpAddress: serverIpAddress ?? this.serverIpAddress,
      recentPatchedAgentId: recentPatchedAgentId ?? this.recentPatchedAgentId,
      totalIncomingCalls: totalIncomingCalls ?? this.totalIncomingCalls,
      totalOutgoingCalls: totalOutgoingCalls ?? this.totalOutgoingCalls,
      leadType: leadType ?? this.leadType,
      leadStatus: leadStatus ?? this.leadStatus,
      cityId: cityId ?? this.cityId,
      productId: productId ?? this.productId,
      productPrice: productPrice ?? this.productPrice,
      assignedAgentId: assignedAgentId ?? this.assignedAgentId,
      connectedCallDuration:
          connectedCallDuration ?? this.connectedCallDuration,
      stickyType: stickyType ?? this.stickyType,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      updateDateTime: updateDateTime ?? this.updateDateTime,
      callType: callType ?? this.callType,
      answer: answer ?? this.answer,
    );
  }

  factory ScheduleDetails.fromJson(Map<String, dynamic> json) {
    return ScheduleDetails(
      customerName: json["customer_name"],
      companyName: json["company_name"],
      agentName: json["agent_name"],
      id: json["id"],
      scheduleCustomerNumber: json["customer_number"],
      customerNumber: json["customerNumber"],
      scheduleDateTime:
          DateTime.parse(json["scheduleDateTime"] ?? "").toLocal(),
      smeId: json["sme_id"],
      createdBy: json["created_by"],
      message: json["message"],
      status: json["status"],
      recentDuration: json["recent_duration"],
      recentViaLongcode: json["recent_via_longcode"],
      serverIpAddress: json["server_ip_address"],
      recentPatchedAgentId: json["recent_patched_agent_id"],
      totalIncomingCalls: json["total_incoming_calls"],
      totalOutgoingCalls: json["total_outgoing_calls"],
      leadType: json["lead_type"],
      leadStatus: json["lead_status"],
      cityId: json["city_id"],
      productId: json["product_id"],
      productPrice: json["product_price"],
      assignedAgentId: json["assigned_agent_id"],
      connectedCallDuration: json["connected_call_duration"],
      stickyType: json["sticky_type"],
      insertDateTime:
          DateTime.tryParse(json["insert_date_time"] ?? "")?.toLocal(),
      updateDateTime:
          DateTime.tryParse(json["update_date_time"] ?? "")?.toLocal(),
      callType: json["call_type"],
      answer: json["answer"],
    );
  }

  Map<String, dynamic> toJson() => {
        "customer_name": customerName,
        "company_name": companyName,
        "agent_name": agentName,
        "id": id,
        "customer_number": scheduleCustomerNumber,
        "customerNumber": customerNumber,
        "scheduleDateTime": scheduleDateTime.toUtc(),
        "sme_id": smeId,
        "created_by": createdBy,
        "message": message,
        "status": status,
        "recent_duration": recentDuration,
        "recent_via_longcode": recentViaLongcode,
        "server_ip_address": serverIpAddress,
        "recent_patched_agent_id": recentPatchedAgentId,
        "total_incoming_calls": totalIncomingCalls,
        "total_outgoing_calls": totalOutgoingCalls,
        "lead_type": leadType,
        "lead_status": leadStatus,
        "city_id": cityId,
        "product_id": productId,
        "product_price": productPrice,
        "assigned_agent_id": assignedAgentId,
        "connected_call_duration": connectedCallDuration,
        "sticky_type": stickyType,
        "insert_date_time": insertDateTime?.toUtc(),
        "update_date_time": updateDateTime?.toUtc(),
        "call_type": callType,
        "answer": answer,
      };

  @override
  String toString() {
    return "$customerName, $companyName, $agentName, $id, $scheduleCustomerNumber, $customerNumber, $scheduleDateTime, $smeId, $createdBy, $message, $status, $recentDuration, $recentViaLongcode, $serverIpAddress, $recentPatchedAgentId, $totalIncomingCalls, $totalOutgoingCalls, $leadType, $leadStatus, $cityId, $productId, $productPrice, $assignedAgentId, $connectedCallDuration, $stickyType, $insertDateTime, $updateDateTime, $callType, $answer, ";
  }

  @override
  List<Object?> get props => [
        customerName,
        companyName,
        agentName,
        id,
        scheduleCustomerNumber,
        customerNumber,
        scheduleDateTime,
        smeId,
        createdBy,
        message,
        status,
        recentDuration,
        recentViaLongcode,
        serverIpAddress,
        recentPatchedAgentId,
        totalIncomingCalls,
        totalOutgoingCalls,
        leadType,
        leadStatus,
        cityId,
        productId,
        productPrice,
        assignedAgentId,
        connectedCallDuration,
        stickyType,
        insertDateTime,
        updateDateTime,
        callType,
        answer,
      ];
}
