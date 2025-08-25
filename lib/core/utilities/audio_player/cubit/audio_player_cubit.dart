import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:equatable/equatable.dart';
import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_minimal/return_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

part 'audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit() : super(const AudioPlayerState()) {
    audioPlayer.onDurationChanged.listen((newDuration) {
      if (state.audioPlayerStateEnum == AudioPlayerStateEnum.loaded &&
          !isClosed) {
        emit(state.copyWith(duration: newDuration));
      }
    });

    audioPlayer.onPositionChanged.listen((newPosition) {
      if (state.audioPlayerStateEnum == AudioPlayerStateEnum.loaded &&
          !isClosed) {
        emit(state.copyWith(position: newPosition));
      }
    });
  }

  @override
  Future<void> close() async {
    audioPlayer.dispose();
    super.close();
  }

  final audioPlayer = AudioPlayer();

  void initAudio({required String audioUrl}) async {
    try {
      emit(state.copyWith(audioPlayerStateEnum: AudioPlayerStateEnum.loading));
      await audioPlayer.play(UrlSource(audioUrl));
      emit(state.copyWith(
        audioPlayerStateEnum: AudioPlayerStateEnum.loaded,
        duration: await audioPlayer.getDuration(),
        position: await audioPlayer.getCurrentPosition(),
        isPlaying: true,
      ));
    } catch (e) {
      try {
        final filePath = await _downloadAndSaveAudio(audioUrl);
        final mp3Path = await _convertToMp3(filePath);
        await audioPlayer.play(DeviceFileSource(mp3Path));
        emit(state.copyWith(
          audioPlayerStateEnum: AudioPlayerStateEnum.loaded,
          duration: await audioPlayer.getDuration(),
          position: await audioPlayer.getCurrentPosition(),
          isPlaying: true,
        ));
      } catch (e) {
        emit(state.copyWith(audioPlayerStateEnum: AudioPlayerStateEnum.error));
      }
    }
  }

  void onPlayPause({required bool isPlaying}) async {
    if (isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.resume();
    }
    emit(state.copyWith(isPlaying: !isPlaying));
  }

  Future<String> _downloadAndSaveAudio(String url) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/temp_audio.wav';
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      final response = await HttpClient().getUrl(Uri.parse(url));
      final bytes = await response
          .close()
          .then((res) => res.fold<List<int>>([], (b, data) => b..addAll(data)));
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _convertToMp3(String filePath) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final mp3Path = '${tempDir.path}/temp_audio.mp3';
      final file = File(mp3Path);
      if (await file.exists()) {
        await file.delete();
      }
      final ffmpegCommand =
          '-i $filePath -codec:a libmp3lame -qscale:a 2 -threads 1 $mp3Path';
      final session = await FFmpegKit.execute(ffmpegCommand);
      final returnCode = await session.getReturnCode();
      if (ReturnCode.isSuccess(returnCode)) {
        return mp3Path;
      } else {
        throw '';
      }
    } catch (e) {
      rethrow;
    }
  }
}
