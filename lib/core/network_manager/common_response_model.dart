import 'package:equatable/equatable.dart';

class CommonResponseModel extends Equatable {
  const CommonResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final dynamic data;

  bool get isSuccess => status == 1;

  CommonResponseModel copyWith({
    int? status,
    String? message,
    dynamic data,
  }) {
    return CommonResponseModel(
      status: status ?? this.status,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) {
    return CommonResponseModel(
      status: json["status"],
      message: json["message"],
      data: json["data"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };

  @override
  String toString() {
    return "$status, $message, $data, ";
  }

  @override
  List<Object?> get props => [status, message, data];
}
