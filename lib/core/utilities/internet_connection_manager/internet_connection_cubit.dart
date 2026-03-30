import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'internet_connection_state.dart';

// class InternetConnectionCubit extends Cubit<InternetConnectionState> {
//   late StreamSubscription<InternetStatus> _internetListen;

//   bool _isInternetConnectionOpen = false;

//   bool checkLogin = true;

//   bool _listenConnection = false;

//   InternetConnectionCubit() : super(const InternetConnectionInitial()) {
//     _internetListen =
//         InternetConnection().onStatusChange.listen((InternetStatus status) {
//       if (_listenConnection) {
//         _listenConnectionState(status: status);
//       }
//     });
//   }

//   @override
//   Future<void> close() async {
//     _internetListen.cancel();
//     super.close();
//   }
// void _closeDialogIfOpen() {
//   final ctx = AppKeys.navigatorKey.currentContext;
//   if (_isInternetConnectionOpen &&
//       ctx != null &&
//       Navigator.of(ctx).canPop()) {
//     Navigator.of(ctx).pop();
//     _isInternetConnectionOpen = false;
//   }
// }

//   // Future<void> checkInitialConnectionState() async {
//   //   _listenConnection = true;
//   //   bool result = await InternetConnection().hasInternetAccess;
//   //   if (result) {
//   //     if (_isInternetConnectionOpen) {
//   //       _isInternetConnectionOpen = false;
//   //       Navigator.of(AppKeys.navigatorKey.currentContext!).pop();
//   //     }
//   //     emit(const InternetConnectedState());
//   //   } else {
//   //     emit(const InternetDisConnectedState());
//   //   }
//   // }
  
//   Future<void> checkInitialConnectionState() async {
//   _listenConnection = true;
//   final result = await InternetConnection().hasInternetAccess;

//   if (result) {
//     _closeDialogIfOpen();
//     emit(const InternetConnectedState());
//   } else {
//     emit(const InternetDisConnectedState());
//   }
// }


//   // Future<void> _listenConnectionState({required InternetStatus status}) async {
//   //   switch (status) {
//   //     case InternetStatus.connected:
//   //       if (_isInternetConnectionOpen) {
//   //         _isInternetConnectionOpen = false;
//   //         Navigator.of(AppKeys.navigatorKey.currentContext!).pop();
//   //       }
//   //       emit(const InternetConnectedState());
//   //       break;
//   //     case InternetStatus.disconnected:
//   //       emit(const InternetDisConnectedState());
//   //       break;
//   //   }
//   // }

// Future<void> _listenConnectionState({required InternetStatus status}) async {
//   if (status == InternetStatus.connected) {
//     _closeDialogIfOpen();
//     emit(const InternetConnectedState());
//   } else {
//     emit(const InternetDisConnectedState());
//   }
// }

//   // Future<void> checkConnectionDialog() async {
//   //   if (_isInternetConnectionOpen) return; 
//   //   _isInternetConnectionOpen = true;
//   //   await appDialog(
//   //     context: AppKeys.navigatorKey.currentContext!,
//   //     alertText: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//   //         .checkInternetConnection,
//   //     constraints: const BoxConstraints(maxHeight: 65),
//   //   );
//   //     _isInternetConnectionOpen = false;

//   // }
//   Future<void> checkConnectionDialog() async {
//   if (_isInternetConnectionOpen) return;

//   _isInternetConnectionOpen = true;

//   await appDialog(
//     context: AppKeys.navigatorKey.currentContext!,
//     alertText: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//         .checkInternetConnection,
//     constraints: const BoxConstraints(maxHeight: 65),
//   );

//   // dialog dismissed manually
//   _isInternetConnectionOpen = false;
// }

  
// }

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  late StreamSubscription<InternetStatus> _internetListen;
  Timer? _debounceTimer;

  bool _isInternetConnectionOpen = false;
  bool checkLogin = true;
  bool _listenConnection = false;

  InternetConnectionCubit() : super(const InternetConnectionInitial()) {
    _internetListen =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      if (_listenConnection) {
        _listenConnectionState(status: status);
      }
    });
  }

  @override
  Future<void> close() async {
    _internetListen.cancel();
    _debounceTimer?.cancel();
    super.close();
  }

  void _closeDialogIfOpen() {
    final ctx = AppKeys.navigatorKey.currentContext;
    if (_isInternetConnectionOpen &&
        ctx != null &&
        Navigator.of(ctx).canPop()) {
      Navigator.of(ctx).pop();
      _isInternetConnectionOpen = false;
    }
  }

  Future<void> checkInitialConnectionState() async {
    _listenConnection = true;
    final result = await InternetConnection().hasInternetAccess;

    if (result) {
      _closeDialogIfOpen();
      emit(const InternetConnectedState());
    } else {
      // Wait 2s and re-check before declaring disconnected
      await Future.delayed(const Duration(seconds: 2));
      final recheck = await InternetConnection().hasInternetAccess;
      if (recheck) {
        _closeDialogIfOpen();
        emit(const InternetConnectedState());
      } else {
        emit(const InternetDisConnectedState());
      }
    }
  }

  Future<void> _listenConnectionState({
    required InternetStatus status,
  }) async {
    if (status == InternetStatus.connected) {
      // Cancel any pending disconnect timer
      _debounceTimer?.cancel();
      _closeDialogIfOpen();
      emit(const InternetConnectedState());
    } else {
      // Wait 3 seconds before showing alert
      // Prevents false alerts from brief network blips
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(seconds: 3), () async {
        final stillDisconnected =
            !(await InternetConnection().hasInternetAccess);
        if (stillDisconnected) {
          emit(const InternetDisConnectedState());
        } else {
          debugPrint('⚡ Network blip — connection recovered');
        }
      });
    }
  }

  Future<void> checkConnectionDialog() async {
    if (_isInternetConnectionOpen) return;
    _isInternetConnectionOpen = true;

    await appDialog(
      context: AppKeys.navigatorKey.currentContext!,
      alertText: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
          .checkInternetConnection,
      constraints: const BoxConstraints(maxHeight: 71),
    );

    _isInternetConnectionOpen = false;
  }
}