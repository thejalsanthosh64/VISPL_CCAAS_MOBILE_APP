import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  TimerCubit() : super(const TimerState(durationInSec: 0));

  Timer? _timer;

  FutureOr<void> timerStartEvent({required int durationInSec}) async {
    emit(TimerState(durationInSec: durationInSec));
    final completer = Completer<void>();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final duration = state.durationInSec - 1;
        if (duration == 0) {
          completer.complete();
          _timer?.cancel();
          _timer = null;
        }
        emit(TimerState(durationInSec: duration));
      },
    );
    return await completer.future;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
