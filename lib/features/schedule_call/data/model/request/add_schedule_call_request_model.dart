import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
class AddScheduleCallRequestModel extends Equatable {
  const AddScheduleCallRequestModel({
    this.smeId,
    required this.message,
    required this.customerNumber,
    required this.customerName,
    required this.scheduleDateTime,
    required this.agentId,
  });

  final String? smeId;
  final String message;
  final String customerNumber;
  final String customerName;
  final DateTime scheduleDateTime;
  final String agentId;

  AddScheduleCallRequestModel copyWith({
    String? smeId,
    String? message,
    String? customerNumber,
    String? customerName,
    DateTime? scheduleDateTime,
    String? agentId,
  }) {
    return AddScheduleCallRequestModel(
      smeId: smeId ?? this.smeId,
      message: message ?? this.message,
      customerNumber: customerNumber ?? this.customerNumber,
      customerName: customerName ?? this.customerName,
      scheduleDateTime: scheduleDateTime ?? this.scheduleDateTime,
      agentId: agentId ?? this.agentId,
    );
  }

  factory AddScheduleCallRequestModel.fromJson(Map<String, dynamic> json) {
    return AddScheduleCallRequestModel(
      smeId: json["sme_id"],
      message: json["message"],
      customerNumber: json["customerNumber"],
      customerName: json["customerName"],
      scheduleDateTime: DateTime.parse(json["scheduleDateTime"]).toLocal(),
      agentId: json["created_by"],
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      "message": message,
      "customerNumber": customerNumber,
      "customerName": customerName,
      "scheduleDateTime":
          DateUtility.scheduleCallRequestDateTimeFormat(
              date: scheduleDateTime),
      "agentId": agentId,
    };

    if (smeId != null && smeId!.isNotEmpty) {
      data["sme_id"] = smeId??"";
    }

    return data;
  }

  @override
  List<Object?> get props => [
        smeId,
        message,
        customerNumber,
        customerName,
        scheduleDateTime,
        agentId,
      ];
}
