import 'package:equatable/equatable.dart';

class GetContactsRequestModel extends Equatable {
  const GetContactsRequestModel({
    required this.batchSize,
    required this.initialRecord,
    required this.smeId,
  });

  final int batchSize;
  final int initialRecord;
  final String smeId;

  GetContactsRequestModel copyWith({
    int? batchSize,
    int? initialRecord,
    String? smeId,
  }) {
    return GetContactsRequestModel(
      batchSize: batchSize ?? this.batchSize,
      initialRecord: initialRecord ?? this.initialRecord,
      smeId: smeId ?? this.smeId,
    );
  }

  factory GetContactsRequestModel.fromJson(Map<String, dynamic> json) {
    return GetContactsRequestModel(
      batchSize: json["batchSize"],
      initialRecord: json["initialRecord"],
      smeId: json["sme_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "batchSize": batchSize,
        "initialRecord": initialRecord,
        "sme_id": smeId,
      };

  @override
  String toString() {
    return "$batchSize, $initialRecord, $smeId, ";
  }

  @override
  List<Object?> get props => [batchSize, initialRecord, smeId];
}
