class UnattendedTransferRequestModel {
  final String sessionId;
  final String channelId;
  final String callType;

  final String? agentMobile;
  final int? agentId;

  final String? queueId;
  final String? outsideNumber;

  UnattendedTransferRequestModel({
    required this.sessionId,
    required this.channelId,
    this.callType = "Outgoing",
    this.agentMobile,
    this.agentId,
    this.queueId,
    this.outsideNumber,
  });

  Map<String, dynamic> toJson() => {
        "sessionId": sessionId,
        "channelId": channelId,
        "callType": callType,
        "agentMobile": agentMobile,
        "agent_id": agentId,
        "queueId": queueId,
        "outsideNumber": outsideNumber,
      }..removeWhere((_, v) => v == null);
}
