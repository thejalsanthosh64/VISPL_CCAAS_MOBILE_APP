import 'dart:async';
import 'dart:convert';

import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/app_routes/app_routes_manager.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/network_manager/alive_set_service.dart';
import 'package:kommuno/core/network_manager/dio_client.dart';
import 'package:kommuno/core/utilities/call_manager/call_session.dart';
import 'package:kommuno/core/utilities/campaign_manager.dart';
import 'package:kommuno/core/utilities/local_storage/hive_service.dart';
import 'package:kommuno/core/utilities/secure_storage/secure_storage.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/calls/cubit/call_cubit.dart';
import 'package:kommuno/features/calls/data/repository/call_repo.dart';
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
  static bool agentAnswered = false;
  static Timer? autoStopTimer;
static bool _isPreviewOpen = false;

static final Set<String> _handledPreviewSessions = {};
static final Set<String> _handledConnectedSessions = {};
static final Set<String> _handledClearSessions = {};
static final Set<String> _handledCallEndedSessions = {};
static final Set<String> _handledRingingSessions = {};
static Timer? _recoveryTimer;
static bool _isRecovering = false;
  static Future<void> startContinuousVibration() async {
    if (isVibrating) return;
    try {
      if (!(await Vibration.hasVibrator() ?? false)) return;

      isVibrating = true;
      await Vibration.vibrate(pattern: [0, 500, 300], repeat: 0);

      autoStopTimer?.cancel();
      autoStopTimer = Timer(const Duration(seconds: 20), () {
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

  static Future<void> _forceLogout() async {
  final ctx = AppKeys.navigatorKey.currentContext;

  if (ctx == null) {
    debugPrint(" No context found for force logout");
    return;
  }

  try {
    // Stop sockets
    disconnectCallSocket();
    disconnectGlobal();

    // Stop alive service if running
    AliveService().stop();

    // Clear user session
    UserLoginInfoManager.setLoginUserInfo(userInfo: null);
    CampaignManager.setCampaignInfo(campaign: null);

    for (var key in StorageEnum.values) {
      await SecureStorage().deleteData(key: key.name);
    }

    await HiveService.deleteAll();

    // Navigate to login screen
    AppKeys.navigatorKey.currentState!.pushNamedAndRemoveUntil(
      AppRouteNames.loginScreen,
      (_) => false,
    );

    FToastManager().showToast(
      message: "You have been logged out by admin.",
    );

  } catch (e, s) {
    debugPrint("Force logout error: $e");
    debugPrint("$s");
  }
}


static void connectGlobal({
  required int smeId,
  required int agentId,
    required CallStateCubit callCubit,
      VoidCallback? onSocketReady,


}) {
  if (globalSocket != null) return;

  globalSocket = IO.io(
    ApiEndpoints.baseUrlWebSo,
    IO.OptionBuilder()
      .setTransports(['websocket'])
      .setPath('/socket.io/')
      .enableAutoConnect()
      .enableReconnection()
      .build(),
  );

globalSocket?.onReconnect((_) {
  debugPrint("🌐 Socket reconnected → starting recovery window");

  startRecoveryWindow(
    smeId: smeId,
    agentId: agentId,
    userName: UserLoginInfoManager.userLoginInfoModel!.username!,

  );
});

  globalSocket?.onConnect((_) async {
 final user = UserLoginInfoManager.userLoginInfoModel;
  final socketId = globalSocket?.id;
    debugPrint(" Global socket connected. socketId=$socketId");

  if (socketId != null) {

  activeCallCubit = callCubit;

  await  callCubit.updateSocketId(
        smeId: smeId,
        agentId: agentId,
        socketId: socketId,
      );

onSocketReady?.call();
      
  
  } else {
    debugPrint("x Socket ID is null");
  }

  globalSocket?.emit("auth", {
    "username": user?.username,
    "id": user?.userId,
  });


    globalSocket?.emit("join_agent_room", {
      "smeId": smeId,
      "agentId": agentId,
      "type": "agent",
    });


   
  });

  // FORCE LOGOUT EVENT
globalSocket?.on("logout_by_Agent", (raw) {
  debugPrint("logout_by_Agent event received: $raw");

  final data = normalize(raw);

  final eventUserId = data["user_id"];
  final role = data["role"];

  final loggedUser = UserLoginInfoManager.userLoginInfoModel;

  if (loggedUser == null) return;

  debugPrint("Event userId: $eventUserId");
  debugPrint("Logged userId: ${loggedUser.userId}");

  if (role == "agent" && eventUserId == loggedUser.userId) {
    debugPrint("User matched → Forcing logout");

    _forceLogout();
  }
});



globalSocket?.on("logout_by_client", (raw) {
  debugPrint("logout_by_Agent event received: $raw");

  final data = normalize(raw);

  final eventUserId = data["user_id"];
  final role = data["role"];

  final loggedUser = UserLoginInfoManager.userLoginInfoModel;

  if (loggedUser == null) return;

  debugPrint("Event userId: $eventUserId");
  debugPrint("Logged userId: ${loggedUser.userId}");

  if (role == "agent" && eventUserId == loggedUser.userId) {
    debugPrint("User matched → Forcing logout");

    _forceLogout();
  }
});


// PREVIEW MANUAL POPUP
globalSocket?.on("preview_manual_dialer_popup", (raw) {
  final data = normalize(raw);
  debugPrint(" preview_manual_dialer_popup: $data");

  final eventAgentId = data["agentId"] ?? data["agent_id"];
  if (eventAgentId != agentId) {
    debugPrint(" Preview manual ignored. Expected agentId=$agentId, got=$eventAgentId");
    return;
  }

  debugPrint(" Preview manual matched agent. Showing popup.");

  final campaign = CampaignManager.campaign;

  if (data["campaign_name"] != campaign!.campaignName) {
  debugPrint(
    " Ignoring preview_auto_dialer_popup — current campaign: ${campaign.campaignName}",
  );
  return;
}

final sessionId = data["sessionId"];
if (sessionId == null) return;

if (_handledPreviewSessions.contains(sessionId)) {
  debugPrint(" Preview already handled: $sessionId");
  return;
}

_handledPreviewSessions.add(sessionId);

  _showPreviewDialerPopup(data, isAuto: false);
});


// PREVIEW AUTO POPUP
globalSocket?.on("preview_auto_dialer_popup", (raw) {


  final data = normalize(raw);
  debugPrint(" preview_auto_dialer_popup: $data");

  final eventAgentId = data["agentId"] ?? data["agent_id"];
  if (eventAgentId != agentId) {
    debugPrint(" Preview auto ignored. Expected agentId=$agentId, got=$eventAgentId");
    return;
  }
  final campaign = CampaignManager.campaign;

  if (data["campaign_name"] != campaign!.campaignName) {
  debugPrint(
    " Ignoring preview_auto_dialer_popup — current campaign: ${campaign.campaignName}",
  );
  return;
}

  debugPrint(" Preview auto matched agent. Showing popup.");

  final sessionId = data["sessionId"];
if (sessionId == null) return;

if (_handledPreviewSessions.contains(sessionId)) {
  debugPrint("Auto preview already handled: $sessionId");
  return;
}

_handledPreviewSessions.add(sessionId);
_showPreviewDialerPopup(data, isAuto: true);

});



  //  INCOMING CALL - Store phone number early
  globalSocket?.on("ringing_live_calls", (raw) async {
      handleRecoveryEvent("ringing_live_calls");

    final data = normalize(raw);

    if (data["agentId"] != agentId) return;
    // if ((data["callType"] ?? "").toString().toLowerCase() == "outgoing") {
    //   return;
    // }

final sessionId = data["sessionId"];
if (sessionId == null) return;
    await _stopWaitingTimerForCall();

if (_handledRingingSessions.contains(sessionId)) {
  debugPrint(" Ringing already handled: $sessionId");
  return;
}

_handledRingingSessions.add(sessionId);
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

final backendType = data["callType"]?.toString().toLowerCase();

final type =
    backendType == "outgoing" ? "Outgoing" : "Incoming";

    CallSession.save(
      session: sessionId,
      channel: data["channel_id"] ?? data["channelId"] ?? "",
      sme: smeId,
      agent: agentId,
      name: customerName,
      type: type,
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

  globalSocket?.onAny((event, raw) {
  final data = normalize(raw);
  final eventAgentId = data["agentId"] ?? data["agent_id"];

  if (eventAgentId == agentId) {
  // logLong('[CALL EVENT] $event →', data);

    debugPrint("[MY EVENT] $event → $data");

  }
});

}

static Future<void> closePreviewPopupSafely() async {
  if (!_isPreviewOpen) {
    debugPrint("🟢 Preview popup already closed – skipping");
    return;
  }

  debugPrint("🔒 Closing preview popup...");
  
  _isPreviewOpen = false;

  previewTimer?.cancel();
  previewTimer = null;
  _previewSetState = null;
  remainingSeconds = 0;

  final ctx = AppKeys.navigatorKey.currentContext;
  if (ctx != null && Navigator.of(ctx, rootNavigator: true).canPop()) {
    Navigator.of(ctx, rootNavigator: true).pop();
    
    // ✅Wait for pop animation to complete
    await Future.delayed(const Duration(milliseconds: 300));
    debugPrint("✅ Preview popup closed");
  }
}

static Future<void> _stopWaitingTimerForCall() async {
  final userDetailsCubit = UserDetailsCubit.instance;

  if (userDetailsCubit == null) {
    debugPrint(" UserDetailsCubit.instance is null");
    return;
  }

  try {
    final waitingSeconds = userDetailsCubit.stopWaitingTimer();

    print("waitingsec$waitingSeconds");
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


static Timer? previewTimer;
static int remainingSeconds = 7; 
static void Function(void Function())? _previewSetState;

static void _showPreviewDialerPopup(
  Map<String, dynamic> data, {
  required bool isAuto,
}) {
  final ctx = AppKeys.navigatorKey.currentContext;
  if (ctx == null) return;

  final customerNumber = data["customerNumber"] ?? "";
  final customerName = data["customerName"] ?? "Unknown";
  final sessionId = data["sessionId"];
  final channelId = data["channelId"];
  final redisKey = data["redis_key"];

final userCubit = UserDetailsCubit.instance;
final expireSeconds =
    userCubit?.userDetailsModel.previewDialerPopupExpire ?? 7;

remainingSeconds = expireSeconds;

  startContinuousVibration();

  // ---------------- Countdown Timer ----------------

previewTimer?.cancel();
// previewTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//   remainingSeconds--;

//   //  Force dialog rebuild
//   if (_previewSetState != null) {
//     _previewSetState!.call(() {});
//   }

//   if (remainingSeconds <= 0) {
//     timer.cancel();
//     stopVibration();
//     Navigator.of(ctx, rootNavigator: true).pop();

//     if (isAuto) {
//       debugPrint("Auto timeout → Auto Call");
//       _sendPreviewAction(
//         isAuto: isAuto,
//         callStatus: "call",
//         sessionId: sessionId,
//         channelId: channelId,
//         redisKey: redisKey,
//       );
//     } else {
//       debugPrint(" Manual timeout → Reject");
//       _sendPreviewAction(
//         isAuto: isAuto,
//         callStatus: "reject",
//         sessionId: sessionId,
//         channelId: channelId,
//         redisKey: redisKey,
//       );
//     }
//   }
// });


previewTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  // 🚫 Dialog already closed
  if (_previewSetState == null) {
    timer.cancel();
    return;
  }

  remainingSeconds--;

  _previewSetState!.call(() {});

  if (remainingSeconds <= 0) {
    timer.cancel();
    _isPreviewOpen = false;

    _previewSetState = null;

    stopVibration();

    if (Navigator.of(ctx, rootNavigator: true).canPop()) {
      Navigator.of(ctx, rootNavigator: true).pop();
    }

    if (isAuto) {
      _sendPreviewAction(
        isAuto: isAuto,
        callStatus: "call",
        sessionId: sessionId,
        channelId: channelId,
        redisKey: redisKey,
      );
    } else {
      _sendPreviewAction(
        isAuto: isAuto,
        callStatus: "reject",
        sessionId: sessionId,
        channelId: channelId,
        redisKey: redisKey,
      );
    }
  }
});


  // ---------------- UI ----------------
                          _isPreviewOpen = true;

showDialog(
  context: ctx,
  barrierDismissible: false,
  builder: (_) => StatefulBuilder(
    builder: (context, setState) {

            _previewSetState = setState;

      return Dialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //  Title
              const Text(
                "Preview Dialer",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 12),

              //  Customer Name
              Text(
                customerName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 4),

              // Phone Number
              Text(
                customerNumber,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 16),

              // Countdown
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Auto ${isAuto ? "Call" : "Reject"} in $remainingSeconds sec",
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Action Buttons
              Row(
                children: [
                  //  Reject Button
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Reject",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          previewTimer?.cancel();
                          _isPreviewOpen = false;

                            _previewSetState = null;

                          stopVibration();
                          Navigator.pop(context);
                          _sendPreviewAction(
                              isAuto: isAuto,

                            callStatus: "reject",
                            sessionId: sessionId,
                            channelId: channelId,
                            redisKey: redisKey,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // 📞 Call Button
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Call",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          previewTimer?.cancel();
                          _isPreviewOpen = false;

                                                      _previewSetState = null;

                          stopVibration();
                          Navigator.pop(context);

                          _sendPreviewAction(
                              isAuto: isAuto,

                            callStatus: "call",
                            sessionId: sessionId,
                            channelId: channelId,
                            redisKey: redisKey,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  ),
).then((_) {
    _isPreviewOpen = false;
    _previewSetState = null;
    previewTimer?.cancel();
  });

}

static Future<void> _sendPreviewAction({
  required bool isAuto,
  required String callStatus,
  required String sessionId,
  required String channelId,
  required String redisKey,
}) async {
  try {
        // final user = UserDetailsCubit.instance!.userDetailsModel;

  
    debugPrint("Sending preview response only");

// connectForCall(
//       sessionId: sessionId,
//       smeId: user.smeId,
//       agentId: user.agentId,
//       cubit: cubit,
//     );

//     debugPrint(" Call socket connected before preview response");
   
//     await Future.delayed(const Duration(milliseconds: 300));

final body = {
      "call_status": callStatus,
      "session_id": sessionId,
      "channel_id": channelId,
      "redis_key": redisKey,
    };
    final repo = CallsRepo();

 

       if (isAuto) {
      await repo.sendPreviewAutoAction(body);
    } else {
      await repo.sendPreviewManualAction(body);
    }
  } catch (e) {
    debugPrint(" Preview action failed: $e");
  }
}

static void connectForCall({
  required String sessionId,
  required int smeId,
  required int agentId,
  required CallStateCubit cubit,
}) {
  activeSessionId = sessionId;
  activeCallCubit = cubit;
  agentAnswered = false;


  callSocket = IO.io(
    ApiEndpoints.baseUrlWebSo,
    IO.OptionBuilder().setTransports(['websocket']).setPath('/socket.io/').enableAutoConnect().build(),
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
  // logLong('[CALL EVENT] $event →', data);
    debugPrint("[MY EVENT] $event → $data");

  });

  // ========================================
  //  LOCATION 1: RINGING (Outgoing)
  // ========================================
  
  callSocket?.on("ringing_live_calls", (raw) async {
    handleRecoveryEvent("ringing_live_calls");
    final e = normalize(raw);
    if (!_matchSession(e)) return;
     await _stopWaitingTimerForCall();

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

  callSocket?.on("connected_live_calls", (raw) async {
      handleRecoveryEvent("connected_live_calls");

    final e = normalize(raw);



    if (!_matchSession(e)) return;
final sessionId = e["sessionId"];
if (sessionId == null) return;

if (_handledConnectedSessions.contains(sessionId)) {
  debugPrint("connected_live_calls already handled: $sessionId");
  return;
}

_handledConnectedSessions.add(sessionId);
    

  final crm = e["crm"];
  final crmForm = crm?["crm_form"];

  debugPrint("🔍 CRM check:");
  debugPrint("  - crm exists: ${crm != null}");
  debugPrint("  - crmForm exists: ${crmForm != null}");
  debugPrint("  - crmForm status: ${crmForm?["status"]}");
  debugPrint("  - current crmPopupShown: ${activeCallCubit?.state.crmPopupShown}");
final hasShownForSession = CallStateCubit.shownCrmSessions.contains(sessionId);
  debugPrint("  - hasShownForSession: $hasShownForSession");
await closePreviewPopupSafely();

  if (crmForm != null && 
      crmForm["status"] == true && 
      !hasShownForSession) {  //  Changed condition
    
    debugPrint("🎯 Emitting CRM state...");
    
    //  Mark session as shown
    CallStateCubit.shownCrmSessions.add(sessionId);
    
    activeCallCubit?.emit(
      activeCallCubit!.state.copyWith(
        showCrmForm: true,
        crmPopupShown: false,  // Reset for the listener to trigger
        crmFormName: crmForm["name"] ?? "CRM Form",
        crmFormJson: List<Map<String, dynamic>>.from(
          crmForm["form_json"] ?? [],
        ),
      ),
    );
    
    debugPrint("✅ CRM state emitted");
  } else {
    debugPrint("⏭️ Skipping CRM emission");
  }

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
      handleRecoveryEvent("call_connected");

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
  callSocket?.on("call_ended", (raw) async {
      handleRecoveryEvent("call_ended");

    final e = normalize(raw);
    if (!_matchSession(e)) return;
final sessionId = e["sessionId"];
if (sessionId == null) return;

if (_handledCallEndedSessions.contains(sessionId)) {
  debugPrint(" call_ended already handled: $sessionId");
  return;
}

_handledCallEndedSessions.add(sessionId);

    stopVibration();
    agentAnswered = true;

    final phone = e["customerNumber"] ?? 
                  e["phoneNumber"] ?? 
                  e["customer_number"] ?? 
                  activeCallCubit?.state.phoneNumber ?? 
                  "";

    debugPrint(" [CALL_ENDED] Phone: $phone");

    final name = phone.isNotEmpty ? ContactLookup.getName(phone) : "Unknown";

    // _navigateToWrapUp(
    //   caller: name,
    //   phone: phone,
    //   cubit: activeCallCubit!,
    //   duration: activeCallCubit!.state.duration,
    // );

await closePreviewPopupSafely();


final campaign = CampaignManager.campaign;
final wrapupEnabled = campaign?.wrapupEnabled == true;

if (wrapupEnabled && !activeCallCubit!.state.isDispositionFilled) {
  _navigateToWrapUp(
    caller: name,
    phone: phone,
    cubit: activeCallCubit!,
    duration: activeCallCubit!.state.duration,
  );
} else {
  // Directly end call
  activeCallCubit!.stopTimer();
}


    disconnectCallSocket();
  });

  //  NO ANSWER 
  callSocket?.on("clear_live_calls", (raw) async {
      handleRecoveryEvent("clear_live_calls");

    final e = normalize(raw);
    if (!_matchSession(e)) return;
final sessionId = e["sessionId"];
if (sessionId == null) return;

if (_handledClearSessions.contains(sessionId)) {
  debugPrint(" clear_live_calls already handled: $sessionId");
  return;
}
_handledClearSessions.add(sessionId);

  
  try {

  CallStateCubit.shownCrmSessions.remove(activeSessionId);

    stopVibration();
    agentAnswered = true;

    final phone = e["customerNumber"] ?? 
                  e["phoneNumber"] ?? 
                  e["customer_number"] ?? 
                  activeCallCubit?.state.phoneNumber ?? 
                  "";

    debugPrint(" [CLEAR_CALL] Phone: $phone");

    final name = phone.isNotEmpty ? ContactLookup.getName(phone) : "Unknown";
   await closePreviewPopupSafely();
  activeCallCubit?.stopTimer();

  final campaign = CampaignManager.campaign;
  final wrapupEnabled = campaign?.wrapupEnabled == true;
  final dispositionFilled = activeCallCubit!.state.isDispositionFilled;

  if (wrapupEnabled && !dispositionFilled) {
    _navigateToWrapUp(
      caller: name,
      phone: phone,
      cubit: activeCallCubit!,
      duration: Duration.zero,
    );

    disconnectCallSocket();
   await Future.delayed(const Duration(milliseconds: 500));
      return; 
      
       }
 
    
    debugPrint(" Wrapup disabled/filled → Returning to main screen");

    // Disconnect socket first
    disconnectCallSocket();

    //  Use scheduler binding for safe navigation
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final ctx = AppKeys.navigatorKey.currentContext;
      
      if (ctx != null) {
        debugPrint("📍 Current context found, navigating...");
        
        try {
          // Check if we're not already on the first route
          if (Navigator.of(ctx, rootNavigator: true).canPop()) {
            // Close all screens
            Navigator.of(ctx, rootNavigator: true).popUntil((route) {
              debugPrint(" Checking route: ${route.settings.name}, isFirst: ${route.isFirst}");
              return route.isFirst;
            });

//             Navigator.of(ctx, rootNavigator: true).pushNamedAndRemoveUntil(
//   AppRouteNames.homeMiddleware, // your actual home screen route
//   (_) => false,
// );
            
            debugPrint(" Navigation completed");
          } else {
            debugPrint("ℹAlready on first route");
          }
          
          // Wait for navigation animation
          await Future.delayed(const Duration(milliseconds: 300));
          
          // Start waiting timer
          CallWebSocketManager.safeStartWaiting();
          
        } catch (e) {
          debugPrint(" Navigation error: $e");
          // Fallback: still start waiting
          CallWebSocketManager.safeStartWaiting();
        }
      } else {
        debugPrint(" No context - starting waiting anyway");
        CallWebSocketManager.safeStartWaiting();
      }
      
      //  Reset flag after everything completes
      await Future.delayed(const Duration(milliseconds: 500));
    });
    
  } catch (e, stackTrace) {
    debugPrint(" Error in clear_live_calls: $e");
    debugPrint("Stack trace: $stackTrace");
    
    
    disconnectCallSocket();
    CallWebSocketManager.safeStartWaiting();
  
  }});
}

static void safeStartWaiting() {
  final cubit = UserDetailsCubit.instance;
  if (cubit == null || cubit.isClosed) {
    debugPrint("⛔ Waiting skipped (cubit invalid)");
    return;
  }

  
  cubit.startWaitingTimer();
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

  static void testPreviewPopup() {
      // activeCallCubit = CallStateCubit();

  final fakeData = {
    "customerName": "Test Customer",
    "customerNumber": "9876543210",
    "sessionId": "test-session-123",
    "channelId": "test-channel-456",
    "redis_key": "test-redis-key",
  };

  _showPreviewDialerPopup(
    fakeData,
    isAuto: false,   // change to false to test manual mode
  );
}


static void logLong(String tag, Object data) {
  final text = const JsonEncoder.withIndent('  ').convert(data);
  const chunkSize = 800;
  for (int i = 0; i < text.length; i += chunkSize) {
    debugPrint('$tag ${text.substring(
      i,
      i + chunkSize > text.length ? text.length : i + chunkSize,
    )}');
  }
}


  // Disconnection
  static void disconnectCallSocket() {
    stopVibration();
    answerDetectionTimer?.cancel();
    answerDetectionTimer = null;

    callSocket?.disconnect();
    callSocket?.dispose();
    callSocket = null;
    if (activeSessionId != null) {
  _clearSessionGuards(activeSessionId);
}

  if (activeSessionId != null) {
    CallStateCubit.shownCrmSessions.remove(activeSessionId);
  }

    activeCallCubit = null;
    activeSessionId = null;
    agentAnswered = false;

  }
static void _clearSessionGuards(String? sessionId) {
  if (sessionId == null) return;

  _handledPreviewSessions.remove(sessionId);
  _handledConnectedSessions.remove(sessionId);
  _handledClearSessions.remove(sessionId);
  _handledCallEndedSessions.remove(sessionId);
  _handledRingingSessions.remove(sessionId);
}

  static void disconnectGlobal() {
    globalSocket?.disconnect();
    globalSocket?.dispose();
    globalSocket = null;
  }

 static Future<void> moveToWaitingState({
  required int smeId,
  required int agentId,
  required String userName,
}) async {
  debugPrint("⏱ Recovery timeout → Moving agent to Waiting");

  // 1️⃣ Stop all local side effects
  stopVibration();


 final cubit = UserDetailsCubit.instance;
  if (cubit == null || cubit.isClosed) {
    debugPrint("⛔ Waiting skipped (cubit invalid)");
    return;
  }
  disconnectCallSocket();
  
  cubit.startWaitingTimer();

 final ctx = AppKeys.navigatorKey.currentContext;
  if (ctx != null) {
    Navigator.of(ctx, rootNavigator: true)
        .popUntil((route) => route.isFirst);
  }

  // 3️⃣ Backend sync
  final repo = ActivityHelperRepo();

  try {
    // 🔹 Agent live status
    await repo.updateAgentLiveStatus(
      smeId: smeId,
      agentId: agentId,
      status: "Waiting",
    );

    // 🔹 Agent activity time
    await repo.updateAgentActivityTime(
      smeId: smeId,
      agentId: agentId,
      status: "Waiting",
      time: 0,
    );

    // 🔹 Optional: activity log (recommended for audit)
    await repo.setActivityLogs(
      smeId,
      action: "waiting",
      userRole: "agent",
      message: "Agent moved to Waiting due to network recovery timeout",
      agentId: agentId,
      moduleName: "call",
    );

    
    debugPrint("Agent successfully moved to Waiting (backend synced)");
  } catch (e, st) {
    debugPrint("Failed to sync Waiting state: $e");
    debugPrintStack(stackTrace: st);
  }
}
static void startRecoveryWindow({
  required int smeId,
  required int agentId,
  required String userName,
}) {
  _isRecovering = true;

  _recoveryTimer?.cancel();
  _recoveryTimer = Timer(const Duration(seconds: 30), () async {
    if (!_isRecovering) return;

    await moveToWaitingState(
      smeId: smeId,
      agentId: agentId,
      userName: userName,
    );
  });

  debugPrint("🛠 Recovery window started (30s)");
}

static void handleRecoveryEvent(String eventName) {
  if (!_isRecovering) return;

  debugPrint(" Recovery resolved by event: $eventName");

  _isRecovering = false;
  _recoveryTimer?.cancel();
}

}
