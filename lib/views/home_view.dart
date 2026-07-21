import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/models/branch_db.dart';
import 'package:study_gram/widgets/ambient_orbs.dart';
import 'package:study_gram/widgets/pull_refresh.dart';
import 'package:study_gram/views/updates_view.dart';

class HomeView extends StatefulWidget {
  final String userName;
  final Function(String) onCourseSelected;
  final VoidCallback onAvatarTap;
  final Function(String subject, String branch) onSubjectSelected;

  const HomeView({
    super.key,
    required this.userName,
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
    final tokens = clean.split(RegExp(r'\s+')).where((t) => t.isNotEmpty).toList();
    if (tokens.isEmpty) return "VS";
    if (tokens.length == 1) {
      return tokens[0].substring(0, tokens[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return (tokens[0][0] + tokens[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    // Filter matching subjects across all branches
    final matchingSubjects = <MapEntry<String, String>>[];
    if (_searchQuery.isNotEmpty) {
      branchSubjectsDb.forEach((branch, subjects) {
        for (final subject in subjects) {
          if (subject.toLowerCase().contains(_searchQuery.toLowerCase())) {
            matchingSubjects.add(MapEntry(subject, branch));
          }
        }
      });
    }

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
            SizedBox(height: 12),
            // ── Header Row ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.school, color: AppColors.primaryLight, size: 26),
                    SizedBox(width: 8),
                    Text(
                      "Studygram",
                      style: TextStyle(
                        fontSize: 20,
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
                          _getInitials(widget.userName),
                          style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold, fontSize: 12),
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
                            border: Border.all(color: AppColors.bgMain, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // ── Greeting Card with active search ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryPale.withValues(alpha: AppColors.isDark ? 0.35 : 0.8),
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
                    "Good Morning, ${widget.userName} 👋",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Unlock your potential today",
                    style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 16),
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(13),
                      border: Border.all(color: AppColors.borderCard),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Search subjects...",
                        hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        prefixIcon: Icon(Icons.search, color: AppColors.primaryLight, size: 18),
                        prefixIconConstraints: BoxConstraints(minWidth: 36, minHeight: 18),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = "";
                                  });
                                },
                                child: Icon(Icons.close, color: AppColors.textSecondary, size: 16),
                              )
                            : null,
                        suffixIconConstraints: BoxConstraints(minWidth: 32, minHeight: 16),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val.trim();
                        });
                      },
                    ),
                  ),
                  if (matchingSubjects.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Container(
                      constraints: BoxConstraints(maxHeight: 160),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(vertical: 4),
                        itemCount: matchingSubjects.length,
                        separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.borderCard),
                        itemBuilder: (context, index) {
                          final entry = matchingSubjects[index];
                          final subject = entry.key;
                          final branch = entry.value;
                          return ListTile(
                            dense: true,
                            title: Text(
                              subject,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                            ),
                            subtitle: Text(
                              branch,
                              style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.primaryLight),
                            onTap: () {
                              // Clear search on select
                              setState(() {
                                _searchController.clear();
                                _searchQuery = "";
                              });
                              widget.onSubjectSelected(subject, branch);
                            },
                          );
                        },
                      ),
                    ),
                  ] else if (_searchQuery.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: Text(
                        "No matching subjects found.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ── Promotional Banner Ad ──
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatesView()));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryPale.withValues(alpha: AppColors.isDark ? 0.35 : 0.8),
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
                      child: Icon(Icons.campaign_rounded, color: AppColors.primaryLight, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Special Offer: Premium Notes & Q&A",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Unlock fully-solved winter answers",
                            style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // ── Latest Updates ──
            Text(
              "Latest Updates",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(18),
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
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryPale,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "ONGOING",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                      Text(
                        "Exam Dept",
                        style: TextStyle(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Discover the new semester modules and examination schedules now released.",
                    style: TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.5),
                  ),
                  SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdatesView()));
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text(
                        "View Details",
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
            SizedBox(height: 24),
            // ── Course Grid ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Choose Your Course",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: Text(
                    "See all",
                    style: TextStyle(fontSize: 13, color: AppColors.primaryLight, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildCourseCard(
                    context,
                    title: "Diploma",
                    description: "Specialized Engineering Technical Course",
                    icon: Icons.bookmark_outline_rounded,
                    color: AppColors.tealAccent,
                  ),
                ),
                SizedBox(width: 14),
                Expanded(
                  child: _buildCourseCard(
                    context,
                    title: "Degree",
                    description: "Bachelor of Engineering Course Program",
                    icon: Icons.emoji_events_outlined,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
        ),      // SingleChildScrollView
        ),      // PullRefresh
      ),        // SafeArea
    );          // AmbientOrbs
  }

  Widget _buildCourseCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: () => widget.onCourseSelected(title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.all(16),
        height: 110,
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderCard),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
