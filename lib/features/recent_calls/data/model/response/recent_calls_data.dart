import 'package:equatable/equatable.dart';

class RecentCallsData extends Equatable {
  const RecentCallsData({
    required this.id,
    required this.smeId,
    required this.callDirection,
    this.connectedDuration,
    this.ringingDuration,
    required this.customerNumber,
    this.agentNumber,
    this.agentName,
    this.longcode,
    required this.sessionId,
    this.answer,
    this.callDirectionStatus,
    this.callRecordedFile,
    this.callRecordingStatus,
    this.callStatus,
    this.cdrMode,
    this.callMode,
    this.channelNo,
    this.disconnectedBy,
    this.duration,
    this.mergeStatus,
    required this.insertDateTime,
    required this.startDateTime,
    required this.endDateTime,
    this.masterShortcode,
    this.patchedAgentId,
    this.serverIpAddress,
    this.shortcodeMapping,
    this.smeIdentifier,
    this.voicemailRecordingFile,
    this.voicemailRecordingStatus,
    this.callType,
    this.hlr,
    this.callDescription,
    this.ivrDuration,
    this.customerStatus,
    this.finalStatus,
    this.callFlowId,
    this.callFlowName,
    this.provisionalFlag,
    this.finalDtmf,
    this.queueId,
    this.queueName,
    this.recordingPath,
    this.blacklist,
    this.did,
    this.channelId,
    this.crmRecordingPath,
    this.ivrRecordingPath,
    this.countryCode,
    this.addressBook = const [],
    this.v,
    this.customerName,
  });

  final String id;
  final int smeId;
  final String callDirection;
  final int? connectedDuration;
  final int? ringingDuration;
  final String customerNumber;
  final String? agentNumber;
  final String? agentName;
  final int? longcode;
  final String sessionId;
  final int? answer;
  final int? callDirectionStatus;
  final String? callRecordedFile;
  final int? callRecordingStatus;
  final int? callStatus;
  final int? cdrMode;
  final int? callMode;
  final int? channelNo;
  final String? disconnectedBy;
  final int? duration;
  final int? mergeStatus;
  final DateTime insertDateTime;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String? masterShortcode;
  final int? patchedAgentId;
  final String? serverIpAddress;
  final String? shortcodeMapping;
  final String? smeIdentifier;
  final String? voicemailRecordingFile;
  final int? voicemailRecordingStatus;
  final String? callType;
  final String? hlr;
  final String? callDescription;
  final int? ivrDuration;
  final int? customerStatus;
  final String? finalStatus;
  final int? callFlowId;
  final String? callFlowName;
  final int? provisionalFlag;
  final String? finalDtmf;
  final int? queueId;
  final String? queueName;
  final String? recordingPath;
  final int? blacklist;
  final dynamic did;
  final String? channelId;
  final String? crmRecordingPath;
  final String? ivrRecordingPath;
  final String? countryCode;
  final List<dynamic> addressBook;
  final int? v;
  final String? customerName;

  RecentCallsData copyWith({
    String? id,
    int? smeId,
    String? callDirection,
    int? connectedDuration,
    int? ringingDuration,
    String? customerNumber,
    String? agentNumber,
    String? agentName,
    int? longcode,
    String? sessionId,
    int? answer,
    int? callDirectionStatus,
    String? callRecordedFile,
    int? callRecordingStatus,
    int? callStatus,
    int? cdrMode,
    int? callMode,
    int? channelNo,
    String? disconnectedBy,
    int? duration,
    int? mergeStatus,
    DateTime? insertDateTime,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? masterShortcode,
    int? patchedAgentId,
    String? serverIpAddress,
    String? shortcodeMapping,
    String? smeIdentifier,
    String? voicemailRecordingFile,
    int? voicemailRecordingStatus,
    String? callType,
    String? hlr,
    String? callDescription,
    int? ivrDuration,
    int? customerStatus,
    String? finalStatus,
    int? callFlowId,
    String? callFlowName,
    int? provisionalFlag,
    String? finalDtmf,
    int? queueId,
    String? queueName,
    String? recordingPath,
    int? blacklist,
    dynamic did,
    String? channelId,
    String? crmRecordingPath,
    String? ivrRecordingPath,
    String? countryCode,
    List<dynamic>? addressBook,
    int? v,
    String? customerName,
  }) {
    return RecentCallsData(
      id: id ?? this.id,
      smeId: smeId ?? this.smeId,
      callDirection: callDirection ?? this.callDirection,
      connectedDuration: connectedDuration ?? this.connectedDuration,
      ringingDuration: ringingDuration ?? this.ringingDuration,
      customerNumber: customerNumber ?? this.customerNumber,
      agentNumber: agentNumber ?? this.agentNumber,
      agentName: agentName ?? this.agentName,
      longcode: longcode ?? this.longcode,
      sessionId: sessionId ?? this.sessionId,
      answer: answer ?? this.answer,
      callDirectionStatus: callDirectionStatus ?? this.callDirectionStatus,
      callRecordedFile: callRecordedFile ?? this.callRecordedFile,
      callRecordingStatus: callRecordingStatus ?? this.callRecordingStatus,
      callStatus: callStatus ?? this.callStatus,
      cdrMode: cdrMode ?? this.cdrMode,
      callMode: callMode ?? this.callMode,
      channelNo: channelNo ?? this.channelNo,
      disconnectedBy: disconnectedBy ?? this.disconnectedBy,
      duration: duration ?? this.duration,
      mergeStatus: mergeStatus ?? this.mergeStatus,
      insertDateTime: insertDateTime ?? this.insertDateTime,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      masterShortcode: masterShortcode ?? this.masterShortcode,
      patchedAgentId: patchedAgentId ?? this.patchedAgentId,
      serverIpAddress: serverIpAddress ?? this.serverIpAddress,
      shortcodeMapping: shortcodeMapping ?? this.shortcodeMapping,
      smeIdentifier: smeIdentifier ?? this.smeIdentifier,
      voicemailRecordingFile: voicemailRecordingFile ?? this.voicemailRecordingFile,
      voicemailRecordingStatus: voicemailRecordingStatus ?? this.voicemailRecordingStatus,
      callType: callType ?? this.callType,
      hlr: hlr ?? this.hlr,
      callDescription: callDescription ?? this.callDescription,
      ivrDuration: ivrDuration ?? this.ivrDuration,
      customerStatus: customerStatus ?? this.customerStatus,
      finalStatus: finalStatus ?? this.finalStatus,
      callFlowId: callFlowId ?? this.callFlowId,
      callFlowName: callFlowName ?? this.callFlowName,
      provisionalFlag: provisionalFlag ?? this.provisionalFlag,
      finalDtmf: finalDtmf ?? this.finalDtmf,
      queueId: queueId ?? this.queueId,
      queueName: queueName ?? this.queueName,
      recordingPath: recordingPath ?? this.recordingPath,
      blacklist: blacklist ?? this.blacklist,
      did: did ?? this.did,
      channelId: channelId ?? this.channelId,
      crmRecordingPath: crmRecordingPath ?? this.crmRecordingPath,
      ivrRecordingPath: ivrRecordingPath ?? this.ivrRecordingPath,
      countryCode: countryCode ?? this.countryCode,
      addressBook: addressBook ?? this.addressBook,
      v: v ?? this.v,
      customerName: customerName ?? this.customerName,
    );
  }

  factory RecentCallsData.fromJson(Map<String, dynamic> json) {
    return RecentCallsData(
      id: json["_id"],
      smeId: json["sme_id"],
      callDirection: json["call_direction"],
      connectedDuration: json["connected_duration"],
      ringingDuration: json["ringing_duration"],
      customerNumber: json["customer_number"],
      agentNumber: json["agent_number"],
      agentName: json["agent_name"],
      longcode: json["longcode"],
      sessionId: json["session_id"],
      answer: json["answer"],
      callDirectionStatus: json["call_direction_status"],
      callRecordedFile: json["call_recorded_file"],
      callRecordingStatus: json["call_recording_status"],
      callStatus: json["call_status"],
      cdrMode: json["cdr_mode"],
      callMode: json["call_mode"],
      channelNo: json["channel_no"],
      disconnectedBy: json["disconnected_by"],
      duration: json["duration"],
      mergeStatus: json["merge_status"],
      insertDateTime: DateTime.parse(json["insert_date_time"] ?? "").toLocal(),
      startDateTime: DateTime.parse(json["start_date_time"] ?? "").toLocal(),
      endDateTime: DateTime.parse(json["end_date_time"] ?? "").toLocal(),
      masterShortcode: json["master_shortcode"],
      patchedAgentId: json["patched_agent_id"],
      serverIpAddress: json["server_ip_address"],
      shortcodeMapping: json["shortcode_mapping"],
      smeIdentifier: json["sme_identifier"],
      voicemailRecordingFile: json["voicemail_recording_file"],
      voicemailRecordingStatus: json["voicemail_recording_status"],
      callType: json["call_type"],
      hlr: json["hlr"],
      callDescription: json["call_description"],
      ivrDuration: json["ivr_duration"],
      customerStatus: json["customer_status"],
      finalStatus: json["final_status"],
      callFlowId: json["call_flow_id"],
      callFlowName: json["call_flow_name"],
      provisionalFlag: json["provisional_flag"],
      finalDtmf: json["final_dtmf"],
      queueId: json["queue_id"],
      queueName: json["queue_name"],
      recordingPath: json["recording_path"],
      blacklist: json["blacklist"],
      did: json["did"],
      channelId: json["channelId"],
      crmRecordingPath: json["crm_recording_path"],
      ivrRecordingPath: json["ivr_recording_path"],
      countryCode: json["country_code"],
      addressBook: json["address_book"] == null ? [] : List<dynamic>.from(json["address_book"]!.map((x) => x)),
      v: json["__v"],
      customerName: /*json["customer_name"]?.toString().toLowerCase() == "no name" ? null :*/ json["customer_name"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "sme_id": smeId,
        "call_direction": callDirection,
        "connected_duration": connectedDuration,
        "ringing_duration": ringingDuration,
        "customer_number": customerNumber,
        "agent_number": agentNumber,
        "agent_name": agentName,
        "longcode": longcode,
        "session_id": sessionId,
        "answer": answer,
        "call_direction_status": callDirectionStatus,
        "call_recorded_file": callRecordedFile,
        "call_recording_status": callRecordingStatus,
        "call_status": callStatus,
        "cdr_mode": cdrMode,
        "call_mode": callMode,
        "channel_no": channelNo,
        "disconnected_by": disconnectedBy,
        "duration": duration,
        "merge_status": mergeStatus,
        "insert_date_time": insertDateTime.toUtc(),
        "start_date_time": startDateTime.toUtc(),
        "end_date_time": endDateTime.toUtc(),
        "master_shortcode": masterShortcode,
        "patched_agent_id": patchedAgentId,
        "server_ip_address": serverIpAddress,
        "shortcode_mapping": shortcodeMapping,
        "sme_identifier": smeIdentifier,
        "voicemail_recording_file": voicemailRecordingFile,
        "voicemail_recording_status": voicemailRecordingStatus,
        "call_type": callType,
        "hlr": hlr,
        "call_description": callDescription,
        "ivr_duration": ivrDuration,
        "customer_status": customerStatus,
        "final_status": finalStatus,
        "call_flow_id": callFlowId,
        "call_flow_name": callFlowName,
        "provisional_flag": provisionalFlag,
        "final_dtmf": finalDtmf,
        "queue_id": queueId,
        "queue_name": queueName,
        "recording_path": recordingPath,
        "blacklist": blacklist,
        "did": did,
        "channelId": channelId,
        "crm_recording_path": crmRecordingPath,
        "ivr_recording_path": ivrRecordingPath,
        "country_code": countryCode,
        "address_book": addressBook.map((x) => x).toList(),
        "__v": v,
        "customer_name": customerName,
      };

  @override
  String toString() {
    return "$id, $smeId, $callDirection, $connectedDuration, $ringingDuration, $customerNumber, $agentNumber, $agentName, $longcode, $sessionId, $answer, $callDirectionStatus, $callRecordedFile, $callRecordingStatus, $callStatus, $cdrMode, $callMode, $channelNo, $disconnectedBy, $duration, $mergeStatus, $insertDateTime, $startDateTime, $endDateTime, $masterShortcode, $patchedAgentId, $serverIpAddress, $shortcodeMapping, $smeIdentifier, $voicemailRecordingFile, $voicemailRecordingStatus, $callType, $hlr, $callDescription, $ivrDuration, $customerStatus, $finalStatus, $callFlowId, $callFlowName, $provisionalFlag, $finalDtmf, $queueId, $queueName, $recordingPath, $blacklist, $did, $channelId, $crmRecordingPath, $ivrRecordingPath, $countryCode, $addressBook, $v, $customerName";
  }

  @override
  List<Object?> get props => [
        id,
        smeId,
        callDirection,
        connectedDuration,
        ringingDuration,
        customerNumber,
        agentNumber,
        agentName,
        longcode,
        sessionId,
        answer,
        callDirectionStatus,
        callRecordedFile,
        callRecordingStatus,
        callStatus,
        cdrMode,
        callMode,
        channelNo,
        disconnectedBy,
        duration,
        mergeStatus,
        insertDateTime,
        startDateTime,
        endDateTime,
        masterShortcode,
        patchedAgentId,
        serverIpAddress,
        shortcodeMapping,
        smeIdentifier,
        voicemailRecordingFile,
        voicemailRecordingStatus,
        callType,
        hlr,
        callDescription,
        ivrDuration,
        customerStatus,
        finalStatus,
        callFlowId,
        callFlowName,
        provisionalFlag,
        finalDtmf,
        queueId,
        queueName,
        recordingPath,
        blacklist,
        did,
        channelId,
        crmRecordingPath,
        ivrRecordingPath,
        countryCode,
        addressBook,
        v,
        customerName,
      ];
}
