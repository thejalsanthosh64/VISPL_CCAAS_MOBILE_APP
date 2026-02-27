import 'package:flutter/material.dart';

/// Stores active call session details so that Hold, Mute, Drop APIs can use.

//  class CallSession {
//   static String? sessionId;
//   static String? channelId;
//   static int? smeId;
//   static int? agentId;
//   static String? agentName;
//   static String callType = "Outgoing"; 

//   static void save({
//     required String session,
//     required String channel,
//     required int sme,
//     required int agent,
//     required String? name,
//     String? type, // NEW PARAM
//   }) {
//     sessionId = session;
//     channelId = channel;
//     smeId = sme;
//     agentId = agent;
//     agentName = name;

//     if (type != null && type.trim().isNotEmpty) {
//       callType = type;
//     }

//     debugPrint(" CallSession Saved:");
//     debugPrint("sessionId: $sessionId");
//     debugPrint("channelId: $channelId");
//     debugPrint("callType: $callType"); 
//   }
// }


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
    String? type,
  }) {
    sessionId = session;
    
    // ✅ Only update channelId if it's currently empty or being set for first time
    if (channelId == null || channelId!.isEmpty) {
      channelId = channel;
    } else if (channel.isNotEmpty && channelId != channel) {
      debugPrint("⚠️ CallSession: ignoring channelId overwrite. "
          "current=$channelId, attempted=$channel");
    }
    
    smeId = sme;
    agentId = agent;
    agentName = name;

    if (type != null && type.trim().isNotEmpty) {
      callType = type;
    }

    debugPrint("CallSession Saved:");
    debugPrint("sessionId: $sessionId");
    debugPrint("channelId: $channelId");
    debugPrint("callType: $callType");
  }

  //  Add this — call it on disconnectCallSocket or wraup screen based on condition
  static void clear() {
    sessionId = null;
    channelId = null;
    smeId = null;
    agentId = null;
    agentName = null;
    callType = "Outgoing";
  }
}