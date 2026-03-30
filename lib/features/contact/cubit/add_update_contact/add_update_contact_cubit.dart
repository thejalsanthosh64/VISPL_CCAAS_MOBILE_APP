import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/debouncer.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/features/contact/data/model/add_update_contact_address_model.dart';
import 'package:kommuno/features/contact/data/repository/contact_repo.dart';

part 'add_update_contact_state.dart';

class AddUpdateContactCubit extends Cubit<AddUpdateContactState> {
  final AddUpdateContactsRequestModel? updateContactDetails;
 final ActivityHelperRepo logRepo = ActivityHelperRepo();
  AddUpdateContactCubit({
    this.updateContactDetails,
  }) : super(const AddUpdateContactState()) {
    if (updateContactDetails != null) {
      customerNameController.text = updateContactDetails!.customerName;
      customerMobileController.text =
          splitByIndiaCountryCode(number: updateContactDetails!.customerNumber);
      companyNameController.text = updateContactDetails!.companyName;
      emailIdController.text = updateContactDetails!.emailId;
      // changeAvatarState(text: updateContactDetails!.customerName);
    emit(state.copyWith(customerName: updateContactDetails!.customerName));
    }
  }

  final _contactRepo = ContactRepo();

  final customerNameController = TextEditingController();
  final customerMobileController = TextEditingController();
  final companyNameController = TextEditingController();
  final emailIdController = TextEditingController();
  final debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  @override
  Future<void> close() async {
    customerNameController.dispose();
    customerMobileController.dispose();
    companyNameController.dispose();
    emailIdController.dispose();
    debouncer.cancel();
    super.close();
  }

  Future<void> addNewContact(
      {required AddUpdateContactsRequestModel addNewContactDetails,  required UserDetailsModel userDetails,
}) async {
    try {
      if (AppValidation.isEmpty(addNewContactDetails.customerName)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterCustomerName);
      } else if (AppValidation.isEmpty(addNewContactDetails.customerNumber)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterMobileNumber);
      } else if (!AppValidation.isValidNumber(
          addNewContactDetails.customerNumber)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .invalidMobile);
      } else if (!AppValidation.isEmpty(addNewContactDetails.emailId) &&
          !AppValidation.isValidEmail(addNewContactDetails.emailId)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .invalidEmail);
      } else {
        hideKeyboard();
        AppLoadingIndicator.showLoadingIndicator();
        final res = await _contactRepo.addContact(
            addUpdateContactsRequest: addNewContactDetails);
        FToastManager().showToast(message: res.message);
        if (res.isSuccess) {
            

       await logRepo.setActivityLogs(
        userDetails.smeId,
        action: "create",
        moduleName: "contacts",
        userRole: userDetails.roles,
        message: "${userDetails.agentName} Added Successfully New Customer",
        agentId: userDetails.agentId,
      );

          emit(state.copyWith(addNewContactDetails: addNewContactDetails));
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("AddUpdateContactCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }

  Future<void> updateContact(
      {required AddUpdateContactsRequestModel addNewContactDetails,   required UserDetailsModel userDetails,
}) async {
    try {
      if (AppValidation.isEmpty(addNewContactDetails.customerName)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterCustomerName);
      } else if (AppValidation.isEmpty(addNewContactDetails.customerNumber)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterMobileNumber);
      } else if (!AppValidation.isValidNumber(
          addNewContactDetails.customerNumber)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .invalidMobile);
      } else if (!AppValidation.isEmpty(addNewContactDetails.emailId) &&
          !AppValidation.isValidEmail(addNewContactDetails.emailId)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .invalidEmail);
      } else {
        hideKeyboard();
        AppLoadingIndicator.showLoadingIndicator();
        final res = await _contactRepo.updateContact(
            addUpdateContactsRequest: addNewContactDetails);
        FToastManager().showToast(message: res.message);
        if (res.isSuccess) {

      await logRepo.setActivityLogs(
        userDetails.smeId,                    
        action: "update",
                moduleName: "contacts",

        userRole: userDetails.roles,
        message: "${userDetails.agentName} Updated Successfully New Customer",
        agentId: userDetails.agentId,
      
      );
          emit(state.copyWith(addNewContactDetails: addNewContactDetails));
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("AddUpdateContactCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }

  void changeAvatarState({required String text}) {
    emit(state.copyWith(customerName: text.trim()));
  }
}
