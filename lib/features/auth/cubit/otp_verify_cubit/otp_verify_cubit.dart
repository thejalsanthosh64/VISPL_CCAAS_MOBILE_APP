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

part 'otp_verify_state.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  OtpVerifyCubit() : super(const OtpVerifyState());


void init({
  required String otpMethod,
  required String sendMessageVia,
}) {
  emit(state.copyWith(
    otpMethod: otpMethod,
    sendMessageVia: sendMessageVia,
  ));
}
  final otpController = TextEditingController();

  final _authRepo = AuthRepo();

  @override
  Future<void> close() {
    otpController.dispose();
    return super.close();
  }

void initialState() {
  emit(state.copyWith(
    isOtpVerified: false,
    isTimeCompleted: false,
  ));
}

  void changeTimeCompleteStatus(bool isCompleted) {
    emit(state.copyWith(isTimeCompleted: isCompleted));
  }

  Future<void> verifyOtp(
      {required String username, required String otp}) async {
    try {
      if (AppValidation.isEmpty(otp)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterYourOtp);
      } else if (otp.length != 6) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .invalidOtp);
      } else {
        hideKeyboard();
        AppLoadingIndicator.showLoadingIndicator();
        final res = await _authRepo.verifyOtp(email: username, otp: otp,mode: state.otpMethod,);
        if (res.isSuccess) {
          emit(state.copyWith(isOtpVerified: true));
        } else {
          FToastManager().showToast(message: res.message);
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("OtpVerifyCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
Future<void> resendOtp({
  required String email,
  required String phone,
  required int smeId,
}) async {
  try {
    AppLoadingIndicator.showLoadingIndicator();

    final sendVia =
        state.sendMessageVia == "0" ? "default" : state.sendMessageVia;

    await _authRepo.sendForgotPasswordOtp(
      email: email,
      phone: phone,
      smeId: smeId,
      sendVia: sendVia,
      sendOptionType: state.otpMethod,
    );

    emit(state.copyWith(isTimeCompleted: false));
    FToastManager().showToast(message: "OTP resent successfully");
  } finally {
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
}
