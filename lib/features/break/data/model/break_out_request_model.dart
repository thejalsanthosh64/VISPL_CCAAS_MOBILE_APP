import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class BreakOutRequestModel extends Equatable {
  const BreakOutRequestModel({
    required this.endDate,
    required this.smeId,
  });

  final DateTime endDate;
  final String smeId;

  BreakOutRequestModel copyWith({
    DateTime? endDate,
    String? smeId,
  }) {
    return BreakOutRequestModel(
      endDate: endDate ?? this.endDate,
      smeId: smeId ?? this.smeId,
    );
  }

  factory BreakOutRequestModel.fromJson(Map<String, dynamic> json) {
    return BreakOutRequestModel(
      endDate: DateTime.parse(json["endDate"] ?? "").toLocal(),
      smeId: json["smeId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "endDate": DateUtility.sendRequestDateTimeFormat(date: endDate.toUtc()),
        "smeId": smeId,
      };

  @override
  String toString() {
    return "$endDate, $smeId, ";
  }

  @override
  List<Object?> get props => [endDate, smeId];
}
