import 'package:equatable/equatable.dart';
// class RemarksDataModel extends Equatable {
//   const RemarksDataModel({
//     this.remarks,
//     required this.startDateTime,
//     this.answer,
//   });

//   final String? remarks;
//   final DateTime startDateTime;
//   final int? answer;

//   RemarksDataModel copyWith({
//     String? remarks,
//     DateTime? startDateTime,
//     int? answer,
//   }) {
//     return RemarksDataModel(
//       remarks: remarks ?? this.remarks,
//       startDateTime: startDateTime ?? this.startDateTime,
//       answer: answer ?? this.answer,
//     );
//   }

//   factory RemarksDataModel.fromJson(Map<String, dynamic> json) {
//     return RemarksDataModel(
//       remarks: json["remarks"]?.toString(),      // <- SAFE
//       startDateTime: DateTime.parse(json["start_date_time"]).toLocal(),
//       answer: json["answer"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "remarks": remarks,
//         "start_date_time": startDateTime.toUtc(),
//         "answer": answer,
//       };

//   @override
//   List<Object?> get props => [
//         remarks,
//         startDateTime,
//         answer,
//       ];
// }


class RemarksDataModel {
  final String id;
  final String message;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int editCount;
  final CreatedByModel createdBy;

  RemarksDataModel({
    required this.id,
    required this.message,
    required this.createdAt,
    this.updatedAt,
    required this.editCount,
    required this.createdBy,
  });

  factory RemarksDataModel.fromJson(Map<String, dynamic> json) {
    return RemarksDataModel(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt']) : null,
      editCount: json['editCount'] ?? 0,
      createdBy: CreatedByModel.fromJson(json['createdBy'] ?? {}),
    );
  }
}

class CreatedByModel {
  final int id;
  final String name;
  final String role;

  CreatedByModel({required this.id, required this.name, required this.role});

  factory CreatedByModel.fromJson(Map<String, dynamic> json) {
    return CreatedByModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      role: json['role'] ?? '',
    );
  }
}