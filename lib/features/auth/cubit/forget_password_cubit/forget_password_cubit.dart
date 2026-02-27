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

  Future<void> forgotPassword({required String email}) async {
    try {
      if (AppValidation.isEmpty(email)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterYourUsername);
      } else if (!AppValidation.isValidEmail(email)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .invalidUsername);
      } else {
        hideKeyboard();
        AppLoadingIndicator.showLoadingIndicator();
        // final res = await _authRepo.forgotPassword(userName: userName);
final res = await _authRepo.getUserDetailByEmail(email: email);


 if (!res.isSuccess || res.data == null) {
        FToastManager().showToast(message: res.message);
        return;
      }


  final userList = List<Map<String, dynamic>>.from(res.data);
    if (userList.isEmpty) {
      FToastManager().showToast(message: "User not found");
      return;
    }

    final user = userList.first;

emit(
  state.copyWith(
    email: email,
    smeId: user["sme_id"],
    phone: user["agent_mobile"],
    sendMessageVia: user["send_message_via"]?.toString() ?? "default",
    showMethodSelector: true,
  ),
    );

        // FToastManager().showToast(message: res.message);
        // if (res.isSuccess) {
        //   emit(
        //     ForgetPasswordState(
        //       forgotPasswordDetails: ForgotPasswordResponseModel.fromJson(
        //           res.data as Map<String, dynamic>),
        //     ),
        //   );
        // }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("ForgetPasswordCubit $e");
      debugPrint("$s");
    }finally {
    AppLoadingIndicator.dismissLoadingIndicator();
  }
  }


  void initialState() {
    emit(const ForgetPasswordState());
  }
Future<void> sendOtp({required String method}) async {
  try {
    AppLoadingIndicator.showLoadingIndicator();

    final sendVia = resolveSendEmailVia(state.sendMessageVia);

    await _authRepo.sendForgotPasswordOtp(
      email: state.email!,
      phone: state.phone!,
      smeId: state.smeId!,
      sendVia: sendVia,
      sendOptionType: method, // email | sms
    );

    FToastManager().showToast(message: "OTP sent successfully");

    // ✅ IMPORTANT: store method + trigger navigation
    emit(
      state.copyWith(
        otpMethod: method,          // 👈 SAVE METHOD
        showMethodSelector: false,
        navigateToOtp: true,        // 👈 NAVIGATION SIGNAL
      ),
    );
  } finally {
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
String resolveSendEmailVia(String? value) {
  if (value == null || value == "0") return "default";
  return value; // default | custom
}

void resetMethodSelector() {
  if (state.showMethodSelector) {
    emit(
      state.copyWith(
        showMethodSelector: false,
      ),
    );
  }
}
}
