import 'package:equatable/equatable.dart';

class UserDetailsModel extends Equatable {
  const UserDetailsModel({
     this.inPermissionFlag,
    required this.outPermissionFlag,
    required this.breakPermissionFlag,
    this.accountSid,
    required this.agentEmail,
    required this.agentExtention,
    required this.agentId,
    this.groupId,
    required this.agentMasking,
    required this.agentMobile,
    required this.agentName,
    this.agentScore,
    required this.agentRelaxTime,
    required this.allowedAgents,
    required this.alternateNumber,
    required this.assignFailedCalls,
    required this.assignVoicemailCalls,
    required this.balance,
    this.bizAddress,
    this.callBackUrl,
    required this.daysFlag,
    required this.guiTimer,
    required this.inChannels,
    required this.insertTime,
    required this.smeInCallPermission,
    required this.smeOutCallPermission,
    required this.inQueueChannels,
    required this.language,
    this.masking,
    this.longcode,
    this.longcodeId,
    required this.outChannels,
    this.recording,
    required this.recValidity,
    required this.eodReportFlag,
    this.selectionAlgo,
    this.serviceFlag,
    required this.smeId,
    required this.smeMobile,
    required this.userDetailsModelSmeName,
    required this.smeStatus,
    required this.agentStatus,
    required this.stickyAlgo,
    required this.stickyAgent,
    required this.stickyDays,
    required this.roles,
    required this.smeName,
    required this.userName,
    required this.status,
    this.billingStatus,
    required this.longocdeJson,
  });

  final int? inPermissionFlag;
  final int outPermissionFlag;
  final int breakPermissionFlag;
  final String? accountSid;
  final String agentEmail;
  final int agentExtention;
  final int agentId;
  final int? groupId;
  final int agentMasking;
  final String agentMobile;
  final String agentName;
  final int? agentScore;
  final int agentRelaxTime;
  final int allowedAgents;
  final String alternateNumber;
  final int assignFailedCalls;
  final int assignVoicemailCalls;
  final int balance;
  final String? bizAddress;
  final String? callBackUrl;
  final int daysFlag;
  final int guiTimer;
  final int inChannels;
  final DateTime? insertTime;
  final int smeInCallPermission;
  final int smeOutCallPermission;
  final int inQueueChannels;
  final int language;
  final int? masking;
  final int? longcode;
  final int? longcodeId;
  final int outChannels;
  final int? recording;
  final int recValidity;
  final int eodReportFlag;
  final String? selectionAlgo;
  final int? serviceFlag;
  final int smeId;
  final String smeMobile;
  final String userDetailsModelSmeName;
  final int smeStatus;
  final int agentStatus;
  final int stickyAlgo;
  final int stickyAgent;
  final int stickyDays;
  final String roles;
  final String smeName;
  final String userName;
  final int status;
  final int? billingStatus;
  final List<LongoCdeJsonData> longocdeJson;

  UserDetailsModel copyWith({
    int? inPermissionFlag,
    int? outPermissionFlag,
    int? breakPermissionFlag,
    String? accountSid,
    String? agentEmail,
    int? agentExtention,
    int? agentId,
    int? groupId,
    int? agentMasking,
    String? agentMobile,
    String? agentName,
    int? agentScore,
    int? agentRelaxTime,
    int? allowedAgents,
    String? alternateNumber,
    int? assignFailedCalls,
    int? assignVoicemailCalls,
    int? balance,
    String? bizAddress,
    String? callBackUrl,
    int? daysFlag,
    int? guiTimer,
    int? inChannels,
    DateTime? insertTime,
    int? smeInCallPermission,
    int? smeOutCallPermission,
    int? inQueueChannels,
    int? language,
    int? masking,
    int? longcode,
    int? longcodeId,
    int? outChannels,
    int? recording,
    int? recValidity,
    int? eodReportFlag,
    String? selectionAlgo,
    int? serviceFlag,
    int? smeId,
    String? smeMobile,
    String? userDetailsModelSmeName,
    int? smeStatus,
    int? agentStatus,
    int? stickyAlgo,
    int? stickyAgent,
    int? stickyDays,
    String? roles,
    String? smeName,
    String? userName,
    int? status,
    int? billingStatus,
    List<LongoCdeJsonData>? longocdeJson,
  }) {
    return UserDetailsModel(
      inPermissionFlag: inPermissionFlag ?? this.inPermissionFlag,
      outPermissionFlag: outPermissionFlag ?? this.outPermissionFlag,
      breakPermissionFlag: breakPermissionFlag ?? this.breakPermissionFlag,
      accountSid: accountSid ?? this.accountSid,
      agentEmail: agentEmail ?? this.agentEmail,
      agentExtention: agentExtention ?? this.agentExtention,
      agentId: agentId ?? this.agentId,
      groupId: groupId ?? this.groupId,
      agentMasking: agentMasking ?? this.agentMasking,
      agentMobile: agentMobile ?? this.agentMobile,
      agentName: agentName ?? this.agentName,
      agentScore: agentScore ?? this.agentScore,
      agentRelaxTime: agentRelaxTime ?? this.agentRelaxTime,
      allowedAgents: allowedAgents ?? this.allowedAgents,
      alternateNumber: alternateNumber ?? this.alternateNumber,
      assignFailedCalls: assignFailedCalls ?? this.assignFailedCalls,
      assignVoicemailCalls: assignVoicemailCalls ?? this.assignVoicemailCalls,
      balance: balance ?? this.balance,
      bizAddress: bizAddress ?? this.bizAddress,
      callBackUrl: callBackUrl ?? this.callBackUrl,
      daysFlag: daysFlag ?? this.daysFlag,
      guiTimer: guiTimer ?? this.guiTimer,
      inChannels: inChannels ?? this.inChannels,
      insertTime: insertTime ?? this.insertTime,
      smeInCallPermission: smeInCallPermission ?? this.smeInCallPermission,
      smeOutCallPermission: smeOutCallPermission ?? this.smeOutCallPermission,
      inQueueChannels: inQueueChannels ?? this.inQueueChannels,
      language: language ?? this.language,
      masking: masking ?? this.masking,
      longcode: longcode ?? this.longcode,
      longcodeId: longcodeId ?? this.longcodeId,
      outChannels: outChannels ?? this.outChannels,
      recording: recording ?? this.recording,
      recValidity: recValidity ?? this.recValidity,
      eodReportFlag: eodReportFlag ?? this.eodReportFlag,
      selectionAlgo: selectionAlgo ?? this.selectionAlgo,
      serviceFlag: serviceFlag ?? this.serviceFlag,
      smeId: smeId ?? this.smeId,
      smeMobile: smeMobile ?? this.smeMobile,
      userDetailsModelSmeName: userDetailsModelSmeName ?? this.userDetailsModelSmeName,
      smeStatus: smeStatus ?? this.smeStatus,
      agentStatus: agentStatus ?? this.agentStatus,
      stickyAlgo: stickyAlgo ?? this.stickyAlgo,
      stickyAgent: stickyAgent ?? this.stickyAgent,
      stickyDays: stickyDays ?? this.stickyDays,
      roles: roles ?? this.roles,
      smeName: smeName ?? this.smeName,
      userName: userName ?? this.userName,
      status: status ?? this.status,
      billingStatus: billingStatus ?? this.billingStatus,
      longocdeJson: longocdeJson ?? this.longocdeJson,
    );
  }

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsModel(
      inPermissionFlag: json["inPermissionFlag"],
      outPermissionFlag: json["outPermissionFlag"],
      breakPermissionFlag: json["breakPermissionFlag"],
      accountSid: json["account_sid"],
      agentEmail: json["agent_email"],
      agentExtention: json["agent_extention"],
      agentId: json["agent_id"],
      groupId: json["group_id"],
      agentMasking: json["agent_masking"],
      agentMobile: json["agent_mobile"],
      agentName: json["agentName"],
      agentScore: json["agent_score"],
      agentRelaxTime: json["agent_relax_time"],
      allowedAgents: json["allowed_agents"],
      alternateNumber: json["alternate_number"],
      assignFailedCalls: json["assign_failed_calls"],
      assignVoicemailCalls: json["assign_voicemail_calls"],
      balance: json["balance"],
      bizAddress: json["biz_address"],
      callBackUrl: json["call_back_url"],
      daysFlag: json["days_flag"],
      guiTimer: json["gui_timer"],
      inChannels: json["in_channels"],
      insertTime: DateTime.tryParse(json["insert_time"] ?? ""),
      smeInCallPermission: json["sme_in_call_permission"],
      smeOutCallPermission: json["sme_out_call_permission"],
      inQueueChannels: json["in_queue_channels"],
      language: json["language"],
      masking: json["masking"],
      longcode: json["longcode"],
      longcodeId: json["longcode_id"],
      outChannels: json["out_channels"],
      recording: json["recording"],
      recValidity: json["rec_validity"],
      eodReportFlag: json["eod_report_flag"],
      selectionAlgo: json["selection_algo"],
      serviceFlag: json["service_flag"],
      smeId: json["smeId"],
      smeMobile: json["sme_mobile"],
      userDetailsModelSmeName: json["sme_name"],
      smeStatus: json["sme_status"],
      agentStatus: json["agent_status"],
      stickyAlgo: json["sticky_algo"],
      stickyAgent: json["sticky_agent"],
      stickyDays: json["sticky_days"],
      roles: json["roles"],
      smeName: json["smeName"],
      userName: json["userName"],
      status: json["status"],
      billingStatus: json["billing_status"],
      longocdeJson:
          json["longocdejson"] == null ? [] : List<LongoCdeJsonData>.from(json["longocdejson"]!.map((x) => LongoCdeJsonData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "inPermissionFlag": inPermissionFlag,
        "outPermissionFlag": outPermissionFlag,
        "breakPermissionFlag": breakPermissionFlag,
        "account_sid": accountSid,
        "agent_email": agentEmail,
        "agent_extention": agentExtention,
        "agent_id": agentId,
        "group_id": groupId,
        "agent_masking": agentMasking,
        "agent_mobile": agentMobile,
        "agentName": agentName,
        "agent_score": agentScore,
        "agent_relax_time": agentRelaxTime,
        "allowed_agents": allowedAgents,
        "alternate_number": alternateNumber,
        "assign_failed_calls": assignFailedCalls,
        "assign_voicemail_calls": assignVoicemailCalls,
        "balance": balance,
        "biz_address": bizAddress,
        "call_back_url": callBackUrl,
        "days_flag": daysFlag,
        "gui_timer": guiTimer,
        "in_channels": inChannels,
        "insert_time": insertTime?.toIso8601String(),
        "sme_in_call_permission": smeInCallPermission,
        "sme_out_call_permission": smeOutCallPermission,
        "in_queue_channels": inQueueChannels,
        "language": language,
        "masking": masking,
        "longcode": longcode,
        "longcode_id": longcodeId,
        "out_channels": outChannels,
        "recording": recording,
        "rec_validity": recValidity,
        "eod_report_flag": eodReportFlag,
        "selection_algo": selectionAlgo,
        "service_flag": serviceFlag,
        "smeId": smeId,
        "sme_mobile": smeMobile,
        "sme_name": userDetailsModelSmeName,
        "sme_status": smeStatus,
        "agent_status": agentStatus,
        "sticky_algo": stickyAlgo,
        "sticky_agent": stickyAgent,
        "sticky_days": stickyDays,
        "roles": roles,
        "smeName": smeName,
        "userName": userName,
        "status": status,
        "billing_status": billingStatus,
        "longocdejson": longocdeJson.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$inPermissionFlag, $outPermissionFlag, $breakPermissionFlag, $accountSid, $agentEmail, $agentExtention, $agentId, $groupId, $agentMasking, $agentMobile, $agentName, $agentScore, $agentRelaxTime, $allowedAgents, $alternateNumber, $assignFailedCalls, $assignVoicemailCalls, $balance, $bizAddress, $callBackUrl, $daysFlag, $guiTimer, $inChannels, $insertTime, $smeInCallPermission, $smeOutCallPermission, $inQueueChannels, $language, $masking, $longcode, $longcodeId, $outChannels, $recording, $recValidity, $eodReportFlag, $selectionAlgo, $serviceFlag, $smeId, $smeMobile, $userDetailsModelSmeName, $smeStatus, $agentStatus, $stickyAlgo, $stickyAgent, $stickyDays, $roles, $smeName, $userName, $status, $billingStatus, $longocdeJson, ";
  }

  @override
  List<Object?> get props => [
        inPermissionFlag,
        outPermissionFlag,
        breakPermissionFlag,
        accountSid,
        agentEmail,
        agentExtention,
        agentId,
        groupId,
        agentMasking,
        agentMobile,
        agentName,
        agentScore,
        agentRelaxTime,
        allowedAgents,
        alternateNumber,
        assignFailedCalls,
        assignVoicemailCalls,
        balance,
        bizAddress,
        callBackUrl,
        daysFlag,
        guiTimer,
        inChannels,
        insertTime,
        smeInCallPermission,
        smeOutCallPermission,
        inQueueChannels,
        language,
        masking,
        longcode,
        longcodeId,
        outChannels,
        recording,
        recValidity,
        eodReportFlag,
        selectionAlgo,
        serviceFlag,
        smeId,
        smeMobile,
        userDetailsModelSmeName,
        smeStatus,
        agentStatus,
        stickyAlgo,
        stickyAgent,
        stickyDays,
        roles,
        smeName,
        userName,
        status,
        billingStatus,
        longocdeJson,
      ];
}

class LongoCdeJsonData extends Equatable {
  const LongoCdeJsonData({
    required this.longCode,
    required this.status,
  });

  final int longCode;
  final int status;

  LongoCdeJsonData copyWith({
    int? longCode,
    int? status,
  }) {
    return LongoCdeJsonData(
      longCode: longCode ?? this.longCode,
      status: status ?? this.status,
    );
  }

  factory LongoCdeJsonData.fromJson(Map<String, dynamic> json) {
    return LongoCdeJsonData(
      longCode: json["longcode"],
      status: json["status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "longcode": longCode,
        "status": status,
      };

  @override
  String toString() {
    return "$longCode, $status, ";
  }

  @override
  List<Object?> get props => [longCode, status];
}
