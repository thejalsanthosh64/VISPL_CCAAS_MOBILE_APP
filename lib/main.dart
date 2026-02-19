import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/local_storage/hive_service.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'core/common/app_keys.dart';
import 'core/common/app_theme/app_theme.dart';
import 'core/utilities/internet_connection_manager/internet_connection_cubit.dart';
import 'core/utilities/permission_handler/cubit/permission_handler_cubit.dart';
import 'core/utilities/permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  HiveService.initHive();
  await UserLoginInfoManager.clearLoginUserInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (__) => PermissionHandlerCubit()),
        BlocProvider(create: (__) => InternetConnectionCubit()),
      ],
      child: const _MyAppState(),
    );
  }
}

class _MyAppState extends StatelessWidget {
  const _MyAppState();

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetConnectionCubit, InternetConnectionState>(
      listener: (__, state) {
        if (state is InternetDisConnectedState) {
          context.read<InternetConnectionCubit>().checkConnectionDialog();
        } else if (state is InternetConnectedState) {
          if (context.read<InternetConnectionCubit>().checkLogin) {
            checkLogin(AppKeys.navigatorKey.currentContext!);
            context.read<InternetConnectionCubit>().checkLogin = false;
          }
        }
      },
      child: BlocListener<PermissionHandlerCubit, PermissionHandlerState>(
        listener: (__, state) {
          if (state is DeniedDisplayOverApps) {
            AppPermissionHandler.displayOverApps();
          } else if (state is DeniedRequiredPermissionsState) {
            AppPermissionHandler.requiredPermission(
                permission: state.permission);
          } else if (state is AllPermissionsGranted) {
            if (context.read<InternetConnectionCubit>().state
                is InternetConnectionInitial) {
              context
                  .read<InternetConnectionCubit>()
                  .checkInitialConnectionState();
            }
          }
        },
        listenWhen: (previous, newState) {
          return previous != newState;
        },
        child: MaterialApp(
          key: AppKeys.materialAppKey,
          builder: FToastBuilder(),
          debugShowCheckedModeBanner: false,
          title: AppConstant.applicationName,
          theme: AppTheme.appTheme(context),
          navigatorKey: AppKeys.navigatorKey,
          scaffoldMessengerKey: AppKeys.scaffoldMessengerKey,
          initialRoute: AppRouteNames.splashScreen,
          onGenerateRoute: AppRouterManager.generateMainRoute,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        ),
      ),
    );
  }
}
