import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/models/branch_db.dart';
import 'package:study_gram/widgets/ambient_orbs.dart';
import 'package:study_gram/widgets/pull_refresh.dart';
import 'package:study_gram/views/updates_view.dart';

class HomeView extends StatefulWidget {
  final ValueNotifier<String> userNameNotifier;
  final Function(String) onCourseSelected;
  final VoidCallback onAvatarTap;
  final Function(
    String subject,
    String branch, {
    String? scheme,
    int? year,
    int? semester,
    List<String>? subjects,
  }) onSubjectSelected;

  const HomeView({
    super.key,
    required this.userNameNotifier,
    required this.onCourseSelected,
    required this.onAvatarTap,
    required this.onSubjectSelected,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return "VS";
    final tokens = clean
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();
    if (tokens.isEmpty) return "VS";
    if (tokens.length == 1) {
      return tokens[0]
          .substring(0, tokens[0].length >= 2 ? 2 : 1)
          .toUpperCase();
    }
    return (tokens[0][0] + tokens[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Filter matching subjects across all branches & schemes
    final matchingSubjects = <Map<String, dynamic>>[];
    if (_searchQuery.isNotEmpty) {
      final queryLower = _searchQuery.toLowerCase();
      branchSemestersDb.forEach((branch, schemes) {
        schemes.forEach((scheme, years) {
          years.forEach((year, sems) {
            sems.forEach((semester, subjects) {
              for (final subject in subjects) {
                if (subject.toLowerCase().contains(queryLower)) {
                  matchingSubjects.add({
                    'subject': subject,
                    'branch': branch,
                    'scheme': scheme,
                    'year': year,
                    'semester': semester,
                    'subjects': subjects,
                  });
                }
              }
            });
          });
        });
      });
    }

    return ValueListenableBuilder<String>(
      valueListenable: AppStrings.languageNotifier,
      builder: (context, currentLang, _) {
        return ValueListenableBuilder<String>(
          valueListenable: widget.userNameNotifier,
          builder: (context, userName, child) {
            return AmbientOrbs(
              showBottomOrb: true,
              child: SafeArea(
                child: PullRefresh(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // ── Header Row ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.12),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/logo/sglogo.jpeg",
                                      width: 32,
                                      height: 32,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Studygram",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Outfit',
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: widget.onAvatarTap,
                              child: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: AppColors.primaryPale,
                                    child: Text(
                                      _getInitials(userName),
                                      style: TextStyle(
                                        color: AppColors.primaryLight,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColors.bgMain,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // ── Greeting Card with active search ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryPale.withValues(
                                  alpha: AppColors.isDark ? 0.35 : 0.8,
                                ),
                                AppColors.bgCard,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.borderCard),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AppStrings.get('goodMorning')}, $userName 👋",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppStrings.get('unlockPotential'),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Search bar
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(color: AppColors.borderCard),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: AppStrings.get('searchSubjects'),
                                    hintStyle: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 15,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.primaryLight,
                                      size: 18,
                                    ),
                                    prefixIconConstraints: const BoxConstraints(
                                      minWidth: 36,
                                      minHeight: 18,
                                    ),
                                    suffixIcon: _searchQuery.isNotEmpty
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _searchController.clear();
                                                _searchQuery = "";
                                              });
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: AppColors.textSecondary,
                                              size: 16,
                                            ),
                                          )
                                        : null,
                                    suffixIconConstraints: const BoxConstraints(
                                      minWidth: 32,
                                      minHeight: 16,
                                    ),
                                  ),
                                  onChanged: (val) {
                                    setState(() {
                                      _searchQuery = val.trim();
                                    });
                                  },
                                ),
                              ),
                              if (matchingSubjects.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  constraints: const BoxConstraints(maxHeight: 160),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgCard,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.borderCard),
                                  ),
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                    itemCount: matchingSubjects.length,
                                    separatorBuilder: (context, index) => Divider(
                                      height: 1,
                                      color: AppColors.borderCard,
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = matchingSubjects[index];
                                      final subject = item['subject'] as String;
                                      final branch = item['branch'] as String;
                                      final scheme = item['scheme'] as String;
                                      final semester = item['semester'] as int;
                                      final subjects = item['subjects'] as List<String>;
                                      final isKScheme = scheme.toLowerCase().contains('k');

                                      return ListTile(
                                        dense: true,
                                        title: Text(
                                          subject,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "$branch • $scheme (Sem $semester)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isKScheme ? AppColors.tealPale : AppColors.bluePale,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                scheme,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: isKScheme ? AppColors.tealAccent : AppColors.blueInfo,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 10,
                                              color: AppColors.primaryLight,
                                            ),
                                          ],
                                        ),
                                        onTap: () {
                                          setState(() {
                                            _searchController.clear();
                                            _searchQuery = "";
                                          });
                                          widget.onSubjectSelected(
                                            subject,
                                            branch,
                                            scheme: scheme,
                                            year: item['year'] as int,
                                            semester: semester,
                                            subjects: subjects,
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ] else if (_searchQuery.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.bgCard,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.borderCard),
                                  ),
                                  child: Text(
                                    "No matching subjects found.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        // ── Promotional Banner Ad ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryPale.withValues(
                                  alpha: AppColors.isDark ? 0.35 : 0.8,
                                ),
                                AppColors.bgCard,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderCard),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.campaign_rounded,
                                  color: AppColors.primaryLight,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Special Offer: Premium Notes & Q&A",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Unlock fully-solved winter answers",
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // ── Latest Updates ──
                        Text(
                          AppStrings.get('latestUpdates'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderCard),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryPale,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "ONGOING",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                        color: AppColors.primaryLight,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Exam Dept",
                                    style: TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Discover the new semester modules and examination schedules now released.",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 14),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const UpdatesView(),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    backgroundColor: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "View Details",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        // ── Course Grid ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.get('chooseCourse'),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                              ),
                              child: Text(
                                AppStrings.get('seeAll'),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCourseCard(
                                context,
                                courseKey: "Diploma",
                                displayTitle: AppStrings.get('diploma'),
                                description: AppStrings.get('polytechnicCourse'),
                                icon: Icons.bookmark_outline_rounded,
                                color: AppColors.tealAccent,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCourseCard(
                                context,
                                courseKey: "Degree",
                                displayTitle: AppStrings.get('degree'),
                                description: AppStrings.get('bachelorEngineering'),
                                icon: Icons.emoji_events_outlined,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildCourseCard(
                                context,
                                courseKey: "BCA",
                                displayTitle: AppStrings.get('bca'),
                                description: AppStrings.get('bachelorComputerApps'),
                                icon: Icons.laptop_chromebook_rounded,
                                color: AppColors.primaryLight,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildCourseCard(
                                context,
                                courseKey: "MCA",
                                displayTitle: AppStrings.get('mca'),
                                description: AppStrings.get('masterComputerApps'),
                                icon: Icons.workspace_premium_outlined,
                                color: AppColors.blueInfo,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCourseCard(
    BuildContext context, {
    required String courseKey,
    required String displayTitle,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () => widget.onCourseSelected(courseKey),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderCard),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 11,
                  color: AppColors.textMuted,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              displayTitle,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
