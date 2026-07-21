import 'package:flutter/material.dart';

/// Wraps any widget with a horizontal swipe-right gesture to pop the Navigator.
/// Only triggers when the swipe starts from the left edge of the screen (within 40px)
/// to match the native system swipe-back behavior.
class SwipeBackWrapper extends StatefulWidget {
  final Widget child;
  const SwipeBackWrapper({super.key, required this.child});

  @override
  State<SwipeBackWrapper> createState() => _SwipeBackWrapperState();
}

class _SwipeBackWrapperState extends State<SwipeBackWrapper> {
  double _startX = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (details) {
        _startX = details.localPosition.dx;
      },
      onHorizontalDragEnd: (details) {
        // Only trigger go back if the drag starts from the left edge of the screen
        if (_startX <= 40.0) {
          if ((details.primaryVelocity ?? 0) > 250) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          }
        }
      },
      child: widget.child,
    );
  }
}
