import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
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
await logRepo.updateLiveCallStatus(
      smeId: smeId,
      agentId: agentId,
      sessionId: sessionId,
      status: "dropCall", 
    );
  await logRepo.setActivityLogs(
    smeId,
                  moduleName: "call",

    action: "dropCall",
    userRole: "agent",
    message: "$agentName Disconnected the call",
    agentId: agentId,
  );
  

await ActivityHelperRepo().updateAgentLiveStatus(
  smeId: smeId,
  agentId: agentId,
  status: CallSession.callType,
);


  stopTimer();
  emit(const CallState());
}}


Future<void> saveWrapUp({
  required String dispositionName,
  required String dispositionId,
  required String remarks,
  required int rating,
  required BuildContext context,
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

await callsRepo.saveRating(smeId: smeId, body: body);
await callsRepo.saveRatingCrm(smeId: smeId, body: body);

  // Agent becomes free
  await logRepo.updateAgentLiveStatus(
    smeId: smeId,
    agentId: agentId, 
    status: "free",
  );

  final seconds = userDetailsCubit.stopWaitingTimer();

await ActivityHelperRepo().updateAgentActivityTime(
  smeId: smeId,
  agentId: agentId,
  time: seconds,
  status: "Waiting",
);


userDetailsCubit.startWaitingTimer();

    
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



}

