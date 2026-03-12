class CallState {
  final bool isConnected;
  final bool isMuted;
  final bool isHold;
  final Duration duration;
  final String callerName;
  final String phoneNumber;

final List<dynamic> smsTemplates;
  final List<dynamic> whatsappTemplates;
final bool isLoadingInteractions;
final List<Map<String, dynamic>> interactions;
  final bool showCrmForm;
  final String crmFormName;
  final List<Map<String, dynamic>> crmFormJson;
  final bool isSavingCrm;
    final bool crmPopupShown; 
final bool isDispositionFilled;


// // single source of truth for transfer/conference UI ────────────────────
//   final TransferStatus transferStatus;

//   /// Once a conference succeeded once, the Conf button stays disabled for
//   /// the rest of this call — even after the conference ends.
//   final bool conferenceCompleted;

//   // ── Derived helpers (read-only, no extra state needed) ───────────────────

//   /// ALL action icons (except Survey) should be disabled.
//   /// True from cbwt_confirmed until transfer_clear_confirmed or call ends.
// bool get areIconsDisabled =>
//     transferStatus == TransferStatus.transferRinging ||
//     transferStatus == TransferStatus.transferDone;
//     // conferenceLive is NOT here → icons enabled during conference ✅

// bool get isConferenceButtonDisabled =>
//     conferenceCompleted || // permanent ✅
//     transferStatus == TransferStatus.transferRinging ||
//     transferStatus == TransferStatus.transferDone;

//   /// Transfer button disabled (icons-disabled covers this, kept for clarity).
//   bool get isTransferButtonDisabled => areIconsDisabled;


  // ── Single source of truth for transfer/conference UI ────────────────────
  final TransferStatus transferStatus;
 
  /// Once a conference succeeded once, the Conf button stays disabled for
  /// the rest of this call — even after the conference ends.
  final bool conferenceCompleted;
 
  // ── Derived helpers (read-only, no extra state needed) ───────────────────
 
  /// ALL action icons (except Survey) should be disabled.
  /// True from cbwt_confirmed until the consult leg is confirmed or cleared.
 bool get areIconsDisabled =>
    transferStatus != TransferStatus.idle &&
    transferStatus != TransferStatus.attendedStep1Confirmed &&
    transferStatus != TransferStatus.conferenceLive;
  // Note: attendedStep1Confirmed re-enables icons so agent can choose Conf/Transfer.
  // conferenceLive also has icons enabled.
 
  /// Conference button should be permanently disabled.
  bool get isConferenceButtonDisabled =>
      conferenceCompleted ||
      transferStatus == TransferStatus.transferRinging ||
      transferStatus == TransferStatus.transferDone;
  // Note: during attendedStep1Confirmed, Conf button IS enabled (that's the whole point).
  // After conferenceCompleted == true, it stays disabled regardless of transferStatus.
 

  const CallState({
    this.isConnected = false,
    this.isMuted = false,
    this.isHold = false,
    this.duration = Duration.zero,
    this.callerName = "",
    this.phoneNumber = "",
    this.smsTemplates = const [],
    this.whatsappTemplates = const [],
    this.isLoadingInteractions = false,
    this.interactions = const [],
      this.showCrmForm = false,
    this.crmFormName = "",
    this.crmFormJson = const [],
    this.isSavingCrm = false,
   this.crmPopupShown= false,
this.isDispositionFilled = false,
 
 this.transferStatus = TransferStatus.idle,
    this.conferenceCompleted = false,
  });

  CallState copyWith({
    bool? isConnected,
    bool? isMuted,
    bool? isHold,
    Duration? duration,
    String? callerName,
    String? phoneNumber,
     List<dynamic>? smsTemplates,
    List<dynamic>? whatsappTemplates,
      bool? isLoadingInteractions,
    List<Map<String, dynamic>>? interactions,
     bool? showCrmForm,
    String? crmFormName,
    List<Map<String, dynamic>>? crmFormJson,
    bool? isSavingCrm,
        bool? crmPopupShown,
        bool? isDispositionFilled,
 TransferStatus? transferStatus,
    bool? conferenceCompleted,
  }) {
    return CallState(
      isConnected: isConnected ?? this.isConnected,
      isMuted: isMuted ?? this.isMuted,
      isHold: isHold ?? this.isHold,
      duration: duration ?? this.duration,
      callerName: callerName ?? this.callerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      smsTemplates: smsTemplates ?? this.smsTemplates,
      whatsappTemplates: whatsappTemplates ?? this.whatsappTemplates,
      isLoadingInteractions:
          isLoadingInteractions ?? this.isLoadingInteractions,
      interactions: interactions ?? this.interactions,
       showCrmForm: showCrmForm ?? this.showCrmForm,
      crmFormName: crmFormName ?? this.crmFormName,
      crmFormJson: crmFormJson ?? this.crmFormJson,
      isSavingCrm: isSavingCrm ?? this.isSavingCrm,
            crmPopupShown: crmPopupShown ?? this.crmPopupShown,
            isDispositionFilled: isDispositionFilled ?? this.isDispositionFilled,
 transferStatus: transferStatus ?? this.transferStatus,
      conferenceCompleted: conferenceCompleted ?? this.conferenceCompleted,
    );
  }
@override
bool operator ==(Object other) {
  if (identical(this, other)) return true;
  return other is CallState &&
      other.isConnected == isConnected &&
      other.isMuted == isMuted &&
      other.isHold == isHold &&
      other.callerName == callerName &&
      other.phoneNumber == phoneNumber &&
      other.duration == duration &&
      other.smsTemplates == smsTemplates &&              
      other.whatsappTemplates == whatsappTemplates &&  
      other.isLoadingInteractions == isLoadingInteractions &&
      other.interactions == interactions &&
      other.showCrmForm == showCrmForm &&
      other.crmFormName == crmFormName &&
      other.crmFormJson == crmFormJson &&
      other.isSavingCrm == isSavingCrm &&
      other.crmPopupShown == crmPopupShown &&
      other.isDispositionFilled == isDispositionFilled &&
  other.transferStatus == transferStatus &&
        other.conferenceCompleted == conferenceCompleted;
}

@override
int get hashCode {
  return isConnected.hashCode ^
      isMuted.hashCode ^
      isHold.hashCode ^
      callerName.hashCode ^
      phoneNumber.hashCode ^
      duration.hashCode ^
      smsTemplates.hashCode ^                             
      whatsappTemplates.hashCode ^
      isLoadingInteractions.hashCode ^
       interactions.hashCode ^
               showCrmForm.hashCode ^
               crmFormName.hashCode ^
               crmFormJson.hashCode ^
               isSavingCrm.hashCode ^
               crmPopupShown.hashCode ^
               isDispositionFilled.hashCode ^
                  transferStatus.hashCode ^
      conferenceCompleted.hashCode;
              



}

}

enum TransferStatus {
  idle,
  transferRinging,          // cbwt_confirmed BLIND — all icons disabled
  attendedConsultRinging,   // cbwt_confirmed ATTENDED — consult ringing, Merge shown
  attendedStep1Confirmed,   // transfer_confirmed (attended/Transfer) — consult answered
  transferDone,             // transfer_confirmed (unattended/Transfer) — call leaving sender
  conferenceLive,           // transfer_confirmed (attended/Conference) — 3-way active
  conferenceEnded,          // conf ended, back to normal (conf button stays off)
}