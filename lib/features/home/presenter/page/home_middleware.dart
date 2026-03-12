import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/user_details_widget.dart';
import 'package:kommuno/core/network_manager/alive_set_service.dart';
import 'package:kommuno/core/network_manager/websocket_service.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/logout_manager.dart';
import 'package:kommuno/core/utilities/shortcuts/cubit/shortcuts_cubit.dart';
import 'package:kommuno/features/auth/data/repository/auth_repo.dart';
import 'package:kommuno/features/break/cubit/break_cubit.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/in_sights/cubit/in_sights_cubit/in_sights_cubit.dart';

class HomeMiddleware extends StatelessWidget {
  const HomeMiddleware({super.key});

  @override
  Widget build(BuildContext context) {
 
    // return PopScope(
    //   canPop: false,
    //   onPopInvokedWithResult: (didPop, result) async {
    //     if (!didPop && !AppLoadingIndicator.isLoading) {
    //       if (NestedRouteObserver.canPop) {
    //         Navigator.of(AppKeys.nestedNavigatorKey.currentContext!).pop();
    //       } else {
    //         final isExit = await exitAppDialog(context: context);
    //         if (isExit) {
    //           exit(0);
    //         }
    //       }
    //     }
    //   },
    //   child: MultiBlocProvider(
    //     providers: [
    //       BlocProvider(create: (__) => UserDetailsCubit()),
    //       BlocProvider(create: (__) => BreakCubit()),
    //       BlocProvider(create: (__) => ShortcutsCubit()),
    //                 BlocProvider(create: (_) => CallStateCubit()),
    //                 BlocProvider(create: (_) => InSightsCubit()),

    //     ],
    //     child: const _HomeMiddleWareState(),
    //   ),
    // );

    return MultiBlocProvider(
  providers: [
    BlocProvider(create: (__) => UserDetailsCubit()),
    BlocProvider(create: (__) => BreakCubit()),
    BlocProvider(create: (__) => ShortcutsCubit()),
    BlocProvider(create: (_) => CallStateCubit()),
    BlocProvider(create: (_) => InSightsCubit()),
  ],
  child: Builder(
    builder: (innerContext) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop && !AppLoadingIndicator.isLoading) {
            if (NestedRouteObserver.canPop) {
              Navigator.of(AppKeys.nestedNavigatorKey.currentContext!).pop();
            } else {
              final isExit = await exitAppDialog(context: innerContext);

             if (isExit) {
  // final cubit = UserDetailsCubit.instance;

  // if (cubit != null) {
          await LogoutManager.logoutAndExit(context: context);

  // }

  CallWebSocketManager.disconnectCallSocket();
  CallWebSocketManager.disconnectGlobal();
  AliveService().stop();

  SystemNavigator.pop(); //  Close app
}
            }
          }
        },
        child: const _HomeMiddleWareState(),
      );
    },
  ),
);
  }
}

class _HomeMiddleWareState extends StatelessWidget {
  const _HomeMiddleWareState();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: UserDetailsWidget(
        builder: (data) {
          return Navigator(
            key: AppKeys.nestedNavigatorKey,
            initialRoute: AppRouteNames.homeScreen,
            onGenerateRoute: AppRouterManager.generateNestedRoute,
            observers: [NestedRouteObserver()],
          );
        },
      ),
    );
  }
}
