import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/network_manager/websocket_service.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/data/repository/call_repo.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/features/calls/presenter/page/call_wrapup_.dart';
import 'package:kommuno/features/contact/presenter/widget/contact_helper.dart';
import 'package:uuid/uuid.dart';

// class CallManager {
//   static final _callsRepo = CallsRepo();

//   static Future<void> makeNewCall({required String number}) async {
//     try {
//       final userDetails = (AppKeys.nestedNavigatorKey.currentContext!
//               .read<UserDetailsCubit>()
//               .state as UserDetailsSuccessState)
//           .userDetailsModel;

//       if (userDetails.outPermissionFlag != 1) {
//         FToastManager().showToast(
//             message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//                 .outgoingPermissionMsg);
//       } else if (userDetails.status == 0) {
//         FToastManager().showToast(
//             message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//                 .currentlyInactiveMsg);
//       } else if (userDetails.status == 4) {
//         FToastManager().showToast(
//             message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//                 .onBreakMsg);
//       } else {
//         AppLoadingIndicator.showLoadingIndicator();
//         final longCodesResponse = await _callsRepo.getLongCodesForCall(
//           smeId: "${userDetails.smeId}",
//           campaignId: CampaignManager.campaign?.id ?? "",
//         );
//         if (longCodesResponse.isSuccess) {
//           final longCodesForCallData =
//               LongCodesForCallData.fromJson(Map.from(longCodesResponse.data));
//           final now = DateTime.now();
//           final newCallRequestDetails = NewCallRequestModel(
//             accountSid: userDetails.accountSid ?? "",
//             agentId: userDetails.agentId,
//             agentNumber: userDetails.agentMobile,
//             from:
//                 "${longCodesForCallData.longcode ?? userDetails.longcode ?? userDetails.agentMobile}",
//             insertDateTime: now,
//             pilotNumber:
//                 "${longCodesForCallData.longcode ?? userDetails.longcode ?? ''}",
//             scheduleDateTime: now,
//             sessionId: longCodesForCallData.sessionId ??
//                 NewCallRequestModel.defaultSessionId,
//             smeId: "${userDetails.smeId}",
//             to: addByIndiaCountryCode(number: number),
//             campaignId: longCodesForCallData.campaignId,
//           );
//           final res = await _callsRepo.makeNewCallV2(
//               newCallRequestData: newCallRequestDetails);
//           if (res.isSuccess) {

// CallSession.save(
//     session: longCodesForCallData.sessionId ?? "",
//     channel: longCodesForCallData.sessionId ?? "",
//     sme: userDetails.smeId,
//     agent: userDetails.agentId,
//     name: userDetails.agentName,
//   );

//   // Navigate to Call Screen
//   Navigator.of(AppKeys.navigatorKey.currentContext!).push(
//     MaterialPageRoute(builder: (_) => const CallScreen()),
//   );

//   FToastManager().showToast(
//       message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//           .waitForTheCall);

//             FToastManager().showToast(
//                 message:
//                     AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//                         .waitForTheCall);
//           } else {
//             FToastManager().showToast(message: res.message);
//           }

//           /// V1
//           /*
//           /// No need to make call from device
//           /// A call will come from the server
//           if (res.isSuccess) {
//             final res = await _callsRepo.makeNewCall(newCallRequestData: newCallRequestDetails);
//             final data = NewCallResponseModel.fromJson(res.data as Map<String, dynamic>);
//             AppMethodChannel.makeDirectCall(number: "${data.virtualNumber}");
//           } else {
//             FToastManager().showToast(message: res.message);
//           }*/
//         } else {
//           FToastManager().showToast(message: longCodesResponse.message);
//         }
//       }
//     } on AppDioException catch (e) {
//       FToastManager().showToast(message: e.message);
//     } on PlatformException catch (e) {
//       FToastManager().showToast(
//           message:
//               "${AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.failedToMakePhoneCall}: '${e.message}'.");
//     } catch (e, s) {
//       FToastManager().showToast(
//           message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//               .somethingWentWrong);
//       debugPrint("CallManager $e");
//       debugPrint("$s");
//     }
//     AppLoadingIndicator.dismissLoadingIndicator();
//   }
// }


// class CallManager {
//   static final _callsRepo = CallsRepo();

//   static Future<void> makeNewCall({required String number}) async {
//     try {
//       final userDetails = (AppKeys.nestedNavigatorKey.currentContext!
//               .read<UserDetailsCubit>()
//               .state as UserDetailsSuccessState)
//           .userDetailsModel;

//       /// permissions check
//       if (userDetails.outPermissionFlag != 1) {
//         FToastManager().showToast(
//             message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//                 .outgoingPermissionMsg);
//         return;
//       }
//       if (userDetails.status == 0) {
//         FToastManager().showToast(
//             message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//                 .currentlyInactiveMsg);
//         return;
//       }
//       if (userDetails.status == 4) {
//         FToastManager().showToast(
//             message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//                 .onBreakMsg);
//         return;
//       }

//       AppLoadingIndicator.showLoadingIndicator();

//       final campaign = CampaignManager.campaign;

//       /// GENERATE NEW SESSION ID HERE (UUID V4)
//       final sessionId = const Uuid().v4();

//       final now = DateTime.now();

//       // final newCallRequestDetails = NewCallRequestModel(
//       //   accountSid: userDetails.accountSid ?? "",
//       //   agentId: userDetails.agentId,
//       //   agentNumber: userDetails.agentMobile,
//       //   from: "+${userDetails.longcode}",  
//       //   pilotNumber: "+${userDetails.longcode}",
//       //   insertDateTime: now,
//       //   scheduleDateTime: now,
//       //   sessionId: sessionId,
//       //   smeId: "${userDetails.smeId}",
//       //   to: addByIndiaCountryCode(number: number),

//       //   /// NEW (MANDATORY)
//       //   callPriority: campaign?.callPriority ?? 0,
//       //   campaignId: campaign?.id,
//       //   agentGroup: userDetails.groupId?.toString() ?? "0",
//       // );

//      String formatScheduleDate(DateTime dt) {
//   return "${dt.year}-${dt.month}-${dt.day} "
//          "${dt.hour}:${dt.minute}:${dt.second}"
//          "T${dt.hour}:${dt.minute}:${dt.second}";
// }

// final newCallRequestDetails = {
//   "Authorization": "c5797dcbaaeed7678c4062a4a3ed2f8a",
//   "sessionId": sessionId,
//   "callMode": 3,
//   "agentGroup": 1,
//   "callPriority": 22,
//   "optionalField": "0",
//   "mediaFileFlag": 0,
//   "mediaFileId": "0",
//   "nameFileFlag": 0,
//   "nameFileId": "0",
//   "customDtmfFlag": 0,
//   "customDtmf": 0,
//   "timeLimit": 0,
//   "recordingFlag": 1,
//   "liveEventFlag": 0,
//   "liveEvent": "0",
//   "status": 0,
//   "agentType": "phone",

//   // dynamic fields
//   "smeId": userDetails.smeId,
//   "accountSid": userDetails.accountSid,
//   "to": addByIndiaCountryCode(number: number),
//   "from": "+${userDetails.longcode}",
//   "scheduleDateTime": formatScheduleDate(now),
//   "pilotNumber": "+${userDetails.longcode}",
//   "campaignId": campaign?.id ?? "",
//   "campaignType": campaign?.campaignType ?? "click_to_call_campaign",
//   "agentNumber": userDetails.agentMobile,
// };


//       /// hit clickToCallLiveCall API
//       final res = await _callsRepo.makeNewCallV2(
//           newCallRequestData: newCallRequestDetails);

//       if (res.isSuccess) {
//         /// Save session only (no channel yet)
//         CallSession.save(
//           session: sessionId,
//           channel: "",   // no channel yet
//           sme: userDetails.smeId,
//           agent: userDetails.agentId,
//           name: userDetails.agentName,
//         );
//  CallWebSocketManager.connect(
//           sessionId: sessionId,
//           smeId: userDetails.smeId,
//           agentId: userDetails.agentId,
//         );
//         /// Navigate to Call Screen
//         // Navigator.of(AppKeys.navigatorKey.currentContext!).push(
//         //   MaterialPageRoute(builder: (_) => const CallScreen()),
//         // );

//         FToastManager().showToast(
//             message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//                 .waitForTheCall);
//       } else {
//         FToastManager().showToast(message: res.message);
//       }
//     } catch (e, s) {
//       debugPrint("makeNewCall ERROR: $e\n$s");
//       FToastManager().showToast(
//         message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//             .somethingWentWrong,
//       );
//     } finally {
//       AppLoadingIndicator.dismissLoadingIndicator();
//     }
//   }
// }


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
        return;
      }
      if (userDetails.status == 0) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .currentlyInactiveMsg);
        return;
      }
      if (userDetails.status == 4) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .onBreakMsg);
        return;
      }

      AppLoadingIndicator.showLoadingIndicator();

      final campaign = CampaignManager.campaign;
      final sessionId = const Uuid().v4();
      final now = DateTime.now();

      String formatScheduleDate(DateTime dt) {
        return "${dt.year}-${dt.month}-${dt.day} "
            "${dt.hour}:${dt.minute}:${dt.second}"
            "T${dt.hour}:${dt.minute}:${dt.second}";
      }

      final newCallRequestDetails = {
        "Authorization": "c5797dcbaaeed7678c4062a4a3ed2f8a",
        "sessionId": sessionId,
        "callMode": 3,
        "agentGroup": 1,
        "callPriority": 22,
        "optionalField": "0",
        "mediaFileFlag": 0,
        "mediaFileId": "0",
        "nameFileFlag": 0,
        "nameFileId": "0",
        "customDtmfFlag": 0,
        "customDtmf": 0,
        "timeLimit": 0,
        "recordingFlag": 1,
        "liveEventFlag": 0,
        "liveEvent": "0",
        "status": 0,
        "agentType": "phone",
        "smeId": userDetails.smeId,
        "accountSid": userDetails.accountSid,
        "to": addByIndiaCountryCode(number: number),
        "from": "+${userDetails.longcode}",
        "scheduleDateTime": formatScheduleDate(now),
        "pilotNumber": "+${userDetails.longcode}",
        "campaignId": campaign?.id ?? "",
        "campaignType": campaign?.campaignType ?? "click_to_call_campaign",
        "agentNumber": userDetails.agentMobile,
      };

debugPrint(
  " newCallRequestDetails => ${jsonEncode(newCallRequestDetails)}"
);
      debugPrint(' Making new call request...');


      final res = await _callsRepo.makeNewCallV2(
          newCallRequestData: newCallRequestDetails);

      if (res.isSuccess) {
        debugPrint(' Call API Success: ${res.message}');
        
        CallSession.save(
          session: sessionId,
          channel: "",
          sme: userDetails.smeId,
          agent: userDetails.agentId,
          name: userDetails.agentName,
          type: "Outgoing",
        );

        final ctx = AppKeys.navigatorKey.currentContext!;
        
        final callStateCubit = CallStateCubit();

        // Connect WebSocket
        debugPrint(' Connecting WebSocket...');
        CallWebSocketManager.connectForCall(
          sessionId: sessionId,
          smeId: userDetails.smeId,
          agentId: userDetails.agentId,
          cubit: callStateCubit,
        );
 final contactName = ContactLookup.getName(number);
        final displayName = contactName != "Unknown" ? contactName : number;

        Navigator.push(
  ctx,
  MaterialPageRoute(
    builder: (_) => MultiBlocProvider(
      providers: [
        BlocProvider.value(value: callStateCubit),
        BlocProvider.value(value: UserDetailsCubit.instance!),  
      ],
      child: AfterCallWrapUpScreen(
        callerName: displayName,
        phoneNumber: number,
        duration: Duration.zero,
        waitingForConnection: true,
      ),
    ),
  ),
);



        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .waitForTheCall);
      } else {
        debugPrint(' Call API Failed: ${res.message}');
        FToastManager().showToast(message: res.message);
      }
    } catch (e, s) {
      debugPrint(" makeNewCall ERROR: $e\n$s");
      FToastManager().showToast(
        message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
            .somethingWentWrong,
      );
    } finally {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
  }
}