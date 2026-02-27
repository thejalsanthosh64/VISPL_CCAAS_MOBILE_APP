part of 'forget_password_cubit.dart';

// final class ForgetPasswordState extends Equatable {
//   const ForgetPasswordState({this.forgotPasswordDetails});

//   final ForgotPasswordResponseModel? forgotPasswordDetails;

//   @override
//   List<Object?> get props => [forgotPasswordDetails];
// }

class ForgetPasswordState extends Equatable {
  const ForgetPasswordState({
    this.email,
    this.smeId,
    this.phone,
    this.sendMessageVia,
    this.otpMethod,
    this.showMethodSelector = false,
    this.navigateToOtp = false,
  });

  final String? email;
  final int? smeId;
  final String? phone;
  final String? sendMessageVia;
  final String? otpMethod; // 👈 email | sms
  final bool showMethodSelector;
  final bool navigateToOtp;

  ForgetPasswordState copyWith({
    String? email,
    int? smeId,
    String? phone,
    String? sendMessageVia,
    String? otpMethod,
    bool? showMethodSelector,
    bool? navigateToOtp,
  }) {
    return ForgetPasswordState(
      email: email ?? this.email,
      smeId: smeId ?? this.smeId,
      phone: phone ?? this.phone,
      sendMessageVia: sendMessageVia ?? this.sendMessageVia,
      otpMethod: otpMethod ?? this.otpMethod,
      showMethodSelector: showMethodSelector ?? this.showMethodSelector,
      navigateToOtp: navigateToOtp ?? this.navigateToOtp,
    );
  }

  @override
  List<Object?> get props =>
      [email, smeId, phone, sendMessageVia, otpMethod, showMethodSelector, navigateToOtp];
}