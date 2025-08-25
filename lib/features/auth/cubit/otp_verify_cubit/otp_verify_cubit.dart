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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'otp_verify_state.dart';

class OtpVerifyCubit extends Cubit<OtpVerifyState> {
  OtpVerifyCubit() : super(const OtpVerifyState());

  final otpController = TextEditingController();

  final _authRepo = AuthRepo();

  @override
  Future<void> close() {
    otpController.dispose();
    return super.close();
  }

  void initialState() {
    emit(const OtpVerifyState());
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
        final res = await _authRepo.verifyOtp(userName: username, otp: otp);
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
}
