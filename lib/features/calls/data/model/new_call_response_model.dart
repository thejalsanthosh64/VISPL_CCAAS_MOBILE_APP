import 'package:equatable/equatable.dart';

class NewCallResponseModel extends Equatable {
  const NewCallResponseModel({
    required this.callScheduleId,
    required this.sessionId,
    required this.virtualNumber,
  });

  final int callScheduleId;
  final String sessionId;
  final int virtualNumber;

  NewCallResponseModel copyWith({
    int? callScheduleId,
    String? sessionId,
    int? virtualNumber,
  }) {
    return NewCallResponseModel(
      callScheduleId: callScheduleId ?? this.callScheduleId,
      sessionId: sessionId ?? this.sessionId,
      virtualNumber: virtualNumber ?? this.virtualNumber,
    );
  }

  factory NewCallResponseModel.fromJson(Map<String, dynamic> json) {
    return NewCallResponseModel(
      callScheduleId: json["callScheduleId"],
      sessionId: json["sessionId"],
      virtualNumber: json["virtualNumber"],
    );
  }

  Map<String, dynamic> toJson() => {
        "callScheduleId": callScheduleId,
        "sessionId": sessionId,
        "virtualNumber": virtualNumber,
      };

  @override
  String toString() {
    return "$callScheduleId, $sessionId, $virtualNumber, ";
  }

  @override
  List<Object?> get props => [
        callScheduleId,
        sessionId,
        virtualNumber,
      ];
}
