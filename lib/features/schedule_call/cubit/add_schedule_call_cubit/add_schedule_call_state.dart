part of 'add_schedule_call_cubit.dart';

abstract class AddScheduleCallState extends Equatable {
  const AddScheduleCallState();
}

final class AddSScheduleCallInitialState extends AddScheduleCallState {
  const AddSScheduleCallInitialState();

  @override
  List<Object?> get props => [];
}

final class AddSScheduleCallSuccessState extends AddScheduleCallState {
  const AddSScheduleCallSuccessState(
      {this.selectedDateTime, this.addScheduleCallRequestModel});

  final DateTime? selectedDateTime;

  final AddScheduleCallRequestModel? addScheduleCallRequestModel;

  AddSScheduleCallSuccessState copyWith(
      {DateTime? selectedDateTime,
      AddScheduleCallRequestModel? addScheduleCallRequestModel}) {
    return AddSScheduleCallSuccessState(
      selectedDateTime: selectedDateTime ?? this.selectedDateTime,
      addScheduleCallRequestModel:
          addScheduleCallRequestModel ?? this.addScheduleCallRequestModel,
    );
  }

  @override
  List<Object?> get props => [selectedDateTime, addScheduleCallRequestModel];
}
