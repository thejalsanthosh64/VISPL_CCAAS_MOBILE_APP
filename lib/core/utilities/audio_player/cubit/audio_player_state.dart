part of 'audio_player_cubit.dart';

enum AudioPlayerStateEnum {
  initial,
  loading,
  loaded,
  error,
}

class AudioPlayerState extends Equatable {
  const AudioPlayerState({
    this.duration = Duration.zero,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.audioPlayerStateEnum = AudioPlayerStateEnum.initial,
  });

  final bool isPlaying;

  final Duration duration;

  final Duration position;

  final AudioPlayerStateEnum audioPlayerStateEnum;

  AudioPlayerState copyWith({
    bool? isPlaying,
    Duration? duration,
    Duration? position,
    AudioPlayerStateEnum? audioPlayerStateEnum,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      duration: duration ?? this.duration,
      position: position ?? this.position,
      audioPlayerStateEnum: audioPlayerStateEnum ?? this.audioPlayerStateEnum,
    );
  }

  @override
  List<Object?> get props =>
      [duration, isPlaying, position, audioPlayerStateEnum];
}
