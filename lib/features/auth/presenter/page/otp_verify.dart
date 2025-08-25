import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/timer_widget/timer_widget.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/features/auth/cubit/forget_password_cubit/forget_password_cubit.dart';
import 'package:kommuno/features/auth/cubit/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:kommuno/features/auth/data/model/forgot_password_response.dart';
import 'package:kommuno/features/auth/presenter/widget/auth_container.dart';
import 'package:kommuno/features/auth/presenter/widget/common_forgot_password_bg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

class OtpVerifyScreen extends StatelessWidget {
  const OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String? userName;
    if (args?["forgotPasswordDetails"] is ForgotPasswordResponseModel) {
      userName = (args?["forgotPasswordDetails"] as ForgotPasswordResponseModel).username;
    }

    if (userName == null) {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          if (context.mounted) {
            FToastManager().showToast(message: AppLocalizations.of(context)!.usernameNotFound);
            Navigator.of(context).pop();
          }
        },
      );
    }
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          bool goBack = await goBackAlertDialog(context: context);
          if (goBack && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (__) => OtpVerifyCubit()),
          BlocProvider(create: (__) => ForgetPasswordCubit()),
        ],
        child: _OtpVerifyScreenState(userName: userName ?? ''),
      ),
    );
  }
}

class _OtpVerifyScreenState extends StatelessWidget {
  const _OtpVerifyScreenState({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return CommonForgotPasswordBg(child: _buildOtpVerifyDialog());
  }

  Widget get _kSized15 => const SizedBox(height: AppConstant.kSized15);

  OtpVerifyCubit _otpVerifyCubit(BuildContext context) => context.read<OtpVerifyCubit>();

  ForgetPasswordCubit _forgetPasswordCubit(BuildContext context) => context.read<ForgetPasswordCubit>();

  Widget _buildOtpVerifyDialog() {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state.forgotPasswordDetails != null) {
          _otpVerifyCubit(context).changeTimeCompleteStatus(false);
          _forgetPasswordCubit(context).initialState();
        }
      },
      child: BlocConsumer<OtpVerifyCubit, OtpVerifyState>(
        listener: (context, state) {
          if (state.isOtpVerified) {
            Navigator.of(context).pushNamed(AppRouteNames.resetPasswordScreen, arguments: {"userName": userName});
            _otpVerifyCubit(context).initialState();
          }
        },
        builder: (context, state) {
          return AuthContainer(
            onTapIcon: () {
              _otpVerifyCubit(context).verifyOtp(username: userName, otp: _otpVerifyCubit(context).otpController.text);
            },
            containerBody: [
              Text(
                AppLocalizations.of(context)!.validateOTP,
                style: AppTextStyle.black25,
              ),
              _kSized15,
              Text(
                "${AppLocalizations.of(context)!.validateOTPDescription} $userName",
                style: AppTextStyle.grey18,
              ),
              _kSized15,
              Center(
                child: Pinput(
                  length: 6,
                  controller: _otpVerifyCubit(context).otpController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  closeKeyboardWhenCompleted: true,
                  cursor: const VerticalDivider(width: 0, thickness: 2, indent: 8, endIndent: 8),
                  focusedPinTheme: AppTheme.otpPinTheme,
                  defaultPinTheme: AppTheme.otpPinTheme.copyWith(height: 40),
                ),
              ),
              _kSized15,
              Center(
                child: TimerWidget(
                  key: ValueKey<String>("OtpVerifyScreen_TimerWidget_${state.isTimeCompleted}"),
                  onComplete: () {
                    _otpVerifyCubit(context).changeTimeCompleteStatus(true);
                  },
                  durationInSec: 600,
                  restartTimer: !state.isTimeCompleted,
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: state.isTimeCompleted
                      ? () {
                          _forgetPasswordCubit(context).forgotPassword(userName: userName);
                        }
                      : null,
                  child: Text(
                    AppLocalizations.of(context)!.resendOTP,
                    style: state.isTimeCompleted ? AppTextStyle.appColor18 : AppTextStyle.grey18,
                  ),
                ),
              ),
              const SizedBox(height: AppConstant.kSized20),
            ],
          );
        },
      ),
    );
  }
}
