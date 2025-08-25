import 'package:equatable/equatable.dart';

class FollowUpDetails extends Equatable {
  const FollowUpDetails({
    required this.id,
    required this.smeId,
    required this.message,
    required this.customerNumber,
    required this.customerName,
    required this.createdBy,
    required this.reminderDateTime,
    required this.createdDateTime,
    required this.status,
    required this.countryCode,
    required this.countryDialCode,
  });

  final String id;
  final int smeId;
  final String message;
  final String customerNumber;
  final String customerName;
  final int createdBy;
  final DateTime reminderDateTime;
  final DateTime createdDateTime;
  final int status;
  final String countryCode;
  final String countryDialCode;

  bool get isPending => status == 0;

  FollowUpDetails copyWith({
    String? id,
    int? smeId,
    String? message,
    String? customerNumber,
    String? customerName,
    int? createdBy,
    DateTime? reminderDateTime,
    DateTime? createdDateTime,
    int? status,
    String? countryCode,
    String? countryDialCode,
  }) {
    return FollowUpDetails(
      id: id ?? this.id,
      smeId: smeId ?? this.smeId,
      message: message ?? this.message,
      customerNumber: customerNumber ?? this.customerNumber,
      customerName: customerName ?? this.customerName,
      createdBy: createdBy ?? this.createdBy,
      reminderDateTime: reminderDateTime ?? this.reminderDateTime,
      createdDateTime: createdDateTime ?? this.createdDateTime,
      status: status ?? this.status,
      countryCode: countryCode ?? this.countryCode,
      countryDialCode: countryDialCode ?? this.countryDialCode,
    );
  }

  factory FollowUpDetails.fromJson(Map<String, dynamic> json) {
    return FollowUpDetails(
      id: json["_id"],
      smeId: json["sme_id"],
      message: json["message"],
      customerNumber: json["customer_number"],
      customerName: json["customer_name"],
      createdBy: json["created_by"],
      reminderDateTime:
          DateTime.parse(json["reminder_date_time"] ?? "").toLocal(),
      createdDateTime:
          DateTime.parse(json["created_date_time"] ?? "").toLocal(),
      status: json["status"],
      countryCode: json["country_code"],
      countryDialCode: json["country_dial_code"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sme_id": smeId,
        "message": message,
        "customer_number": customerNumber,
        "customer_name": customerName,
        "created_by": createdBy,
        "reminder_date_time": reminderDateTime.toUtc(),
        "created_date_time": createdDateTime.toUtc(),
        "status": status,
        "country_code": countryCode,
        "country_dial_code": countryDialCode,
      };

  @override
  String toString() {
    return "$id, $smeId, $message, $customerNumber, $customerName, $createdBy, $reminderDateTime, $createdDateTime, $status, $countryCode, $countryDialCode, ";
  }

  @override
  List<Object?> get props => [
        id,
        smeId,
        message,
        customerNumber,
        customerName,
        createdBy,
        reminderDateTime,
        createdDateTime,
        status,
        countryCode,
        countryDialCode,
      ];
}
