import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/schedule_call/data/model/request/add_schedule_call_request_model.dart';
import 'package:kommuno/features/schedule_call/data/repository/schedule_call_repo.dart';

part 'add_schedule_call_state.dart';

class AddScheduleCallCubit extends Cubit<AddScheduleCallState> {
  AddScheduleCallCubit() : super(const AddSScheduleCallInitialState());

  final mobileController = TextEditingController();
  final noteController = TextEditingController();
  final noteFocusNode = FocusNode();

  final _scheduleCallRepo = ScheduleCallRepo();
String customerName = "";

void setCustomerName(String name) {
  customerName = name;
}

  @override
  Future<void> close() async {
    mobileController.dispose();
    noteController.dispose();
    noteFocusNode.dispose();
    super.close();
  }

  void setData({required String number}) {
    mobileController.text = splitByIndiaCountryCode(number: number);
    emit(const AddSScheduleCallSuccessState());
  }

  Future<void> selectDateTime({required BuildContext context}) async {
    if (state is AddSScheduleCallSuccessState) {
      final selectedDateTime = await showDateTimePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 30)),
        initialDate: DateTime.now(),
      );
      if (context.mounted && selectedDateTime != null) {
        if (selectedDateTime
            .isBefore(DateTime.now().add(const Duration(seconds: 10)))) {
          FToastManager().showToast(
              message: AppLocalizations.of(context)!
                  .pastAndCurrentDurationNotAllowed);
        } else {
          emit((state as AddSScheduleCallSuccessState)
              .copyWith(selectedDateTime: selectedDateTime));
        }
      }
    }
  }

  Future<void> addScheduleCall({
      required int smeId,

    required String number,
    required String customerName,
    required String note,
    DateTime? selectedDateTime,
  }) async {
    try {
      
      if (AppValidation.isEmpty(number)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterMobileNumber);
      } else if (!AppValidation.isValidNumber(number)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .invalidMobile);
      } else if (AppValidation.isEmpty(note)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterNote);
      } else if (selectedDateTime == null) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseSelectDateTime);
      } else {
        AppLoadingIndicator.showLoadingIndicator();
        final userDetailsModel = (AppKeys.nestedNavigatorKey.currentContext!
                .read<UserDetailsCubit>()
                .state as UserDetailsSuccessState)
            .userDetailsModel;
        final addScheduleCallRequestModel = AddScheduleCallRequestModel(
          message: note,
          customerName: customerName,
          customerNumber: addByIndiaCountryCode(number: number),
          scheduleDateTime: selectedDateTime,
          agentId: "${userDetailsModel.agentId}",
        );

              print("📤 Add Schedule Call → ${addScheduleCallRequestModel.toJson()}");

        final res = await _scheduleCallRepo.addScheduleCall(
            addScheduleCallRequestModel: addScheduleCallRequestModel,smeId:smeId );

         final followUpCubit = await _scheduleCallRepo.nearTimeScheduleCalls(agentId: userDetailsModel.agentId,smeId: smeId,time: DateUtility.scheduleCallRequestDateTimeFormat(
              date: selectedDateTime));

            
        FToastManager().showToast(message: res.message);
        if (res.isSuccess) {


          emit(AddSScheduleCallSuccessState(
              selectedDateTime: selectedDateTime,
              addScheduleCallRequestModel: addScheduleCallRequestModel));
        }

      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("AddScheduleCallCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
