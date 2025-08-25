part of 'dio_client.dart';

abstract class ApiEndpoints {
  static const String _baseUrl = "https://test.smartping.ai/v1/";

  // static const String _baseUrl = "https://newdev.kommuno.com/v1/";

  // static const String _baseUrl = "https://dev.kommuno.com/v1/";

  static const int _receiveTimeout = 15000;

  static const int _connectionTimeout = 15000;

  static const authMountPoint = "mobileapp";

  // static const authMountPoint = "";

  static const login = "oauth/signin";

  static String logout(int id) => "$id/setNotificationToken";

  static String forgotPassword(String userName) => "component/$userName/forget/password";

  static String verifyOtp(String userName) => "component/$userName/forget/otp/verify";

  static String changePassword(String userName) => "component/$userName/forget/change/password";

  static String userDetails(String userName) => "user/$userName/typedetail";

  ///Id will be agent_id
  static String getAllContacts(int id) => "user/$id/addressbook/listnew";

  static String addContacts(int id) => "user/$id/setCustomerName";

  static String updateContacts(int id) => "user/$id/updateCustomerName";

  static String getFollowUpCall(int id) => "$id/getFollowUpCall";

  static String changeScheduleStatus(int smeId) => "$smeId/changeScheduleStatus";

  static String getAssignedCalls(int id) => "$id/getOutgoingCampaign";

  static String breakList(int id) => "$id/break/list";

  static String breakIn(int id) => "$id/break/in";

  static String breakOut(int id) => "$id/break/out";

  static String addManualLead(int smeId) => "sme/$smeId/addManualLead";

  static String getUniqueCalls(int smeId) => "$smeId/getUniqueCalls";

  static String updateUniqueCalls(int smeId) => "$smeId/updateUniqueCalls";

  static String getSourceCityProductStatus(int smeId) => "$smeId/masterApiSourceCityProductStatus";

  static String addCustomerNote(int smeId) => "$smeId/addCustomerNote";

  static String addScheduleCall(int id) => "user/$id/call/schedule";

  static String getScheduledCalls(int smeId) => "$smeId/getScheduledCalls";

  static String getInsight(int smeId) => "user/$smeId/insight";

  static String getListRemarks(int id) => "$id/getListRemarks";

  static String setRemarks(int id) => "$id/setRemarks";

  static const clickToCall = "user/clickToCall";

  static String getLongCodesForCall(int id) => "$id/getLongcodesForCall";

  static const clickToCallLiveCall = "user/clickToCallLiveCall";

  static String getRecentCalls(int id) => "$id/todayCallHistory";

  static String getLoginCampaigns(int id) => "$id/getLoginCampaigns";

  static String updateAgentCurrentCampaign(int id) => "$id/updateAgentCurrentCampaign";
}
