import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/user_details_widget.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/shortcuts/cubit/shortcuts_cubit.dart';
import 'package:kommuno/features/break/cubit/break_cubit.dart';

class HomeMiddleware extends StatelessWidget {
  const HomeMiddleware({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && !AppLoadingIndicator.isLoading) {
          if (NestedRouteObserver.canPop) {
            Navigator.of(AppKeys.nestedNavigatorKey.currentContext!).pop();
          } else {
            final isExit = await exitAppDialog(context: context);
            if (isExit) {
              exit(0);
            }
          }
        }
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (__) => UserDetailsCubit()),
          BlocProvider(create: (__) => BreakCubit()),
          BlocProvider(create: (__) => ShortcutsCubit()),
        ],
        child: const _HomeMiddleWareState(),
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
