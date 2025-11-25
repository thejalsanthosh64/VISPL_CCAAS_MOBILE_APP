import 'package:equatable/equatable.dart';

// class CampaignData extends Equatable {
//   const CampaignData({
//     this.virtualNumberPool,
//     this.id,
//     this.campaignQueueName,
//     this.campaignType,
//     this.campaignQueue,
//     this.campaignName,
//     this.smeId,
//   });

//   final List<VirtualNumberPool>? virtualNumberPool;
//   final String? id;
//   final String? campaignQueueName;
//   final String? campaignType;
//   final String? campaignQueue;
//   final String? campaignName;
//   final int? smeId;

//   CampaignData copyWith({
//     List<VirtualNumberPool>? virtualNumberPool,
//     String? id,
//     String? campaignQueueName,
//     String? campaignType,
//     String? campaignQueue,
//     String? campaignName,
//     int? smeId,
//   }) {
//     return CampaignData(
//       virtualNumberPool: virtualNumberPool ?? this.virtualNumberPool,
//       id: id ?? this.id,
//       campaignQueueName: campaignQueueName ?? this.campaignQueueName,
//       campaignType: campaignType ?? this.campaignType,
//       campaignQueue: campaignQueue ?? this.campaignQueue,
//       campaignName: campaignName ?? this.campaignName,
//       smeId: smeId ?? this.smeId,
//     );
//   }

//   factory CampaignData.fromJson(Map<String, dynamic> json) {
//     return CampaignData(
//       virtualNumberPool: json["virtual_number_pool"] == null
//           ? null
//           : List<VirtualNumberPool>.from(json["virtual_number_pool"]!.map((x) => VirtualNumberPool.fromJson(x))),
//       id: json["_id"],
//       campaignQueueName: json["campaign_queue_name"],
//       campaignType: json["campaign_type"],
//       campaignQueue: json["campaign_queue"],
//       campaignName: json["campaign_name"],
//       smeId: json["sme_id"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "virtual_number_pool": virtualNumberPool?.map((x) => x.toJson()).toList(),
//         "_id": id,
//         "campaign_queue_name": campaignQueueName,
//         "campaign_type": campaignType,
//         "campaign_queue": campaignQueue,
//         "campaign_name": campaignName,
//         "sme_id": smeId,
//       };

//   @override
//   List<Object?> get props => [
//         virtualNumberPool,
//         id,
//         campaignQueueName,
//         campaignType,
//         campaignQueue,
//         campaignName,
//         smeId,
//       ];
// }

// class VirtualNumberPool extends Equatable {
//   const VirtualNumberPool({
//      this.id,
//      this.longcode,
//   });

//   final int? id;
//   final String? longcode;

//   VirtualNumberPool copyWith({
//     int? id,
//     String? longcode,
//   }) {
//     return VirtualNumberPool(
//       id: id ?? this.id,
//       longcode: longcode ?? this.longcode,
//     );
//   }

//   factory VirtualNumberPool.fromJson(Map<String, dynamic> json) {
//     return VirtualNumberPool(
//       id: json["id"],
//       longcode: json["longcode"],
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "longcode": longcode,
//       };

//   @override
//   List<Object?> get props => [
//         id,
//         longcode,
//       ];
// }



class CampaignData extends Equatable {
  const CampaignData({
    this.virtualNumberPool,
    this.id,
    this.campaignQueueName,
    this.campaignType,
    this.campaignQueue,
    this.campaignName,
    this.smeId,
    this.callPriority,
    this.wrapupTimeInSeconds,
    this.ringTimeoutInSeconds,
    this.dispositions,
    this.datesObject,
    this.pacingRatio,
  });

  final List<VirtualNumberPool>? virtualNumberPool;
  final String? id;
  final String? campaignQueueName;
  final String? campaignType;
  final String? campaignQueue;
  final String? campaignName;
  final int? smeId;

  /// NEWLY ADDED FIELDS
  final int? callPriority;
  final int? wrapupTimeInSeconds;
  final int? ringTimeoutInSeconds;
  final List<DispositionItem>? dispositions;
  final List<DateWindow>? datesObject;
  final String? pacingRatio;

  CampaignData copyWith({
    List<VirtualNumberPool>? virtualNumberPool,
    String? id,
    String? campaignQueueName,
    String? campaignType,
    String? campaignQueue,
    String? campaignName,
    int? smeId,
    int? callPriority,
    int? wrapupTimeInSeconds,
    int? ringTimeoutInSeconds,
    List<DispositionItem>? dispositions,
    List<DateWindow>? datesObject,
    String? pacingRatio,
  }) {
    return CampaignData(
      virtualNumberPool: virtualNumberPool ?? this.virtualNumberPool,
      id: id ?? this.id,
      campaignQueueName: campaignQueueName ?? this.campaignQueueName,
      campaignType: campaignType ?? this.campaignType,
      campaignQueue: campaignQueue ?? this.campaignQueue,
      campaignName: campaignName ?? this.campaignName,
      smeId: smeId ?? this.smeId,
      callPriority: callPriority ?? this.callPriority,
      wrapupTimeInSeconds:
          wrapupTimeInSeconds ?? this.wrapupTimeInSeconds,
      ringTimeoutInSeconds:
          ringTimeoutInSeconds ?? this.ringTimeoutInSeconds,
      dispositions: dispositions ?? this.dispositions,
      datesObject: datesObject ?? this.datesObject,
      pacingRatio: pacingRatio ?? this.pacingRatio,
    );
  }

  factory CampaignData.fromJson(Map<String, dynamic> json) {
    return CampaignData(
      virtualNumberPool: json["virtual_number_pool"] == null
          ? null
          : List<VirtualNumberPool>.from(json["virtual_number_pool"]
              .map((x) => VirtualNumberPool.fromJson(x))),
      id: json["_id"],
      campaignQueueName: json["campaign_queue_name"],
      campaignType: json["campaign_type"],
      campaignQueue: json["campaign_queue"],
      campaignName: json["campaign_name"],
      smeId: json["sme_id"],

      /// NEWLY PARSED FIELDS
      callPriority: json["call_priority"],
      wrapupTimeInSeconds: json["wrapup_time_in_seconds"],
      ringTimeoutInSeconds: json["ring_timeout_in_seconds"],
      pacingRatio: json["pacing_ratio"],

      dispositions: json["dispositions"] == null
          ? null
          : List<DispositionItem>.from(json["dispositions"]
              .map((x) => DispositionItem.fromJson(x))),

      datesObject: json["dates_object"] == null
          ? null
          : List<DateWindow>.from(json["dates_object"]
              .map((x) => DateWindow.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "virtual_number_pool":
            virtualNumberPool?.map((x) => x.toJson()).toList(),
        "_id": id,
        "campaign_queue_name": campaignQueueName,
        "campaign_type": campaignType,
        "campaign_queue": campaignQueue,
        "campaign_name": campaignName,
        "sme_id": smeId,
        "call_priority": callPriority,
        "wrapup_time_in_seconds": wrapupTimeInSeconds,
        "ring_timeout_in_seconds": ringTimeoutInSeconds,
        "pacing_ratio": pacingRatio,
        "dispositions": dispositions?.map((x) => x.toJson()).toList(),
        "dates_object": datesObject?.map((x) => x.toJson()).toList(),
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
        callPriority,
        wrapupTimeInSeconds,
        ringTimeoutInSeconds,
        dispositions,
        datesObject,
        pacingRatio,
      ];
}

class VirtualNumberPool extends Equatable {
  const VirtualNumberPool({
    this.id,
    this.longcode,
  });

  final int? id;
  final String? longcode;

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
  List<Object?> get props => [id, longcode];
}

class DispositionItem extends Equatable {
  const DispositionItem({this.id, this.combinedField});

  final String? id;
  final String? combinedField;

  factory DispositionItem.fromJson(Map<String, dynamic> json) =>
      DispositionItem(
        id: json["_id"],
        combinedField: json["combinedField"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "combinedField": combinedField,
      };

  @override
  List<Object?> get props => [id, combinedField];
}

class DateWindow extends Equatable {
  const DateWindow({
    this.startTime,
    this.endTime,
  });

  final int? startTime;
  final int? endTime;

  factory DateWindow.fromJson(Map<String, dynamic> json) => DateWindow(
        startTime: json["startTime"],
        endTime: json["endTime"],
      );

  Map<String, dynamic> toJson() => {
        "startTime": startTime,
        "endTime": endTime,
      };

  @override
  List<Object?> get props => [startTime, endTime];
}
