import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class SendRemarksRequestModel extends Equatable {
  const SendRemarksRequestModel({
    required this.sessionId,
    required this.remarks,
    required this.callDirection,
    required this.smeId,
    required this.customerNumber,
    required this.insertDateTime,
  });

  final String sessionId;
  final String remarks;
  final String callDirection;
  final int smeId;
  final String customerNumber;
  final DateTime insertDateTime;

  SendRemarksRequestModel copyWith({
    String? sessionId,
    String? remarks,
    String? callDirection,
    int? smeId,
    String? customerNumber,
    DateTime? insertDateTime,
  }) {
    return SendRemarksRequestModel(
      sessionId: sessionId ?? this.sessionId,
      remarks: remarks ?? this.remarks,
      callDirection: callDirection ?? this.callDirection,
      smeId: smeId ?? this.smeId,
      customerNumber: customerNumber ?? this.customerNumber,
      insertDateTime: insertDateTime ?? this.insertDateTime,
    );
  }

  factory SendRemarksRequestModel.fromJson(Map<String, dynamic> json) {
    return SendRemarksRequestModel(
      sessionId: json["sessionId"],
      remarks: json["remarks"],
      callDirection: json["callDirection"],
      smeId: json["smeId"],
      customerNumber: json["customerNumber"],
      insertDateTime: DateTime.parse(json["insertDateTime"]).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "sessionId": sessionId,
        "remarks": remarks,
        "callDirection": callDirection,
        "smeId": smeId,
        "customerNumber": customerNumber,
        "insertDateTime":
            DateUtility.sendRequestDateTimeFormat(date: insertDateTime.toUtc()),
      };

  @override
  String toString() {
    return "$sessionId, $remarks, $callDirection, $smeId, $customerNumber, $insertDateTime, ";
  }

  @override
  List<Object?> get props => [
        sessionId,
        remarks,
        callDirection,
        smeId,
        customerNumber,
        insertDateTime,
      ];
}
