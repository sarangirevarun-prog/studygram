import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/widgets/pull_refresh.dart';
import 'package:study_gram/widgets/swipe_back.dart';

class UpdatesView extends StatelessWidget {
  final VoidCallback? onBack;

  const UpdatesView({
    super.key,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SwipeBackWrapper(
      child: ValueListenableBuilder<String>(
        valueListenable: AppStrings.languageNotifier,
        builder: (context, currentLang, _) {
          return Scaffold(
            backgroundColor: AppColors.bgMain,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 14),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (onBack != null) {
                              onBack!();
                            } else if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          },
                          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.centerLeft,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.campaign_rounded, color: AppColors.primaryLight, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          AppStrings.get('updates'),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PullRefresh(
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          const SizedBox(height: 120),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPale.withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.notifications_none_rounded,
                                      color: AppColors.primary,
                                      size: 56,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    "No New Updates",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "There are no active announcements or offers right now. Check back soon for new semester study materials!",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
