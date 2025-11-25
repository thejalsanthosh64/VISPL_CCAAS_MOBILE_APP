import 'package:flutter/material.dart';

/// Stores active call session details so that Hold, Mute, Drop APIs can use.
class CallSession {
  static String sessionId = "";
  static String channelId = "";
  static int smeId = 0;
  static int agentId = 0;
  static String agentName = "";

  /// save session details after click-to-call API
  static void save({
    required String session,
    required String channel,
    required int sme,
    required int agent,
    required String name,
  }) {
    sessionId = session;
    channelId = channel;
    smeId = sme;
    agentId = agent;
    agentName = name;

    debugPrint("📞 CallSession Saved:");
    debugPrint("sessionId: $sessionId");
    debugPrint("channelId: $channelId");
    debugPrint("smeId: $smeId");
    debugPrint("agentId: $agentId");
  }

  /// Clear on call end
  static void clear() {
    sessionId = "";
    channelId = "";
    smeId = 0;
    agentId = 0;
    agentName = "";
  }
}
