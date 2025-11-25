import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/features/auth/cubit/forget_password_cubit/forget_password_cubit.dart';
import 'package:kommuno/features/auth/presenter/widget/auth_text_field.dart';
import 'package:kommuno/features/auth/presenter/widget/common_forgot_password_bg.dart';
import 'package:kommuno/generated/assets.dart';
import '../widget/auth_container.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (__) => ForgetPasswordCubit(),
      child: const _ForgetPasswordScreenState(),
    );
  }
}

class _ForgetPasswordScreenState extends StatelessWidget {
  const _ForgetPasswordScreenState();

  @override
  Widget build(BuildContext context) {
    return CommonForgotPasswordBg(
      child: _buildForgotDialog(context: context),
    );
  }

  Widget get _kSized15 => const SizedBox(height: AppConstant.kSized15);

  Widget get _kSized20 => const SizedBox(height: AppConstant.kSized20);

  ForgetPasswordCubit _forgetPasswordCubit(BuildContext context) =>
      context.read<ForgetPasswordCubit>();

  Widget _buildForgotDialog({required BuildContext context}) {
    return BlocListener<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (__, state) {
        if (state.forgotPasswordDetails != null) {
          Navigator.of(context).pushNamed(AppRouteNames.otpVerifyScreen,
              arguments: {
                "forgotPasswordDetails": state.forgotPasswordDetails
              });
          _forgetPasswordCubit(context).initialState();
        }
      },
      child: AuthContainer(
        containerBody: [
          Text(
            AppLocalizations.of(context)!.forgotPassword,
            style: AppTextStyle.black25,
          ),
          _kSized15,
          Text(
            AppLocalizations.of(context)!.forgotPasswordDescription,
            style: AppTextStyle.grey18,
          ),
          _kSized20,
          AuthTextField(
            controller: _forgetPasswordCubit(context).userNameController,
            keyboardType: TextInputType.emailAddress,
            hintText: AppLocalizations.of(context)!.enterUsername,
            prefixIcon: const AppSvgPicture(
              assetName: Assets.iconsEmail,
              color: AppColors.appColor,
            ),
            textInputAction: TextInputAction.done,
          ),
          _kSized15,
          _kSized20,
        ],
        onTapIcon: () {
          _forgetPasswordCubit(context).forgotPassword(
              userName: _forgetPasswordCubit(context).userNameController.text);
        },
        endChildren: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              AppLocalizations.of(context)!.backToLogin,
              style: AppTextStyle.white25,
            ),
          ),
          _kSized20,
        ],
        childrenWithScroll: [
          Text(
            AppLocalizations.of(context)!.otpDescription,
            style: AppTextStyle.whiteNormal.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          _kSized15,
        ],
      ),
    );
  }
}
