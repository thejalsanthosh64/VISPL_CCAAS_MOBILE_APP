import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/utilities/logout_manager.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';

import 'common_response_model.dart';

part 'api_endpoints.dart';

part 'custom_interceptor.dart';

class DioClient {
  final _dio = Dio();

  DioClient({String? mountPoint}) {
    _dio
      ..options.baseUrl = (mountPoint ?? '').isEmpty
          ? ApiEndpoints._baseUrl
          : "${ApiEndpoints._baseUrl}$mountPoint/"
      ..options.connectTimeout =
          const Duration(seconds: ApiEndpoints._connectionTimeout)
      ..options.receiveTimeout =
          const Duration(seconds: ApiEndpoints._receiveTimeout)
      ..options.responseType = ResponseType.json
      ..interceptors.add(const CustomInterceptor());
  }

  Future<CommonResponseModel> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return CommonResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AppDioException.fromDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> post(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {

   debugPrint("===== DIO POST REQUEST =====");
debugPrint("BASE URL: ${_dio.options.baseUrl}");
debugPrint("ENDPOINT: $uri");
debugPrint("FULL URL: ${_dio.options.baseUrl}$uri");
  debugPrint("BODY: ${const JsonEncoder.withIndent('  ').convert(data)}");


      final response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
         debugPrint("STATUS: ${response.statusCode}");
    debugPrint("RESPONSE: ${response.data}");

      return CommonResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AppDioException.fromDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> put(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return CommonResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AppDioException.fromDioException(e);
    } catch (e) {
      rethrow;
    }
  }

  Future<CommonResponseModel> delete(
    String uri, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return CommonResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw AppDioException.fromDioException(e);
    } catch (e) {
      rethrow;
    }
  }
}
