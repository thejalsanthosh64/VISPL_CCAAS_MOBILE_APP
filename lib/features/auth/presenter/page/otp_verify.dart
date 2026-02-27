import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/timer_widget/timer_widget.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/auth/cubit/otp_verify_cubit/otp_verify_cubit.dart';
import 'package:kommuno/features/auth/presenter/widget/auth_container.dart';
import 'package:kommuno/features/auth/presenter/widget/common_forgot_password_bg.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:pinput/pinput.dart';

class OtpVerifyScreen extends StatelessWidget {
  const OtpVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // String? userName;
    // if (args?["forgotPasswordDetails"] is ForgotPasswordResponseModel) {
    //   userName = (args?["forgotPasswordDetails"] as ForgotPasswordResponseModel).username;
    // }

   final String? email = args?["email"];
    final String otpMethod = args?["otpMethod"] ?? "email";
    final String sendMessageVia = args?["sendMessageVia"] ?? "default";
    final String phone = args?["phone"];
    final int smeId = args?["smeId"];

    if (email == null || phone == null || smeId == null) {
      Future.microtask(() {
        FToastManager().showToast(
          message: AppLocalizations.of(context)!.usernameNotFound,
        );
        Navigator.of(context).pop();
      });
      return const SizedBox.shrink();
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
          BlocProvider(create: (__) => OtpVerifyCubit()
    ..init(
      otpMethod: otpMethod,
      sendMessageVia: sendMessageVia,
    ),),
        ],
        
  child: _OtpVerifyScreenState(
    email: email,
    phone: phone,
    smeId: smeId,
  ),
      ),
    );
  }
}

class _OtpVerifyScreenState extends StatelessWidget {
  const _OtpVerifyScreenState({
    required this.email,
    required this.phone,
    required this.smeId,
  });

  final String email;
  final String phone;
  final int smeId;

  @override
  Widget build(BuildContext context) {
    return CommonForgotPasswordBg(child: _buildOtpVerifyDialog());
  }

  Widget get _kSized15 => const SizedBox(height: AppConstant.kSized15);

  OtpVerifyCubit _otpVerifyCubit(BuildContext context) => context.read<OtpVerifyCubit>();


  Widget _buildOtpVerifyDialog() {
    
      return BlocConsumer<OtpVerifyCubit, OtpVerifyState>(
        listener: (context, state) {
          if (state.isOtpVerified) {
            Navigator.of(context).pushNamed(AppRouteNames.resetPasswordScreen, arguments: {"userName": email});
            _otpVerifyCubit(context).initialState();
          }
        },
        builder: (context, state) {
          return AuthContainer(
            onTapIcon: () {
              _otpVerifyCubit(context).verifyOtp(username: email, otp: _otpVerifyCubit(context).otpController.text);
            },
            containerBody: [
IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () async {
        final goBack = await goBackAlertDialog(context: context);
        if (goBack && context.mounted) {
          Navigator.of(context).pop();
        }
      },
    ),    const SizedBox(width: 8),


              Text(
                AppLocalizations.of(context)!.validateOTP,
                style: AppTextStyle.black25,
              ),
              _kSized15,
             Text(
  state.otpMethod == "sms"
      ? "${AppLocalizations.of(context)!.validateOTPDescription} ${AppValidation.maskPhone(phone)}"
      : "${AppLocalizations.of(context)!.validateOTPDescription} ${AppValidation.maskEmail(email)}",
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
                  durationInSec: 60,
                  restartTimer: !state.isTimeCompleted,
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: state.isTimeCompleted
    ? () {
       _otpVerifyCubit(context).resendOtp(
          email: email,
          phone: phone,
          smeId: smeId,
        );
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
      
    );
  }
}
