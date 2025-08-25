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
}
