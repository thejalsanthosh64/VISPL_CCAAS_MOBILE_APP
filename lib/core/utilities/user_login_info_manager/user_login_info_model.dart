part of 'user_login_info_manager.dart';

class UserLoginInfoModel extends Equatable {
  const UserLoginInfoModel({
    required this.username,
    required this.role,
    required this.userRoleId,
    this.ipsWhitelist,
    this.whitelistStatus,
    required this.userId,
    required this.accessToken,
    required this.tokenType,
  });

  final String username;
  final String role;
  final int userRoleId;
  final String? ipsWhitelist;
  final int? whitelistStatus;
  final int userId;
  final String accessToken;
  final String tokenType;

  UserLoginInfoModel copyWith({
    String? username,
    String? role,
    int? userRoleId,
    String? ipsWhitelist,
    int? whitelistStatus,
    int? userId,
    String? accessToken,
    String? tokenType,
  }) {
    return UserLoginInfoModel(
      username: username ?? this.username,
      role: role ?? this.role,
      userRoleId: userRoleId ?? this.userRoleId,
      ipsWhitelist: ipsWhitelist ?? this.ipsWhitelist,
      whitelistStatus: whitelistStatus ?? this.whitelistStatus,
      userId: userId ?? this.userId,
      accessToken: accessToken ?? this.accessToken,
      tokenType: tokenType ?? this.tokenType,
    );
  }

  factory UserLoginInfoModel.fromJson(Map<String, dynamic> json) {
    return UserLoginInfoModel(
      username: json["username"],
      role: json["ROLE"],
      userRoleId: json["user_role_id"],
      ipsWhitelist: json["ips_whitelist"],
      whitelistStatus: json["whitelist_status"],
      userId: json["user_id"],
      accessToken: json["access_token"],
      tokenType: json["token_type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "username": username,
        "ROLE": role,
        "user_role_id": userRoleId,
        "ips_whitelist": ipsWhitelist,
        "whitelist_status": whitelistStatus,
        "user_id": userId,
        "access_token": accessToken,
        "token_type": tokenType,
      };

  @override
  String toString() {
    return "$username, $role, $userRoleId, $ipsWhitelist, $whitelistStatus, $userId, $accessToken, $tokenType, ";
  }

  @override
  List<Object?> get props => [
        username,
        role,
        userRoleId,
        ipsWhitelist,
        whitelistStatus,
        userId,
        accessToken,
        tokenType,
      ];
}
