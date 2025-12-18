import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/auth/data/model/login_request_model.dart';
import 'package:kommuno/features/auth/data/repository/auth_repo.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  final userNameController = TextEditingController(text: kDebugMode ? "boffincodersprojects@gmail.com" : '');
  final passwordController = TextEditingController(text: kDebugMode ? "123456" : '');

  final _authRepo = AuthRepo();

  @override
  Future<void> close() {
    userNameController.dispose();
    passwordController.dispose();
    return super.close();
  }

  void changePasswordVisibility(bool isVisible) {
    emit(state.copyWith(isPasswordVisible: isVisible));
  }

  Future<void> loginUser({required String username, required String password}) async {
    try {
      if (AppValidation.isEmpty(username)) {
        FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.pleaseEnterYourUsername);
      } else if (!AppValidation.isValidEmail(username)) {
        FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.invalidUsername);
      } else if (AppValidation.isEmpty(password)) {
        FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.pleaseEnterYourPassword);
      } else {
        hideKeyboard();
        AppLoadingIndicator.showLoadingIndicator();
        final res = await _authRepo.loginUser(
          loginRequestModel: LoginRequestModel(
          password: password,
          username: username,
          deviceType: AppConstant.loginDeviceType,
        ));
        if (res.isSuccess) {

          await UserLoginInfoManager.setLoginUserInfo(userInfo: res.data);
          emit(state.copyWith(isUserLoginSuccess: true));
        } else {
          FToastManager().showToast(message: res.message);
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.somethingWentWrong);
      debugPrint("LoginCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
