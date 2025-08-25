import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/features/in_sights/data/enum/in_sights_date_enum.dart';
import 'package:kommuno/features/in_sights/data/model/response/in_sights_response.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kommuno/features/in_sights/data/repository/in_sights_repo.dart';

part 'in_sights_state.dart';

class InSightsCubit extends Cubit<InSightsState> {
  InSightsCubit() : super(const InSightsInitialState());

  final _inSightsRepo = InSightsRepo();

  Future<void> getInSights({
    bool isLoading = false,
    required int smeId,
    DateTimeRange? selectedDateTimeRange,
    InSightsDateEnum? inSightsDateEnum,
  }) async {
    try {
      if (isLoading) {
        emit(const InSightsLoadingState());
      } else {
        AppLoadingIndicator.showLoadingIndicator();
      }

      final dateTimeRange = selectedDateTimeRange ??
          _getDateTimeRange(inSightsDateEnum ?? InSightsDateEnum.today);

      final res = await _inSightsRepo.getInsight(
        startDate: dateTimeRange.start,
        endDate: dateTimeRange.end,
        smeId: smeId,
      );

      if (res.isSuccess) {
        if (state is InSightsSuccessState) {
          emit((state as InSightsSuccessState).copyWith(
            inSightsDateEnum: () => inSightsDateEnum,
            dateTimeRange: () => selectedDateTimeRange,
            insightsResponse: InsightsResponse.fromJson(res.data[0]),
          ));
        } else {
          emit(
            InSightsSuccessState(
              insightsResponse: InsightsResponse.fromJson(res.data[0]),
              dateTimeRange: selectedDateTimeRange,
              inSightsDateEnum: inSightsDateEnum,
            ),
          );
        }
      } else {
        if (isLoading) {
          emit(const InSightsErrorState());
        }
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(const InSightsErrorState());
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(const InSightsErrorState());
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("InSightsCubit $e");
      debugPrint("$s");
    }

    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
  }

  DateTimeRange _getDateTimeRange(InSightsDateEnum inSightsDateEnum) {
    switch (inSightsDateEnum) {
      case InSightsDateEnum.today:
        return DateTimeRange(start: DateTime.now(), end: DateTime.now());
      case InSightsDateEnum.yesterday:
        return DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 1)),
            end: DateTime.now());
      case InSightsDateEnum.last7Days:
        return DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now());
      case InSightsDateEnum.last15Days:
        return DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 15)),
            end: DateTime.now());
      case InSightsDateEnum.last30Days:
        return DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 30)),
            end: DateTime.now());
    }
  }
}
