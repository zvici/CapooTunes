import 'package:capoo_tunes/ui/now_playing/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:get/get.dart';

class PlayingNow extends StatelessWidget {
  const PlayingNow({super.key});

  @override
  Widget build(BuildContext context) {
    final AudioController controller = Get.put(AudioController());
    return Obx(() {
      final song = controller.currentSong.value;
      if (song == null) return SizedBox();
      return Container(
        padding: EdgeInsets.all(10),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: controller.dominantColor.value,
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/music-icon.png',
                image: song.image,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                imageErrorBuilder:
                    (context, error, stackTrace) => Image.asset(
                      'assets/images/music-icon.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
              ),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  width: MediaQuery.of(context).size.width - 180,
                  child: Marquee(
                    text: song.title,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    blankSpace: MediaQuery.of(context).size.width - 180,
                  ),
                ),
                Text(
                  song.artist,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {
                if (controller.player.playing) {
                  controller.pauseSong();
                } else {
                  controller.playSong(song);
                }
              },
              icon: Icon(
                controller.player.playing
                    ? FontAwesomeIcons.pause
                    : FontAwesomeIcons.play,
              ),
            ),
            IconButton(
              onPressed: controller.playNext,
              icon: Icon(FontAwesomeIcons.forward),
            ),
          ],
        ),
      );
    });
  }
}
