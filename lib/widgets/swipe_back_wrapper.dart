import 'package:flutter/material.dart';

/// Wraps any widget with a horizontal swipe-right gesture to pop the Navigator.
/// Works on both web and mobile. The swipe threshold is 60px for responsiveness.
class SwipeBackWrapper extends StatelessWidget {
  final Widget child;
  const SwipeBackWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Swipe right → go back
      onHorizontalDragEnd: (details) {
        if ((details.primaryVelocity ?? 0) > 250) {
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        }
      },
      child: child,
    );
  }
}
