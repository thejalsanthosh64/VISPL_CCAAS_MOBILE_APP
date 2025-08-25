import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/app_methods.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/core/utilities/validation.dart';
import 'package:kommuno/features/leads/data/model/request/add_lead_request_model.dart';
import 'package:kommuno/features/leads/data/repository/lead_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'add_lead_state.dart';

class AddLeadCubit extends Cubit<AddLeadState> {
  AddLeadCubit() : super(const AddLeadState());

  final phoneController = TextEditingController();

  final _leadRepo = LeadRepo();

  @override
  Future<void> close() async {
    phoneController.dispose();
    super.close();
  }

  Future<void> addManualLead({
    required String customerNumber,
    String? stickyType,
    required int smeId,
  }) async {
    try {
      if (AppValidation.isEmpty(customerNumber)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseEnterMobileNumber);
      } else if (!AppValidation.isValidNumber(customerNumber)) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .invalidMobile);
      } else if (stickyType == null) {
        FToastManager().showToast(
            message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
                .pleaseSelectStyckyType);
      } else {
        AppLoadingIndicator.showLoadingIndicator();
        final addLeadRequestModel = AddMannualLeadRequestModel(
          assignedAgentId: UserLoginInfoManager.userLoginInfoModel!.userId,
          stickyType: _getStickyType(stickyType),
          insertDateTime: DateTime.now(),
          customerNumber: addByIndiaCountryCode(number: customerNumber),
        );
        final res = await _leadRepo.addManualLead(
          addLeadRequestModel: addLeadRequestModel,
          smeId: smeId,
        );
        FToastManager().showToast(message: res.message);
        if (res.isSuccess) {
          emit(state.copyWith(addLeadRequestModel: addLeadRequestModel));
        }
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("AddLeadCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }

  void selectStickyType(String value) {
    emit(state.copyWith(selectedStickyType: value));
  }

  int _getStickyType(String stickyType) {
    if (AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.soft ==
        stickyType) {
      return 1;
    } else {
      return 2;
    }
  }
}
