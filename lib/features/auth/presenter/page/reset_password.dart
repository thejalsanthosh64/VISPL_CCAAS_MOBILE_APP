import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/features/auth/cubit/reset_password_cubit/reset_password_cubit.dart';
import 'package:kommuno/features/auth/presenter/widget/auth_container.dart';
import 'package:kommuno/features/auth/presenter/widget/auth_text_field.dart';
import 'package:kommuno/features/auth/presenter/widget/common_forgot_password_bg.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String? userName;
    if (args?["userName"] is String) {
      userName = args?["userName"];
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
      child: BlocProvider(
        create: (__) => ResetPasswordCubit(),
        child: _ResetPasswordScreenState(userName: userName ?? ''),
      ),
    );
  }
}

class _ResetPasswordScreenState extends StatelessWidget {
  const _ResetPasswordScreenState({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    return CommonForgotPasswordBg(
      child: _buildResetPasswordDialog(),
    );
  }

  Widget get _kSized15 => const SizedBox(height: AppConstant.kSized15);

  ResetPasswordCubit _resetPasswordCubit(BuildContext context) => context.read<ResetPasswordCubit>();

  Widget _buildResetPasswordDialog() {
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.isPasswordChanged) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouteNames.loginScreen, (predicate) => false);
        }
      },
      builder: (context, state) {
        return AuthContainer(
          containerBody: [
            Text(
              AppLocalizations.of(context)!.newPassword,
              style: AppTextStyle.black25,
            ),
            _kSized15,
            AuthTextField(
              controller: _resetPasswordCubit(context).passwordController,
              obscureText: !state.isPasswordVisible,
              hintText: AppLocalizations.of(context)!.newPassword,
              prefixIcon: const Icon(Icons.lock_outline_sharp),
              textInputAction: TextInputAction.next,
              suffixIcon: IconButton(
                onPressed: () {
                  _resetPasswordCubit(context).changePasswordVisibility(!state.isPasswordVisible);
                },
                icon: state.isPasswordVisible ? const Icon(Icons.visibility_sharp) : const Icon(Icons.visibility_off_sharp),
              ),
            ),
            _kSized15,
            AuthTextField(
              controller: _resetPasswordCubit(context).confirmPasswordController,
              obscureText: !state.isConfirmPasswordVisible,
              hintText: AppLocalizations.of(context)!.confirmPassword,
              prefixIcon: const Icon(Icons.lock_outline_sharp),
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                onPressed: () {
                  _resetPasswordCubit(context).changeConfirmPasswordVisibility(!state.isConfirmPasswordVisible);
                },
                icon: state.isConfirmPasswordVisible ? const Icon(Icons.visibility_sharp) : const Icon(Icons.visibility_off_sharp),
              ),
            ),
            _kSized15,
            const SizedBox(height: AppConstant.kSized20),
          ],
          onTapIcon: () {
            _resetPasswordCubit(context).resetPassword(
                password: _resetPasswordCubit(context).passwordController.text,
                confirmPassword: _resetPasswordCubit(context).confirmPasswordController.text,
                userName: userName);
          },
        );
      },
    );
  }
}
