import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:capoo_tunes/ui/now_playing/audio_controller.dart';
import 'package:capoo_tunes/ui/now_playing/media_button_control.dart';
import 'package:capoo_tunes/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';

class PlayingBottomSheet extends StatefulWidget {
  const PlayingBottomSheet({super.key});

  @override
  State<PlayingBottomSheet> createState() => _PlayingBottomSheetState();
}

class _PlayingBottomSheetState extends State<PlayingBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  final AudioController controller = Get.put(AudioController());

  @override
  void initState() {
    super.initState();
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;

    return Obx(() {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: controller.dominantColor.value,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 4,
                    width: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(height: 32),
                  RotationTransition(
                    turns: Tween(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(_imageAnimationController),
                    child: Container(
                      width: screenWidth - delta,
                      height: screenWidth - delta,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            FadeInImage.assetNetwork(
                              placeholder: 'assets/images/music-icon.png',
                              image: controller.currentSong.value?.image ?? '',
                              width: screenWidth - delta,
                              height: screenWidth - delta,
                              fit: BoxFit.cover,
                              imageErrorBuilder:
                                  (context, error, stackTrace) => Image.asset(
                                    'assets/images/music-icon.png',
                                    width: screenWidth - delta,
                                    height: screenWidth - delta,
                                    fit: BoxFit.cover,
                                  ),
                            ),
                            Container(
                              width: (screenWidth - delta) * 0.2,
                              height: (screenWidth - delta) * 0.2,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.background,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
                      left: 28,
                      right: 28,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.share,
                            color: AppColors.textColor,
                            size: 24,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                                child: Marquee(
                                  text:
                                      controller.currentSong.value?.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  scrollAxis: Axis.horizontal,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  blankSpace: 50.0,
                                  velocity: 30.0,
                                  pauseAfterRound: Duration(seconds: 1),
                                  startPadding: 10.0,
                                  accelerationDuration: Duration(seconds: 1),
                                  accelerationCurve: Curves.linear,
                                  decelerationDuration: Duration(
                                    milliseconds: 500,
                                  ),
                                  decelerationCurve: Curves.easeOut,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.currentSong.value?.artist ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textColor,
                                ),
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite_border,
                            color: AppColors.textColor,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 58,
                      left: 28,
                      right: 28,
                    ),
                    child: _buildProgressBar(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 28,
                      right: 28,
                    ),
                    child: _buildMediaButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildMediaButton() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
            function: null,
            icon: FontAwesomeIcons.shuffle,
            color: AppColors.textColor.withValues(alpha: true ? 1 : 0.3),
            size: 20,
          ),
          MediaButtonControl(
            function: null,
            icon: FontAwesomeIcons.backwardStep,
            color: AppColors.textColor,
            size: 32,
          ),
          _buildPlayButton(),
          MediaButtonControl(
            function: null,
            icon: FontAwesomeIcons.forwardStep,
            color: AppColors.textColor,
            size: 32,
          ),
          _buildRepeatButton(),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _buildProgressBar() {
    return StreamBuilder<DurationState>(
      stream:
          controller.durationState.stream
              .where((event) => event != null)
              .cast<DurationState>(),
      builder: (context, snapshot) {
        final durationState = controller.durationState.value;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          total: total,
          buffered: buffered,
          onSeek: controller.player.seek,
          barHeight: 4,
          barCapShape: BarCapShape.round,
          baseBarColor: Colors.black,
          progressBarColor: AppColors.secondary,
          bufferedBarColor: AppColors.secondary.withValues(alpha: 0.4),
          thumbColor: AppColors.secondary,
          thumbRadius: 7,
          timeLabelTextStyle: TextStyle(fontSize: 14),
          timeLabelPadding: 4,
        );
      },
    );
  }

  StreamBuilder<PlayerState> _buildPlayButton() {
    return StreamBuilder(
      stream: controller.player.playerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: EdgeInsets.all(8),
            width: 50,
            height: 50,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          _imageAnimationController.stop();
          return MediaButtonControl(
            function: () {
              controller.resumeSong();
            },
            icon: FontAwesomeIcons.solidCirclePlay,
            color: AppColors.primary,
            size: 64,
          );
        } else if (processingState != ProcessingState.completed) {
          _imageAnimationController.repeat();
          return MediaButtonControl(
            function: () {
              controller.pauseSong();
            },
            icon: FontAwesomeIcons.solidCirclePause,
            color: AppColors.primary,
            size: 64,
          );
        } else {
          return MediaButtonControl(
            function: () {
              // _audioPlayManager.player.seek(Duration.zero);
              // controller.playSong();
            },
            icon: FontAwesomeIcons.solidCirclePlay,
            color: AppColors.primary,
            size: 64,
          );
        }
      },
    );
  }

  Widget _buildRepeatButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        MediaButtonControl(
          function: null,
          icon: FontAwesomeIcons.repeat,
          color: AppColors.textColor.withValues(alpha: 0.3),
          size: 20,
        ),
      ],
    );
  }
}
