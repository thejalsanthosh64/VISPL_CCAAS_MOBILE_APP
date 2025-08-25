import 'package:equatable/equatable.dart';

class RemarksRequestModel extends Equatable {
  const RemarksRequestModel({
    required this.customerNumber,
    required this.smeId,
    this.callDirection = defaultCallDirection,
  });

  final String customerNumber;
  final int smeId;
  final int callDirection;

  static const defaultCallDirection = 1;

  RemarksRequestModel copyWith({
    String? customerNumber,
    int? smeId,
    int? callDirection,
  }) {
    return RemarksRequestModel(
      customerNumber: customerNumber ?? this.customerNumber,
      smeId: smeId ?? this.smeId,
      callDirection: callDirection ?? this.callDirection,
    );
  }

  factory RemarksRequestModel.fromJson(Map<String, dynamic> json) {
    return RemarksRequestModel(
      customerNumber: json["customerNumber"],
      smeId: json["smeId"],
      callDirection: json["callDirection"],
    );
  }

  Map<String, dynamic> toJson() => {
        "customerNumber": customerNumber,
        "smeId": smeId,
        "callDirection": callDirection,
      };

  @override
  String toString() {
    return "$customerNumber, $smeId, $callDirection, ";
  }

  @override
  List<Object?> get props => [
        customerNumber,
        smeId,
        callDirection,
      ];
}
