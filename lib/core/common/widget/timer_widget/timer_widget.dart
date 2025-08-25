import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';

import 'timer_cubit/timer_cubit.dart';

/// Key is required please provide [restartTimer] value to key and Screen Name
/// e.g ValueKey<String>("ScreenName_TimerWidget_${restartTimer}")
class TimerWidget extends StatelessWidget {
  const TimerWidget({
    required super.key,
    required this.onComplete,
    required this.durationInSec,
    required this.restartTimer,
  });

  final void Function() onComplete;
  final int durationInSec;
  final bool restartTimer;

  @override
  Widget build(BuildContext context) {
    final timerCubit = TimerCubit();
    if (restartTimer) {
      timerCubit.timerStartEvent(durationInSec: durationInSec);
    }
    return BlocProvider(
      create: (__) => timerCubit,
      child: _TimerWidgetState(onComplete: onComplete),
    );
  }
}

class _TimerWidgetState extends StatelessWidget {
  const _TimerWidgetState({required this.onComplete});

  final void Function() onComplete;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerCubit, TimerState>(
      listener: (__, state) {
        if (state.durationInSec == 0) {
          onComplete();
        }
      },
      builder: (__, state) {
        return Text(_formattedTime(timeInSecond: state.durationInSec),
            style: AppTextStyle.appColor18);
      },
    );
  }

  String _formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    return "${"$min".padLeft(2, "0")} : ${"$sec".padLeft(2, "0")}";
  }
}
