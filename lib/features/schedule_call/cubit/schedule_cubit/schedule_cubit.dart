import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/features/schedule_call/data/model/response/schedule_calls_response_model.dart';
import 'package:kommuno/features/schedule_call/data/repository/schedule_call_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  ScheduleCubit() : super(const ScheduleInitialState());

  final _scheduleCallRepo = ScheduleCallRepo();

  Future<void> getScheduleCalls({
    bool isLoading = true,
    required int smeId,
  }) async {
    try {
      if (isLoading) {
        emit(const ScheduleLoadingState());
      } else {
        AppLoadingIndicator.showLoadingIndicator();
      }

      final res = await _scheduleCallRepo.getScheduleCalls(smeId: smeId);
      if (res.isSuccess) {
        final scheduleCallsResponseModel =
            ScheduleCallsResponseModel.fromJson(res.data);
        emit(ScheduleSuccessState(
            scheduleCallsResponseModel: scheduleCallsResponseModel));
      } else {
        emit(const ScheduleErrorState());
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(const ScheduleErrorState());
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(const ScheduleErrorState());
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("ScheduleCubit $e");
      debugPrint("$s");
    }
    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
  }
}
