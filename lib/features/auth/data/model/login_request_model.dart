import 'package:equatable/equatable.dart';

class LoginRequestModel extends Equatable {
  const LoginRequestModel({
    required this.deviceType,
    required this.password,
    required this.username,
  });

  final String deviceType;
  final String password;
  final String username;

  LoginRequestModel copyWith({
    String? deviceType,
    String? password,
    String? username,
  }) {
    return LoginRequestModel(
      deviceType: deviceType ?? this.deviceType,
      password: password ?? this.password,
      username: username ?? this.username,
    );
  }

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      deviceType: json["deviceType"],
      password: json["password"],
      username: json["username"],
    );
  }

  Map<String, dynamic> toJson() => {
        "deviceType": deviceType,
        "password": password,
        "username": username,
      };

  @override
  String toString() {
    return "$deviceType, $password, $username, ";
  }

  @override
  List<Object?> get props => [deviceType, password, username];
}
