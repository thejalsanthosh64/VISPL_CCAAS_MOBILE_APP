import 'package:equatable/equatable.dart';

import 'remarks_request_model.dart';

class RemarksRequiredFieldsModel extends Equatable {
  final String customerNumber;
  final String? customerName;
  final String sessionId;
  final String callDirection;

  const RemarksRequiredFieldsModel({
    required this.customerNumber,
    this.customerName,
    required this.sessionId,
    required this.callDirection,
  });

  static const defaultCallDirection =
      "${RemarksRequestModel.defaultCallDirection}";

  @override
  List<Object?> get props =>
      [customerNumber, customerName, sessionId, callDirection];
}
