import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:kommuno/core/common/app_constant.dart';
import 'package:kommuno/core/common/app_theme/app_theme.dart';
import 'package:kommuno/core/utilities/audio_player_2/manager/audio_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppAudioPlayer1 extends StatefulWidget {
  const AppAudioPlayer1({super.key, required this.audioUrl});

  final String audioUrl;

  @override
  State<AppAudioPlayer1> createState() => _AppAudioPlayerState();
}

class _AppAudioPlayerState extends State<AppAudioPlayer1> {
  late AudioManager audioManager;

  @override
  void initState() {
    super.initState();
    audioManager = AudioManager(widget.audioUrl);
    audioManager.play();
  }

  @override
  void didUpdateWidget(covariant AppAudioPlayer1 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.audioUrl != widget.audioUrl) {
      audioManager.dispose();
      audioManager = AudioManager(widget.audioUrl);
    }
  }

  @override
  void dispose() {
    audioManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: SingleChildScrollView(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstant.kBodyHorizontalPadding),
              child: ValueListenableBuilder<ProgressBarState>(
                valueListenable: audioManager.progressNotifier,
                builder: (_, value, __) {
                  return ProgressBar(
                    progress: value.current,
                    buffered: value.buffered,
                    total: value.total,
                    onSeek: audioManager.seek,
                    thumbColor: AppColors.appColor,
                    baseBarColor: AppColors.appColor.withValues(alpha: 0.2),
                    progressBarColor: AppColors.appColor,
                  );
                },
              ),
            ),
            _kSized10,
            Center(
              child: ValueListenableBuilder<ButtonState>(
                valueListenable: audioManager.buttonNotifier,
                builder: (_, value, __) {
                  final isPlaying = value == ButtonState.playing;
                  return InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {
                      if (isPlaying) {
                        audioManager.pause();
                      } else {
                        audioManager.play();
                      }
                    },
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.appColor,
                      child: Icon(
                        isPlaying ? Icons.pause_outlined : Icons.play_arrow_rounded,
                        color: AppColors.white,
                        size: 25,
                      ),
                    ),
                  );
                },
              ),
            ),
            _kSized10,
          ],
        ),
      ),
    );
  }

  SizedBox get _kSized10 => const SizedBox(height: 10, width: 10);

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
