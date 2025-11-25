import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';


class BreakInRequestModel extends Equatable {
  const BreakInRequestModel({
    required this.message,
    required this.smeId,
    required this.startDate,
    required this.startDateTime,
  });

  final String message;
  final String smeId;
  final DateTime startDate;      
  final String startDateTime;     

  BreakInRequestModel copyWith({
    String? message,
    String? smeId,
    DateTime? startDate,
    String? startDateTime,
  }) {
    return BreakInRequestModel(
      message: message ?? this.message,
      smeId: smeId ?? this.smeId,
      startDate: startDate ?? this.startDate,
      startDateTime: startDateTime ?? this.startDateTime,
    );
  }

  factory BreakInRequestModel.fromJson(Map<String, dynamic> json) {
    return BreakInRequestModel(
      message: json["message"],
      smeId: json["smeId"].toString(),
      startDate: DateTime.parse(json["startDate"]),
      startDateTime: json["startDateTime"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "message": message,
        "smeId": smeId,
        "startDate": DateFormat("yyyy-MM-dd").format(startDate),
        "startDateTime": startDateTime,
      };

  @override
  List<Object?> get props => [message, smeId, startDate, startDateTime];
}



