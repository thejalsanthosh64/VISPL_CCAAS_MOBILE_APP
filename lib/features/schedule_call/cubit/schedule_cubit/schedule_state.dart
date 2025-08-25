part of 'schedule_cubit.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
}

final class ScheduleInitialState extends ScheduleState {
  const ScheduleInitialState();

  @override
  List<Object> get props => [];
}

final class ScheduleLoadingState extends ScheduleState {
  const ScheduleLoadingState();

  @override
  List<Object> get props => [];
}

final class ScheduleErrorState extends ScheduleState {
  const ScheduleErrorState();

  @override
  List<Object> get props => [];
}

final class ScheduleSuccessState extends ScheduleState {
  const ScheduleSuccessState({
    required this.scheduleCallsResponseModel,
  });

  final ScheduleCallsResponseModel scheduleCallsResponseModel;

  ScheduleSuccessState copyWith(
      {ScheduleCallsResponseModel? scheduleCallsResponseModel}) {
    return ScheduleSuccessState(
        scheduleCallsResponseModel:
            scheduleCallsResponseModel ?? this.scheduleCallsResponseModel);
  }

  @override
  List<Object> get props => [scheduleCallsResponseModel];
}
