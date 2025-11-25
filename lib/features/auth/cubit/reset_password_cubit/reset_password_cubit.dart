import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/auth/data/repository/auth_repo.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(const ResetPasswordState());

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final _authRepo = AuthRepo();

  @override
  Future<void> close() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }

  void changeConfirmPasswordVisibility(bool isConfirmPasswordVisible) {
    emit(state.copyWith(isConfirmPasswordVisible: isConfirmPasswordVisible));
  }

  void changePasswordVisibility(bool isPasswordVisible) {
    emit(state.copyWith(isPasswordVisible: isPasswordVisible));
  }

  Future<void> resetPassword({
    required String password,
    required String confirmPassword,
    required String userName,
  }) async {
    try {
      if (AppValidation.isEmpty(password)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterYourPassword);
      } else if (AppValidation.isEmpty(confirmPassword)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterYourConfirmPassword);
      } else if (password != confirmPassword) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .passwordMisMatch);
      } else {
        hideKeyboard();
        AppLoadingIndicator.showLoadingIndicator();
        final res = await _authRepo.changePassword(
            userName: userName, newPassword: password);
        FToastManager().showToast(message: res.message);
        if (res.isSuccess) {
          emit(state.copyWith(isPasswordChanged: true));
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("ResetPasswordCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
