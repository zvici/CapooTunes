import 'package:capoo_tunes/data/model/song.dart';
import 'package:capoo_tunes/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class AudioController extends GetxController {
  final AudioPlayer player = AudioPlayer();

  var playlist = <Song>[].obs;
  Rxn<Song> currentSong = Rxn<Song>();
  Rxn<DurationState> durationState = Rxn<DurationState>();
  Rxn<Color> dominantColor = Rxn<Color>();

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
  }

  void _setupListeners() {
    rxdart.Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
      player.positionStream,
      player.playbackEventStream,
      (position, playbackEvent) => DurationState(
        progress: position,
        buffered: playbackEvent.bufferedPosition,
        total: playbackEvent.duration,
      ),
    ).listen((state) {
      durationState.value = state;
    });
  }

  Future<void> playSong(Song song) async {
    if (currentSong.value?.source == song.source && player.playing) return;
    dominantColor.value = await getDominantColor(song.image);
    currentSong.value = song;
    await player.setUrl(song.source);
    player.play();
  }

  void pauseSong() {
    player.pause();
  }

  void stopSong() {
    player.stop();
  }

  void playNext() {
    if (playlist.isNotEmpty) {
      int index = playlist.indexWhere(
        (song) => song.source == currentSong.value?.source,
      );
      if (index != -1 && index < playlist.length - 1) {
        playSong(playlist[index + 1]);
      }
    }
  }

  void playPrevious() {
    if (playlist.isNotEmpty) {
      int index = playlist.indexWhere(
        (song) => song.source == currentSong.value?.source,
      );
      if (index > 0) {
        playSong(playlist[index - 1]);
      }
    }
  }

  void addSongToPlaylist(Song song) {
    playlist.add(song);
  }

  void removeSongFromPlaylist(Song song) {
    playlist.remove(song);
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}

class DurationState {
  DurationState({required this.progress, required this.buffered, this.total});

  final Duration progress;
  final Duration buffered;
  final Duration? total;
}

Future<Color> getDominantColor(String imageUrl) async {
  final paletteGenerator = await PaletteGenerator.fromImageProvider(
    NetworkImage(imageUrl),
  );
  Color selectedColor =
      paletteGenerator.dominantColor?.color ?? AppColors.background;
  return selectedColor;
}
