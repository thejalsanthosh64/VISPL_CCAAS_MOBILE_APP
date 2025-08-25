import 'package:equatable/equatable.dart';

class LongCodesForCallData extends Equatable {
  const LongCodesForCallData({
    this.smeId,
    this.agentId,
    this.longcode,
    this.campaignId,
    this.campaignName,
    this.campaignType,
    this.sessionId,
    this.smeVirtualPool,
  });

  final String? smeId;
  final int? agentId;
  final int? longcode;
  final String? campaignId;
  final String? campaignName;
  final String? campaignType;
  final String? sessionId;
  final List<SmeVirtualPool>? smeVirtualPool;

  LongCodesForCallData copyWith({
    String? smeId,
    int? agentId,
    int? longcode,
    String? campaignId,
    String? campaignName,
    String? campaignType,
    String? sessionId,
    List<SmeVirtualPool>? smeVirtualPool,
  }) {
    return LongCodesForCallData(
      smeId: smeId ?? this.smeId,
      agentId: agentId ?? this.agentId,
      longcode: longcode ?? this.longcode,
      campaignId: campaignId ?? this.campaignId,
      campaignName: campaignName ?? this.campaignName,
      campaignType: campaignType ?? this.campaignType,
      sessionId: sessionId ?? this.sessionId,
      smeVirtualPool: smeVirtualPool ?? this.smeVirtualPool,
    );
  }

  factory LongCodesForCallData.fromJson(Map<String, dynamic> json) {
    return LongCodesForCallData(
      smeId: json["smeId"],
      agentId: json["agentId"],
      longcode: json["longcode"],
      campaignId: json["campaignId"],
      campaignName: json["campaignName"],
      campaignType: json["campaignType"],
      sessionId: json["sessionId"],
      smeVirtualPool:
          json["smeVirtualPool"] == null ? null : List<SmeVirtualPool>.from(json["smeVirtualPool"]!.map((x) => SmeVirtualPool.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "smeId": smeId,
        "agentId": agentId,
        "longcode": longcode,
        "campaignId": campaignId,
        "campaignName": campaignName,
        "campaignType": campaignType,
        "sessionId": sessionId,
        "smeVirtualPool": smeVirtualPool?.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        smeId,
        agentId,
        longcode,
        campaignId,
        campaignName,
        campaignType,
        sessionId,
        smeVirtualPool,
      ];
}

class SmeVirtualPool extends Equatable {
  const SmeVirtualPool({
    this.longcode,
    this.id,
    this.status,
    this.numberType,
    this.location,
    this.type,
    this.smeVirtualPoolOperator,
    this.siteIdentifier,
    this.dc,
    this.callFlowId,
    this.flowName,
    this.agentName,
  });

  final int? longcode;
  final int? id;
  final int? status;
  final String? numberType;
  final String? location;
  final String? type;
  final String? smeVirtualPoolOperator;
  final int? siteIdentifier;
  final String? dc;
  final dynamic callFlowId;
  final dynamic flowName;
  final dynamic agentName;

  SmeVirtualPool copyWith({
    int? longcode,
    int? id,
    int? status,
    String? numberType,
    String? location,
    String? type,
    String? smeVirtualPoolOperator,
    int? siteIdentifier,
    String? dc,
    dynamic callFlowId,
    dynamic flowName,
    dynamic agentName,
  }) {
    return SmeVirtualPool(
      longcode: longcode ?? this.longcode,
      id: id ?? this.id,
      status: status ?? this.status,
      numberType: numberType ?? this.numberType,
      location: location ?? this.location,
      type: type ?? this.type,
      smeVirtualPoolOperator: smeVirtualPoolOperator ?? this.smeVirtualPoolOperator,
      siteIdentifier: siteIdentifier ?? this.siteIdentifier,
      dc: dc ?? this.dc,
      callFlowId: callFlowId ?? this.callFlowId,
      flowName: flowName ?? this.flowName,
      agentName: agentName ?? this.agentName,
    );
  }

  factory SmeVirtualPool.fromJson(Map<String, dynamic> json) {
    return SmeVirtualPool(
      longcode: json["longcode"],
      id: json["id"],
      status: json["status"],
      numberType: json["number_type"],
      location: json["location"],
      type: json["type"],
      smeVirtualPoolOperator: json["operator"],
      siteIdentifier: json["site_identifier"],
      dc: json["dc"],
      callFlowId: json["call_flow_id"],
      flowName: json["flow_name"],
      agentName: json["agent_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "longcode": longcode,
        "id": id,
        "status": status,
        "number_type": numberType,
        "location": location,
        "type": type,
        "operator": smeVirtualPoolOperator,
        "site_identifier": siteIdentifier,
        "dc": dc,
        "call_flow_id": callFlowId,
        "flow_name": flowName,
        "agent_name": agentName,
      };

  @override
  List<Object?> get props => [
        longcode,
        id,
        status,
        numberType,
        location,
        type,
        smeVirtualPoolOperator,
        siteIdentifier,
        dc,
        callFlowId,
        flowName,
        agentName,
      ];
}
