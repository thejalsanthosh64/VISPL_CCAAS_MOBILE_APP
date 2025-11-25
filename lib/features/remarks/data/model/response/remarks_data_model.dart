import 'package:equatable/equatable.dart';
class RemarksDataModel extends Equatable {
  const RemarksDataModel({
    this.remarks,
    required this.startDateTime,
    this.answer,
  });

  final String? remarks;
  final DateTime startDateTime;
  final int? answer;

  RemarksDataModel copyWith({
    String? remarks,
    DateTime? startDateTime,
    int? answer,
  }) {
    return RemarksDataModel(
      remarks: remarks ?? this.remarks,
      startDateTime: startDateTime ?? this.startDateTime,
      answer: answer ?? this.answer,
    );
  }

  factory RemarksDataModel.fromJson(Map<String, dynamic> json) {
    return RemarksDataModel(
      remarks: json["remarks"]?.toString(),      // <- SAFE
      startDateTime: DateTime.parse(json["start_date_time"]).toLocal(),
      answer: json["answer"],
    );
  }

  Map<String, dynamic> toJson() => {
        "remarks": remarks,
        "start_date_time": startDateTime.toUtc(),
        "answer": answer,
      };

  @override
  List<Object?> get props => [
        remarks,
        startDateTime,
        answer,
      ];
}
