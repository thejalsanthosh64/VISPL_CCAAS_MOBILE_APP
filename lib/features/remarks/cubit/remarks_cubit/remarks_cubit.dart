import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/features/remarks/data/model/request/remarks_request_model.dart';
import 'package:kommuno/features/remarks/data/model/request/send_remarks_request_model.dart';
import 'package:kommuno/features/remarks/data/model/response/remarks_data_model.dart';
import 'package:kommuno/features/remarks/data/repository/remarks_repo.dart';

part 'remarks_state.dart';

class RemarksCubit extends Cubit<RemarksState> {
  RemarksCubit() : super(const RemarksInitialState());

  final _remarksRepo = RemarksRepo();

  final remarksController = TextEditingController();

  @override
  Future<void> close() async {
    remarksController.dispose();
    super.close();
  }

  Future<void> getRemarksList(
      {required RemarksRequestModel remarksRequestModel}) async {
    try {
      emit(const RemarksLoadingState());
      final res = await _remarksRepo.getRemarksList(
          remarksRequestModel: remarksRequestModel);
      if (res.isSuccess) {
        final remarksDataModel = List<RemarksDataModel>.from(
          (res.data as List<dynamic>).map(
            (e) => RemarksDataModel.fromJson(e),
          ),
        );
        if (state is RemarksSuccessState) {
          emit((state as RemarksSuccessState)
              .copyWith(remarksDataModel: remarksDataModel));
        } else {
          emit(RemarksSuccessState(remarksDataModel: remarksDataModel));
        }
      } else {
        emit(const RemarksErrorState());
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      emit(const RemarksErrorState());
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      emit(const RemarksErrorState());
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("RemarksCubit $e");
      debugPrint("$s");
    }
  }

  void changeSendIconVisibility(bool visible) {
    if (state is RemarksSuccessState) {
      emit((state as RemarksSuccessState)
          .copyWith(isSendButtonVisible: visible));
    }
  }

  Future<void> setRemarks(
      {required SendRemarksRequestModel sendRemarksRequestModel}) async {
    try {
      AppLoadingIndicator.showLoadingIndicator();
      final res = await _remarksRepo.setRemarks(
          sendRemarksRequestModel: sendRemarksRequestModel);
      if (res.isSuccess) {
        if (state is RemarksSuccessState) {
          emit((state as RemarksSuccessState)
              .copyWith(sendRemarksRequestModel: sendRemarksRequestModel));
        }
      } else {
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("RemarksCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
