import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';


class BreakOutRequestModel extends Equatable {
  const BreakOutRequestModel({
    required this.endDate,
    required this.endDateTime,
    required this.smeId,
  });

  final DateTime endDate;       
  final String endDateTime;     
  final String smeId;

  BreakOutRequestModel copyWith({
    DateTime? endDate,
    String? endDateTime,
    String? smeId,
  }) {
    return BreakOutRequestModel(
      endDate: endDate ?? this.endDate,
      endDateTime: endDateTime ?? this.endDateTime,
      smeId: smeId ?? this.smeId,
    );
  }

  factory BreakOutRequestModel.fromJson(Map<String, dynamic> json) {
    return BreakOutRequestModel(
      endDate: DateTime.parse(json["endDate"]),
      endDateTime: json["endDateTime"] ?? "",
      smeId: json["smeId"].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "endDate": DateFormat("yyyy-MM-dd").format(endDate),
        "endDateTime": endDateTime,
        "smeId": smeId,
      };

  @override
  List<Object?> get props => [endDate, endDateTime, smeId];
}
