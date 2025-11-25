class QueueAgentModel {
  final int? agentId;
  final String? agentName;
  final String? agentMobile;
  final String? status;

  QueueAgentModel({
    this.agentId,
    this.agentName,
    this.agentMobile,
    this.status,
  });

  factory QueueAgentModel.fromJson(Map<String, dynamic> json) {
    return QueueAgentModel(
      agentId: json["agent_id"],
      agentName: json["agent_name"],
      agentMobile: json["agent_mobile"],
      status: json["status"]?.toString(),
    );
  }
}
