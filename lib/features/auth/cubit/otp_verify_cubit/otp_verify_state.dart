part of 'otp_verify_cubit.dart';

final class OtpVerifyState extends Equatable {
  final bool isTimeCompleted;
  final bool isOtpVerified;

  const OtpVerifyState({
    this.isTimeCompleted = false,
    this.isOtpVerified = false,
  });

  OtpVerifyState copyWith({
    bool? isTimeCompleted,
    bool? isOtpVerified,
  }) {
    return OtpVerifyState(
      isTimeCompleted: isTimeCompleted ?? this.isTimeCompleted,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
    );
  }

  @override
  List<Object?> get props => [isTimeCompleted, isOtpVerified];
}
