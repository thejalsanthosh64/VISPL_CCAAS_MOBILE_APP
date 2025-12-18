import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/presenter/page/call_screen.dart';
import 'package:kommuno/features/calls/presenter/page/call_wrapup_.dart';
import 'package:kommuno/features/contact/presenter/widget/contact_helper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';



class CallWebSocketManager {
  static IO.Socket? globalSocket;
  static IO.Socket? callSocket;

  static CallStateCubit? activeCallCubit;
  static String? activeSessionId;
  static bool isVibrating = false;
  static String? lastRingingSessionId;
  static bool agentAnswered = false;
  static Timer? autoStopTimer;

  //  VIBRATION
  static Future<void> startContinuousVibration() async {
    if (isVibrating) return;
    try {
      if (!(await Vibration.hasVibrator() ?? false)) return;

      isVibrating = true;
      await Vibration.vibrate(pattern: [0, 500, 300], repeat: 0);

      autoStopTimer?.cancel();
      autoStopTimer = Timer(const Duration(seconds: 30), () {
        if (isVibrating && !agentAnswered) {
          stopVibration();
          agentAnswered = true;
        }
      });
    } catch (_) {}
  }

  static Future<void> stopVibration() async {
    autoStopTimer?.cancel();
    autoStopTimer = null;
    if (!isVibrating) return;
    try {
      await Vibration.cancel();
      isVibrating = false;
    } catch (_) {
      isVibrating = false;
    }
  }

static void connectGlobal({
  required int smeId,
  required int agentId,
}) {
  if (globalSocket != null) return;

  globalSocket = IO.io(
    "https://testsio.smartping.ai/",
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .enableAutoConnect()
      .enableReconnection()
      .build(),
  );

  globalSocket?.onConnect((_) {
    globalSocket?.emit("join_agent_room", {
      "smeId": smeId,
      "agentId": agentId,
      "type": "agent",
    });
  });

  //  INCOMING CALL - Store phone number early
  globalSocket?.on("ringing_live_calls", (raw) async {
    await _stopWaitingTimerForCall();
    final data = normalize(raw);

    if (data["agentId"] != agentId) return;
    if ((data["callType"] ?? "").toString().toLowerCase() == "outgoing") {
      return;
    }

    final sessionId = data["sessionId"];
    if (sessionId == null || sessionId.toString().isEmpty) return;

    final customerNumber = data["customerNumber"] ?? 
                          data["phoneNumber"] ?? 
                          data["customer_number"] ?? "";
    
    final customerName = extractCustomerName(data);

    debugPrint(" [INCOMING] Phone: $customerNumber, Name: $customerName");

    // start vibration
    startContinuousVibration();

    final callCubit = CallStateCubit();

    debugPrint(" [INCOMING] Storing phone in cubit: $customerNumber");
    callCubit.setPhoneNumber(customerNumber);

    CallSession.save(
      session: sessionId,
      channel: data["channel_id"] ?? data["channelId"] ?? "",
      sme: smeId,
      agent: agentId,
      name: customerName,
      type: "Incoming",
    );

    connectForCall(
      sessionId: sessionId,
      smeId: smeId,
      agentId: agentId,
      cubit: callCubit,
    );

    stopVibration();
    agentAnswered = true;

    _navigateToWaitingScreen(
      cubit: callCubit,
      callerName: customerName,
      phone: customerNumber,
    );
  });

  // FOLLOW-UP REMINDER EVENT 
  globalSocket?.on("follow_up_notification", (raw) {
    debugPrint(" [FOLLOW-UP] Raw data received: $raw");
    
    final data = normalize(raw);
    debugPrint(" [FOLLOW-UP] Normalized data: $data");
    debugPrint(" [FOLLOW-UP] Event agentId: ${data["agent_id"]}");
    debugPrint(" [FOLLOW-UP] Expected agentId: $agentId");
    
    final eventAgentId = data["agent_id"] ?? data["agentId"];
    
    if (eventAgentId != agentId) {
      debugPrint(" [FOLLOW-UP] Agent ID mismatch. Expected: $agentId, Got: $eventAgentId");
      return;
    }

    debugPrint(" [FOLLOW-UP] Agent ID matched. Showing popup...");
    _showReminderPopup(data);
  });
}


static Future<void> _stopWaitingTimerForCall() async {
  final userDetailsCubit = UserDetailsCubit.instance;

  if (userDetailsCubit == null) {
    debugPrint(" UserDetailsCubit.instance is null");
    return;
  }

  try {
    final waitingSeconds = userDetailsCubit.stopWaitingTimer();
    final user = userDetailsCubit.userDetailsModel;

    await ActivityHelperRepo().updateAgentActivityTime(
      smeId: user.smeId,
      agentId: user.agentId ,
      time: waitingSeconds,
      status: "Waiting",
    );

    debugPrint(" Updated waiting time: $waitingSeconds seconds");
  } catch (e) {
    debugPrint(" stopWaitingTimer error: $e");
  }
}

// REMINDER POPUP 
static void _showReminderPopup(Map<String, dynamic> data) {
  debugPrint(" [POPUP] Attempting to show reminder popup");
  debugPrint(" [POPUP] Data: $data");
  
  final ctx = AppKeys.navigatorKey.currentContext;
  if (ctx == null) {
    debugPrint(" [POPUP] Context is null! Cannot show dialog.");
    return;
  }
  
  debugPrint(" [POPUP] Context found. Building dialog...");

  final number = data["customer_number"] ?? "";
  final customerNameFromEvent = data["customer_name"] ?? "";
  
  debugPrint(" [POPUP] Number: $number");
  debugPrint(" [POPUP] Customer name from event: $customerNameFromEvent");
  
  // Try to get name from contacts first, fallback to event name
  String displayName = ContactLookup.getName(number);
  if (displayName == "Unknown" && 
      customerNameFromEvent.isNotEmpty && 
      customerNameFromEvent.toLowerCase() != "no name") {
    displayName = customerNameFromEvent;
  }
  
  debugPrint(" [POPUP] Display name: $displayName");

  final msg = data["message"] ?? "Reminder";
  final note = data["note"] ?? "";
  final title = data["title"] ?? "Follow-up Reminder";
  final scheduleDateTime = data["schedule_date_time"] ?? "";

  // Format schedule time if available
  String timeInfo = "";
  if (scheduleDateTime.isNotEmpty) {
    try {
      final dt = DateTime.parse(scheduleDateTime);
      final now = DateTime.now();
      final diff = dt.difference(now);
      
      if (diff.inMinutes < 1) {
        timeInfo = "Now";
      } else if (diff.inMinutes < 60) {
        timeInfo = "in ${diff.inMinutes} minutes";
      } else {
        timeInfo = "at ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
      }
    } catch (e) {
      debugPrint(" [POPUP] Error parsing date: $e");
    }
  }

  debugPrint(" [POPUP] Showing dialog now...");

  showDialog(
    context: ctx,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.appColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.schedule,
              color: AppColors.appColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Info Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.appColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          displayName.isNotEmpty && displayName != "Unknown"
                              ? displayName[0].toUpperCase()
                              : "?",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.appColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            number,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          if (timeInfo.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  "Scheduled: $timeInfo",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          
          if (note.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              "Note:",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              note,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            debugPrint(" [POPUP] Dismiss button pressed");
            Navigator.pop(ctx);
          },
          child: Text(
            "Dismiss",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ),
      
      ],
    ),
  );

  debugPrint(" [POPUP] Dialog shown successfully");

  FToastManager().showToast(
    message: " Follow-up: $displayName ($number)",
  );
}

static String extractCustomerName(Map<String, dynamic> e) {
  final number = e["customerNumber"] ??
      e["phoneNumber"] ??
      e["customer_number"] ??
      "";

  String name = ContactLookup.getName(number);
  
  if (name == "Unknown") {
    final eventName = e["customerName"] ?? e["customer_name"] ?? "";
    if (eventName.isNotEmpty && 
        eventName.toLowerCase() != "no name" && 
        eventName.toLowerCase() != "unknown") {
      name = eventName;
      // Also save it for future use
      ContactLookup.addContact(number, eventName);
    }
  }

  return name;
}


static void connectForCall({
  required String sessionId,
  required int smeId,
  required int agentId,
  required CallStateCubit cubit,
}) {
  activeSessionId = sessionId;
  activeCallCubit = cubit;
  lastRingingSessionId = null;
  agentAnswered = false;

  callSocket = IO.io(
    "https://testsio.smartping.ai/",
    IO.OptionBuilder().setTransports(['websocket']).enableAutoConnect().build(),
  );

  callSocket?.onConnect((_) {
    callSocket?.emit("join_session", {
      "sessionId": sessionId,
      "smeId": smeId,
      "agentId": agentId,
      "type": "agent",
    });
  });

  callSocket?.onAny((event, data) {
    debugPrint(" [CALL EVENT] $event → $data");
  });

  // ========================================
  //  LOCATION 1: RINGING (Outgoing)
  // ========================================
  callSocket?.on("ringing_live_calls", (raw) async {
     await _stopWaitingTimerForCall();
    final e = normalize(raw);
    if (!_matchSession(e)) return;

    if (lastRingingSessionId == sessionId) return;
    lastRingingSessionId = sessionId;

    startContinuousVibration();
    _startAgentAnswerDetection();

    final customerNumber = e["customerNumber"] ?? 
                          e["phoneNumber"] ?? 
                          e["customer_number"] ?? "";
    
    final customerName = extractCustomerName(e);
    
    debugPrint(" [RINGING] Storing phone early: $customerNumber");
    activeCallCubit?.setPhoneNumber(customerNumber);

    final channel = e["channel_id"] ?? e["channelId"];
    if (channel != null) {
      CallSession.save(
        session: sessionId,
        channel: channel,
        sme: smeId,
        agent: agentId,
        name: customerName,
        type: "Outgoing",
      );
    }

    _navigateToWaitingScreen(
      cubit: activeCallCubit!,
      callerName: customerName,
      phone: customerNumber,
    );
  });

  callSocket?.on("connected_live_calls", (raw) {
    final e = normalize(raw);
    if (!_matchSession(e)) return;

    stopVibration();
    agentAnswered = true;

    final customerNumber = e["customerNumber"] ?? 
                          e["phoneNumber"] ?? 
                          e["customer_number"] ?? "";
    
    final customerName = extractCustomerName(e);

    
    if (activeCallCubit?.state.phoneNumber.isEmpty ?? true) {
      debugPrint(" [CONNECTED] Storing phone as backup: $customerNumber");
      activeCallCubit?.setPhoneNumber(customerNumber);
    }

    activeCallCubit?.setConnected(
      callerName: customerName,
      phoneNumber: customerNumber,
    );

    _navigateToCallScreen(activeCallCubit!);
  });

  // CALL_CONNECTED 
  callSocket?.on("call_connected", (raw) {
    final e = normalize(raw);
    if (!_matchSession(e)) return;

    stopVibration();
    agentAnswered = true;

    final customerNumber = e["customerNumber"] ?? 
                          e["phoneNumber"] ?? 
                          e["customer_number"] ?? "";
    
    final customerName = extractCustomerName(e);

    if (activeCallCubit?.state.phoneNumber.isEmpty ?? true) {
      debugPrint(" [CALL_CONNECTED] Storing phone as backup: $customerNumber");
      activeCallCubit?.setPhoneNumber(customerNumber);
    }

    activeCallCubit?.setConnected(
      callerName: customerName,
      phoneNumber: customerNumber,
    );

    _navigateToCallScreen(activeCallCubit!);
  });

  //  CALL END 
  callSocket?.on("call_ended", (raw) {
    final e = normalize(raw);
    if (!_matchSession(e)) return;

    stopVibration();
    agentAnswered = true;

    final phone = e["customerNumber"] ?? 
                  e["phoneNumber"] ?? 
                  e["customer_number"] ?? 
                  activeCallCubit?.state.phoneNumber ?? 
                  "";

    debugPrint(" [CALL_ENDED] Phone: $phone");

    final name = phone.isNotEmpty ? ContactLookup.getName(phone) : "Unknown";

    _navigateToWrapUp(
      caller: name,
      phone: phone,
      cubit: activeCallCubit!,
      duration: activeCallCubit!.state.duration,
    );

    disconnectCallSocket();
  });

  //  NO ANSWER 
  callSocket?.on("clear_live_calls", (raw) {
    final e = normalize(raw);
    if (!_matchSession(e)) return;

    stopVibration();
    agentAnswered = true;

    final phone = e["customerNumber"] ?? 
                  e["phoneNumber"] ?? 
                  e["customer_number"] ?? 
                  activeCallCubit?.state.phoneNumber ?? 
                  "";

    debugPrint(" [CLEAR_CALL] Phone: $phone");

    final name = phone.isNotEmpty ? ContactLookup.getName(phone) : "Unknown";

    _navigateToWrapUp(
      caller: name,
      phone: phone,
      cubit: activeCallCubit!,
      duration: Duration.zero,
    );

    disconnectCallSocket();
  });
}
  // AGENT ANSWER DETECTION 
  static Timer? answerDetectionTimer;
  static void _startAgentAnswerDetection() {
    answerDetectionTimer?.cancel();
    int count = 0;

    answerDetectionTimer =
        Timer.periodic(const Duration(seconds: 2), (timer) {
      count++;

      if (count >= 2 && isVibrating && !agentAnswered) {
        stopVibration();
        agentAnswered = true;
        timer.cancel();
      }

      if (count >= 7) timer.cancel();
    });
  }


static void _navigateToWaitingScreen({
  required CallStateCubit cubit,
  required String callerName,
  required String phone,
}) {
  final ctx = AppKeys.navigatorKey.currentContext;
  if (ctx == null) return;

  Navigator.pushAndRemoveUntil(
    ctx,
    MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),                    
          BlocProvider.value(value: UserDetailsCubit.instance!)
        ],
        child: AfterCallWrapUpScreen(
          callerName: callerName,
          phoneNumber: phone,
          duration: Duration.zero,
          waitingForConnection: true,
        ),
      ),
    ),
    (_) => _.isFirst,
  );
}


  static void _navigateToCallScreen(CallStateCubit cubit) {
    final ctx = AppKeys.navigatorKey.currentContext;
    if (ctx == null) return;

    Navigator.pushAndRemoveUntil(
      ctx,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: const CallScreen(),
        ),
      ),
      (_) => _.isFirst,
    );
  }


static void _navigateToWrapUp({
  required String caller,
  required String phone,
  required CallStateCubit cubit,
  required Duration duration,
}) {
  final ctx = AppKeys.navigatorKey.currentContext;
  if (ctx == null) return;

  final phoneFromCubit = cubit.state.phoneNumber;
  final actualPhone = phoneFromCubit.isNotEmpty ? phoneFromCubit : phone;

  final freshName = ContactLookup.getName(actualPhone);
  final displayName = (freshName == "Unknown" && caller.isNotEmpty)
      ? caller
      : freshName;

  Navigator.pushAndRemoveUntil(
    ctx,
    MaterialPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: cubit),                    
          BlocProvider.value(value: UserDetailsCubit.instance!), 
        ],
        child: AfterCallWrapUpScreen(
          callerName: displayName,
          phoneNumber: actualPhone,
          duration: duration,
          waitingForConnection: false,
        ),
      ),
    ),
    (_) => _.isFirst,
  );
}

  static bool _matchSession(Map<String, dynamic> e) {
    return e["sessionId"] == activeSessionId;
  }

  static Map<String, dynamic> normalize(dynamic d) {
    if (d is List && d.isNotEmpty && d.first is Map) {
      return Map<String, dynamic>.from(d.first);
    }
    if (d is Map) {
      return Map<String, dynamic>.from(d);
    }
    return {};
  }

  // Disconnection
  static void disconnectCallSocket() {
    stopVibration();
    answerDetectionTimer?.cancel();
    answerDetectionTimer = null;

    callSocket?.disconnect();
    callSocket?.dispose();
    callSocket = null;

    activeCallCubit = null;
    activeSessionId = null;
    lastRingingSessionId = null;
    agentAnswered = false;
  }

  static void disconnectGlobal() {
    globalSocket?.disconnect();
    globalSocket?.dispose();
    globalSocket = null;
  }
}
