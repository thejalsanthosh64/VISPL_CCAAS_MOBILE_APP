
// import 'package:flutter/material.dart';

// class WhiteLabelModel {
//   final bool isWhitelabel;
//   final String? loginLogo;
//   final String? dashboardLogo;
//   final String? loginBg;
//   final Color? primaryColor;
//   final Color? secondaryColor;
//   final String? companyName;

//   WhiteLabelModel({
//     required this.isWhitelabel,
//     this.loginLogo,
//     this.dashboardLogo,
//     this.loginBg,
//     this.primaryColor,
//     this.secondaryColor,
//     this.companyName,
//   });

//   factory WhiteLabelModel.fromJson(Map<String, dynamic> json) {
//     Color? parseColor(String? hex) {
//       if (hex == null || hex.isEmpty) return null;
//       return Color(int.parse(hex.replaceFirst('#', '0xff')));
//     }

//     return WhiteLabelModel(
//       isWhitelabel: json["isWhitelabel"] == true,
//       loginLogo: json["loginLogo"],
//       dashboardLogo: json["dashboardLogo"],
//       loginBg: json["loginPageBackground"],
//       primaryColor: parseColor(json["primaryColor"]),
//       secondaryColor: parseColor(json["secondaryColor"]),
//       companyName: json["companyName"],
//     );
//   }
// }