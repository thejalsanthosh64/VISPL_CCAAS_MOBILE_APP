import 'package:dio/dio.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/common/app_keys.dart';

class AppDioException implements Exception {
  late String message;
  late int statusCode;

  AppDioException.fromDioException(DioException dioException) {
    
    statusCode = dioException.response?.statusCode ?? 0;
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .cancelRequest;
        break;
      case DioExceptionType.connectionTimeout:
        message = AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .connectionTimeout;
        break;
      case DioExceptionType.receiveTimeout:
        message = AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .receiveTimeout;
        break;
      case DioExceptionType.sendTimeout:
        message = AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .sendTimeout;
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
            dioException.response?.statusCode, dioException.response?.data);
        break;
      default:
        message = AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .somethingWentWrong;
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    if (error != null && error is Map<String, dynamic>) {
      if (error.containsKey('message') && error['message'] != null) {
        return error['message'].toString(); 
      }}
    switch (statusCode) {
      case 400:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .badRequest;
      case 401:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .unauthorized;
      case 403:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .requestForbidden;
      case 404:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .urlNotFound;
      case 500:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .internalServerError;
      default:
        return AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .somethingWentWrong;
    }
  }

  @override
  String toString() => 'DioException: $message (status code: $statusCode)';
}
