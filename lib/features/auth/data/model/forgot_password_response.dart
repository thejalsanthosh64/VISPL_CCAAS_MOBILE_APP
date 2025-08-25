import 'package:equatable/equatable.dart';

class ForgotPasswordResponseModel extends Equatable {
  const ForgotPasswordResponseModel({
    required this.username,
    required this.email,
    required this.updateDateTime,
  });

  final String username;
  final String email;
  final DateTime updateDateTime;

  ForgotPasswordResponseModel copyWith({
    String? username,
    String? email,
    DateTime? updateDateTime,
  }) {
    return ForgotPasswordResponseModel(
      username: username ?? this.username,
      email: email ?? this.email,
      updateDateTime: updateDateTime ?? this.updateDateTime,
    );
  }

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      username: json["username"],
      email: json["email"],
      updateDateTime:
          DateTime.parse(json["updateDateTime"] ?? DateTime.now()).toLocal(),
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "updateDateTime": updateDateTime.toUtc(),
      };

  @override
  String toString() {
    return "$username, $email, $updateDateTime, ";
  }

  @override
  List<Object?> get props => [username, email, updateDateTime];
}
