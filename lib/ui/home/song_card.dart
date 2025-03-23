import 'package:capoo_tunes/data/model/song.dart';
import 'package:capoo_tunes/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SongCard extends StatefulWidget {
  final Song song;
  final Function? onTap;
  const SongCard({super.key, required this.song, this.onTap});

  @override
  State<SongCard> createState() => _SongCardState();
}

class _SongCardState extends State<SongCard> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {widget.onTap!(widget.song)},
      onTapDown: (_) => setState(() => _scale = 0.3),
      onTapUp: (_) => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.only(right: 14),
          child: SizedBox(
            width: 149,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 147,
                  height: 205,
                  decoration: BoxDecoration(),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // Cắt hình ảnh theo borderRadius
                            child: FadeInImage.assetNetwork(
                              height: 185,
                              width: 147,
                              placeholder: 'assets/images/music-icon.png',
                              image: widget.song.image,
                              fit: BoxFit.cover,
                              imageErrorBuilder:
                                  (context, error, stackTrace) => Image.asset(
                                    'assets/images/music-icon.png',
                                    fit: BoxFit.cover,
                                    height: 185,
                                    width: 147,
                                  ),
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                      Positioned(
                        right: 11,
                        bottom: 6,
                        child: Container(
                          height: 29,
                          width: 29,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.grey2,
                          ),
                          child: Icon(FontAwesomeIcons.play, size: 14),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  widget.song.title,
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  widget.song.artist,
                  style: TextStyle(color: AppColors.secondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
