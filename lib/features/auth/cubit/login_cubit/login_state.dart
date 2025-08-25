part of 'login_cubit.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.isPasswordVisible = false,
    this.isUserLoginSuccess = false,
  });

  final bool isPasswordVisible;
  final bool isUserLoginSuccess;

  LoginState copyWith({
    bool? isPasswordVisible,
    bool? isUserLoginSuccess,
  }) {
    return LoginState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isUserLoginSuccess: isUserLoginSuccess ?? this.isUserLoginSuccess,
    );
  }

  @override
  List<Object?> get props => [isPasswordVisible, isUserLoginSuccess];
}
