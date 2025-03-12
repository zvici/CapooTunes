import 'dart:async';

import 'package:capoo_tunes/data/model/song.dart';
import 'package:capoo_tunes/data/repository/repository.dart';

class MusicAppViewModel {
  StreamController<List<Song>> songStream = StreamController();
  
  void loadSong() {
    final repository = DefaultRepository();
    repository.loadData().then((songs) {
      songStream.add(songs!);
    });
  }
}
