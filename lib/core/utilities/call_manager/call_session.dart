import 'package:flutter/material.dart';

/// Stores active call session details so that Hold, Mute, Drop APIs can use.

 class CallSession {
  static String? sessionId;
  static String? channelId;
  static int? smeId;
  static int? agentId;
  static String? agentName;
  static String callType = "Outgoing"; 

  static void save({
    required String session,
    required String channel,
    required int sme,
    required int agent,
    required String? name,
    String? type, // NEW PARAM
  }) {
    sessionId = session;
    channelId = channel;
    smeId = sme;
    agentId = agent;
    agentName = name;

    if (type != null && type.trim().isNotEmpty) {
      callType = type;
    }

    debugPrint(" CallSession Saved:");
    debugPrint("sessionId: $sessionId");
    debugPrint("channelId: $channelId");
    debugPrint("callType: $callType"); 
  }
}
