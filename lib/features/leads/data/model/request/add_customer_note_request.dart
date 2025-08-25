import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class AddCustomerNoteRequest extends Equatable {
  const AddCustomerNoteRequest({
    required this.customerNumber,
    required this.insertDateTime,
    required this.remarks,
    this.sessionId,
  });

  final String customerNumber;
  final DateTime insertDateTime;
  final String remarks;
  final String? sessionId;

  static final generateSessionId =
      "pbx_${DateTime.now().millisecondsSinceEpoch}";

  AddCustomerNoteRequest copyWith({
    String? customerNumber,
    DateTime? insertDateTime,
    String? remarks,
    String? sessionId,
  }) {
    return AddCustomerNoteRequest(
      customerNumber: customerNumber ?? this.customerNumber,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      remarks: remarks ?? this.remarks,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  Map<String, dynamic> toJson() => {
        "customerNumber": customerNumber,
        "insertDateTime":
            DateUtility.sendRequestDateTimeFormat(date: insertDateTime.toUtc()),
        "remarks": remarks,
        "sessionId": sessionId ?? generateSessionId,
      };

  @override
  String toString() {
    return "$customerNumber, $insertDateTime, $remarks, $sessionId, ";
  }

  @override
  List<Object?> get props => [
        customerNumber,
        insertDateTime,
        remarks,
        sessionId,
      ];
}
