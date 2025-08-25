import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class AddMannualLeadRequestModel extends Equatable {
  const AddMannualLeadRequestModel({
    required this.assignedAgentId,
    this.callType = requestCallType,
    required this.stickyType,
    required this.insertDateTime,
    required this.customerNumber,
    this.ip,
  });

  final int assignedAgentId;
  final String callType;
  final int stickyType;
  final DateTime insertDateTime;
  final String customerNumber;
  final String? ip;

  static const requestCallType = "MANUAL";

  AddMannualLeadRequestModel copyWith({
    int? assignedAgentId,
    String? callType,
    int? stickyType,
    DateTime? insertDateTime,
    String? customerNumber,
    String? ip,
  }) {
    return AddMannualLeadRequestModel(
      assignedAgentId: assignedAgentId ?? this.assignedAgentId,
      callType: callType ?? this.callType,
      stickyType: stickyType ?? this.stickyType,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      customerNumber: customerNumber ?? this.customerNumber,
      ip: ip ?? this.ip,
    );
  }

  factory AddMannualLeadRequestModel.fromJson(Map<String, dynamic> json) {
    return AddMannualLeadRequestModel(
      assignedAgentId: json["assigned_agent_id"],
      callType: json["call_type"],
      stickyType: json["sticky_type"],
      insertDateTime: DateTime.parse(json["insertDateTime"] ?? "").toLocal(),
      customerNumber: json["customerNumber"],
      ip: json["ip"],
    );
  }

  Map<String, dynamic> toJson() => {
        "assigned_agent_id": assignedAgentId,
        "call_type": callType,
        "sticky_type": stickyType,
        "insertDateTime":
            DateUtility.sendRequestDateTimeFormat(date: insertDateTime.toUtc()),
        "customerNumber": customerNumber,
        "ip": ip,
      };

  @override
  String toString() {
    return "$assignedAgentId, $callType, $stickyType, $insertDateTime, $customerNumber, $ip ";
  }

  @override
  List<Object?> get props => [
        assignedAgentId,
        callType,
        stickyType,
        insertDateTime,
        customerNumber,
        ip
      ];
}
