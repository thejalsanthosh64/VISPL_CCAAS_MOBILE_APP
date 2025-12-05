class QueueAgentModel {
  final int? agentId;
  final String? agentName;
  final String? agentMobile;
  final String? agentLiveStatus;
  final String? queueId;

  QueueAgentModel({
    this.agentId,
    this.agentName,
    this.agentMobile,
    this.agentLiveStatus,
    this.queueId,
  });

  factory QueueAgentModel.fromJson(Map<String, dynamic> json) {
    return QueueAgentModel(
      agentId: json["agent_id"] ?? json["id"],
      agentName: json["agent_name"] ?? "-",
      agentMobile: json["agent_mobile"] ?? "",
      agentLiveStatus: (json["agent_live_status"] == null ||
              json["agent_live_status"].toString().trim().isEmpty)
          ? "-"
          : json["agent_live_status"],
      queueId: json["queue_id"]?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
        "agent_name": agentName,
        "agent_mobile": agentMobile,
        "agent_live_status": agentLiveStatus,
        "queue_id": queueId,
      };
}


class QueueModel {
  final int id;
  final String name;

  QueueModel({
    required this.id,
    required this.name,
  });

  factory QueueModel.fromJson(Map<String, dynamic> json) {
    return QueueModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
    );
  }
}

class AgentStatusModel {
  final int agentId;
  final String agentName;
  final String agentMobile;
  final String agentLiveStatus; // free/busy/logout
  final String displayStatus;   // "Waiting" → for UI

  AgentStatusModel({
    required this.agentId,
    required this.agentName,
    required this.agentMobile,
    required this.agentLiveStatus,
    required this.displayStatus,
  });

  factory AgentStatusModel.fromJson(Map<String, dynamic> json) {
    final live = json["agent_live_status"] ?? "";
    String uiStatus = "Waiting";

    // Convert backend → UI text
    if (live.toLowerCase() == "free") uiStatus = "Waiting";
    if (live.toLowerCase() == "busy") uiStatus = "Busy";

    return AgentStatusModel(
      agentId: json["agent_id"] ?? 0,
      agentName: json["agent_name"] ?? "",
      agentMobile: json["agent_mobile"] ?? "",
      agentLiveStatus: live,
      displayStatus: uiStatus,
    );
  }
}
class TeamLeadModel {
  final int agentId;
  final String agentName;
  final String agentMobile;

  TeamLeadModel({
    required this.agentId,
    required this.agentName,
    required this.agentMobile,
  });

  factory TeamLeadModel.fromJson(Map<String, dynamic> json) {
    return TeamLeadModel(
      agentId: json["agent_id"] ?? 0,
      agentName: json["agent_name"] ?? "",
      agentMobile: json["agent_mobile"] ?? "",
    );
  }
}
