import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/calls/data/model/long_codes_for_call_data.dart';
import 'package:kommuno/features/calls/data/model/new_call_request_model.dart';
import 'package:kommuno/features/calls/data/repository/call_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CallManager {
  static final _callsRepo = CallsRepo();

  static Future<void> makeNewCall({required String number}) async {
    try {
      final userDetails = (AppKeys.nestedNavigatorKey.currentContext!
              .read<UserDetailsCubit>()
              .state as UserDetailsSuccessState)
          .userDetailsModel;

      if (userDetails.outPermissionFlag != 1) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .outgoingPermissionMsg);
      } else if (userDetails.status == 0) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .currentlyInactiveMsg);
      } else if (userDetails.status == 4) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .onBreakMsg);
      } else {
        AppLoadingIndicator.showLoadingIndicator();
        final longCodesResponse = await _callsRepo.getLongCodesForCall(
          smeId: "${userDetails.smeId}",
          campaignId: CampaignManager.campaign?.id ?? "",
        );
        if (longCodesResponse.isSuccess) {
          final longCodesForCallData =
              LongCodesForCallData.fromJson(Map.from(longCodesResponse.data));
          final now = DateTime.now();
          final newCallRequestDetails = NewCallRequestModel(
            accountSid: userDetails.accountSid ?? "",
            agentId: userDetails.agentId,
            agentNumber: userDetails.agentMobile,
            from:
                "${longCodesForCallData.longcode ?? userDetails.longcode ?? userDetails.agentMobile}",
            insertDateTime: now,
            pilotNumber:
                "${longCodesForCallData.longcode ?? userDetails.longcode ?? ''}",
            scheduleDateTime: now,
            sessionId: longCodesForCallData.sessionId ??
                NewCallRequestModel.defaultSessionId,
            smeId: "${userDetails.smeId}",
            to: addByIndiaCountryCode(number: number),
            campaignId: longCodesForCallData.campaignId,
          );
          final res = await _callsRepo.makeNewCallV2(
              newCallRequestData: newCallRequestDetails);
          if (res.isSuccess) {
            FToastManager().showToast(
                message:
                    AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                        .waitForTheCall);
          } else {
            FToastManager().showToast(message: res.message);
          }

          /// V1
          /*
          /// No need to make call from device
          /// A call will come from the server
          if (res.isSuccess) {
            final res = await _callsRepo.makeNewCall(newCallRequestData: newCallRequestDetails);
            final data = NewCallResponseModel.fromJson(res.data as Map<String, dynamic>);
            AppMethodChannel.makeDirectCall(number: "${data.virtualNumber}");
          } else {
            FToastManager().showToast(message: res.message);
          }*/
        } else {
          FToastManager().showToast(message: longCodesResponse.message);
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } on PlatformException catch (e) {
      FToastManager().showToast(
          message:
              "${AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.failedToMakePhoneCall}: '${e.message}'.");
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("CallManager $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
