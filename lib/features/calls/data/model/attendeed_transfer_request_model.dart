class AttendedTransferRequestModel {
  final String sessionId;
  final String channelId;
  final String callType;

  final String? agentMobile;
  final int? agentId;

  final String? queueId;
  final String? outsideNumber;

  /// REQUIRED when 2nd agent connects and agent selects conference/transfer
  final String? action; // "conference" or "transfer"

  AttendedTransferRequestModel({
    required this.sessionId,
    required this.channelId,
    this.callType = "Outgoing",
    this.agentMobile,
    this.agentId,
    this.queueId,
    this.outsideNumber,
    this.action,
  });

  Map<String, dynamic> toJson() => {
        "sessionId": sessionId,
        "channelId": channelId,
        "callType": callType,
        "agentMobile": agentMobile,
        "agent_id": agentId,
        "queueId": queueId,
        "outsideNumber": outsideNumber,
        "action": action,
      }..removeWhere((_, v) => v == null);
}
