import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @applicationName.
  ///
  /// In en, this message translates to:
  /// **'Smartping'**
  String get applicationName;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Request to API server was cancelled'**
  String get cancelRequest;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout with API server'**
  String get connectionTimeout;

  /// No description provided for @receiveTimeout.
  ///
  /// In en, this message translates to:
  /// **'Receive timeout in connection with API server'**
  String get receiveTimeout;

  /// No description provided for @sendTimeout.
  ///
  /// In en, this message translates to:
  /// **'Send timeout in connection with API server'**
  String get sendTimeout;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Oops Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @badRequest.
  ///
  /// In en, this message translates to:
  /// **'Bad request'**
  String get badRequest;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get unauthorized;

  /// No description provided for @requestForbidden.
  ///
  /// In en, this message translates to:
  /// **'Request Forbidden'**
  String get requestForbidden;

  /// No description provided for @urlNotFound.
  ///
  /// In en, this message translates to:
  /// **'Url not found'**
  String get urlNotFound;

  /// No description provided for @internalServerError.
  ///
  /// In en, this message translates to:
  /// **'Internal server error'**
  String get internalServerError;

  /// No description provided for @dataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Data not found'**
  String get dataNotFound;

  /// No description provided for @mobileNoNotFound.
  ///
  /// In en, this message translates to:
  /// **'Mobile number not found'**
  String get mobileNoNotFound;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please Login'**
  String get pleaseLogin;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter Username'**
  String get enterUsername;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @createNewContact.
  ///
  /// In en, this message translates to:
  /// **'Create New Contact'**
  String get createNewContact;

  /// No description provided for @updateContact.
  ///
  /// In en, this message translates to:
  /// **'Update Contact'**
  String get updateContact;

  /// No description provided for @breakIn.
  ///
  /// In en, this message translates to:
  /// **'Break in'**
  String get breakIn;

  /// No description provided for @breakOut.
  ///
  /// In en, this message translates to:
  /// **'Break Out'**
  String get breakOut;

  /// No description provided for @pleaseEnterYourUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get pleaseEnterYourUsername;

  /// No description provided for @pleaseEnterRemarks.
  ///
  /// In en, this message translates to:
  /// **'Please enter remarks'**
  String get pleaseEnterRemarks;

  /// No description provided for @pleaseEnterNote.
  ///
  /// In en, this message translates to:
  /// **'Please enter note'**
  String get pleaseEnterNote;

  /// No description provided for @invalidUsername.
  ///
  /// In en, this message translates to:
  /// **'Invalid username'**
  String get invalidUsername;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @pleaseEnterYourConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your confirm password'**
  String get pleaseEnterYourConfirmPassword;

  /// No description provided for @passwordMisMatch.
  ///
  /// In en, this message translates to:
  /// **'Password not matched'**
  String get passwordMisMatch;

  /// No description provided for @pleaseEnterYourOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter your otp'**
  String get pleaseEnterYourOtp;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid otp'**
  String get invalidOtp;

  /// No description provided for @usernameNotFound.
  ///
  /// In en, this message translates to:
  /// **'Username not found'**
  String get usernameNotFound;

  /// No description provided for @displayOverApps.
  ///
  /// In en, this message translates to:
  /// **'In order to use the App, Please allow to display over other apps.'**
  String get displayOverApps;

  /// No description provided for @allPermission.
  ///
  /// In en, this message translates to:
  /// **'Please open the settings and allow all the permission.'**
  String get allPermission;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'EXIT'**
  String get exit;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter the below details to reset your password.'**
  String get forgotPasswordDescription;

  /// No description provided for @otpDescription.
  ///
  /// In en, this message translates to:
  /// **'The One Time Password (OTP) will be sent on your registered mail ID. The OTP will be valid for 10 m.'**
  String get otpDescription;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @validateOTP.
  ///
  /// In en, this message translates to:
  /// **'Validate OTP'**
  String get validateOTP;

  /// No description provided for @validateOTPDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter the One Time Password (OTP) below sent to your registered email'**
  String get validateOTPDescription;

  /// No description provided for @resendOTP.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOTP;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'YES'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'NO'**
  String get no;

  /// No description provided for @goBackAlert.
  ///
  /// In en, this message translates to:
  /// **'Do you want to go back?'**
  String get goBackAlert;

  /// No description provided for @exitAppAlert.
  ///
  /// In en, this message translates to:
  /// **'Do you want exit?'**
  String get exitAppAlert;

  /// No description provided for @timeIn.
  ///
  /// In en, this message translates to:
  /// **'Time in'**
  String get timeIn;

  /// No description provided for @timeOut.
  ///
  /// In en, this message translates to:
  /// **'Time out'**
  String get timeOut;

  /// No description provided for @activeTime.
  ///
  /// In en, this message translates to:
  /// **'Active Time'**
  String get activeTime;

  /// No description provided for @breakTime.
  ///
  /// In en, this message translates to:
  /// **'Break Time'**
  String get breakTime;

  /// No description provided for @bestWayConnectedCustomers.
  ///
  /// In en, this message translates to:
  /// **'The best way to stay connected with your customers'**
  String get bestWayConnectedCustomers;

  /// No description provided for @twentyFourSeven.
  ///
  /// In en, this message translates to:
  /// **'24/7'**
  String get twentyFourSeven;

  /// No description provided for @assignedCalls.
  ///
  /// In en, this message translates to:
  /// **'Assigned Calls'**
  String get assignedCalls;

  /// No description provided for @dial.
  ///
  /// In en, this message translates to:
  /// **'Dial'**
  String get dial;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @recentCalls.
  ///
  /// In en, this message translates to:
  /// **'Recent calls'**
  String get recentCalls;

  /// No description provided for @followUp.
  ///
  /// In en, this message translates to:
  /// **'Follow Up'**
  String get followUp;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @leads.
  ///
  /// In en, this message translates to:
  /// **'Leads'**
  String get leads;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add New'**
  String get addNew;

  /// No description provided for @call.
  ///
  /// In en, this message translates to:
  /// **'Call'**
  String get call;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search.....'**
  String get search;

  /// No description provided for @checkInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection.'**
  String get checkInternetConnection;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get companyName;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @pleaseEnterCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Please enter customer name'**
  String get pleaseEnterCustomerName;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @pleaseEnterMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get pleaseEnterMobileNumber;

  /// No description provided for @pleaseSelectStyckyType.
  ///
  /// In en, this message translates to:
  /// **'Please select stycky type'**
  String get pleaseSelectStyckyType;

  /// No description provided for @pleaseSelectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select date time'**
  String get pleaseSelectDateTime;

  /// No description provided for @invalidMobile.
  ///
  /// In en, this message translates to:
  /// **'Invalid mobile'**
  String get invalidMobile;

  /// No description provided for @accountContacts.
  ///
  /// In en, this message translates to:
  /// **'Account Contacts'**
  String get accountContacts;

  /// No description provided for @phoneContacts.
  ///
  /// In en, this message translates to:
  /// **'Phone Contacts'**
  String get phoneContacts;

  /// No description provided for @addressBook.
  ///
  /// In en, this message translates to:
  /// **'Address Book'**
  String get addressBook;

  /// No description provided for @outgoingPermissionMsg.
  ///
  /// In en, this message translates to:
  /// **'Outgoing call permission is not allowed'**
  String get outgoingPermissionMsg;

  /// No description provided for @currentlyInactiveMsg.
  ///
  /// In en, this message translates to:
  /// **'You are currently Inactive'**
  String get currentlyInactiveMsg;

  /// No description provided for @onBreakMsg.
  ///
  /// In en, this message translates to:
  /// **'You are on break'**
  String get onBreakMsg;

  /// No description provided for @addLead.
  ///
  /// In en, this message translates to:
  /// **'Add Lead'**
  String get addLead;

  /// No description provided for @searchLeadDes.
  ///
  /// In en, this message translates to:
  /// **'Search Customer Name, Number, and Company Name'**
  String get searchLeadDes;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @remarks.
  ///
  /// In en, this message translates to:
  /// **'Remarks'**
  String get remarks;

  /// No description provided for @scheduleCalls.
  ///
  /// In en, this message translates to:
  /// **'Schedule Calls'**
  String get scheduleCalls;

  /// No description provided for @callDetails.
  ///
  /// In en, this message translates to:
  /// **'Call Details'**
  String get callDetails;

  /// No description provided for @styckyType.
  ///
  /// In en, this message translates to:
  /// **'Stycky Type'**
  String get styckyType;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @filterAndSorting.
  ///
  /// In en, this message translates to:
  /// **'Filter and Sorting'**
  String get filterAndSorting;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @typeYourNote.
  ///
  /// In en, this message translates to:
  /// **'Type your note'**
  String get typeYourNote;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get addNote;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @breakTimeDes.
  ///
  /// In en, this message translates to:
  /// **'Note: During break time, you will not be able to receive any calls.'**
  String get breakTimeDes;

  /// No description provided for @pleaseSpecifyReason.
  ///
  /// In en, this message translates to:
  /// **'Please Specify Reason'**
  String get pleaseSpecifyReason;

  /// No description provided for @addBreakReason.
  ///
  /// In en, this message translates to:
  /// **'Add Break Reason'**
  String get addBreakReason;

  /// No description provided for @breaksAreNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Breaks are not allowed'**
  String get breaksAreNotAllowed;

  /// No description provided for @youAreCurrentlyInactive.
  ///
  /// In en, this message translates to:
  /// **'You are currently inactive'**
  String get youAreCurrentlyInactive;

  /// No description provided for @inActive.
  ///
  /// In en, this message translates to:
  /// **'In Active'**
  String get inActive;

  /// No description provided for @idle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get idle;

  /// No description provided for @busy.
  ///
  /// In en, this message translates to:
  /// **'Busy'**
  String get busy;

  /// No description provided for @offHours.
  ///
  /// In en, this message translates to:
  /// **'Off hours'**
  String get offHours;

  /// No description provided for @breakText.
  ///
  /// In en, this message translates to:
  /// **'Break'**
  String get breakText;

  /// No description provided for @pleaseInstallWhatsAppFirst.
  ///
  /// In en, this message translates to:
  /// **'Please install whatsApp first'**
  String get pleaseInstallWhatsAppFirst;

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// No description provided for @soft.
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get soft;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @scheduleACall.
  ///
  /// In en, this message translates to:
  /// **'Schedule a Call'**
  String get scheduleACall;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @enterNotes.
  ///
  /// In en, this message translates to:
  /// **'Enter Notes'**
  String get enterNotes;

  /// No description provided for @selectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time'**
  String get selectDateTime;

  /// No description provided for @pastAndCurrentDurationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Past and current duration not allowed'**
  String get pastAndCurrentDurationNotAllowed;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @last7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get last7Days;

  /// No description provided for @last15Days.
  ///
  /// In en, this message translates to:
  /// **'Last 15 days'**
  String get last15Days;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30Days;

  /// No description provided for @incomingCalls.
  ///
  /// In en, this message translates to:
  /// **'Incoming Calls'**
  String get incomingCalls;

  /// No description provided for @outgoingCalls.
  ///
  /// In en, this message translates to:
  /// **'Outgoing Calls'**
  String get outgoingCalls;

  /// No description provided for @totalCalls.
  ///
  /// In en, this message translates to:
  /// **'Total Calls'**
  String get totalCalls;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @fail.
  ///
  /// In en, this message translates to:
  /// **'Fail'**
  String get fail;

  /// No description provided for @successPercent.
  ///
  /// In en, this message translates to:
  /// **'Success %'**
  String get successPercent;

  /// No description provided for @avgCallDuration.
  ///
  /// In en, this message translates to:
  /// **'Avg. Call Duration'**
  String get avgCallDuration;

  /// No description provided for @totalCallDuration.
  ///
  /// In en, this message translates to:
  /// **'Total Call Duration'**
  String get totalCallDuration;

  /// No description provided for @totalActiveTime.
  ///
  /// In en, this message translates to:
  /// **'Total Active Time'**
  String get totalActiveTime;

  /// No description provided for @totalBreakTime.
  ///
  /// In en, this message translates to:
  /// **'Total Break Time'**
  String get totalBreakTime;

  /// No description provided for @noRecordFound.
  ///
  /// In en, this message translates to:
  /// **'No record found.'**
  String get noRecordFound;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found.'**
  String get noItemsFound;

  /// No description provided for @logoutDes.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out'**
  String get logoutDes;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @lessThan.
  ///
  /// In en, this message translates to:
  /// **'Less than'**
  String get lessThan;

  /// No description provided for @greaterThan.
  ///
  /// In en, this message translates to:
  /// **'Greater than'**
  String get greaterThan;

  /// No description provided for @equalsTo.
  ///
  /// In en, this message translates to:
  /// **'Equals to'**
  String get equalsTo;

  /// No description provided for @sortByLastCommunicationDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by last communication date'**
  String get sortByLastCommunicationDate;

  /// No description provided for @sortByCreatedDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by  created date'**
  String get sortByCreatedDate;

  /// No description provided for @clearFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear Filter'**
  String get clearFilter;

  /// No description provided for @leadEdit.
  ///
  /// In en, this message translates to:
  /// **'Lead Edit'**
  String get leadEdit;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @lastCommunication.
  ///
  /// In en, this message translates to:
  /// **'Last Communication'**
  String get lastCommunication;

  /// No description provided for @audioPlayer.
  ///
  /// In en, this message translates to:
  /// **'Audio Player'**
  String get audioPlayer;

  /// No description provided for @campaigns.
  ///
  /// In en, this message translates to:
  /// **'Campaigns'**
  String get campaigns;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @pleaseEnterPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter price'**
  String get pleaseEnterPrice;

  /// No description provided for @pleaseSelectPriceSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Please select price sort order'**
  String get pleaseSelectPriceSortOrder;

  /// No description provided for @failedToMakePhoneCall.
  ///
  /// In en, this message translates to:
  /// **'Failed to make phone call'**
  String get failedToMakePhoneCall;

  /// No description provided for @waitForTheCall.
  ///
  /// In en, this message translates to:
  /// **'Your request has been submitted. Please wait for the call.'**
  String get waitForTheCall;

  /// No description provided for @noMatchingRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No matching records found'**
  String get noMatchingRecordsFound;

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No records found'**
  String get noRecordsFound;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @confirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Once confirmed, you will not be able to revert this!'**
  String get confirmMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Yes, delete it'**
  String get delete;

  /// No description provided for @contactsPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission is required to view phone contacts.'**
  String get contactsPermissionRequired;

  /// No description provided for @contactsPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Contacts permission denied.'**
  String get contactsPermissionDenied;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @switchCampaign.
  ///
  /// In en, this message translates to:
  /// **'Switch Campaign'**
  String get switchCampaign;

  /// No description provided for @selfCallNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'You cannot call your own number'**
  String get selfCallNotAllowed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
