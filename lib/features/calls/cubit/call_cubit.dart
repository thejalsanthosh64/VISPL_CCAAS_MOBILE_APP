import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/features/calls/cubit/call_state.dart';
import 'package:kommuno/features/calls/data/model/agent_queue_model.dart';
import 'package:kommuno/features/calls/data/model/attendeed_transfer_request_model.dart';
import 'package:kommuno/features/calls/data/model/tranfer_request_model.dart';
import 'package:kommuno/features/calls/data/repository/call_repo.dart';

class CallStateCubit extends Cubit<CallState> {
 final CallsRepo callsRepo;
  final ActivityHelperRepo logRepo;

  CallStateCubit({
    required this.callsRepo,
    required this.logRepo,
  }) : super(const CallState());

  Timer? _timer;

 
  Future<void> setConnected({
    required String callerName,
    required String phoneNumber,
  }) async {
    emit(state.copyWith(
      isConnected: true,
      callerName: callerName,
      phoneNumber: phoneNumber,
    ));

final smeId = CallSession.smeId;
  final agentId = CallSession.agentId;
  final sessionId = CallSession.sessionId;

  await logRepo.updateLiveCallStatus(
    smeId: smeId,
    agentId: agentId,
    sessionId: sessionId,
    status: "Connected",
  );

  await logRepo.updateAgentLiveStatus(
    smeId: smeId,
    agentId: agentId,
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
    "callType": "Outgoing",
  };

  final res = await callsRepo.hold(smeId: smeId, body: body);

  if (res.isSuccess) {
    emit(state.copyWith(isHold: true));

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
    "callType": "Outgoing",
  };

  final res = await callsRepo.unhold(smeId: smeId, body: body);

  if (res.isSuccess) {
    emit(state.copyWith(isHold: false));

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
    
    "callType": "Outgoing",
  };

  final res = await callsRepo.mute(smeId: smeId, body: body);

  if (res.isSuccess) {
    emit(state.copyWith(isMuted: true));

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
    "callType": "Outgoing",
  };

  final res = await callsRepo.unmute(smeId: smeId, body: body);

  if (res.isSuccess) {
    emit(state.copyWith(isMuted: false));

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
    "callType": "Outgoing",
  };

  await callsRepo.drop(smeId: smeId, body: body);

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
  status: "Outgoing",
);


  stopTimer();
  emit(const CallState());
}

Future<void> unattendedTransfer({
  required int smeId,
  required String sessionId,
  required String channelId,
  required int agentId,
  required String agentName,
  String? agentMobile,
  int? transferToAgentId,
  String? queueId,
  String? outsideNumber,
}) async {
  final req = UnattendedTransferRequestModel(
    sessionId: sessionId,
    channelId: channelId,
    agentMobile: agentMobile,
    agentId: transferToAgentId,
    queueId: queueId,
    outsideNumber: outsideNumber,
  );

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
      message: "$agentName transferred the call (unattended)",
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
  String? agentMobile,
  int? transferToAgentId,
  String? queueId,
  String? outsideNumber,
  required String? action,  // Optional for step 1
}) async {
  final req = AttendedTransferRequestModel(
    sessionId: sessionId,
    channelId: channelId,
    agentMobile: agentMobile,
    agentId: transferToAgentId,
    queueId: queueId,
    outsideNumber: outsideNumber,
    action: action, // null for step 1
  );

  final res = await callsRepo.attendedTransfer(
    smeId: smeId,
    body: req, 
  );

  if (res.isSuccess) {
    await logRepo.setActivityLogs(
      smeId,
      moduleName: "call",
      action: "Attended ${action ?? 'init'}",
      userRole: "agent",
      message: "$agentName performed attended ${action ?? '(connect)'}",
      agentId: agentId,
    );
  }
}

Future<List<QueueAgentModel>> loadQueueAgents(int smeId, String queueId) async {
  final res = await callsRepo.getQueueAgents(
    smeId: smeId,
    queueId: queueId,
  );

  if (!res.isSuccess) return [];

  final list = (res.data as List)
      .map((e) => QueueAgentModel.fromJson(e))
      .toList();

  return list;
}

Future<bool> isAgentAvailable(int smeId, int agentId) async {
  final res = await callsRepo.getAgentStatus(
    smeId: smeId,
    agentId: agentId,
  );

  if (!res.isSuccess) return false;

  final status = res.data["call_status"];
  return status == "free";
}




}
