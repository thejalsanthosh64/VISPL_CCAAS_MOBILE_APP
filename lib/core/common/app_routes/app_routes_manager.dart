import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/shortcuts/cubit/shortcuts_cubit.dart';
import 'package:kommuno/core/utilities/shortcuts/enum/shortcuts_enum.dart';
import 'package:kommuno/features/assigned_calls/presenter/page/assigned_calls_screen.dart';
import 'package:kommuno/features/auth/presenter/page/forget_password.dart';
import 'package:kommuno/features/auth/presenter/page/login_screen.dart';
import 'package:kommuno/features/auth/presenter/page/otp_verify.dart';
import 'package:kommuno/features/auth/presenter/page/reset_password.dart';
import 'package:kommuno/features/calls/presenter/page/call_screen.dart';
import 'package:kommuno/features/calls/presenter/page/call_wrapup_.dart';
import 'package:kommuno/features/campaigns/presenter/page/campaign_list.dart';
import 'package:kommuno/features/contact/presenter/page/add_update_contact.dart';
import 'package:kommuno/features/contact/presenter/page/contact_list.dart';
import 'package:kommuno/features/dial/presenter/page/dial_screen.dart';
import 'package:kommuno/features/follow_up/presenter/page/follow_up_screen.dart';
import 'package:kommuno/features/home/presenter/page/home_middleware.dart';
import 'package:kommuno/features/home/presenter/page/home_screen.dart';
import 'package:kommuno/features/in_sights/presenter/page/in_sights.dart';
import 'package:kommuno/features/leads/presenter/page/leads_details.dart';
import 'package:kommuno/features/leads/presenter/page/leads_screen.dart';
import 'package:kommuno/features/recent_calls/presenter/page/recent_calls.dart';
import 'package:kommuno/features/remarks/presenter/page/remarks.dart';
import 'package:kommuno/features/schedule_call/presenter/page/add_schedule_call.dart';
import 'package:kommuno/features/splash_screen.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'app_route_names.dart';

part 'nested_router_observer.dart';

abstract interface class AppRouterManager {
  static Route<dynamic> generateMainRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.splashScreen:
        return _GeneratePageRoute(widget: const SplashScreen(), settings: settings);
      case AppRouteNames.loginScreen:
        return _GeneratePageRoute(widget: const LoginScreen(), settings: settings);
      case AppRouteNames.forgetPasswordScreen:
        return _GeneratePageRoute(widget: const ForgetPasswordScreen(), settings: settings);
      case AppRouteNames.otpVerifyScreen:
        return _GeneratePageRoute(widget: const OtpVerifyScreen(), settings: settings);
      case AppRouteNames.resetPasswordScreen:
        return _GeneratePageRoute(widget: const ResetPasswordScreen(), settings: settings);
      case AppRouteNames.homeMiddleware:
        return _GeneratePageRoute(widget: const HomeMiddleware(), settings: settings);
      case AppRouteNames.assignCampaign:
        return _GeneratePageRoute(widget: const CampaignList(), settings: settings);
      default:
        return _GeneratePageRoute(widget: NoRouteFoundScreen(settings: settings), settings: settings);
    }
  }

  static Route<dynamic> generateNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRouteNames.contactList:
        return _GeneratePageRoute(widget: const ContactList(), settings: settings);
      case AppRouteNames.addUpdateContact:
        return _GeneratePageRoute(widget: const AddUpdateContact(), settings: settings);
      case AppRouteNames.homeScreen:
        return _GeneratePageRoute(widget: const HomeScreen(), settings: settings);
      case AppRouteNames.dialScreen:
        return _GeneratePageRoute(widget: const DialScreen(), settings: settings);
         case AppRouteNames.activeScreen:
        return _GeneratePageRoute(widget: const AfterCallWrapUpScreen(callerName: "test",duration: Duration(seconds: 2),phoneNumber: "8921388124",), settings: settings);
      case AppRouteNames.leads:
        return _GeneratePageRoute(widget: const LeadsScreen(), settings: settings);
      case AppRouteNames.leadsDetails:
        return _GeneratePageRoute(widget: const LeadsDetails(), settings: settings);
      case AppRouteNames.followUp:
        return _GeneratePageRoute(widget: const FollowUpScreen(), settings: settings);
      case AppRouteNames.addScheduleCall:
        return _GeneratePageRoute(widget: const AddScheduleCall(), settings: settings);
      case AppRouteNames.inSights:
        return _GeneratePageRoute(widget: const InSightsScreen(), settings: settings);
      case AppRouteNames.assignedCalls:
        return _GeneratePageRoute(widget: const AssignedCallsScreen(), settings: settings);
      case AppRouteNames.recentCalls:
        return _GeneratePageRoute(widget: const RecentCalls(), settings: settings);
      case AppRouteNames.remarks:
        return _GeneratePageRoute(widget: const RemarksScreen(), settings: settings);
      case AppRouteNames.switchCampaign:
        return _GeneratePageRoute(widget: const CampaignList(), settings: settings);
      default:
        return _GeneratePageRoute(widget: NoRouteFoundScreen(settings: settings), settings: settings);
    }
  }
}

final class _GeneratePageRoute<T> extends CupertinoPageRoute<T> {
  final Widget widget;

  _GeneratePageRoute({required this.widget, required super.settings})
      : super(builder: (BuildContext context) {
          return widget;
        });
}

final class NoRouteFoundScreen extends StatelessWidget {
  const NoRouteFoundScreen({super.key, required this.settings});

  final RouteSettings settings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              '${AppConstant.noRouteDefined} ${settings.name}',
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                checkLogin(context);
              },
              child: Text(AppLocalizations.of(context)!.goBack),
            )
          ],
        ),
      ),
    );
  }
}
