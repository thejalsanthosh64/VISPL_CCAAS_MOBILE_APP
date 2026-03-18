import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/network_manager/alive_set_service.dart';
import 'package:kommuno/core/utilities/secure_storage/secure_storage.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/auth/data/model/login_request_model.dart';
import 'package:kommuno/features/auth/data/repository/auth_repo.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
LoginCubit() : super(const LoginState()) {
    _loadLastUsername();
  }
  final userNameController = TextEditingController(text: kDebugMode ? "boffincodersprojects@gmail.com" : '');
  final passwordController = TextEditingController(text: kDebugMode ? "123456" : '');

  final _authRepo = AuthRepo();

  @override
  Future<void> close() {
    userNameController.dispose();
    passwordController.dispose();
    return super.close();
  }

  void changePasswordVisibility(bool isVisible) {
    emit(state.copyWith(isPasswordVisible: isVisible));
  }

  Future<void> loginUser({required String username, required String password}) async {
    try {
      if (AppValidation.isEmpty(username)) {
        FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.pleaseEnterYourUsername);
      } else if (!AppValidation.isValidEmail(username)) {
        FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.invalidUsername);
      } else if (AppValidation.isEmpty(password)) {
        FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.pleaseEnterYourPassword);
      } else {
        hideKeyboard();
        AppLoadingIndicator.showLoadingIndicator();

        final res = await _authRepo.loginUser(
          loginRequestModel: LoginRequestModel(
          password: password,
          username: username,
          deviceType: AppConstant.loginDeviceType,
        ));

 if (!res.isSuccess) {
      AppLoadingIndicator.dismissLoadingIndicator();
      FToastManager().showToast(message: res.message);
      return;
    }
await SecureStorage().writeData(key: 'last_saved_username', value: username);
      await UserLoginInfoManager.setLoginUserInfo(
        userInfo: res.data,
      );
  final userDetails = await _authRepo.getTypeDetail(
  username: username,
);

//  INACTIVE AGENT
if (userDetails.agentStatus == 0) {
  AppLoadingIndicator.dismissLoadingIndicator();

  FToastManager().showToast(
    message: "Account is inactive! Please contact your Admin",
  );

  return; 
}

 final aliveRes = await _authRepo.checkIsAlive(username: username);

      if (aliveRes.status == 1 &&
          aliveRes.message.toLowerCase() == "already login") {
        AppLoadingIndicator.dismissLoadingIndicator();

        FToastManager().showToast(
          message: "Agent already logged in",
        );
        return;
      }

      final user = UserLoginInfoManager.userLoginInfoModel!;
// final whiteLabelData = await _authRepo.getWhiteLabelDetails(
//   smeId: user.smeId,
// );

// if (whiteLabelData != null) {
//   final model = WhiteLabelModel.fromJson(whiteLabelData);
//   AppKeys.navigatorKey.currentContext!
//       .read<WhiteLabelCubit>()
//       .applyWhiteLabel(model);
// }
      AliveService().sendLogin(username: user.username);

      await ActivityHelperRepo().setActivityLogs(
        user.smeId,
        userRole: user.role,
        moduleName: "auth",
        action: "login",
        message: "${user.username} Successfully Logged In",
        agentId: user.userId,
      );

      await ActivityHelperRepo().updateAgentActivityTime(
        smeId: user.smeId,
        agentId: user.userId,
        time: 0,
        status: "Login",
      );

      emit(state.copyWith(isUserLoginSuccess: true));

//         if (res.isSuccess) {

//           await UserLoginInfoManager.setLoginUserInfo(userInfo: res.data);

// // // Call Ready-To-Take-Call API
// // await _authRepo.updateReadyToTakeCall(
// //   agentId: user.userId,
// // );

//           // emit(state.copyWith(isUserLoginSuccess: true));
//         } else {
//           FToastManager().showToast(message: res.message);
//         }

//          final aliveRes = await _authRepo.checkIsAlive(
//       username: username,
//     );

//     if (aliveRes.status == 1 &&
//         aliveRes.message.toLowerCase() == "already login") {
//       AppLoadingIndicator.dismissLoadingIndicator();

//       FToastManager().showToast(
//         message: "Agent already logged in",
//       );
//       return; 
//     }
//           final user = UserLoginInfoManager.userLoginInfoModel!;

// AliveService().sendLogin(
//     username: user.username,
//   );
    
// await ActivityHelperRepo().setActivityLogs(
//   user.smeId,
//   userRole: user.role,
//   moduleName: "auth",
//   action: "login",
//   message: "${user.username} Successfully Logged In",
//   agentId: user.userId,
// );

// await ActivityHelperRepo().updateAgentActivityTime(
//   smeId: user.smeId,
//   agentId: user.userId,
//   time: 0,
//   status: "Login",
// );


//                     emit(state.copyWith(isUserLoginSuccess: true));

      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.somethingWentWrong);
      debugPrint("LoginCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }

Future<void> _loadLastUsername() async {
    try {
      final savedUsername = await SecureStorage().readData(key: 'last_saved_username');
      
      if (savedUsername != null && savedUsername.toString().isNotEmpty) {
        userNameController.text = savedUsername.toString();
      }
      
    } catch (e) {
      debugPrint("Failed to load last username: $e");
    }
  }

}
