class AttendedTransferRequestModel {
  final String sessionId;
  final String channelId;
  final String? callType;
  final int? agentId;
  final String? agentMobile;
  final String? action;
  final String? outsideNumber;

  AttendedTransferRequestModel({
    required this.sessionId,
    required this.channelId,
    this.callType,
    this.agentId,
    this.agentMobile,
    this.action,
        this.outsideNumber,

  });

  Map<String, dynamic> toJson() {
    return {
      "sessionId": sessionId,
      "channelId": channelId,
      "callType": callType,
      if (agentId != null) "agent_id": agentId,
      if (agentMobile != null) "agentMobile": agentMobile,
      if (action != null) "action": action,
            if (outsideNumber != null) "outsideNumber": outsideNumber,

    };
  }
}
