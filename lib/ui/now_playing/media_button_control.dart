import 'package:flutter/material.dart';

class MediaButtonControl extends StatefulWidget {
  const MediaButtonControl({
    super.key,
    required this.function,
    required this.icon,
    required this.color,
    required this.size,
  });
  final Function()? function;
  final IconData icon;
  final Color color;
  final double size;
  @override
  State<MediaButtonControl> createState() => _MediaButtonControlState();
}

class _MediaButtonControlState extends State<MediaButtonControl>
    with SingleTickerProviderStateMixin {
  late AnimationController _buttonAnimationController;

  @override
  void initState() {
    _buttonAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: GestureDetector(
        onTapDown: (_) {
          _buttonAnimationController.forward();
        },
        onTapUp: (_) {
          _buttonAnimationController.reverse();
          if (widget.function != null) {
            widget.function!();
          }
        },
        onTapCancel: () {
          _buttonAnimationController.reverse();
        },
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 0.9).animate(
            CurvedAnimation(
              parent: _buttonAnimationController,
              curve: Curves.easeInOut,
            ),
          ),
          child: Icon(widget.icon, color: widget.color, size: widget.size),
        ),
      ),
    );
  }
}
