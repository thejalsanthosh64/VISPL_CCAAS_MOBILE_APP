import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_keys.dart';
import 'package:kommuno/core/common/repo/activity_log_repo.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/common/widget/toast_manager.dart';
import 'package:kommuno/core/common/widget/user_details/cubit/user_details_cubit.dart';
import 'package:kommuno/core/common/widget/user_details/data/model/user_details_model.dart';
import 'package:kommuno/core/exception/app_dio_exception.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';
import 'package:kommuno/core/utilities/date_utility.dart';
import 'package:kommuno/core/utilities/user_login_info_manager/user_login_info_manager.dart';
import 'package:kommuno/features/break/data/model/break_in_request_model.dart';
import 'package:kommuno/features/break/data/model/break_out_request_model.dart';
import 'package:kommuno/features/break/data/model/break_response.dart';
import 'package:kommuno/features/break/data/repository/break_repo.dart';
import 'package:kommuno/features/in_sights/cubit/in_sights_cubit/in_sights_cubit.dart';
import 'package:kommuno/features/in_sights/data/enum/in_sights_date_enum.dart';
import 'package:kommuno/features/in_sights/data/repository/in_sights_repo.dart';

part 'break_state.dart';

class BreakCubit extends Cubit<BreakState> {
  BreakCubit() : super(const BreakInitial());

  final _breakRepo = BreakRepo();

  final breakReasonList = ["Lunch", "Meeting", "Tea", "Training"];

  Timer? _timer;

  @override
  Future<void> close() async {
    _timer?.cancel();
    super.close();
  }


  Future<void> getBreakDetails({bool isLoading = true}) async {
  try {
    if (isLoading) {
      emit(const BreakLoadingState());
    } else {
      AppLoadingIndicator.showLoadingIndicator();
    }
    final res = await _breakRepo.getBreakDetails();

    if (res.isSuccess) {
      final breakResponse = BreakResponseModel.fromJson(res.data);
      
      final isOnBreak = breakResponse.breakStatus == 4;
      
      if (state is BreakSuccessState) {
        emit((state as BreakSuccessState).copyWith(
          breakResponseModel: breakResponse,
          isOnBreak: isOnBreak, 
        ));
      } else {
        emit(BreakSuccessState(
          breakResponseModel: breakResponse,
          isOnBreak: isOnBreak,  
        ));
      }
      
      // THEN: Start the timer (it will now read from the correct state)
      _startTimer(isOnBreak: isOnBreak);
    } else {
      if (isLoading) {
        emit(const BreakErrorState());
      }
      FToastManager().showToast(message: res.message);
    }
  } on AppDioException catch (e) {
    if (isLoading) {
      emit(const BreakErrorState());
    }
    FToastManager().showToast(message: e.message);
  } catch (e, s) {
    if (isLoading) {
      emit(const BreakErrorState());
    }
    FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.somethingWentWrong);
    debugPrint("BreakCubit $e");
    debugPrint("$s");
  }
  if (!isLoading) {
    AppLoadingIndicator.dismissLoadingIndicator();
  }
}

  Future<void> breakIn({required BreakInRequestModel breakInRequestData,required BuildContext context,}) async {
    try {
      AppLoadingIndicator.showLoadingIndicator();
      
      UserDetailsModel? user;

        final userDetailsCubit = context.read<UserDetailsCubit>();
       int waitingSeconds = userDetailsCubit.stopWaitingTimer();
       debugPrint(" breakIn waitingSeconds: $waitingSeconds");

        user = userDetailsCubit.userDetailsModel;
        await ActivityHelperRepo().updateAgentActivityTime(
      smeId: user.smeId,
      agentId: user.agentId ?? 0,
      time: waitingSeconds,
      status: "Waiting",
    );

      final res = await _breakRepo.breakIn(breakInRequestData: breakInRequestData);


      FToastManager().showToast(message: res.message);


      if (res.isSuccess) {
        print("✔ Break In API SUCCESS: ${res.data}");

        getBreakDetails(isLoading: false);
      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.somethingWentWrong);
      debugPrint("BreakCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }

  Future<void> breakOut({required BreakOutRequestModel breakOutRequestData,required BuildContext context}) async {
    try {
      AppLoadingIndicator.showLoadingIndicator();
              final userDetailsCubit = context.read<UserDetailsCubit>();

      final res = await _breakRepo.breakOut(breakOutRequestData: breakOutRequestData);
      FToastManager().showToast(message: res.message);
      if (res.isSuccess) {

      userDetailsCubit.startWaitingTimer(); 
        getBreakDetails(isLoading: false);

final user = UserLoginInfoManager.userLoginInfoModel;
  if (user != null) {
    await _breakRepo.updateReadyToTakeCall(
      agentId: user.userId,
    );
  }

 final userDetails = userDetailsCubit.userDetailsModel;

      final insightsCubit = InSightsCubit.safeInstance;
     
       await insightsCubit.getInSights(
        smeId: userDetails.smeId,
        isLoading: false,
        inSightsDateEnum: InSightsDateEnum.today,
      );

      final insightsState = insightsCubit.state;
      if (insightsState is InSightsSuccessState) {
        userDetailsCubit.setTodayLunchHours(
          insightsState.insightsResponse.lunchHours ?? 0,
        );
      }

      }
    } on AppDioException catch (e) {
      FToastManager().showToast(message: e.message);
    } catch (e, s) {
      FToastManager().showToast(message: AppLocalizations.of(AppKeys.navigatorKey.currentContext!)!.somethingWentWrong);
      debugPrint("BreakCubit $e");
      debugPrint("$s");
    }
    AppLoadingIndicator.dismissLoadingIndicator();
  }

  Future<void> _startTimer({required bool isOnBreak,}) async {

    if (state is BreakSuccessState) {
      BreakSuccessState currentState = state as BreakSuccessState;
      if (currentState.breakResponseModel.status != 0) {
        _timer?.cancel();
        int breakTime = 0;
        if (isOnBreak && currentState.breakResponseModel.breaks.isNotEmpty) {
          breakTime = _getTimeSinceLastBreak(
              breakInStr: currentState.breakResponseModel.breaks.firstOrNull?.breakOutStr == null
                  ? currentState.breakResponseModel.breaks.firstOrNull?.breakInStr
                  : null);
        }
        _timer = Timer.periodic(
          
          const Duration(seconds: 1),
          (time) {

            currentState = state as BreakSuccessState;

            emit(
              currentState.copyWith(
                breakResponseModel: currentState.breakResponseModel
                    .copyWith(totalActiveTime: isOnBreak ? null : (currentState.breakResponseModel.totalActiveTime ?? 0) + 1),
                breakTime: isOnBreak ? breakTime++ : 0,
                isOnBreak: isOnBreak,
              ),
            );
          },
        );
      }
    }
  }

  int _getTimeSinceLastBreak({String? breakInStr}) {
    if (breakInStr != null) {
      try {
        final breakInDate = DateUtility.getTimeSinceLastBreak(date: breakInStr);
        final now = DateTime.now().toUtc();
        final differenceInSeconds = now.difference(breakInDate);
        return differenceInSeconds.inSeconds;
      } catch (e, s) {
        debugPrint('Error parsing date: $e');
        debugPrint("$s");
        return 0;
      }
    }
    return 0;
  }
}
