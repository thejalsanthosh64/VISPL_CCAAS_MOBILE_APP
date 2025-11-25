import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/debouncer.dart';
import 'package:kommuno/core/utilities/pagination_scroll_controller.dart';
import 'package:kommuno/features/assigned_calls/data/model/assigned_calls_list_model.dart';
import 'package:kommuno/features/assigned_calls/data/repository/assigned_calls_repo.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'assigned_calls_state.dart';

class AssignedCallsCubit extends Cubit<AssignedCallsState> {
  AssignedCallsCubit() : super(const AssignedCallsInitialState());

  final _assignedCallsRepo = AssignedCallsRepo();

  final debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  final paginationScrollController = PaginationScrollController();

  @override
  Future<void> close() async {
    debouncer.cancel();
    paginationScrollController.dispose();
    super.close();
  }

  Future<bool> getAssignedCalls({
    bool isLoading = true,
    int? initialRecordValue,
    required int smeId,
  }) async {
    bool hasMoreData = true;
    try {
      int batchSize = 20;
      int initialRecord = 1;

      if (isLoading) {
        emit(const AssignedCallsLoadingState());
      } else {
        AppLoadingIndicator.showLoadingIndicator();
        if (state is AssignedCallsSuccessState) {
          initialRecord = initialRecordValue ??
              (state as AssignedCallsSuccessState).initialRecord + batchSize;
        }
      }

      final res = await _assignedCallsRepo.getAssignedCalls(
          batchSize: batchSize, initialRecord: initialRecord, smeId: smeId);
      if (res.isSuccess) {
        final assignedCallsDetails = List<AssignedCallsDetails>.from(
          (res.data as List<dynamic>).map(
            (e) => AssignedCallsDetails.fromJson(e),
          ),
        );
        if (assignedCallsDetails.length < batchSize) {
          hasMoreData = false;
          paginationScrollController.hasMoreData = false;
        } else {
          paginationScrollController.hasMoreData = true;
        }
        if (state is AssignedCallsSuccessState) {
          final currentState = state as AssignedCallsSuccessState;
          List<AssignedCallsDetails> list = [];
          if (initialRecordValue == 1) {
            list = [...assignedCallsDetails];
          } else {
            list = [...currentState.assignedCallsDetails];
            list.addAll(assignedCallsDetails);
          }
          emit((state as AssignedCallsSuccessState).copyWith(
              initialRecord: initialRecord, assignedCallsDetails: list));
        } else {
          emit(
            AssignedCallsSuccessState(
                initialRecord: initialRecord,
                assignedCallsDetails: assignedCallsDetails),
          );
        }
      } else {
        if (isLoading) {
          emit(const AssignedCallsErrorState());
        }
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(const AssignedCallsErrorState());
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(const AssignedCallsErrorState());
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("AssignedCallsCubit $e");
      debugPrint("$s");
    }
    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
    return hasMoreData;
  }

  void searchAssignedCalls(String text) {
    if (state is AssignedCallsSuccessState) {
      final currentState = state as AssignedCallsSuccessState;
      final searchedText = text.trim().toLowerCase();
      if (searchedText.isNotEmpty) {
        final searchedList = currentState.assignedCallsDetails
            .where((e) => "${e.customerName ?? ''} ${e.customerNumber}"
                .trim()
                .toLowerCase()
                .contains(searchedText))
            .toList();
        emit(currentState.copyWith(
            searchedAssignedCallsDetails: () => searchedList));
      } else {
        emit(currentState.copyWith(searchedAssignedCallsDetails: () => null));
      }
    }
  }
}
