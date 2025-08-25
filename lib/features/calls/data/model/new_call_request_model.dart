import 'package:equatable/equatable.dart';
import 'package:kommuno/core/utilities/date_utility.dart';

class NewCallRequestModel extends Equatable {
  const NewCallRequestModel({
    required this.accountSid,
    this.agentGroup = defaultAgentGroup,
    required this.agentId,
    required this.agentNumber,
    this.baseId = defaultBaseId,
    this.callMode = defaultCallMode,
    this.callPriority = defaultCallPriority,
    this.customDtmf = defaultCustomDtmf,
    this.customDtmfFlag = defaultCustomDtmfFlag,
    required this.from,
    required this.insertDateTime,
    this.liveEvent = defaultLiveEvent,
    this.liveEventFlag = defaultLiveEventFlag,
    this.mediaFileFlag = defaultMediaFileFlag,
    this.mediaFileId = defaultMediaFileId,
    this.nameFileFlag = defaultNameFileFlag,
    this.nameFileId = defaultNameFileId,
    this.optionalField = defaultOptionalField,
    required this.pilotNumber,
    this.recordingFlag = defaultRecordingFlag,
    required this.scheduleDateTime,
    required this.sessionId,
    required this.smeId,
    this.timeLimit = defaultTimeLimit,
    required this.to,
    this.campaignId,
  });

  final String accountSid;
  final String agentGroup;
  final int agentId;
  final String agentNumber;
  final int baseId;
  final String callMode;
  final int callPriority;
  final String customDtmf;
  final bool customDtmfFlag;
  final String from;
  final DateTime insertDateTime;
  final String liveEvent;
  final bool liveEventFlag;
  final bool mediaFileFlag;
  final String mediaFileId;
  final bool nameFileFlag;
  final String nameFileId;
  final String optionalField;
  final String pilotNumber;
  final bool recordingFlag;
  final DateTime scheduleDateTime;
  final String sessionId;
  final String smeId;
  final int timeLimit;
  final String to;

  /// Will be null for clickToCall Endpoint
  final String? campaignId;

  static const String defaultAgentGroup = "";
  static const String defaultCallMode = "4";
  static const int defaultBaseId = 0;
  static const int defaultTimeLimit = 0;
  static const int defaultCallPriority = 0;
  static const String defaultCustomDtmf = "";
  static const bool defaultCustomDtmfFlag = false;
  static const String defaultLiveEvent = "";
  static const String defaultMediaFileId = "";
  static const String defaultNameFileId = "";
  static const bool defaultLiveEventFlag = false;
  static const bool defaultMediaFileFlag = false;
  static const bool defaultNameFileFlag = false;
  static const bool defaultRecordingFlag = true;
  static const String defaultOptionalField = "wringg_app_call";
  static final String defaultSessionId = "wri${DateTime.now().millisecondsSinceEpoch}";

  NewCallRequestModel copyWith({
    String? accountSid,
    String? agentGroup,
    int? agentId,
    String? agentNumber,
    int? baseId,
    String? callMode,
    int? callPriority,
    String? customDtmf,
    bool? customDtmfFlag,
    String? from,
    DateTime? insertDateTime,
    String? liveEvent,
    bool? liveEventFlag,
    bool? mediaFileFlag,
    String? mediaFileId,
    bool? nameFileFlag,
    String? nameFileId,
    String? optionalField,
    String? pilotNumber,
    bool? recordingFlag,
    DateTime? scheduleDateTime,
    String? sessionId,
    String? smeId,
    int? timeLimit,
    String? to,
    String? campaignId,
  }) {
    return NewCallRequestModel(
      accountSid: accountSid ?? this.accountSid,
      agentGroup: agentGroup ?? this.agentGroup,
      agentId: agentId ?? this.agentId,
      agentNumber: agentNumber ?? this.agentNumber,
      baseId: baseId ?? this.baseId,
      callMode: callMode ?? this.callMode,
      callPriority: callPriority ?? this.callPriority,
      customDtmf: customDtmf ?? this.customDtmf,
      customDtmfFlag: customDtmfFlag ?? this.customDtmfFlag,
      from: from ?? this.from,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      liveEvent: liveEvent ?? this.liveEvent,
      liveEventFlag: liveEventFlag ?? this.liveEventFlag,
      mediaFileFlag: mediaFileFlag ?? this.mediaFileFlag,
      mediaFileId: mediaFileId ?? this.mediaFileId,
      nameFileFlag: nameFileFlag ?? this.nameFileFlag,
      nameFileId: nameFileId ?? this.nameFileId,
      optionalField: optionalField ?? this.optionalField,
      pilotNumber: pilotNumber ?? this.pilotNumber,
      recordingFlag: recordingFlag ?? this.recordingFlag,
      scheduleDateTime: scheduleDateTime ?? this.scheduleDateTime,
      sessionId: sessionId ?? this.sessionId,
      smeId: smeId ?? this.smeId,
      timeLimit: timeLimit ?? this.timeLimit,
      to: to ?? this.to,
      campaignId: campaignId ?? this.campaignId,
    );
  }

  factory NewCallRequestModel.fromJson(Map<String, dynamic> json) {
    return NewCallRequestModel(
      accountSid: json["accountSid"],
      agentGroup: json["agentGroup"],
      agentId: json["agentId"],
      agentNumber: json["agentNumber"],
      baseId: json["baseId"],
      callMode: json["callMode"],
      callPriority: json["callPriority"],
      customDtmf: json["customDtmf"],
      customDtmfFlag: json["customDtmfFlag"],
      from: json["from"],
      insertDateTime: DateTime.parse(json["insertDateTime"] ?? "").toLocal(),
      liveEvent: json["liveEvent"],
      liveEventFlag: json["liveEventFlag"],
      mediaFileFlag: json["mediaFileFlag"],
      mediaFileId: json["mediaFileId"],
      nameFileFlag: json["nameFileFlag"],
      nameFileId: json["nameFileId"],
      optionalField: json["optionalField"],
      pilotNumber: json["pilotNumber"],
      recordingFlag: json["recordingFlag"],
      scheduleDateTime: DateTime.parse(json["scheduleDateTime"] ?? "").toLocal(),
      sessionId: json["sessionId"],
      smeId: json["smeId"],
      timeLimit: json["timeLimit"],
      to: json["to"],
      campaignId: json["campaignId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "accountSid": accountSid,
        "agentGroup": agentGroup,
        "agentId": agentId,
        "agentNumber": agentNumber,
        "baseId": baseId,
        "callMode": callMode,
        "callPriority": callPriority,
        "customDtmf": customDtmf,
        "customDtmfFlag": customDtmfFlag,
        "from": from,
        "insertDateTime": DateUtility.sendRequestDateTimeFormat(date: insertDateTime.toUtc()),
        "liveEvent": liveEvent,
        "liveEventFlag": liveEventFlag,
        "mediaFileFlag": mediaFileFlag,
        "mediaFileId": mediaFileId,
        "nameFileFlag": nameFileFlag,
        "nameFileId": nameFileId,
        "optionalField": optionalField,
        "pilotNumber": pilotNumber,
        "recordingFlag": recordingFlag,
        "scheduleDateTime": DateUtility.sendRequestDateTimeFormat(date: scheduleDateTime.toUtc()),
        "sessionId": sessionId,
        "smeId": smeId,
        "timeLimit": timeLimit,
        "to": to,
        "campaignId": campaignId,
      };

  @override
  String toString() {
    return "$accountSid, $agentGroup, $agentId, $agentNumber, $baseId, $callMode, $callPriority, $customDtmf, $customDtmfFlag, $from, $insertDateTime, $liveEvent, $liveEventFlag, $mediaFileFlag, $mediaFileId, $nameFileFlag, $nameFileId, $optionalField, $pilotNumber, $recordingFlag, $scheduleDateTime, $sessionId, $smeId, $timeLimit, $to, $campaignId ";
  }

  @override
  List<Object?> get props => [
        accountSid,
        agentGroup,
        agentId,
        agentNumber,
        baseId,
        callMode,
        callPriority,
        customDtmf,
        customDtmfFlag,
        from,
        insertDateTime,
        liveEvent,
        liveEventFlag,
        mediaFileFlag,
        mediaFileId,
        nameFileFlag,
        nameFileId,
        optionalField,
        pilotNumber,
        recordingFlag,
        scheduleDateTime,
        sessionId,
        smeId,
        timeLimit,
        to,
        campaignId,
      ];
}
