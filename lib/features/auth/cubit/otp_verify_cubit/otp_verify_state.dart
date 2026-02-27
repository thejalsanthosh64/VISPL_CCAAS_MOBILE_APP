part of 'otp_verify_cubit.dart';
final class OtpVerifyState extends Equatable {
  final bool isTimeCompleted;
  final bool isOtpVerified;
  final String otpMethod; // email | sms
  final String sendMessageVia;

  const OtpVerifyState({
    this.isTimeCompleted = false,
    this.isOtpVerified = false,
    this.otpMethod = "email",
    this.sendMessageVia = "default",
  });

  OtpVerifyState copyWith({
    bool? isTimeCompleted,
    bool? isOtpVerified,
    String? otpMethod,
    String? sendMessageVia,
  }) {
    return OtpVerifyState(
      isTimeCompleted: isTimeCompleted ?? this.isTimeCompleted,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
      otpMethod: otpMethod ?? this.otpMethod,
      sendMessageVia: sendMessageVia ?? this.sendMessageVia,
    );
  }

  @override
  List<Object?> get props =>
      [isTimeCompleted, isOtpVerified, otpMethod, sendMessageVia];
}