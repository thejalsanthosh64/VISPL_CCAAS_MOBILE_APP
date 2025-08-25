import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/utilities/debouncer.dart';
import 'package:kommuno/core/utilities/pagination_scroll_controller.dart';
import 'package:kommuno/features/follow_up/data/model/follow_up_list_model.dart';
import 'package:kommuno/features/follow_up/data/repository/follow_up_repo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'follow_up_state.dart';

class FollowUpCubit extends Cubit<FollowUpState> {
  final int smeId;

  FollowUpCubit({required this.smeId}) : super(const FollowUpInitialState()) {
    paginationScrollController.init(loadAction: () {
      if (state is FollowUpSuccessState &&
          (state as FollowUpSuccessState).searchedFollowUpListModel == null) {
        return getFollowUpDetails(isLoading: false);
      }
      return Future.value(paginationScrollController.hasMoreData);
    });
  }

  final _followUpRepo = FollowUpRepo();

  final debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  final paginationScrollController = PaginationScrollController();

  final searchController = TextEditingController();

  @override
  Future<void> close() async {
    debouncer.cancel();
    paginationScrollController.dispose();
    searchController.dispose();
    super.close();
  }

  Future<bool> getFollowUpDetails({
    bool isLoading = true,
    int? initialRecordValue,
  }) async {
    bool hasMoreData = true;
    try {
      int batchSize = 20;
      int initialRecord = 1;

      if (isLoading) {
        emit(const FollowUpLoadingState());
      } else {
        AppLoadingIndicator.showLoadingIndicator();
        if (state is FollowUpSuccessState) {
          initialRecord = initialRecordValue ??
              (state as FollowUpSuccessState).initialRecord + batchSize;
        }
      }

      final res = await _followUpRepo.followUpDetails(
          batchSize: batchSize, initialRecord: initialRecord, smeId: smeId);
      if (res.isSuccess) {
        final followUpListModel = List<FollowUpDetails>.from(
          (res.data as List<dynamic>).map(
            (e) => FollowUpDetails.fromJson(e),
          ),
        );
        if (followUpListModel.length < batchSize) {
          hasMoreData = false;
          paginationScrollController.hasMoreData = false;
        } else {
          paginationScrollController.hasMoreData = true;
        }
        if (state is FollowUpSuccessState) {
          final currentState = state as FollowUpSuccessState;
          List<FollowUpDetails> list = [];
          if (initialRecordValue == 1) {
            list = [...followUpListModel];
          } else {
            list = [...currentState.followUpListModel];
            list.addAll(followUpListModel);
          }

          emit((state as FollowUpSuccessState)
              .copyWith(initialRecord: initialRecord, followUpListModel: list));
        } else {
          emit(
            FollowUpSuccessState(
                initialRecord: initialRecord,
                followUpListModel: followUpListModel),
          );
        }
      } else {
        if (isLoading) {
          emit(const FollowUpErrorState());
        }
        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(const FollowUpErrorState());
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(const FollowUpErrorState());
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("FollowUpCubit $e");
      debugPrint("$s");
    }
    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
    return hasMoreData;
  }

  void searchFollowUp(String text) {
    if (state is FollowUpSuccessState) {
      final currentState = state as FollowUpSuccessState;
      final searchedText = text.trim().toLowerCase();
      if (searchedText.isNotEmpty) {
        final searchedList = currentState.followUpListModel
            .where((e) => "${e.customerName} ${e.customerNumber}"
                .trim()
                .toLowerCase()
                .contains(searchedText))
            .toList();
        emit(currentState.copyWith(
            searchedFollowUpListModel: () => searchedList));
      } else {
        searchController.clear();
        emit(currentState.copyWith(searchedFollowUpListModel: () => null));
      }
    }
  }

  Future<void> changeScheduleStatus({required String scheduleId}) async {
    try {
      AppLoadingIndicator.showLoadingIndicator();
      final res = await _followUpRepo.changeScheduleStatus(
          status: 1, scheduleId: scheduleId, smeId: smeId);
      FToastManager().showToast(message: res.message);
      if (res.isSuccess) {
        await getFollowUpDetails(isLoading: false, initialRecordValue: 1);
        searchFollowUp(searchController.text);
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("FollowUpCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
