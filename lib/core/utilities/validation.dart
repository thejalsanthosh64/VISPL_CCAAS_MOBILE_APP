import 'package:kommuno/core/utilities/regex.dart';

abstract class AppValidation {
  static bool isEmpty(String text) {
    return text.trim().isEmpty;
  }

  static bool isValidEmail(String email) {
    return AppRegEx.emailRegEx.hasMatch(email);
  }

  static bool isValidNumber(String number) {
    return AppRegEx.indianNo.hasMatch(number);
  }


 static String maskEmail(String email) {
  final parts = email.split("@");
  if (parts.length != 2) return email;
  final name = parts[0];
  final domain = parts[1];
  return "${name[0]}***@${domain.substring(0, 2)}****";
}

static String maskPhone(String phone) {
  if (phone.length < 4) return phone;
  return "******${phone.substring(phone.length - 4)}";
}
}
