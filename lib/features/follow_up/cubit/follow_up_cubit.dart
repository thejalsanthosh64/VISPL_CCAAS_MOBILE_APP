import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/utilities/debouncer.dart';
import 'package:kommuno/core/utilities/pagination_scroll_controller.dart';
import 'package:kommuno/features/follow_up/data/model/follow_up_list_model.dart';
import 'package:kommuno/features/follow_up/data/repository/follow_up_repo.dart';

part 'follow_up_state.dart';

// class FollowUpCubit extends Cubit<FollowUpState> {
//   final int smeId;

//   FollowUpCubit({required this.smeId}) : super(const FollowUpInitialState()) {
//     paginationScrollController.init(loadAction: () {
//       if (state is FollowUpSuccessState &&
//           (state as FollowUpSuccessState).searchedFollowUpListModel == null) {
//         return getFollowUpDetails(isLoading: false);
//       }
//       return Future.value(paginationScrollController.hasMoreData);
//     });
//   }

//   final _followUpRepo = FollowUpRepo();

//   final debouncer = Debouncer(delay: const Duration(milliseconds: 300));

//   final paginationScrollController = PaginationScrollController();

//   final searchController = TextEditingController();

//   @override
//   Future<void> close() async {
//     debouncer.cancel();
//     paginationScrollController.dispose();
//     searchController.dispose();
//     super.close();
//   }

//   Future<bool> getFollowUpDetails({
//     bool isLoading = true,
//     int? initialRecordValue,
//   }) async {
//     bool hasMoreData = true;
//     try {
//       int batchSize = 20;
//       int initialRecord = 1;

//       if (isLoading) {
//         emit(const FollowUpLoadingState());
//       } else {
//         AppLoadingIndicator.showLoadingIndicator();
//         if (state is FollowUpSuccessState) {
//           initialRecord = initialRecordValue ??
//               (state as FollowUpSuccessState).initialRecord + batchSize;
//         }
//       }

//       final res = await _followUpRepo.followUpDetails(
//           batchSize: batchSize, initialRecord: initialRecord, smeId: smeId);
//       if (res.isSuccess) {
//         final followUpListModel = List<FollowUpDetails>.from(
//           (res.data as List<dynamic>).map(
//             (e) => FollowUpDetails.fromJson(e),
//           ),
//         );
//         if (followUpListModel.length < batchSize) {
//           hasMoreData = false;
//           paginationScrollController.hasMoreData = false;
//         } else {
//           paginationScrollController.hasMoreData = true;
//         }
//         if (state is FollowUpSuccessState) {
//           final currentState = state as FollowUpSuccessState;
//           List<FollowUpDetails> list = [];
//           if (initialRecordValue == 1) {
//             list = [...followUpListModel];
//           } else {
//             list = [...currentState.followUpListModel];
//             list.addAll(followUpListModel);
//           }

//           emit((state as FollowUpSuccessState)
//               .copyWith(initialRecord: initialRecord, followUpListModel: list));
//         } else {
//           emit(
//             FollowUpSuccessState(
//                 initialRecord: initialRecord,
//                 followUpListModel: followUpListModel),
//           );
//         }
//       } else {
//         if (isLoading) {
//           emit(const FollowUpErrorState());
//         }
//         FToastManager().showToast(message: res.message);
//       }
//     } on AppDioException catch (e) {
//       if (isLoading) {
//         emit(const FollowUpErrorState());
//       }
//       FToastManager().showToast(message: e.message);
//     } catch (e, s) {
//       if (isLoading) {
//         emit(const FollowUpErrorState());
//       }
//       FToastManager().showToast(
//           message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//               .somethingWentWrong);
//       debugPrint("FollowUpCubit $e");
//       debugPrint("$s");
//     }
//     if (!isLoading) {
//       AppLoadingIndicator.dismissLoadingIndicator();
//     }
//     return hasMoreData;
//   }

//   void searchFollowUp(String text) {
//     if (state is FollowUpSuccessState) {
//       final currentState = state as FollowUpSuccessState;
//       final searchedText = text.trim().toLowerCase();
//       if (searchedText.isNotEmpty) {
//         final searchedList = currentState.followUpListModel
//             .where((e) => "${e.customerName} ${e.customerNumber}"
//                 .trim()
//                 .toLowerCase()
//                 .contains(searchedText))
//             .toList();
//         emit(currentState.copyWith(
//             searchedFollowUpListModel: () => searchedList));
//       } else {
//         searchController.clear();
//         emit(currentState.copyWith(searchedFollowUpListModel: () => null));
//       }
//     }
//   }

//   Future<void> changeScheduleStatus({required String scheduleId}) async {
//     try {
//       AppLoadingIndicator.showLoadingIndicator();
//       final res = await _followUpRepo.changeScheduleStatus(
//           status: 1, scheduleId: scheduleId, smeId: smeId);
//       FToastManager().showToast(message: res.message);
//       if (res.isSuccess) {
//         await getFollowUpDetails(isLoading: false, initialRecordValue: 1);
//         searchFollowUp(searchController.text);
//       }
//     } on AppDioException catch (e) {
//       FToastManager().showToast(message: e.message);
//     } catch (e, s) {
//       FToastManager().showToast(
//           message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
//               .somethingWentWrong);
//       debugPrint("FollowUpCubit $e");
//       debugPrint("$s");
//     }
//     AppLoadingIndicator.dismissLoadingIndicator();
//   }
// }


enum FollowUpTab { past, today, upcoming }

class FollowUpCubit extends Cubit<FollowUpState> {
  final int smeId;
  final int agentId;

  FollowUpCubit({
    required this.smeId,
    required this.agentId,
  }) : super(const FollowUpInitialState()) {
    paginationScrollController.init(loadAction: _loadMore);
    loadFollowUps();
  }

  final _repo = FollowUpRepo();

  FollowUpTab selectedTab = FollowUpTab.today;

  final debouncer = Debouncer(delay: Duration(milliseconds: 300));

  final paginationScrollController = PaginationScrollController();

  final searchController = TextEditingController();

  List<FollowUpDetails> pastList = [];
  List<FollowUpDetails> todayList = [];
  List<FollowUpDetails> upcomingList = [];

  List<FollowUpDetails>? searchedList;

  int pastInitialRecord = 1;
  int todayInitialRecord = 1;
  int upcomingInitialRecord = 1;

  static const int batchSize = 20;

  Future<bool> loadFollowUps({bool isLoading = true, int? reset}) async {
    switch (selectedTab) {
      case FollowUpTab.past:
        return _loadPast(isLoading: isLoading, reset: reset);
      case FollowUpTab.today:
        return _loadToday(isLoading: isLoading, reset: reset);
      case FollowUpTab.upcoming:
        return _loadUpcoming(isLoading: isLoading, reset: reset);
    }
  }

  Future<bool> _loadMore() {
    return loadFollowUps(isLoading: false);
  }

void changeTab(FollowUpTab tab) {
    selectedTab = tab;
    searchedList = null; 
    searchController.clear();
    
    final currentList = getCurrentList();
    
    if (currentList.isEmpty) {
      // If the tab has no data yet, load it
      loadFollowUps();
    } else {
      // If data exists, just emit it
      emit(FollowUpSuccessState(
        followUpListModel: currentList,
        initialRecord: _getInitialRecord(),
        searchedFollowUpListModel: searchedList,
      ));
    }
  }

Future<bool> _loadPast({bool isLoading = true, int? reset}) async {
 

  try {
    if (isLoading) emit(const FollowUpLoadingState());

    if (reset == 1) {
      pastInitialRecord = 1;
    }

    final res = await _repo.getPastScheduledCalls(
      smeId: smeId,
      agentId: agentId,
      initialRecord: pastInitialRecord,
      batchSize: batchSize,
      pastDate: DateTime.now(),
    );

    if (!res.isSuccess) {
      emit(const FollowUpErrorState());
      return false;
    }

    final list = List<FollowUpDetails>.from(
      (res.data as List).map((e) => FollowUpDetails.fromJson(e)),
    );

    if (pastInitialRecord == 1) {
      pastList = list;
    } else {
      pastList.addAll(list);
    }
    if (list.length < batchSize) {
      paginationScrollController.hasMoreData = false;
    } else {
      paginationScrollController.hasMoreData = true;
      pastInitialRecord += batchSize;
    }

    emit(FollowUpSuccessState(
      followUpListModel: getCurrentList(),
      initialRecord: pastInitialRecord,
      searchedFollowUpListModel: searchedList,
    ));

    return true;

  } catch (e) {
    emit(const FollowUpErrorState());
    return false;
  }
}


  Future<bool> _loadToday({bool isLoading = true, int? reset}) async {
    try {
      if (isLoading) emit(const FollowUpLoadingState());

      if (reset == 1) todayInitialRecord = 1;

      final res = await _repo.getTodayScheduledCalls(
        smeId: smeId,
        agentId: agentId,
        initialRecord: todayInitialRecord,
        batchSize: batchSize,
        todayDate: DateTime.now(),
      );

      if (!res.isSuccess) {
        emit(const FollowUpErrorState());
        return false;
      }

      final list = List<FollowUpDetails>.from(
        (res.data as List).map((e) => FollowUpDetails.fromJson(e)),
      );

      if (todayInitialRecord == 1) {
        todayList = list;
      } else {
        todayList.addAll(list);
      }

      if (list.length < batchSize) {
        paginationScrollController.hasMoreData = false;
      } else {
        paginationScrollController.hasMoreData = true;
        todayInitialRecord += batchSize;
      }

      emit(FollowUpSuccessState(
        followUpListModel: getCurrentList(),
        initialRecord: todayInitialRecord,
        searchedFollowUpListModel: searchedList,
      ));

      return true;
    } catch (_) {
      emit(const FollowUpErrorState());
      return false;
    }
  }

  Future<bool> _loadUpcoming({bool isLoading = true, int? reset}) async {
    try {
      if (isLoading) emit(const FollowUpLoadingState());

      if (reset == 1) upcomingInitialRecord = 1;

      final res = await _repo.getUpcomingScheduledCalls(
        smeId: smeId,
        agentId: agentId,
        initialRecord: upcomingInitialRecord,
        batchSize: batchSize,
        upcomingDate: DateTime.now(),
      );

      if (!res.isSuccess) {
        emit(const FollowUpErrorState());
        return false;
      }

      final list = List<FollowUpDetails>.from(
        (res.data as List).map((e) => FollowUpDetails.fromJson(e)),
      );

      if (upcomingInitialRecord == 1) {
        upcomingList = list;
      } else {
        upcomingList.addAll(list);
      }

      if (list.length < batchSize) {
        paginationScrollController.hasMoreData = false;
      } else {
        paginationScrollController.hasMoreData = true;
        upcomingInitialRecord += batchSize;
      }

      emit(FollowUpSuccessState(
        followUpListModel: getCurrentList(),
        initialRecord: upcomingInitialRecord,
        searchedFollowUpListModel: searchedList,
      ));

      return true;
    } catch (_) {
      emit(const FollowUpErrorState());
      return false;
    }
  }

  void searchFollowUp(String text) {
    final baseList = getCurrentList();

    if (text.trim().isEmpty) {
      searchedList = null;
    } else {
      final t = text.trim().toLowerCase();
      searchedList = baseList.where((e) {
        return ("${e.customerName} ${e.customerNumber}")
            .trim()
            .toLowerCase()
            .contains(t);
      }).toList();
    }

    emit(FollowUpSuccessState(
      followUpListModel: baseList,
      initialRecord: _getInitialRecord(),
      searchedFollowUpListModel: searchedList,
    ));
  }

  Future<void> changeScheduleStatus(String scheduleId) async {
    try {
      AppLoadingIndicator.showLoadingIndicator();

      final res = await _repo.changeScheduleStatus(
        smeId: smeId,
        scheduleId: scheduleId,
        status: 1,
      );

      FToastManager().showToast(message: res.message);

      if (res.isSuccess) {
        await loadFollowUps(isLoading: false, reset: 1);
        searchFollowUp(searchController.text);
      }
    } catch (e) {
      FToastManager().showToast(message: "Something went wrong");
    }

    AppLoadingIndicator.dismissLoadingIndicator();
  }

List<FollowUpDetails> getCurrentList() {
  switch (selectedTab) {
    case FollowUpTab.past:
      return pastList;
    case FollowUpTab.today:
      return todayList;
    case FollowUpTab.upcoming:
      return upcomingList;
  }
}
Future<void> refreshCurrentTab() async {
  switch (selectedTab) {
    case FollowUpTab.past:
      pastInitialRecord = 1;
      await _loadPast(isLoading: false, reset: 1);
      break;

    case FollowUpTab.today:
      todayInitialRecord = 1;
      await _loadToday(isLoading: false, reset: 1);
      break;

    case FollowUpTab.upcoming:
      upcomingInitialRecord = 1;
      await _loadUpcoming(isLoading: false, reset: 1);
      break;
  }
}

Future<void> markAsCompleted(String scheduleId) async {
  try {
    AppLoadingIndicator.showLoadingIndicator();

    final res = await _repo.changeScheduleStatus(
      scheduleId: scheduleId,
      status: 1,
      smeId: smeId,
    );

    FToastManager().showToast(message: res.message);

    if (res.isSuccess) {
      await refreshCurrentTab();
    }
  } catch (e) {
    FToastManager().showToast(message: "Something went wrong");
  } finally {
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}
Future<void> deleteFollowUp(FollowUpDetails detail, UserDetailsModel userDetails,) async {
  try {
    AppLoadingIndicator.showLoadingIndicator();

    final res = await _repo.deleteFollowUp(
      smeId: smeId,
      followUpId: detail.id,
    );

    FToastManager().showToast(message: res.message);

    if (res.isSuccess) {

      // Activity Log
      await ActivityHelperRepo().setActivityLogs(
        smeId,
        moduleName: "call",
        action: "delete",
        userRole: userDetails.roles,
        message: "${userDetails.agentName} Deleted Successfully Follow Up Call",
        agentId: agentId,
      );

      await refreshCurrentTab();
    }
  } catch (e) {
    FToastManager().showToast(message: "Something went wrong");
  } finally {
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}




  int _getInitialRecord() {
    switch (selectedTab) {
      case FollowUpTab.past:
        return pastInitialRecord;
      case FollowUpTab.today:
        return todayInitialRecord;
      case FollowUpTab.upcoming:
        return upcomingInitialRecord;
    }
  }

  @override
  Future<void> close() {
    debouncer.cancel();
    paginationScrollController.dispose();
    searchController.dispose();
    return super.close();
  }
}
