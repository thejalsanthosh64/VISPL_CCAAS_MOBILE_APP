class UnattendedTransferRequestModel {
  final String sessionId;
  final String channelId;
  final String? callType;
  final int? agentId; // transferToAgentId
  final String? agentMobile;
  final String? queueId;
  final String? outsideNumber;

  UnattendedTransferRequestModel({
    required this.sessionId,
    required this.channelId,
    this.callType,
    this.agentId,
    this.agentMobile,
    this.queueId,
    this.outsideNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "sessionId": sessionId,
      "channelId": channelId,
      "callType": callType,
      if (agentId != null) "agent_id": agentId,
      if (agentMobile != null) "agentMobile": agentMobile,
      if (queueId != null) "queueId": queueId,
      if (outsideNumber != null) "outsideNumber": outsideNumber,
    };
  }
}
