import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

enum ButtonState {
  paused,
  playing,
}

class AudioManager {
  StreamSubscription? _playerStateSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _bufferedPositionSubscription;
  StreamSubscription? _durationSubscription;

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  final String url;

  late AudioPlayer _audioPlayer;

  AudioManager(this.url) {
    _init();
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    if (url.startsWith('http')) {
      await _audioPlayer.setUrl(url);
    } else {
      await _audioPlayer.setFilePath(url);
    }
    _playerStateSubscription = _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (![ProcessingState.loading, ProcessingState.buffering].contains(processingState)) {
        if (!isPlaying) {
          buttonNotifier.value = ButtonState.paused;
        } else if (processingState != ProcessingState.completed) {
          buttonNotifier.value = ButtonState.playing;
        } else if (processingState == ProcessingState.completed) {
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.pause();
        }
      }
    });

    _positionSubscription = _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _bufferedPositionSubscription = _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _durationSubscription = _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _playerStateSubscription?.cancel();
    _positionSubscription?.cancel();
    _bufferedPositionSubscription?.cancel();
    _durationSubscription?.cancel();
    _audioPlayer.dispose();
    progressNotifier.dispose();
    buttonNotifier.dispose();
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });

  final Duration current;
  final Duration buffered;
  final Duration total;
}
