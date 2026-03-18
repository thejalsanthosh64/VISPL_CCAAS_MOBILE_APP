import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionHandler extends WidgetsBindingObserver {
  AppPermissionHandler._();

  static final AppPermissionHandler _instance = AppPermissionHandler._();

  factory AppPermissionHandler() {
    return _instance;
  }

  static bool isOpenDisplayOverApp = false;

  static bool isOpenRequiredPermission = false;

  static AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;

  static Future<void> displayOverApps() async {
    isOpenDisplayOverApp = true;
    await appDialog(
      context: AppKeys.navigatorKey.currentContext!,
      alertText: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
          .displayOverApps,
      actions: (ctx) => [
        TextButton(
          onPressed: () async {
            await openAppSettings();
          },
          child: Text(AppLocalizations.of(ctx)!.ok),
        )
      ],
    );
  }

  static Future<void> requiredPermission({
    required Permission permission,
  }) async {
    PermissionStatus status = await permission.request();
    if (status.isGranted) {
      return;
    } else if (status.isDenied && await permission.shouldShowRequestRationale) {
      status = await permission.request();
    }

    if (!status.isGranted) {
      isOpenRequiredPermission = true;
      await appDialog(
        context: AppKeys.navigatorKey.currentContext!,
        alertText: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .allPermission,
        actions: (ctx) => [
          TextButton(
            onPressed: () async {
              // exit(0);

SystemNavigator.pop();            },
            child: Text(AppLocalizations.of(ctx)!.exit),
          ),
          TextButton(
            onPressed: () async {
              await openAppSettings();
            },
            child: Text(AppLocalizations.of(ctx)!.ok),
          )
        ],
      );
    }
  }

  static Future<bool> checkPermission(
      {required Permission permission, required BuildContext context}) async {
    PermissionStatus? status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied && await permission.shouldShowRequestRationale) {
      status = await permission.request();
      return status.isGranted;
    } else {
      _appLifecycleState = AppLifecycleState.resumed;
      WidgetsBinding.instance.addObserver(AppPermissionHandler());
      if (context.mounted) {
        status = await appDialog<PermissionStatus>(
          context: context,
          alertText: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .allPermission,
          actions: (ctx) => [
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop(PermissionStatus.denied);
              },
              child: Text(AppLocalizations.of(ctx)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                await openAppSettings();
                final completer = Completer<PermissionStatus>();
                bool isCompleted = false;
                final timer =
                    Timer.periodic(const Duration(seconds: 3), (timer) async {
                  if (_appLifecycleState == AppLifecycleState.resumed &&
                      !isCompleted) {
                    isCompleted = true;
                    completer.complete(await permission.status);
                  }
                });
                final status = await completer.future;
                timer.cancel();
                if (ctx.mounted) {
                  Navigator.of(ctx).pop(status);
                }
              },
              child: Text(AppLocalizations.of(ctx)!.ok),
            )
          ],
        );
      }
      WidgetsBinding.instance.removeObserver(AppPermissionHandler());
    }
    return status?.isGranted ?? false;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
    super.didChangeAppLifecycleState(state);
  }
}
