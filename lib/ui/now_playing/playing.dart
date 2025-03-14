import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:capoo_tunes/data/model/song.dart';
import 'package:capoo_tunes/ui/now_playing/audio_play_manager.dart';
import 'package:capoo_tunes/ui/now_playing/media_button_control.dart';
import 'package:capoo_tunes/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.songs, required this.playingSong});
  final List<Song> songs;
  final Song playingSong;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(songs: songs, playingSong: playingSong);
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({
    super.key,
    required this.songs,
    required this.playingSong,
  });
  final List<Song> songs;
  final Song playingSong;

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimationController;
  late AudioPlayManager _audioPlayManager;

  @override
  void initState() {
    super.initState();
    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    _audioPlayManager = AudioPlayManager(songUrl: widget.playingSong.source);
    _audioPlayManager.init();
  }

  @override
  void dispose() {
    _imageAnimationController.dispose();
    _audioPlayManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;

    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Now Playing',
          style: TextStyle(color: AppColors.textColor),
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.more_vert,
            color: AppColors.textColor,
            size: 24,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
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
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                  ),
                  child: ClipOval(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        FadeInImage.assetNetwork(
                          placeholder: 'assets/images/music-icon.png',
                          image: widget.playingSong.image,
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
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 28, right: 28),
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.playingSong.title,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.playingSong.artist,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textColor,
                          ),
                        ),
                      ],
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
                padding: const EdgeInsets.only(top: 32, left: 28, right: 28),
                child: _buildProgressBar(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 28, right: 28),
                child: _buildMediaButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaButton() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          MediaButtonControl(
            function: () {},
            icon: FontAwesomeIcons.shuffle,
            color: AppColors.textColor,
            size: 20,
          ),
          MediaButtonControl(
            function: () {},
            icon: FontAwesomeIcons.backwardStep,
            color: AppColors.textColor,
            size: 32,
          ),
          _buildPlayButton(),
          MediaButtonControl(
            function: () {},
            icon: FontAwesomeIcons.forwardStep,
            color: AppColors.textColor,
            size: 32,
          ),
          MediaButtonControl(
            function: () {},
            icon: FontAwesomeIcons.repeat,
            color: AppColors.textColor,
            size: 20,
          ),
        ],
      ),
    );
  }

  StreamBuilder<DurationState> _buildProgressBar() {
    return StreamBuilder<DurationState>(
      stream: _audioPlayManager.durationState,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;
        return ProgressBar(
          progress: progress,
          total: total,
          buffered: buffered,
          onSeek: _audioPlayManager.player.seek,
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
      stream: _audioPlayManager.player.playerStateStream,
      builder: (context, snapshot) {
        final playState = snapshot.data;
        final processingState = playState?.processingState;
        final playing = playState?.playing;
        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: EdgeInsets.all(8),
            width: 64,
            height: 64,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          _imageAnimationController.stop();
          return MediaButtonControl(
            function: () {
              _audioPlayManager.player.play();
            },
            icon: FontAwesomeIcons.solidCirclePlay,
            color: AppColors.primary,
            size: 64,
          );
        } else if (processingState != ProcessingState.completed) {
          _imageAnimationController.repeat();
          return MediaButtonControl(
            function: () {
              _audioPlayManager.player.pause();
            },
            icon: FontAwesomeIcons.solidCirclePause,
            color: AppColors.primary,
            size: 64,
          );
        } else {
          return MediaButtonControl(
            function: () {
              _audioPlayManager.player.seek(Duration.zero);
              _audioPlayManager.player.play();
            },
            icon: FontAwesomeIcons.solidCirclePlay,
            color: AppColors.primary,
            size: 64,
          );
        }
      },
    );
  }
}
