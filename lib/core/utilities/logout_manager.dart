import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/core/utilities/local_storage/hive_service.dart';
import 'package:kommuno/core/utilities/secure_storage/secure_storage.dart';
import 'package:kommuno/features/auth/data/repository/auth_repo.dart';

import 'user_login_info_manager/user_login_info_manager.dart';

abstract class LogoutManager {
  static Future<void> logoutDialog({required BuildContext context}) async {
    appDialog(
      context: context,
      insetPadding: const EdgeInsets.symmetric(horizontal: 50),
      customBody: Padding(
        padding: const EdgeInsets.only(left: 20, top: 18, bottom: 18),
        child: Row(
          children: [
            Flexible(child: FittedBox(child: Text(AppLocalizations.of(context)!.logoutDes))),
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Icon(
                CupertinoIcons.question,
                color: AppColors.black,
                size: 13,
              ),
            )
          ],
        ),
      ),
      actions: (ctx) {
        return [
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
            },
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          TextButton(
            onPressed: () {
              logoutUser(context: ctx);
            },
            child: Text(AppLocalizations.of(ctx)!.logout),
          ),
          const SizedBox(width: 15),
        ];
      },
    );
  }

  static Future<void> logoutUser({required BuildContext context}) async {
    AppLoadingIndicator.showLoadingIndicator();
    try {
      final res = await AuthRepo().logoutUser(
        username: UserLoginInfoManager.userLoginInfoModel?.username ?? "",
        mode: AppConstant.loginDeviceType,
      );

      if (res.isSuccess) {
        UserLoginInfoManager.setLoginUserInfo(userInfo: null);
        CampaignManager.setCampaignInfo(campaign: null);
        for (var key in StorageEnum.values) {
          SecureStorage().deleteData(key: key.name);
        }
        await HiveService.deleteAll();
        if (context.mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRouteNames.loginScreen, (settings) => false);
        }
      } else {
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      debugPrint("LogoutManager $e");
      debugPrint("$s");
      if (context.mounted) {
        FToastManager().showToast(message: AppLocalizations.of(context)!.somethingWentWrong);
      }
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
