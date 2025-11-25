import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/auth/data/model/forgot_password_response.dart';
import 'package:kommuno/features/auth/data/repository/auth_repo.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(const ForgetPasswordState());

  final userNameController = TextEditingController();

  final _authRepo = AuthRepo();

  @override
  Future<void> close() async {
    userNameController.dispose();
    super.close();
  }

  Future<void> forgotPassword({required String userName}) async {
    try {
      if (AppValidation.isEmpty(userName)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterYourUsername);
      } else if (!AppValidation.isValidEmail(userName)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .invalidUsername);
      } else {
        hideKeyboard();
        AppLoadingIndicator.showLoadingIndicator();
        final res = await _authRepo.forgotPassword(userName: userName);
        FToastManager().showToast(message: res.message);
        if (res.isSuccess) {
          emit(
            ForgetPasswordState(
              forgotPasswordDetails: ForgotPasswordResponseModel.fromJson(
                  res.data as Map<String, dynamic>),
            ),
          );
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("ForgetPasswordCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }

  void initialState() {
    emit(const ForgetPasswordState());
  }
}
