part of 'reset_password_cubit.dart';

final class ResetPasswordState extends Equatable {
  const ResetPasswordState({
    this.isConfirmPasswordVisible = false,
    this.isPasswordVisible = false,
    this.isPasswordChanged = false,
  });

  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isPasswordChanged;

  ResetPasswordState copyWith({
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isPasswordChanged,
  }) {
    return ResetPasswordState(
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isPasswordChanged: isPasswordChanged ?? this.isPasswordChanged,
    );
  }

  @override
  List<Object?> get props =>
      [isPasswordVisible, isConfirmPasswordVisible, isPasswordChanged];
}
