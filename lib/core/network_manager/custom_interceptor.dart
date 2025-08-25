part of 'dio_client.dart';

class CustomInterceptor extends Interceptor {
  const CustomInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    if (UserLoginInfoManager.userLoginInfoModel != null) {
      final token =
          "${UserLoginInfoManager.userLoginInfoModel?.tokenType} ${UserLoginInfoManager.userLoginInfoModel?.accessToken}";
      options.headers["authentication"] = token;
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (UserLoginInfoManager.userLoginInfoModel != null &&
        err.response?.statusCode == 401) {
      LogoutManager.logoutUser(context: AppKeys.navigatorKey.currentContext!);
    }
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
