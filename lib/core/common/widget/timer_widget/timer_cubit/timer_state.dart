part of 'timer_cubit.dart';

final class TimerState extends Equatable {
  const TimerState({required this.durationInSec});

  final int durationInSec;

  @override
  List<Object?> get props => [durationInSec];
}
