import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_svg_picture.dart';
import 'package:kommuno/core/common/widget/hide_keyboard_widget.dart';
import 'package:kommuno/features/auth/cubit/login_cubit/login_cubit.dart';
import 'package:kommuno/features/auth/presenter/widget/auth_container.dart';
import 'package:kommuno/features/auth/presenter/widget/auth_text_field.dart';
import 'package:kommuno/generated/assets.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (__) => LoginCubit(),
      child: const _LoginScreenState(),
    );
  }
}

class _LoginScreenState extends StatelessWidget {
  const _LoginScreenState();

  @override
  Widget build(BuildContext context) {
    return HideKeyboardWidget(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          decoration:  const BoxDecoration(
            color: AppColors.appColor,
            image: DecorationImage(
              image: AssetImage(Assets.imagesLoginBg),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                AppColors.appColor,
                BlendMode.lighten,
              ),
            ),
          ),
          
          child: _buildLoginDialog(),
        ),
      ),
    );
  }

  Widget get _kSized15 => const SizedBox(height: AppConstant.kSized15);

  LoginCubit _loginCubit(BuildContext context) => context.read<LoginCubit>();

  Widget _buildLoginDialog() {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.isUserLoginSuccess) {
          
          Navigator.of(context)
              .pushReplacementNamed(AppRouteNames.assignCampaign);


          // Navigator.of(context).pushReplacementNamed(AppRouteNames.homeMiddleware);
        }
      },
      builder: (context, state) {
        return AuthContainer(
          containerBody: [
            Row(
              children: [
                Text(
                  AppLocalizations.of(context)!.pleaseLogin,
                  style: AppTextStyle.black25,
                ),            const SizedBox(width: AppConstant.kSized10),

                             const Text(
      "v1.0.22",
      style: TextStyle(
        color: Colors.black,
        fontSize: 12,
      ),
    ),
              ],
            ),
            _kSized15,
            AuthTextField(
              controller: _loginCubit(context).userNameController,
              hintText: AppLocalizations.of(context)!.enterUsername,
              prefixIcon:  const AppSvgPicture(
                assetName: Assets.iconsEmail,
                color: AppColors.appColor,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            _kSized15,
            AuthTextField(
              controller: _loginCubit(context).passwordController,
              obscureText: !state.isPasswordVisible,
              hintText: AppLocalizations.of(context)!.enterPassword,
              prefixIcon: const Icon(Icons.lock_outline_sharp),
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                onPressed: () {
                  _loginCubit(context)
                      .changePasswordVisibility(!state.isPasswordVisible);
                },
                icon: state.isPasswordVisible
                    ? const Icon(Icons.visibility_sharp)
                    : const Icon(Icons.visibility_off_sharp),
              ),
            ),
            _kSized15,
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRouteNames.forgetPasswordScreen);
              },
              child: Text("${AppLocalizations.of(context)!.forgotPassword}?"),
            ),
            const SizedBox(height: AppConstant.kSized5),

          ],
          onTapIcon: () {
            _loginCubit(context).loginUser(
                username: _loginCubit(context).userNameController.text,
                password: _loginCubit(context).passwordController.text);
          },
        );
      },
    );
  }
}
