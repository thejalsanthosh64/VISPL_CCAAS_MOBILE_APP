import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/common/widget/user_details/data/repository/user_details_repo.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

part 'user_details_state.dart';

class UserDetailsCubit extends Cubit<UserDetailsState> {
static UserDetailsCubit? instance;   

  UserDetailsCubit() : super(const UserDetailsInitialState()) {
    instance = this;                 
  }
  final _userDetailsRepo = UserDetailsRepo();
  late UserDetailsModel userDetailsModel;

  Timer? _waitingTimer;
  int waitingSeconds = 0;

Timer? _activeTimer;
int activeSeconds = 0;
int todayLunchHours = 0;

void startWaitingTimer() {
  if (isClosed) return;

  if (_waitingTimer != null) {
    debugPrint(" Waiting timer already running");
    return;
  }

  if (state is UserDetailsSuccessState) {
    emit((state as UserDetailsSuccessState).copyWith(
      agentStatus: "Waiting",
      waitingSeconds: waitingSeconds,
    ));
  }

  _waitingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    if (isClosed) return;

    waitingSeconds++;
    if (state is UserDetailsSuccessState) {
      emit((state as UserDetailsSuccessState).copyWith(
        agentStatus: "Waiting",
        waitingSeconds: waitingSeconds,
      ));
    }
  });

  debugPrint("Waiting timer started");
}


int stopWaitingTimer() {
   
  if (isClosed || _waitingTimer == null) {
    debugPrint("stopWaitingTimer ignored");
    return waitingSeconds;
  }

  final capturedSeconds = waitingSeconds;
  _waitingTimer?.cancel();
  _waitingTimer = null;
    waitingSeconds = 0;
if (state is UserDetailsSuccessState) {
    emit((state as UserDetailsSuccessState).copyWith(
      waitingSeconds: 0,
    ));
  }


  debugPrint(" Waiting paused - $capturedSeconds sec");
  return capturedSeconds;
}


void setActive() {
  final elapsedSeconds = stopWaitingTimer();
  waitingSeconds = 0; 

  debugPrint("▶ Agent Active after $elapsedSeconds sec");

  if (state is UserDetailsSuccessState) {
    emit((state as UserDetailsSuccessState).copyWith(
      agentStatus: "Active",
      waitingSeconds: 0,
    ));
  }
}

  //  After call restart waiting
  void backToWaiting() {
    debugPrint("⏮️ Agent back to Waiting");
    startWaitingTimer();
  }

void startActiveTimer() {
  if (_activeTimer != null) {
    debugPrint("⚠️ Active timer already running");
    return;
  }

  _activeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
    activeSeconds++;

    if (state is UserDetailsSuccessState) {
      emit((state as UserDetailsSuccessState).copyWith(
        activeSeconds: activeSeconds,
      ));
    }
  });

  debugPrint("✅ Active Timer Started");
}

// void startActiveTimer() {
//   stopActiveTimer(); 

//   _activeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//     activeSeconds++;

//     if (state is UserDetailsSuccessState) {
//       emit((state as UserDetailsSuccessState).copyWith(
//         activeSeconds: activeSeconds,
//       ));
//     }
//   });

//   debugPrint(" Active Timer Started");
// }

void stopActiveTimer() {
  _activeTimer?.cancel();
  _activeTimer = null;
  debugPrint("Active Timer Stopped");
}

void resetActiveTimer() {
  activeSeconds = 0;
  debugPrint(" Active Timer Reset");
}
int todayOfficeHours = 0;

void setTodayOfficeHours(int value) {
  todayOfficeHours = value;
  if (state is UserDetailsSuccessState) {
    emit((state as UserDetailsSuccessState).copyWith(
      officeHours: value,
    ));
  }
}
void setTodayLunchHours(int value) {
  todayLunchHours = value;

  if (state is UserDetailsSuccessState) {
    emit((state as UserDetailsSuccessState).copyWith(
      lunchHours: value,
    ));
  }
}
  @override
  Future<void> close() {
    stopWaitingTimer();
    stopActiveTimer();
    return super.close();}

  Future<void> loadUserDetails({bool isLoading = true}) async {
    try {
      if (isLoading) {
        emit(const UserDetailsLoadingState());
      } else {
        AppLoadingIndicator.showLoadingIndicator();
      }
      final res = await _userDetailsRepo.loadUserDetails();
      if (res.isSuccess) {
        print(res.data);

        final data = List<Map<String, dynamic>>.from(res.data as List);
        if (data. isNotEmpty) {
          userDetailsModel = UserDetailsModel.fromJson(data.first);
          emit(UserDetailsSuccessState(userDetailsModel: userDetailsModel,  activeSeconds: activeSeconds,lunchHours: todayLunchHours,
  officeHours: todayOfficeHours,));
        } else {
          emit(const UserDetailsNotFoundState());
        }
      } else {
        if (isLoading) {
          emit(const UserDetailsErrorState());
        }

        FToastManager().showToast(message: res.message);
      }
    } on AppDioException catch (e) {
      if (isLoading) {
        emit(const UserDetailsErrorState());
      }
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      if (isLoading) {
        emit(const UserDetailsErrorState());
      }
      FToastManager().showToast(
          message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!
              .somethingWentWrong);
      debugPrint("UserDetailsCubit $e");
      debugPrint("$s");
    }
    if (!isLoading) {
      AppLoadingIndicator.dismissLoadingIndicator();
    }
  }
}
