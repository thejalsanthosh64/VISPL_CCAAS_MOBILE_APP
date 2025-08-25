import 'package:equatable/equatable.dart';

class AssignedCallsDetails extends Equatable {
  const AssignedCallsDetails({
    required this.id,
    required this.smeId,
    required this.campaignId,
    required this.assignedCallsDetailsCustomerNumber,
    required this.customerNumber,
    required this.other,
    required this.callMode,
    required this.isPicked,
    required this.insertDateTime,
    required this.updateDateTime,
    required this.callStatus,
    required this.sessionId,
    required this.endDateTime,
    required this.campaignName,
    this.customerName,
  });

  final int id;
  final int smeId;
  final int campaignId;
  final String assignedCallsDetailsCustomerNumber;
  final String customerNumber;
  final String other;
  final int callMode;
  final int isPicked;
  final DateTime insertDateTime;
  final DateTime updateDateTime;
  final int callStatus;
  final String sessionId;
  final DateTime endDateTime;
  final String campaignName;
  final String? customerName;

  AssignedCallsDetails copyWith({
    int? id,
    int? smeId,
    int? campaignId,
    String? assignedCallsDetailsCustomerNumber,
    String? customerNumber,
    String? other,
    int? callMode,
    int? isPicked,
    DateTime? insertDateTime,
    DateTime? updateDateTime,
    int? callStatus,
    String? sessionId,
    DateTime? endDateTime,
    String? campaignName,
    String? customerName,
  }) {
    return AssignedCallsDetails(
      id: id ?? this.id,
      smeId: smeId ?? this.smeId,
      campaignId: campaignId ?? this.campaignId,
      assignedCallsDetailsCustomerNumber: assignedCallsDetailsCustomerNumber ??
          this.assignedCallsDetailsCustomerNumber,
      customerNumber: customerNumber ?? this.customerNumber,
      other: other ?? this.other,
      callMode: callMode ?? this.callMode,
      isPicked: isPicked ?? this.isPicked,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      updateDateTime: updateDateTime ?? this.updateDateTime,
      callStatus: callStatus ?? this.callStatus,
      sessionId: sessionId ?? this.sessionId,
      endDateTime: endDateTime ?? this.endDateTime,
      campaignName: campaignName ?? this.campaignName,
      customerName: customerName ?? this.customerName,
    );
  }

  factory AssignedCallsDetails.fromJson(Map<String, dynamic> json) {
    return AssignedCallsDetails(
      id: json["id"],
      smeId: json["sme_id"],
      campaignId: json["campaign_id"],
      assignedCallsDetailsCustomerNumber: json["customer_number"],
      customerNumber: json["customerNumber"],
      other: json["other"],
      callMode: json["call_mode"],
      isPicked: json["is_picked"],
      insertDateTime:
          DateTime.parse(json["insert_date_time"] ?? DateTime.now()).toLocal(),
      updateDateTime:
          DateTime.parse(json["update_date_time"] ?? DateTime.now()).toLocal(),
      callStatus: json["call_status"],
      sessionId: json["session_id"],
      endDateTime: DateTime.parse(json["end_date_time"]).toLocal(),
      campaignName: json["campaign_name"],
      customerName: json["customer_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "sme_id": smeId,
        "campaign_id": campaignId,
        "customer_number": assignedCallsDetailsCustomerNumber,
        "customerNumber": customerNumber,
        "other": other,
        "call_mode": callMode,
        "is_picked": isPicked,
        "insert_date_time": insertDateTime.toUtc(),
        "update_date_time": updateDateTime.toUtc(),
        "call_status": callStatus,
        "session_id": sessionId,
        "end_date_time": endDateTime.toUtc(),
        "campaign_name": campaignName,
        "customer_name": customerName,
      };

  @override
  String toString() {
    return "$id, $smeId, $campaignId, $assignedCallsDetailsCustomerNumber, $customerNumber, $other, $callMode, $isPicked, $insertDateTime, $updateDateTime, $callStatus, $sessionId, $endDateTime, $campaignName, $customerName, ";
  }

  @override
  List<Object?> get props => [
        id,
        smeId,
        campaignId,
        assignedCallsDetailsCustomerNumber,
        customerNumber,
        other,
        callMode,
        isPicked,
        insertDateTime,
        updateDateTime,
        callStatus,
        sessionId,
        endDateTime,
        campaignName,
        customerName,
      ];
}
