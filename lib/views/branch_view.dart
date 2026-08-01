import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/swipe_back.dart';
import 'package:study_gram/models/branch_db.dart';

class BranchView extends StatelessWidget {
  final String selectedCourse;
  final VoidCallback onBack;
  final Function(String) onBranchSelected;

  const BranchView({
    super.key,
    required this.selectedCourse,
    required this.onBack,
    required this.onBranchSelected,
  });

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Could not open the website."),
            backgroundColor: AppColors.redDanger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchSubjectsMap = getBranchSubjectsDbForCourse(selectedCourse);
    final branchInfoMap = getBranchInfoDbForCourse(selectedCourse);
    final branches = branchSubjectsMap.keys.toList();

    final List<IconData> icons = [
      Icons.laptop_chromebook_rounded,
      Icons.psychology_rounded,
      Icons.build_circle_outlined,
      Icons.settings_outlined,
      Icons.bolt_rounded,
      Icons.cell_tower_rounded,
      Icons.security_rounded,
      Icons.biotech_rounded,
    ];

    final List<Color> colors = [
      AppColors.primaryLight,
      AppColors.accent,
      AppColors.tealAccent,
      AppColors.blueInfo,
      Colors.deepPurpleAccent,
      Colors.orangeAccent,
      Colors.indigoAccent,
      Colors.pinkAccent,
    ];

    return SwipeBackWrapper(
      child: Scaffold(
        backgroundColor: AppColors.bgMain,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Bar ──────────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onBack,
                      icon: Icon(Icons.arrow_back_rounded,
                          color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$selectedCourse Courses",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          Text(
                            "Tap a course branch to explore subjects",
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // ── Branch List ───────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branchKey = branches[index];
                    final info = branchInfoMap[branchKey];
                    final color = colors[index % colors.length];
                    final icon  = icons[index % icons.length];
                    final subjectCount =
                        branchSubjectsMap[branchKey]?.length ?? 0;

                    return _BranchCard(
                      branchKey: branchKey,
                      info: info,
                      color: color,
                      icon: icon,
                      subjectCount: subjectCount,
                      onTap: () => onBranchSelected(branchKey),
                      onWebsiteTap: info != null
                          ? () => _openUrl(context, info.url)
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Branch Card Widget ────────────────────────────────────────────────────────
class _BranchCard extends StatelessWidget {
  final String branchKey;
  final BranchInfo? info;
  final Color color;
  final IconData icon;
  final int subjectCount;
  final VoidCallback onTap;
  final VoidCallback? onWebsiteTap;

  const _BranchCard({
    required this.branchKey,
    required this.info,
    required this.color,
    required this.icon,
    required this.subjectCount,
    required this.onTap,
    this.onWebsiteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderCard),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              SizedBox(width: 14),
              Expanded(
                child: Text(
                  info?.degree ?? branchKey,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted,
                size: 13,
              ),
            ],
          ),
        ),
        
      ),
    );
  }
}


