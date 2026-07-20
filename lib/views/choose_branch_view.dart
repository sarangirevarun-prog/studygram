import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/swipe_back_wrapper.dart';
import 'package:study_gram/models/quiz_question.dart';

class ChooseBranchView extends StatelessWidget {
  final String selectedCourse;
  final VoidCallback onBack;
  final Function(String) onBranchSelected;

  const ChooseBranchView({
    super.key,
    required this.selectedCourse,
    required this.onBack,
    required this.onBranchSelected,
  });

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
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
    final branches = branchSubjectsDb.keys.toList();

    final List<IconData> icons = [
      Icons.laptop_chromebook_rounded,
      Icons.build_circle_outlined,
      Icons.settings_outlined,
      Icons.bolt_rounded,
      Icons.cell_tower_rounded,
    ];

    final List<Color> colors = [
      AppColors.primaryLight,
      AppColors.accent,
      AppColors.tealAccent,
      AppColors.blueInfo,
      Colors.deepPurpleAccent,
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
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$selectedCourse Branches",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Text(
                            "Tap a branch to explore subjects",
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // ── Branch List ───────────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: branches.length,
                  itemBuilder: (context, index) {
                    final branchKey = branches[index];
                    final info = diplomaBranchInfoDb[branchKey];
                    final color = colors[index % colors.length];
                    final icon  = icons[index % icons.length];
                    final subjectCount =
                        branchSubjectsDb[branchKey]?.length ?? 0;

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
      margin: const EdgeInsets.only(bottom: 14),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header Row ────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          info?.degree ?? branchKey,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            _Chip(
                              label: info?.affiliation ?? "MSBTE",
                              color: color,
                            ),
                            const SizedBox(width: 6),
                            _Chip(
                              label: info?.duration ?? "3 Years",
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.textMuted,
                    size: 13,
                  ),
                ],
              ),

              // ── Description ───────────────────────────────────────────
              if (info?.description != null) ...[
                const SizedBox(height: 12),
                Text(
                  info!.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],

              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.borderCard),
              const SizedBox(height: 10),

              // ── Footer: Subjects count + Website link ─────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 14,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "$subjectCount Core Subjects",
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (info != null)
                    GestureDetector(
                      onTap: onWebsiteTap,
                      child: Row(
                        children: [
                          const Icon(
                            Icons.language_rounded,
                            size: 13,
                            color: AppColors.primaryLight,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            info!.website,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryLight,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Small Chip badge ─────────────────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
