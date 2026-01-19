import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/debouncer.dart';
import 'package:kommuno/core/utilities/pagination_scroll_controller.dart';
import 'package:kommuno/features/recent_calls/data/model/request/recent_calls_request_model.dart';
import 'package:kommuno/features/recent_calls/data/model/response/recent_calls_data.dart';
import 'package:kommuno/features/recent_calls/data/repository/recent_calls_repo.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'recent_calls_state.dart';

class RecentCallsCubit extends Cubit<RecentCallsState> {
  RecentCallsCubit() : super(const RecentCallsInitialState());

  final paginationScrollController = PaginationScrollController();

  final debouncer = Debouncer(delay: const Duration(milliseconds: 500));

  final _recentCallsRepo = RecentCallsRepo();

  final dateController = TextEditingController();

  @override
  Future<void> close() async {
    debouncer.cancel();
    paginationScrollController.dispose();
    dateController.dispose();
    super.close();
  }

  // Future<bool> getRecentCalls({
  //   List<RecentCallsRequestModel>? recentCallsRequestModel,
  //   bool isLoading = true,
  //   required int smeId,
  //   int? initialRecordValue,
  // }) async {
  //   bool hasMoreData = true;
  //   try {
  //     int batchSize = 20;
  //     int initialRecord = 1;
  //     if (isLoading) {
  //       emit(const RecentCallsLoadingState());
  //     } else {
  //       AppLoadingIndicator.showLoadingIndicator();
  //       if (state is RecentCallsSuccessState) {
  //         initialRecord = initialRecordValue ??
  //             (state as RecentCallsSuccessState).initialRecord + batchSize;
  //       }
  //     }

  //     final res = await _recentCallsRepo.getRecentCalls(
  //       initialRecord: initialRecord,
  //       smeId: smeId,
  //       batchSize: batchSize,
  //       recentCallsRequestModel: recentCallsRequestModel,
  //     );

Future<bool> getRecentCalls({
  bool isLoading = true,
  required int smeId,
    required int agentId,

  int? initialRecordValue,
  DateTimeRange? selectedDateRange,
}) async {
  bool hasMoreData = true;
  try {
    int batchSize = 20;
    int initialRecord = 1;
    
    if (isLoading) {
      emit(const RecentCallsLoadingState());
    } else {
      AppLoadingIndicator.showLoadingIndicator();
      if (state is RecentCallsSuccessState) {
        initialRecord = initialRecordValue ??
            (state as RecentCallsSuccessState).initialRecord + batchSize;
      }
    }

    // Default to today if no date range provided
    final dateRange = selectedDateRange ?? DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 1)),
      end: DateTime.now(),
    );

    // final requestModel = RecentCallsRequestModel(
    //   agentNumber: agentNumber,
    //   startDateTime: dateRange.start.toUtc().toIso8601String(),
    //   endDateTime: dateRange.end.toUtc().toIso8601String(),
    //   batchSize: batchSize,
    //   initialRecord: initialRecord,
    // );

final start = _startOfDay(dateRange.start).toUtc().toIso8601String();
final end   = _endOfDay(dateRange.end).toUtc().toIso8601String();

final requestModel = RecentCallsRequestModel(
  agentId: agentId,
  startDate: start,
  endDate: end,
  batchSize: batchSize,
  initialRecord: initialRecord,
);

    final res = await _recentCallsRepo.getRecentCalls(

      requestModel: requestModel,
    smeId: smeId
    );
      if (res.isSuccess) {
        final recentCallsData = List<RecentCallsData>.from(
          (res.data as List<dynamic>).map(
            (e) => RecentCallsData.fromJson(e),
          ),
        );

        if (recentCallsData.length < batchSize) {
          hasMoreData = false;
          paginationScrollController.hasMoreData = false;
        } else {
          paginationScrollController.hasMoreData = true;
        }
        if (state is RecentCallsSuccessState) {
          final currentState = state as RecentCallsSuccessState;
          List<RecentCallsData> list = [];
          if (initialRecordValue == 1) {
            list = [...recentCallsData];
          } else {
            list = [...currentState.recentCallsData];
            list.addAll(recentCallsData);
          }
          // if (recentCallsRequestModel == null) {
          //   dateController.clear();
          // }
          emit((state as RecentCallsSuccessState).copyWith(
              initialRecord: initialRecord,
              recentCallsData: list,
              // recentCallsRequestModel: () => recentCallsRequestModel,
              // selectedDate:
                  // recentCallsRequestModel == null ? () => null : null
                  )
                  );
        } else {
          emit(RecentCallsSuccessState(
            initialRecord: initialRecord,
            recentCallsData: recentCallsData,
            // recentCallsRequestModel: recentCallsRequestModel,
          ));
        }
      } else {
        if (isLoading) {
          emit(const RecentCallsErrorState());
        }
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(const RecentCallsErrorState());
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(const RecentCallsErrorState());
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("RecentCallsCubit $e");
      debugPrint("$s");
    }
    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
    return hasMoreData;
  }

  void searchRecentCalls(String text) {
    if (state is RecentCallsSuccessState) {
      final currentState = state as RecentCallsSuccessState;
      final searchedText = text.trim().toLowerCase();
      if (searchedText.isNotEmpty) {
        final searchedList = currentState.recentCallsData
            .where((e) => "${e.customerName ?? ''} ${e.customerNumber}"
                .trim()
                .toLowerCase()
                .contains(searchedText))
            .toList();
        emit(
            currentState.copyWith(searchedRecentCallsData: () => searchedList));
      } else {
        emit(currentState.copyWith(searchedRecentCallsData: () => null));
      }
    }
  }

  // void onSelectDate({DateTimeRange? selectedDate, required int smeId}) {
  //   if (state is RecentCallsSuccessState) {
  //     final currentState = state as RecentCallsSuccessState;
  //     dateController.text = selectedDate != null
  //         ? "${DateUtility.getDateYMDOnly(date: selectedDate.start)}    ${DateUtility.getDateYMDOnly(date: selectedDate.end)}"
  //         : '';
  //     emit(currentState.copyWith(selectedDate: () => selectedDate));
  //     getRecentCalls(
  //       smeId: smeId,
  //       isLoading: false,
  //       initialRecordValue: 1,
  //       recentCallsRequestModel: selectedDate == null
  //           ? null
  //           : [
  //               RecentCallsRequestModel(
  //                 recentCallsFilterEnum: RecentCallsFilterEnum.startDate,
  //                 val: DateUtility.sendRequestDateTimeFormat(
  //                     date: selectedDate.start),
  //               ),
  //               RecentCallsRequestModel(
  //                 recentCallsFilterEnum: RecentCallsFilterEnum.endDate,
  //                 val: DateUtility.sendRequestDateTimeFormat(
  //                     date: selectedDate.end),
  //               )
  //             ],
  //     );
  //   }
  // }

  void onSelectDate({DateTimeRange? selectedDate, required int smeId, required String agentNumber,required int agentId}) {
  if (state is RecentCallsSuccessState) {
    final currentState = state as RecentCallsSuccessState;
    
    // Use selected date or default to today
    final DateTimeRange dateRange = selectedDate ?? DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 1)), // Yesterday
      end: DateTime.now(),
    );
    
    dateController.text = selectedDate != null
        ? "${DateUtility.getDateYMDOnly(date: dateRange.start)}    ${DateUtility.getDateYMDOnly(date: dateRange.end)}"
        : '';
    
    emit(currentState.copyWith(selectedDate: () => selectedDate));
    
    getRecentCalls(
      smeId: smeId,
      isLoading: false,
      initialRecordValue: 1,
      selectedDateRange: dateRange,
      agentId: agentId
    );
  }
}

DateTime _startOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

DateTime _endOfDay(DateTime date) {
  return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}

}
