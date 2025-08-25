import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class AddScheduleCallRequestModel extends Equatable {
  const AddScheduleCallRequestModel({
    required this.smeId,
    required this.message,
    required this.customerNumber,
    required this.customerName,
    required this.scheduleDateTime,
  });

  final String smeId;
  final String message;
  final String customerNumber;
  final String customerName;
  final DateTime scheduleDateTime;

  AddScheduleCallRequestModel copyWith({
    String? smeId,
    String? message,
    String? customerNumber,
    String? customerName,
    DateTime? scheduleDateTime,
  }) {
    return AddScheduleCallRequestModel(
      smeId: smeId ?? this.smeId,
      message: message ?? this.message,
      customerNumber: customerNumber ?? this.customerNumber,
      customerName: customerName ?? this.customerName,
      scheduleDateTime: scheduleDateTime ?? this.scheduleDateTime,
    );
  }

  factory AddScheduleCallRequestModel.fromJson(Map<String, dynamic> json) {
    return AddScheduleCallRequestModel(
      smeId: json["sme_id"],
      message: json["message"],
      customerNumber: json["customerNumber"],
      customerName: json["customerName"],
      scheduleDateTime: DateTime.parse(json["scheduleDateTime"]).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "sme_id": smeId,
        "message": message,
        "customerNumber": customerNumber,
        "customerName": customerName,
        "scheduleDateTime": DateUtility.scheduleCallRequestDateTimeFormat(
            date: scheduleDateTime.toUtc()),
      };

  @override
  String toString() {
    return "$smeId, $message, $customerNumber, $customerName, $scheduleDateTime, ";
  }

  @override
  List<Object?> get props => [
        smeId,
        message,
        customerNumber,
        customerName,
        scheduleDateTime,
      ];
}
