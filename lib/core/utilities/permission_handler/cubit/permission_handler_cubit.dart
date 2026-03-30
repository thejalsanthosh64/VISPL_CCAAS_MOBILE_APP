import 'dart:async';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/utilities/permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_handler_state.dart';

class PermissionHandlerCubit extends Cubit<PermissionHandlerState>
    with WidgetsBindingObserver {
  int _delayDuration = 2;

  late Timer _timer;

  AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;
  // bool _contactsPermissionRequested = false;


  PermissionHandlerCubit() : super(const PermissionHandlerInitial()) {
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(Duration(seconds: _delayDuration), (timer) {
      if (_appLifecycleState == AppLifecycleState.resumed) {
        _checkPermission();
      }
    });
  }

  @override
  Future<void> close() async {
    _timer.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.close();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifecycleState = state;
  }

  Future<void> _checkPermission() async {
    final systemAlertWindowStatus = Platform.isAndroid
        ? await Permission.systemAlertWindow.status
        : PermissionStatus.granted;

    if (!systemAlertWindowStatus.isGranted) {
      if (state is! DeniedDisplayOverApps) {
        _delayDuration = 2;
        emit(const DeniedDisplayOverApps());
      }
      return;
    } else if (AppPermissionHandler.isOpenDisplayOverApp) {
      AppPermissionHandler.isOpenDisplayOverApp = false;
      Navigator.of(AppKeys.navigatorKey.currentContext!).pop();
    }

    const phonePermission = Permission.phone;
    final phoneStatus = Platform.isAndroid
        ? await phonePermission.status
        : PermissionStatus.granted;
    if (!phoneStatus.isGranted) {
      if (state is! DeniedRequiredPermissionsState ||
          (state is DeniedRequiredPermissionsState &&
              (state as DeniedRequiredPermissionsState).permission !=
                  phonePermission)) {
        _delayDuration = 2;
        emit(const DeniedRequiredPermissionsState(permission: phonePermission));
      }
      return;
    }

    // const contactsPermission = Permission.contacts;
    // final contactsStatus = await contactsPermission.status;

    // if (!contactsStatus.isGranted) {
    //   if (state is! DeniedRequiredPermissionsState ||
    //       (state is DeniedRequiredPermissionsState &&
    //           (state as DeniedRequiredPermissionsState).permission !=
    //               contactsPermission)) {
    //     _delayDuration = 2;
    //     emit(const DeniedRequiredPermissionsState(
    //         permission: contactsPermission));
    //   }
    //   return;
    // }

  //  const contactsPermission = Permission.contacts;
// final contactsStatus = await contactsPermission.status;

// if (contactsStatus.isDenied && !_contactsPermissionRequested) {
//   _contactsPermissionRequested = true;

//   final result = await contactsPermission.request();

//   if (!result.isGranted) {
//     FToastManager().showToast(
//       message: AppLocalizations.of(
//   AppKeys.navigatorKey.currentContext!,
// )!.contactsPermissionDenied,
//     );
//   }
// }

    if (AppPermissionHandler.isOpenRequiredPermission) {
      AppPermissionHandler.isOpenRequiredPermission = false;
      Navigator.of(AppKeys.navigatorKey.currentContext!).pop();
    }

    if (state is! AllPermissionsGranted) {
      _delayDuration = 5;
      emit(const AllPermissionsGranted());
    }
  }
  
}
