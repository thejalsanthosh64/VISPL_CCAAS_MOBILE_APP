import 'package:equatable/equatable.dart';

// class UpdateUserCampaignData extends Equatable {
//   const UpdateUserCampaignData({
//     this.smeId,
//     this.agentName,
//     this.queueId,
//     this.selectedCampaigns,
//   });

//   final int? smeId;
//   final String? agentName;
//   final int? queueId;
//   final List<SelectedCampaign>? selectedCampaigns;

//   UpdateUserCampaignData copyWith({
//     int? smeId,
//     String? agentName,
//     int? queueId,
//     List<SelectedCampaign>? selectedCampaigns,
//   }) {
//     return UpdateUserCampaignData(
//       smeId: smeId ?? this.smeId,
//       agentName: agentName ?? this.agentName,
//       queueId: queueId ?? this.queueId,
//       selectedCampaigns: selectedCampaigns ?? this.selectedCampaigns,
//     );
//   }

//   factory UpdateUserCampaignData.fromJson(Map<String, dynamic> json) {
//     return UpdateUserCampaignData(
//       smeId: json["smeId"],
//       agentName: json["agentName"],
//       queueId: json["queueId"],
//       selectedCampaigns: json["selectedCampaigns"] == null
//           ? null
//           : List<SelectedCampaign>.from(json["selectedCampaigns"]!.map((x) => SelectedCampaign.fromJson(x))),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "smeId": smeId,
//         "agentName": agentName,
//         "queueId": queueId,
//         "selectedCampaigns": selectedCampaigns?.map((x) => x.toJson()).toList(),
//       };

//   @override
//   List<Object?> get props => [
//         smeId,
//         agentName,
//         queueId,
//         selectedCampaigns,
//       ];
// }

// class SelectedCampaign extends Equatable {
//   const SelectedCampaign({
//     this.campaignName,
//     this.campaignId,
//     this.queueId,
//   });

//   final String? campaignName;
//   final String? campaignId;
//   final int? queueId;

//   SelectedCampaign copyWith({
//     String? campaignName,
//     String? campaignId,
//     int? queueId,
//   }) {
//     return SelectedCampaign(
//       campaignName: campaignName ?? this.campaignName,
//       campaignId: campaignId ?? this.campaignId,
//       queueId: queueId ?? this.queueId,
//     );
//   }

//   factory SelectedCampaign.fromJson(Map<String, dynamic> json) {
//     return SelectedCampaign(
//       campaignName: json["campaignName"],
//       campaignId: json["campaignId"],
//       queueId: json["queueId"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "campaignName": campaignName,
//         "campaignId": campaignId,
//         "queueId": queueId,
//       };

//   @override
//   List<Object?> get props => [
//         campaignName,
//         campaignId,
//         queueId,
//       ];
// }


class UpdateUserCampaignData extends Equatable {
  final int agentId;
  final String agentName;
  final int currentCallMode;
  final String role;
  final String queueId;
  final List<SelectedCampaignItem> selectedCampaigns;

  const UpdateUserCampaignData({
    required this.agentId,
    required this.agentName,
    this.currentCallMode = 1,
    this.role = "agent",
    required this.queueId,
    required this.selectedCampaigns,
  });

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
        "agent_name": agentName,
        "current_call_mode": currentCallMode,
        "role": role,
        "queue_id": queueId,
        "selected_campaigns":
            selectedCampaigns.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        agentId,
        agentName,
        currentCallMode,
        role,
        queueId,
        selectedCampaigns,
      ];
}

class SelectedCampaignItem extends Equatable {
  final String itemText;
  final String name;
  final String itemId;
  final String id;
  final String category;
  final String group;
  final String queueId;

  const SelectedCampaignItem({
    required this.itemText,
    required this.name,
    required this.itemId,
    required this.id,
    required this.category,
    required this.group,
    required this.queueId,
  });

  Map<String, dynamic> toJson() => {
        "item_text": itemText,
        "name": name,
        "item_id": itemId,
        "id": id,
        "category": category,
        "group": group,
        "queue_id": queueId,
      };

  @override
  List<Object?> get props =>
      [itemText, name, itemId, id, category, group, queueId];
}
