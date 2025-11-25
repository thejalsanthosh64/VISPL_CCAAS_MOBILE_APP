import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/common/widget/app_avatar.dart';
import 'package:kommuno/core/common/widget/empty_error_widget.dart';
import 'package:kommuno/core/common/widget/loading_indicator.dart';
import 'package:kommuno/core/utilities/audio_player/cubit/audio_player_cubit.dart';
import 'package:kommuno/core/l10n/app_localizations.dart';

class AppAudioPlayer extends StatelessWidget {
  const AppAudioPlayer({super.key, required this.audioUrl});

  final String audioUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioPlayerCubit(),
      child: _AppAudioPlayerState(audioUrl: audioUrl),
    );
  }
}

class _AppAudioPlayerState extends StatelessWidget {
  final String audioUrl;

  const _AppAudioPlayerState({required this.audioUrl});

  AudioPlayerCubit _audioPlayerCubit(BuildContext context) =>
      context.read<AudioPlayerCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
        builder: (context, state) {
          switch (state.audioPlayerStateEnum) {
            case AudioPlayerStateEnum.initial:
              Future.delayed(
                Duration.zero,
                () {
                  if (context.mounted) {
                    _audioPlayerCubit(context).initAudio(audioUrl: audioUrl);
                  }
                },
              );
              return const SizedBox();
            case AudioPlayerStateEnum.loading:
              return const AppLoadingIndicator();
            case AudioPlayerStateEnum.error:
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Spacer(),
                      _closeButton(context: context),
                    ],
                  ),
                  EmptyErrorWidget(
                    text: AppLocalizations.of(context)!.somethingWentWrong,
                    onTap: () {
                      _audioPlayerCubit(context).initAudio(audioUrl: audioUrl);
                    },
                  ),
                ],
              );
            case AudioPlayerStateEnum.loaded:
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Text(
                            AppLocalizations.of(context)!.audioPlayer,
                            style: AppTextStyle.black23,
                          ),
                        ),
                        _closeButton(context: context),
                      ],
                    ),
                    _kSized10,
                    Slider(
                      min: 0,
                      max: state.duration.inSeconds.toDouble(),
                      value: state.position.inSeconds.toDouble(),
                      onChanged: (value) {
                        final newPosition = Duration(seconds: value.toInt());
                        _audioPlayerCubit(context)
                            .audioPlayer
                            .seek(newPosition);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstant.kBodyHorizontalPadding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(state.position)),
                          Text(_formatDuration(state.duration)),
                        ],
                      ),
                    ),
                    _kSized10,
                    InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () {
                        _audioPlayerCubit(context)
                            .onPlayPause(isPlaying: state.isPlaying);
                      },
                      child: AppAvatar(
                        radius: 15,
                        backgroundColor: AppColors.appColor,
                        child: Icon(
                          state.isPlaying
                              ? Icons.pause_outlined
                              : Icons.play_arrow_rounded,
                          color: AppColors.white,
                          size: 25,
                        ),
                      ),
                    ),
                    _kSized10
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  SizedBox get _kSized10 => const SizedBox(height: 10, width: 10);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [
      if (hours > 0) hours,
      minutes,
      seconds,
    ].map((e) => e.toString()).join(':');
  }

  Widget _closeButton({required BuildContext context}) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      iconSize: 40,
      color: AppColors.black,
      icon: const Icon(Icons.highlight_off_rounded),
    );
  }
}
