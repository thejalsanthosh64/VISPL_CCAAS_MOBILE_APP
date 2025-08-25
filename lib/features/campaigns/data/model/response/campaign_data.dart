import 'package:equatable/equatable.dart';

class CampaignData extends Equatable {
  const CampaignData({
    this.virtualNumberPool,
    this.id,
    this.campaignQueueName,
    this.campaignType,
    this.campaignQueue,
    this.campaignName,
    this.smeId,
  });

  final List<VirtualNumberPool>? virtualNumberPool;
  final String? id;
  final String? campaignQueueName;
  final String? campaignType;
  final String? campaignQueue;
  final String? campaignName;
  final int? smeId;

  CampaignData copyWith({
    List<VirtualNumberPool>? virtualNumberPool,
    String? id,
    String? campaignQueueName,
    String? campaignType,
    String? campaignQueue,
    String? campaignName,
    int? smeId,
  }) {
    return CampaignData(
      virtualNumberPool: virtualNumberPool ?? this.virtualNumberPool,
      id: id ?? this.id,
      campaignQueueName: campaignQueueName ?? this.campaignQueueName,
      campaignType: campaignType ?? this.campaignType,
      campaignQueue: campaignQueue ?? this.campaignQueue,
      campaignName: campaignName ?? this.campaignName,
      smeId: smeId ?? this.smeId,
    );
  }

  factory CampaignData.fromJson(Map<String, dynamic> json) {
    return CampaignData(
      virtualNumberPool: json["virtual_number_pool"] == null
          ? null
          : List<VirtualNumberPool>.from(json["virtual_number_pool"]!.map((x) => VirtualNumberPool.fromJson(x))),
      id: json["_id"],
      campaignQueueName: json["campaign_queue_name"],
      campaignType: json["campaign_type"],
      campaignQueue: json["campaign_queue"],
      campaignName: json["campaign_name"],
      smeId: json["sme_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "virtual_number_pool": virtualNumberPool?.map((x) => x.toJson()).toList(),
        "_id": id,
        "campaign_queue_name": campaignQueueName,
        "campaign_type": campaignType,
        "campaign_queue": campaignQueue,
        "campaign_name": campaignName,
        "sme_id": smeId,
      };

  @override
  List<Object?> get props => [
        virtualNumberPool,
        id,
        campaignQueueName,
        campaignType,
        campaignQueue,
        campaignName,
        smeId,
      ];
}

class VirtualNumberPool extends Equatable {
  const VirtualNumberPool({
     this.id,
     this.longcode,
  });

  final int? id;
  final String? longcode;

  VirtualNumberPool copyWith({
    int? id,
    String? longcode,
  }) {
    return VirtualNumberPool(
      id: id ?? this.id,
      longcode: longcode ?? this.longcode,
    );
  }

  factory VirtualNumberPool.fromJson(Map<String, dynamic> json) {
    return VirtualNumberPool(
      id: json["id"],
      longcode: json["longcode"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "longcode": longcode,
      };

  @override
  List<Object?> get props => [
        id,
        longcode,
      ];
}
