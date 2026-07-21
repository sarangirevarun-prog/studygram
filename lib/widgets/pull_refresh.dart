import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';

/// A reusable pull-to-refresh wrapper.
///
/// Wrap any scrollable child (ListView, SingleChildScrollView, etc.) with this
/// widget to add a pull-to-refresh gesture on that screen.
///
/// If [onRefresh] is null, a default 800ms cosmetic delay is used —
/// useful for screens that just need the UI gesture without backend data.
class PullRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;

  const PullRefresh({
    super.key,
    required this.child,
    this.onRefresh,
  });

  Future<void> _defaultRefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh ?? _defaultRefresh,
      color: AppColors.primaryLight,
      backgroundColor: AppColors.bgCard,
      strokeWidth: 2.5,
      displacement: 50,
      child: child,
    );
  }
}
