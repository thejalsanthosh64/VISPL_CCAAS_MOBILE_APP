import 'package:equatable/equatable.dart';

class UpdateUserCampaignData extends Equatable {
  const UpdateUserCampaignData({
    this.smeId,
    this.agentName,
    this.queueId,
    this.selectedCampaigns,
  });

  final int? smeId;
  final String? agentName;
  final int? queueId;
  final List<SelectedCampaign>? selectedCampaigns;

  UpdateUserCampaignData copyWith({
    int? smeId,
    String? agentName,
    int? queueId,
    List<SelectedCampaign>? selectedCampaigns,
  }) {
    return UpdateUserCampaignData(
      smeId: smeId ?? this.smeId,
      agentName: agentName ?? this.agentName,
      queueId: queueId ?? this.queueId,
      selectedCampaigns: selectedCampaigns ?? this.selectedCampaigns,
    );
  }

  factory UpdateUserCampaignData.fromJson(Map<String, dynamic> json) {
    return UpdateUserCampaignData(
      smeId: json["smeId"],
      agentName: json["agentName"],
      queueId: json["queueId"],
      selectedCampaigns: json["selectedCampaigns"] == null
          ? null
          : List<SelectedCampaign>.from(json["selectedCampaigns"]!.map((x) => SelectedCampaign.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "smeId": smeId,
        "agentName": agentName,
        "queueId": queueId,
        "selectedCampaigns": selectedCampaigns?.map((x) => x.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        smeId,
        agentName,
        queueId,
        selectedCampaigns,
      ];
}

class SelectedCampaign extends Equatable {
  const SelectedCampaign({
    this.campaignName,
    this.campaignId,
    this.queueId,
  });

  final String? campaignName;
  final String? campaignId;
  final int? queueId;

  SelectedCampaign copyWith({
    String? campaignName,
    String? campaignId,
    int? queueId,
  }) {
    return SelectedCampaign(
      campaignName: campaignName ?? this.campaignName,
      campaignId: campaignId ?? this.campaignId,
      queueId: queueId ?? this.queueId,
    );
  }

  factory SelectedCampaign.fromJson(Map<String, dynamic> json) {
    return SelectedCampaign(
      campaignName: json["campaignName"],
      campaignId: json["campaignId"],
      queueId: json["queueId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "campaignName": campaignName,
        "campaignId": campaignId,
        "queueId": queueId,
      };

  @override
  List<Object?> get props => [
        campaignName,
        campaignId,
        queueId,
      ];
}
