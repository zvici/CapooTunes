import 'package:capoo_tunes/utils/app_colors.dart';
import 'package:capoo_tunes/widgets/playing_now.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  bool isPlaying = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isPlaying) PlayingNow(),
          Container(
            color: AppColors.secondaryBackground,
            child: SafeArea(
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(FontAwesomeIcons.house, "Home", 0),
                      _buildNavItem(FontAwesomeIcons.solidCompass, "Search", 1),
                      _buildNavItem(FontAwesomeIcons.solidHeart, "Profile", 2),
                      _buildNavItem(FontAwesomeIcons.solidUser, "Settings", 3),
                    ],
                  ),
                  AnimatedPositioned(
                    top: 0,
                    left:
                        MediaQuery.of(context).size.width /
                        4 *
                        widget.currentIndex,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.fastEaseInToSlowEaseOut,
                    child: Container(
                      height: 3,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          color: AppColors.secondaryBackground,
          child: Icon(
            icon,
            color:
                widget.currentIndex == index
                    ? AppColors.primary
                    : AppColors.grey,
          ),
        ),
      ),
    );
  }
}
