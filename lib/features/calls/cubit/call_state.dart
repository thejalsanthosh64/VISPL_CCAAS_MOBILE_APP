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
      other.isDispositionFilled == isDispositionFilled;
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
               isDispositionFilled.hashCode;
              



}

}
