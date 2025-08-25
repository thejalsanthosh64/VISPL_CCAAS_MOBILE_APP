import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

class FToastManager {
  FToast? _fToast;

  FToastManager._();

  static final _ins = FToastManager._();

  factory FToastManager() {
    return _ins;
  }

  void showToast({required String message}) {
    _fToast ??= FToast()..init(AppKeys.navigatorKey.currentContext!);
    _fToast?.removeQueuedCustomToasts();
    Widget toast = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: AppConstant.kCenterPadding),
        child: Text(
          message,
          style: AppTextStyle.blackNormal,
        ),
      ),
    );

    // Custom Toast Position
    _fToast?.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 2),
      isDismissible: true,
      fadeDuration: const Duration(milliseconds: 200),
      positionedToastBuilder: (context, child,gravity) {
        return Positioned(
          top: 0,
          child: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
