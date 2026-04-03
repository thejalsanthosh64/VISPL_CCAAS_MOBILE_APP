part of 'dio_client.dart';

abstract class ApiEndpoints {

static const String _baseUrl = "https://ccs.sparc.smartping.io/v1/";
  // static const String _baseUrl = "https://test.smartping.ai/v1/";

  // static const String _baseUrl = "https://newdev.kommuno.com/v1/";

  // static const String _baseUrl = "https://dev.kommuno.com/v1/";

  // static const String baseUrlWebSo = "https://testsio.smartping.ai/";
  static const String baseUrlWebSo = "https://ccssio.smartping.io/";


  static const String whiteLabelDomain = "https://test.smartping.ai";
// static const String whiteLabelDomain = "https://ccs.sparc.smartping.io";


  static const int _receiveTimeout = 15000;

  static const int _connectionTimeout = 15000;

  static const authMountPoint = "mobileapp";

  // static const authMountPoint = "";

  static const login = "oauth/signin";

  static String logout(int id) => "sme/$id/setNotificationToken";

  // static String forgotPassword(String userName) => "component/$userName/forget/password";

  // static String verifyOtp(String userName) => "component/$userName/forget/otp/verify";

  // static String changePassword(String userName) => "component/$userName/forget/change/password";


 static String getUserDetailByEmail(String email) =>
      "agent/$email/getUserDetailByEmailId";

  static String sendForgotPasswordOtp =
      "agent/sendForgotPasswordOtp";

  static String verifyOtp(String email) =>
      "component/$email/forget/otp/verify";

  static String changePassword(String email) =>
      "component/$email/forget/change/password";

  static String userDetails(String userName) => "user/$userName/typedetail";

  ///Id will be agent_id
  // static String getAllContacts(int id) => "user/$id/addressbook/listnew";

  // static String addContacts(int id) => "user/$id/setCustomerName";

  // static String updateContacts(int id) => "user/$id/updateCustomerName";

 static String getAllContacts(String smeId) => "sme/$smeId/getAddressbookDetail";
  static String addContacts(String smeId) => "sme/$smeId/setAddressbookDetail";
  static String updateContacts(String smeId) => "sme/$smeId/setAddressbookDetail";



  // static String getFollowUpCall(int id) => "$id/getFollowUpCall";
  static String getPastScheduledCalls(int id) => "sme/$id/getPastScheduledCalls";

  static String getTodayScheduledCalls(int id) => "sme/$id/getTodayScheduledCalls";

  static String getUpcomingScheduledCalls(int id) => "sme/$id/getUpcomingScheduledCalls";

  static String changeScheduleStatus(int smeId) => "sme/$smeId/changeScheduleStatus";
  static String deleteFollowUp(int smeId, String followUpId) =>
    "/sme/$smeId/followup/$followUpId";


  static String getAssignedCalls(int id) => "$id/getOutgoingCampaign";

  static String breakList(int id) => "$authMountPoint/$id/break/list";

  static String breakIn(int id) => "agent/$id/break/in";

  static String breakOut(int id) => "agent/$id/break/out";

  static String addManualLead(int smeId) => "sme/$smeId/addManualLead";

  static String getUniqueCalls(int smeId) => "$smeId/getUniqueCalls";

  static String updateUniqueCalls(int smeId) => "$smeId/updateUniqueCalls";

  static String getSourceCityProductStatus(int smeId) => "$smeId/masterApiSourceCityProductStatus";

  static String addCustomerNote(int smeId) => "$smeId/addCustomerNote";

  // static String addScheduleCall(int id) => "user/$id/call/schedule";
    static String addScheduleCall(int id) => "sme/$id/setFollowUpCall";


  static String getScheduledCalls(int smeId) => "$smeId/getScheduledCalls";

  static String getInsight(int smeId) => "sme/$smeId/insight";

  static String getListRemarks(int id) => "sme/$id/getListRemarks";

  static String setRemarks(int id) => "sme/$id/setRemarks";

  static String updateRemark(int smeId) => "sme/$smeId/updateRemark"; 

  static const clickToCall = "user/clickToCall";

  static String getLongCodesForCall(int id) => "$id/getLongcodesForCall";

  static const clickToCallLiveCall = "crm/clickToCallLiveCall";

  static String holdCall(int smeId) => "agent/$smeId/hold";

  static String unHoldCall(int smeId) => "agent/$smeId/unhold";

  static String muteCall(int smeId) => "agent/$smeId/mute";

  static String unMuteCall(int smeId) => "agent/$smeId/unmute";

  static String dropCall(int smeId) => "agent/$smeId/dropCall";

  static String transferCall(int smeId) => "agent/$smeId/unattended";

  static String conferenceall(int smeId) => "agent/$smeId/attended";
    static String getAgentStatus(int smeId) => "sme/$smeId/getAgentStatus";

  static String getQueue(int smeId) => "sme/$smeId/getQueue";

  static String getTeamLeads(int smeId) => "teamlead/$smeId/getTeamLeads";


  static String getQueueAgent(int smeId) => "agent/$smeId/getQueueAgent";

  static String getAgentStatusDetail(int smeId) => "agent/$smeId/getAgentStatusDetail";


  static String getRecentCalls(int id) => "sme/$id/getAgentMergeCalls";

  static String getLoginCampaigns(int id) => "sme/$id/getLoginCampaigns";

  // static String updateAgentCurrentCampaign(int id) => "$id/updateAgentCurrentCampaign";

  static String updateAgentCurrentCampaign(int smeId) => "agent/$smeId/updateAgentCurrentCallMode";
    static String saveRating(int smeId) => "agent/$smeId/saveRating";

  static String saveRatingInCrm(int smeId) => "agent/$smeId/saveRatingInCrm";

    static String setIsAlive(String username) => "sme/$username/setIsAlive";

  static String updateWebrtcAgentStatus(int smeId) => "sme/$smeId/updateWebrtcAgentStatus";
    static String nearTimeScheduleCalls(int smeId) => "sme/$smeId/nearTimeScheduleCalls";
    static String updateUserOnlineOffline(String username) => "sme/$username/updateUserOnlineOffline";



    static String updateAgentActivityTime(int smeId) => "agent/$smeId/updateAgentActivityTime";
    static String updateLiveCallStatus(int smeId) => "agent/$smeId/updateLiveCallStatus";
    static String updateAgentLiveStatus(int smeId) => "agent/$smeId/updateAgentLiveStatus";
    static String setActivityLogs(int id) => "common/$id/setActivityLogs";
        static String checkIsAlive(String username) => "sme/$username/checkIsAlive";
        static String getDispositionSummary(int smeId) =>
    "agent/$smeId/getSummaryByDisposition";


static String surveyEndCall(int smeId) =>
   "agent/$smeId/surveyEndCall";
static String updateReadyToTakeCall(int agentId) =>
    "agent/$agentId/updateReadyToTakeCall";



static String getSmsTemplate(int smeId) =>
    "sme/$smeId/getSmsTemplate";

static String getWhatsappTemplate(int smeId) =>
    "sme/$smeId/getWhatsapp";



 static String sendEndCallSms(int smeId) =>
      "ksms/$smeId/sendEndcallSms";

  static String sendWhatsapp(int smeId) =>
      "whatsapp/$smeId/sendWhatsapp";

static const previewManualDialerResponse =
    "kcrm/previewManualDialerResponse";

static const previewAutoDialerResponse =
    "kcrm/previewAutoDialerResponse";
static String updateSocketId(int smeId) =>
    "sme/$smeId/updateSocketId";

static String updateCrmForm(int smeId, String sessionId) =>
    "sme/$smeId/calling-cdr/session/$sessionId/update-form-json";
    static String updateIsWrapUpTimeOver(int smeId) => "agent/$smeId/updateIsWrapUpTimeOver";
      static String setDialerStatus(int smeID) =>
      "agent/$smeID/setDialerStatus";

static const String getWhiteLabelingDetails =
    "billing/getWhiteLabelingDetails";

}
