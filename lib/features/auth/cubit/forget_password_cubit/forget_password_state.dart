part of 'forget_password_cubit.dart';

final class ForgetPasswordState extends Equatable {
  const ForgetPasswordState({this.forgotPasswordDetails});

  final ForgotPasswordResponseModel? forgotPasswordDetails;

  @override
  List<Object?> get props => [forgotPasswordDetails];
}
