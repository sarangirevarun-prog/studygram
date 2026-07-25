import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/models/branch_db.dart';
import 'package:study_gram/widgets/ambient_orbs.dart';
import 'package:study_gram/widgets/pull_refresh.dart';
import 'package:study_gram/views/updates_view.dart';
import 'package:study_gram/widgets/user_avatar.dart';

class HomeView extends StatefulWidget {
  final ValueNotifier<String> userNameNotifier;
  final ValueNotifier<String?> userAvatarNotifier;
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
    required this.userAvatarNotifier,
    required this.onCourseSelected,
    required this.onAvatarTap,
    required this.onSubjectSelected,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = "";
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isSearchFocused = _searchFocusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    // Filter matching subjects across all branches & schemes
    final matchingSubjects = <Map<String, dynamic>>[];
    final shouldShowSearchResults = _isSearchFocused || _searchQuery.isNotEmpty;

    if (shouldShowSearchResults) {
      final queryLower = _searchQuery.toLowerCase();
      branchSemestersDb.forEach((branch, schemes) {
        schemes.forEach((scheme, years) {
          years.forEach((year, sems) {
            sems.forEach((semester, subjects) {
              for (final subject in subjects) {
                if (_searchQuery.isEmpty || subject.toLowerCase().contains(queryLower)) {
                  if (!matchingSubjects.any((element) => element['subject'] == subject && element['branch'] == branch)) {
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
                    physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        // ── Header Row ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.bgCard,
                                    border: Border.all(
                                      color: AppColors.primaryLight.withValues(alpha: 0.4),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(alpha: 0.12),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/logo/sglogo.jpeg",
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
                            ValueListenableBuilder<String?>(
                              valueListenable: widget.userAvatarNotifier,
                              builder: (context, avatarVal, _) {
                                return UserAvatar(
                                  avatarPathOrUrl: avatarVal,
                                  userName: userName,
                                  radius: 20,
                                  onTap: widget.onAvatarTap,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // ── Greeting Card with active search ──
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${AppStrings.get('hello')}, $userName ",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          AppStrings.get('unlockPotential'),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 70,
                                    width: 95,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(alpha: 0.2),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Image.asset(
                                        "assets/images/students_banner.png",
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.primaryPale,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.school_rounded,
                                            color: AppColors.primary,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Search bar
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(13),
                                  border: Border.all(color: AppColors.borderCard),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  onTap: () {
                                    setState(() {
                                      _isSearchFocused = true;
                                    });
                                  },
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
                                    suffixIcon: shouldShowSearchResults
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _searchController.clear();
                                                _searchQuery = "";
                                                _searchFocusNode.unfocus();
                                                _isSearchFocused = false;
                                              });
                                            },
                                            child: Icon(
                                              Icons.close,
                                              color: AppColors.textSecondary,
                                              size: 18,
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
                                    physics: const ClampingScrollPhysics(),
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
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "$branch • $scheme (Sem $semester)",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                                            _searchFocusNode.unfocus();
                                            _isSearchFocused = false;
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Unlock fully-solved winter answers",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
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
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderCard),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryPale,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.notifications_active_outlined,
                                  color: AppColors.primaryLight,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "New Semester Modules & Timetable",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "Official exam department release notes",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UpdatesView(),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    "View",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // ── Course Grid ──
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppStrings.get('chooseCourse'),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton(
                              onPressed: _showAllCoursesSheet,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                              ),
                              child: Text(
                                AppStrings.get('seeAll'),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primaryLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
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
                            const SizedBox(width: 10),
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
                        const SizedBox(height: 8),
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
                                isComingSoon: true,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildCourseCard(
                                context,
                                courseKey: "MCA",
                                displayTitle: AppStrings.get('mca'),
                                description: AppStrings.get('masterComputerApps'),
                                icon: Icons.workspace_premium_outlined,
                                color: AppColors.blueInfo,
                                isComingSoon: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
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

  void _showAllCoursesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final allCourses = [
          {
            'key': 'Diploma',
            'title': 'Diploma (Polytechnic)',
            'desc': 'MSBTE K-Scheme & I-Scheme Diploma Engineering',
            'icon': Icons.bookmark_outline_rounded,
            'color': AppColors.tealAccent,
            'isAvailable': true,
          },
          {
            'key': 'Degree',
            'title': 'Degree (B.E / B.Tech)',
            'desc': 'Bachelor of Engineering & Technology',
            'icon': Icons.emoji_events_outlined,
            'color': AppColors.accent,
            'isAvailable': true,
          },
          {
            'key': 'BCA',
            'title': 'BCA',
            'desc': 'Bachelor of Computer Applications',
            'icon': Icons.laptop_chromebook_rounded,
            'color': AppColors.primaryLight,
            'isAvailable': false,
          },
          {
            'key': 'MCA',
            'title': 'MCA',
            'desc': 'Master of Computer Applications',
            'icon': Icons.workspace_premium_outlined,
            'color': AppColors.blueInfo,
            'isAvailable': false,
          },
          {
            'key': 'Pharmacy',
            'title': 'Pharmacy (D.Pharm / B.Pharm)',
            'desc': 'Diploma & Bachelor of Pharmacy',
            'icon': Icons.local_pharmacy_rounded,
            'color': const Color(0xFFEC4899),
            'isAvailable': false,
          },
          {
            'key': 'Commerce',
            'title': 'Commerce (B.Com / M.Com / BBA)',
            'desc': 'Bachelor & Master of Commerce & Business',
            'icon': Icons.account_balance_rounded,
            'color': const Color(0xFF8B5CF6),
            'isAvailable': false,
          },
          {
            'key': 'Arts',
            'title': 'Arts & Humanities (B.A / M.A)',
            'desc': 'Bachelor & Master of Arts Stream',
            'icon': Icons.palette_rounded,
            'color': const Color(0xFFF97316),
            'isAvailable': false,
          },
          {
            'key': 'Science',
            'title': 'Science Stream (B.Sc / M.Sc)',
            'desc': 'Bachelor & Master of Science',
            'icon': Icons.biotech_rounded,
            'color': const Color(0xFF06B6D4),
            'isAvailable': false,
          },
          {
            'key': 'ITI',
            'title': 'ITI & Vocational Trades',
            'desc': 'Industrial Training Institutes',
            'icon': Icons.build_circle_rounded,
            'color': const Color(0xFF14B8A6),
            'isAvailable': false,
          },
          {
            'key': 'Law',
            'title': 'Law (LL.B / B.A LL.B)',
            'desc': 'Bachelor of Law & Legal Studies',
            'icon': Icons.gavel_rounded,
            'color': const Color(0xFF64748B),
            'isAvailable': false,
          },
        ];

        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderCard,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "All Educational Courses",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(Icons.close_rounded, color: AppColors.textMuted, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    itemCount: allCourses.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final item = allCourses[index];
                      final isAvail = item['isAvailable'] as bool;
                      final color = item['color'] as Color;

                      return InkWell(
                        onTap: () {
                          Navigator.pop(ctx);
                          if (isAvail) {
                            widget.onCourseSelected(item['key'] as String);
                          } else {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "${item['title']} study materials are coming soon!",
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.bgMain,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.borderCard),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: color.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(item['icon'] as IconData, color: color, size: 22),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item['desc'] as String,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isAvail)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPale,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Active",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryLight,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.accentPale,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "Soon",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.accent,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
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
    bool isComingSoon = false,
  }) {
    return InkWell(
      onTap: () {
        if (isComingSoon) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "$displayTitle materials are empty right now • Coming Soon!",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 3),
            ),
          );
        } else {
          widget.onCourseSelected(courseKey);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderCard),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
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
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, color: color, size: 18),
                ),
                if (isComingSoon)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.accentPale,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Text(
                      "Soon",
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent,
                      ),
                    ),
                  )
                else
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: AppColors.textMuted,
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              displayTitle,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                fontFamily: 'Outfit',
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isComingSoon ? "Content Empty • Coming Soon" : description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                color: isComingSoon ? AppColors.textMuted : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
