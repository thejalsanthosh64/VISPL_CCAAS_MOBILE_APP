import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class BreakInRequestModel extends Equatable {
  const BreakInRequestModel({
    required this.message,
    required this.smeId,
    required this.startDate,
  });

  final String message;
  final String smeId;
  final DateTime startDate;

  BreakInRequestModel copyWith({
    String? message,
    String? smeId,
    DateTime? startDate,
  }) {
    return BreakInRequestModel(
      message: message ?? this.message,
      smeId: smeId ?? this.smeId,
      startDate: startDate ?? this.startDate,
    );
  }

  factory BreakInRequestModel.fromJson(Map<String, dynamic> json) {
    return BreakInRequestModel(
      message: json["message"],
      smeId: json["smeId"],
      startDate: DateTime.parse(json["startDate"] ?? "").toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "smeId": smeId,
        "startDate":
            DateUtility.sendRequestDateTimeFormat(date: startDate.toUtc()),
      };

  @override
  String toString() {
    return "$message, $smeId, $startDate, ";
  }

  @override
  List<Object?> get props => [message, smeId, startDate];
}
