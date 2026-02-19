import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/features/calls/cubit/call_state.dart';
import 'package:kommuno/features/calls/data/model/agent_queue_model.dart';
import 'package:kommuno/features/calls/data/model/attendeed_transfer_request_model.dart';
import 'package:kommuno/features/calls/data/model/tranfer_request_model.dart';
import 'package:kommuno/features/calls/data/repository/call_repo.dart';

class CallStateCubit extends Cubit<CallState> {
 final CallsRepo callsRepo;
  final ActivityHelperRepo logRepo;
  static final Set<String> shownCrmSessions = {};


CallStateCubit({
    CallsRepo? callsRepo,  
    ActivityHelperRepo? logRepo,  
  })  : callsRepo = callsRepo ?? CallsRepo(),  
        logRepo = logRepo ?? ActivityHelperRepo(),  
        super(const CallState());

  Timer? _timer;

 
  void setPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return;
    
    debugPrint(" [CUBIT] Storing phone number: $phoneNumber");
    
    emit(state.copyWith(
      phoneNumber: phoneNumber,
    ));
  }

  Future<void> setConnected({
    required String callerName,
    required String phoneNumber,
  }) async {
    debugPrint(" [CUBIT] setConnected called");
    debugPrint(" [CUBIT] Incoming phone: $phoneNumber");
    debugPrint(" [CUBIT] Current state phone: ${state.phoneNumber}");
    
    final finalPhone = phoneNumber.isNotEmpty 
        ? phoneNumber 
        : state.phoneNumber;
    
    debugPrint(" [CUBIT] Final phone: $finalPhone");
    
    emit(state.copyWith(
      isConnected: true,
      callerName: callerName.isNotEmpty ? callerName : state.callerName,
      phoneNumber: finalPhone,
    ));

    final smeId = CallSession.smeId;
    final agentId = CallSession.agentId;
    final sessionId = CallSession.sessionId;

    await logRepo.updateLiveCallStatus(
      smeId: smeId ?? 0,
      agentId: agentId ?? 0,
      sessionId: sessionId ?? "",
      status: "Connected",
    );

    await logRepo.updateAgentLiveStatus(
      smeId: smeId ?? 0,
      agentId: agentId ?? 0,
      status: "On Call",
    );

    _startTimer();
  }
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(state.copyWith(
        duration: state.duration + const Duration(seconds: 1),
      ));
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

 
  Future<void> hold({
  required int smeId,
  required String sessionId,
  required String channelId,
  required int agentId,
  required String agentName,
}) async {
  final body = {
    "sessionId": sessionId,
    "channelId": channelId,
    "agentId": agentId,
    "callType": CallSession.callType,
  };

  final res = await callsRepo.hold(smeId: smeId, body: body);

  if (res.isSuccess) {
    emit(state.copyWith(isHold: true));
await logRepo.updateLiveCallStatus(
      smeId: smeId,
      agentId: agentId,
      sessionId: sessionId,
      status: "Hold", 
    );
    await logRepo.setActivityLogs(
      smeId,
                    moduleName: "call",

      action: "Hold",
      userRole: "agent",
      message: "$agentName Hold the call",
      agentId: agentId,
    );
  }
}

Future<void> unhold({
  required int smeId,
  required String sessionId,
  required String channelId,
  required int agentId,
  required String agentName,
}) async {
  final body = {
    "sessionId": sessionId,
    "channelId": channelId,
    "agentId": agentId,
    "callType": CallSession.callType,
  };

  final res = await callsRepo.unhold(smeId: smeId, body: body);

  if (res.isSuccess) {
    emit(state.copyWith(isHold: false));
 await logRepo.updateLiveCallStatus(
      smeId: smeId,
      agentId: agentId,
      sessionId: sessionId,
      status: "UnHold", 
    );
    await logRepo.setActivityLogs(
      smeId,
      action: "Unhold",
              moduleName: "call",

      userRole: "agent",
      message: "$agentName UnHold the call",
      agentId: agentId,
    );
  }
}

Future<void> mute({
  required int smeId,
  required String sessionId,
  required String channelId,
  required int agentId,
  required String agentName,
}) async {
  final body = {
    "sessionId": sessionId,
    "channelId": channelId,
    "agentId": agentId,
    
    "callType": CallSession.callType,
  };

  final res = await callsRepo.mute(smeId: smeId, body: body);

  if (res.isSuccess) {
    emit(state.copyWith(isMuted: true));
await logRepo.updateLiveCallStatus(
      smeId: smeId,
      agentId: agentId,
      sessionId: sessionId,
      status: "Mute", 
    );
    await logRepo.setActivityLogs(
      smeId,
      action: "Mute",
                    moduleName: "call",

      userRole: "agent",
      message: "$agentName Muted the call",
      agentId: agentId,
    );
  }
}

Future<void> unmute({
  required int smeId,
  required String sessionId,
  required String channelId,
  required int agentId,
  required String agentName,
}) async {
  final body = {
    "sessionId": sessionId,
    "channelId": channelId,
    "agentId": agentId,
    "callType": CallSession.callType,
  };

  final res = await callsRepo.unmute(smeId: smeId, body: body);

  if (res.isSuccess) {
    emit(state.copyWith(isMuted: false));
await logRepo.updateLiveCallStatus(
      smeId: smeId,
      agentId: agentId,
      sessionId: sessionId,
      status: "Unmute", 
    );
    await logRepo.setActivityLogs(
      smeId,
                    moduleName: "call",

      action: "Unmute",
      userRole: "agent",
      message: "$agentName UnMuted the call",
      agentId: agentId,
    );
  }
}

Future<void> drop({
  required int smeId,
  required String sessionId,
  required String channelId,
  required int agentId,
  required String agentName,
}) async {
  final body = {
    "sessionId": sessionId,
    "channelId": channelId,
    "callType": CallSession.callType,
  };

  final res=await callsRepo.drop(smeId: smeId, body: body);
  if (res.isSuccess) {

   
final enabledWrapTime = CampaignManager.campaign?.wrapupTimeInSeconds;
final wrapUpTime = (enabledWrapTime != null && enabledWrapTime > 0)
    ? enabledWrapTime
    : AppConstant.defaultWrapUpFallbackSeconds;

// await callsRepo.updateAgentLiveStatusForDropCall(
//       smeId: smeId,
//       agentId: agentId,
//       status: "Wrap up", 
//       enabledWrapupTime: wrapUpTime
//     );
    

    final wrapupEnabled = CampaignManager.campaign?.wrapupEnabled == true;
final dispositionFilled = state.isDispositionFilled;
final userDetailsCubit = UserDetailsCubit.instance;

if (wrapupEnabled && !dispositionFilled) {
  // show wrapup screen
  await callsRepo.updateAgentLiveStatusForDropCall(
    smeId: smeId,
    agentId: agentId,
    status: "Wrap up",
    enabledWrapupTime: wrapUpTime,
  );
} else {

  //  userDetailsCubit?.stopWaitingTimer() ?? 0;

  // skip wrapup
  await logRepo.updateAgentLiveStatus(
    smeId: smeId,
    agentId: agentId,
    status: "Waiting",
  );

    // userDetailsCubit?.startWaitingTimer();

}



  await logRepo.setActivityLogs(
    smeId,
                  moduleName: "call",

    action: "dropCall",
    userRole: "agent",
    message: "$agentName Disconnected the call",
    agentId: agentId,
  );
  

// await ActivityHelperRepo().updateAgentLiveStatus(
//   smeId: smeId,
//   agentId: agentId,
//   status: CallSession.callType,
// );


  stopTimer();
  emit(const CallState());
}}


Future<void> saveWrapUpInCall({
  required String dispositionName,
  required String dispositionId,
  required String remarks,
  required int rating,
  required BuildContext context,
    required int wrapUpSeconds,

}) async {
  final smeId = CallSession.smeId ?? 0;
  final agentId = CallSession.agentId ?? 0;
  final sessionId = CallSession.sessionId ?? "";
      final userDetailsCubit = context.read<UserDetailsCubit>();

  final body = {
    "session_id": sessionId,
    "rate": rating,
    "remarks": remarks,
    "disposition_id": dispositionId,
    "disposition_name": dispositionName,
    "agent_id": agentId,
  };
 final wrapupEnabled = CampaignManager.campaign?.wrapupEnabled == true;
await callsRepo.saveRating(smeId: smeId, body: body);
await callsRepo.saveRatingCrm(smeId: smeId, body: body);

markDispositionFilled();


}



Future<void> saveWrapUp({
  required String dispositionName,
  required String dispositionId,
  required String remarks,
  required int rating,
  required BuildContext context,
    required int wrapUpSeconds,

}) async {
  final smeId = CallSession.smeId ?? 0;
  final agentId = CallSession.agentId ?? 0;
  final sessionId = CallSession.sessionId ?? "";
      final userDetailsCubit = context.read<UserDetailsCubit>();

  final body = {
    "session_id": sessionId,
    "rate": rating,
    "remarks": remarks,
    "disposition_id": dispositionId,
    "disposition_name": dispositionName,
    "agent_id": agentId,
  };
 final wrapupEnabled = CampaignManager.campaign?.wrapupEnabled == true;
await callsRepo.saveRating(smeId: smeId, body: body);
await callsRepo.saveRatingCrm(smeId: smeId, body: body);

markDispositionFilled();


  if (wrapupEnabled) {
 
  userDetailsCubit.stopWaitingTimer();

  await logRepo.updateIsWrapUpTimeOver(
      smeId: smeId,
      agentId: agentId,
      sessionId: sessionId,
      wrapupTime: wrapUpSeconds,
    );

  // Agent becomes free
  await logRepo.updateAgentLiveStatus(
    smeId: smeId,
    agentId: agentId, 
    status: "Waiting",
  );


await ActivityHelperRepo().updateAgentActivityTime(
  smeId: smeId,
  agentId: agentId,
  time: wrapUpSeconds,
  status: "Wrap up",
);


userDetailsCubit.startWaitingTimer();
  }

}



Future<void> unattendedTransfer({
  required int smeId,
  required String sessionId,
  required String channelId,
  required int agentId,
  required String agentName,
  int? transferToAgentId,
  String? agentMobile,
  String? queueId,
  String? outsideNumber, 
}) async {
  debugPrint(" [UNATTENDED TRANSFER] Called with:");
  debugPrint("   transferToAgentId: $transferToAgentId");
  debugPrint("  agentMobile: $agentMobile");
  debugPrint(" queueId: $queueId");
  debugPrint("  outsideNumber: $outsideNumber");

  final req = UnattendedTransferRequestModel(
    sessionId: sessionId,
    channelId: channelId,
    callType: CallSession.callType,
    agentId: transferToAgentId,
    agentMobile: agentMobile,
    queueId: queueId,
    outsideNumber: outsideNumber,
  );

  debugPrint(" [UNATTENDED TRANSFER] Request body: ${req.toJson()}");

  final res = await callsRepo.unattendedTransfer(
    smeId: smeId,
    body: req,
  );

  if (res.isSuccess) {
    await logRepo.setActivityLogs(
      smeId,
      moduleName: "call",
      action: "Unattended Transfer",
      userRole: "agent",
      message: outsideNumber != null
          ? "$agentName transferred call to $outsideNumber"
          : "$agentName transferred call unattended",
      agentId: agentId,
    );
  } 
}

Future<void> attendedTransfer({
  required int smeId,
  required String sessionId,
  required String channelId,
  required int agentId,
  required String agentName,
  int? transferToAgentId,
  String? agentMobile,
  String? outsideNumber, 
  String? action, 
}) async {
  debugPrint(" [ATTENDED TRANSFER] Called with:");
  debugPrint("   - transferToAgentId: $transferToAgentId");
  debugPrint("   - agentMobile: $agentMobile");
  debugPrint("   - outsideNumber: $outsideNumber");
  debugPrint("   - action: $action");

  final req = AttendedTransferRequestModel(
    sessionId: sessionId,
    channelId: channelId,
    callType: CallSession.callType,
    agentId: transferToAgentId,
    agentMobile: agentMobile,
    outsideNumber: outsideNumber, 
    action: action,
  );

  debugPrint(" [ATTENDED TRANSFER] Request body: ${req.toJson()}");

  final res = await callsRepo.attendedTransfer(
    smeId: smeId,
    body: req,
  );

  if (res.isSuccess) {
    if (action == null) {
      // Step 1
      await logRepo.setActivityLogs(
        smeId,
        moduleName: "call",
        action: "Attended Step1",
        userRole: "agent",
        message: outsideNumber != null
            ? "$agentName initiated attended transfer to $outsideNumber"
            : "$agentName initiated attended transfer",
        agentId: agentId,
      );
    } else if (action == "conference") {
      // Step 2 — CONFERENCE
      await logRepo.setActivityLogs(
        smeId,
        moduleName: "call",
        action: "Conference",
        userRole: "agent",
        message: "$agentName started conference",
        agentId: agentId,
      );
    } else if (action == "transfer") {
      // Step 2 — TRANSFER
      await logRepo.setActivityLogs(
        smeId,
        moduleName: "call",
        action: "Attended Transfer Completed",
        userRole: "agent",
        message: "$agentName completed attended transfer",
        agentId: agentId,
      );
    }
  } 
}
List<Map<String, dynamic>> getWaitingAgentsOnly(
  List<dynamic> data,
) {
  final currentAgentId = CallSession.agentId;

  return data.where((agent) {
    return agent["status"] == 1 &&
        agent["agent_live_status"] == "Waiting" &&
        agent["agent_id"] != currentAgentId;
  }).cast<Map<String, dynamic>>().toList();
}



  Future<List<dynamic>> loadAllAgents(int smeId) async {
    final res = await callsRepo.getAllAgents(smeId: smeId);
    if (!res.isSuccess) return [];
    return res.data ?? [];
  }

  Future<List<dynamic>> loadAllQueues(int smeId) async {
    final res = await callsRepo.getAllQueues(smeId: smeId);
    if (!res.isSuccess) return [];
    return res.data ?? [];
  }

  Future<List<dynamic>> loadTeamLeads(int smeId) async {
    final res = await callsRepo.getTeamLeads(smeId: smeId);
    if (!res.isSuccess) return [];
    return res.data ?? [];
  }

  Future<List<QueueAgentModel>> loadQueueAgents(int smeId, String queueId) async {
    final res = await callsRepo.getQueueAgents(smeId: smeId, queueId: queueId);
    if (!res.isSuccess) return [];

    return (res.data as List)
        .map((e) => QueueAgentModel.fromJson(e))
        .toList();
  }

  Future<List<QueueAgentModel>> loadSameQueueAgents() async {
    final queueId = CampaignManager.campaign?.campaignQueue;

    if (queueId == null || queueId.isEmpty) return [];

    final smeId = CallSession.smeId!;
    return loadQueueAgents(smeId, queueId);
  }

  Future<bool> isAgentAvailable(int smeId, int agentId) async {
    final res = await callsRepo.getAgentStatus(smeId: smeId, agentId: agentId);
    if (!res.isSuccess) return false;

    final status = res.data["call_status"];
    return status == "free";
  }
Future<void> sendSurveyIVR() async {
  final smeId = CallSession.smeId!;
  final sessionId = CallSession.sessionId!;

  final res = await callsRepo.sendSurveyIVR(
    smeId: smeId,
    sessionId: sessionId,
  );

  if (res.isSuccess) {
    FToastManager().showToast(
      message: "Survey IVR sent successfully",
    );
  } else {
    FToastManager().showToast(
      message: "Failed to send survey IVR",
    );
  }
}


Future<void> loadWhatsappTemplates() async {
  final smeId = CallSession.smeId!;
  final res = await callsRepo.getWhatsappTemplates(smeId);

  if (res.isSuccess) {
    final list = List<Map<String, dynamic>>.from(res.data ?? []);
    
    emit(state.copyWith(
      whatsappTemplates: list,
    ));

    debugPrint("WhatsApp Templates Loaded: ${list.length}");
  }
}

Future<void> loadSmsTemplates() async {
  final smeId = CallSession.smeId!;
  final res = await callsRepo.getSmsTemplates(smeId);

  if (res.isSuccess) {
    final list = List<Map<String, dynamic>>.from(res.data ?? []);
    
    emit(state.copyWith(
      smsTemplates: list,
    ));

    debugPrint("SMS Templates Loaded: ${list.length}");
  }
}

Future<void> sendSmsTemplate(Map<String, dynamic> t) async {
  final smeId = CallSession.smeId!;
final userCubit = UserDetailsCubit.instance;
final agentMobile = userCubit?.userDetailsModel.agentMobile;

  final body = {
    "message": t["message"],
    "templateId": t["id"],
    "customerNo": state.phoneNumber,
    "sessionId": CallSession.sessionId,
    "callType": CallSession.callType,
    "agentNo": agentMobile,
    "dateTime": DateTime.now().toIso8601String(),
    "callStatus": 22,
    "duration": state.duration.inSeconds,
    "agentName": CallSession.agentName,
    "smsConfigId": t["sms_config_id"],
    "campaignName": CampaignManager.campaign?.campaignName,
    "type": "on_call",
  };

  final res = await callsRepo.sendSms(smeId: smeId, body: body);

  final message = _extractBackendMessage(
    res.data,
    fallback: "SMS failed",
  );

  FToastManager().showToast(message: message);
}
Future<void> sendWhatsappTemplate(Map<String, dynamic> t) async {
  final smeId = CallSession.smeId!;
 final userCubit = UserDetailsCubit.instance;
final agentMobile = userCubit?.userDetailsModel.agentMobile;
  final body = {
    "message": t["message"],
    "templateId": t["id"],
    "customerNo": state.phoneNumber,
    "sessionId": CallSession.sessionId,
    "callType": CallSession.callType,
    "agentNo":agentMobile,
    "dateTime": DateTime.now().toIso8601String(),
    "callStatus": 22,
    "duration": state.duration.inSeconds,
    "agentName": CallSession.agentName,
    "campaign_name": CampaignManager.campaign?.campaignName,
    "campaign_id": CampaignManager.campaign?.id,
    "type": "on_call",
  };

  final res = await callsRepo.sendWhatsapp(smeId: smeId, body: body);

   final message = _extractBackendMessage(
    res.data,
    fallback: "WhatsApp failed",
  );

  FToastManager().showToast(message: message);
}

String _extractBackendMessage(dynamic data,
    {String fallback = "Request failed"}) {
  try {
    if (data == null) return fallback;

    if (data is Map) {
      if (data["message"] != null) {
        return data["message"].toString();
      }

      final inner = data["data"];
      if (inner is Map) {
        if (inner["message"] != null) {
          return inner["message"].toString();
        }

        if (inner["description"] != null) {
          return inner["description"].toString();
        }

        if (inner["success"] == true || inner["success"] == "true") {
          return "Message sent successfully";
        }
      }

      if (data["success"] == true || data["success"] == "true") {
        return "Message sent successfully";
      }
    }
  } catch (e) {
    debugPrint("Message parse error: $e");
  }

  return fallback;
}




Future<void> updateSocketId({
  required int smeId,
  required int agentId,
  required String socketId,
}) async {
  try {
    debugPrint("Updating socket id → $socketId");

    final res = await callsRepo.updateSocketId(
      smeId: smeId,
      agentId: agentId,
      socketId: socketId,
    );

    if (res.isSuccess) {
      debugPrint(" Socket ID updated successfully");
    } else {
      debugPrint("Failed to update socket id: ${res.message}");
    }
  } catch (e) {
    debugPrint("updateSocketId error: $e");
  }
}



Future<void> loadInteractionHistory({
  required String customerNumber,
}) async {
  try {
    emit(state.copyWith(isLoadingInteractions: true));

    final smeId = CallSession.smeId!;
    final agentId = CallSession.agentId!;

    final payload = buildInteractionPayload(
      agentId: agentId,
      customerNumber: customerNumber,
    );

    final res = await callsRepo.getInteractionHistory(
      smeId: smeId,
      body: payload,
    );

    if (res.isSuccess) {
      final list = List<Map<String, dynamic>>.from(res.data ?? []);
      emit(state.copyWith(interactions: list));
    } else {
      emit(state.copyWith(interactions: []));
    }
  } catch (e) {
    debugPrint("Interaction history error: $e");
    emit(state.copyWith(interactions: []));
  } finally {
    emit(state.copyWith(isLoadingInteractions: false));
  }
}


Map<String, dynamic> buildInteractionPayload({
  required int agentId,
  required String customerNumber,
}) {
  final now = DateTime.now();

  // 3 months ago (start of day)
  final threeMonthsAgo = DateTime(
    now.year,
    now.month - 3,
    now.day,
    0,
    0,
    0,
    0,
  );

  // Today end time → 23:59:59.999
  final endOfToday = DateTime(
    now.year,
    now.month,
    now.day,
    23,
    59,
    59,
    999,
  );

  final normalizedNumber =
      customerNumber.replaceAll("+91", "").trim();

  return {
    "filterList": {
      "startDate": threeMonthsAgo.toIso8601String(),
      "endDate": endOfToday.toIso8601String(),
      "customer_number": normalizedNumber,
    },
    "batchSize": 10,
    "initialRecord": 1,
    "agentId": agentId,
  };
}
Future<bool> saveCrmForm(List<Map<String, dynamic>> updatedForm) async {
  emit(state.copyWith(isSavingCrm: true));

  final smeId = CallSession.smeId!;
  final sessionId = CallSession.sessionId!;

  final res = await callsRepo.saveCrmForm(
    smeId: smeId,
    sessionId: sessionId,
    body: {"form_json": updatedForm},
  );

  emit(state.copyWith(isSavingCrm: false));

  if (res.isSuccess) {
    FToastManager().showToast(message: "CRM form saved");
    return true;
  } else {
    FToastManager().showToast(message: "Failed to save CRM form");
    return false;
  }
}

void markCrmPopupShown() {
  debugPrint("🔒 markCrmPopupShown called");
  debugPrint("  - Before: crmPopupShown = ${state.crmPopupShown}");
  
  if (state.crmPopupShown) {
    debugPrint("⚠️ Already marked as shown - skipping");
    return;
  }
  
  emit(state.copyWith(crmPopupShown: true));
  
  debugPrint("  - After: crmPopupShown = ${state.crmPopupShown}");
}


void markDispositionFilled() {
  emit(state.copyWith(isDispositionFilled: true));
}


}

