part of 'break_cubit.dart';

abstract class BreakState extends Equatable {
  const BreakState();
}

final class BreakInitial extends BreakState {
  const BreakInitial();

  @override
  List<Object> get props => [];
}

final class BreakLoadingState extends BreakState {
  const BreakLoadingState();

  @override
  List<Object> get props => [];
}

final class BreakErrorState extends BreakState {
  const BreakErrorState();

  @override
  List<Object> get props => [];
}

final class BreakSuccessState extends BreakState {
  const BreakSuccessState({
    required this.breakResponseModel,
    this.breakTime = 0,
    this.isOnBreak = false,
  });

  final BreakResponseModel breakResponseModel;
  final int breakTime;
  final bool isOnBreak;

  BreakSuccessState copyWith({
    BreakResponseModel? breakResponseModel,
    int? breakTime,
    bool? isOnBreak,
  }) {
    return BreakSuccessState(
      breakResponseModel: breakResponseModel ?? this.breakResponseModel,
      breakTime: breakTime ?? this.breakTime,
      isOnBreak: isOnBreak ?? this.isOnBreak,
    );
  }

  @override
  List<Object?> get props => [breakResponseModel, breakTime, isOnBreak];
}
