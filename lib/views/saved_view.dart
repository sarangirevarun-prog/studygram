import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/models/branch_db.dart';
import 'package:study_gram/widgets/pull_refresh.dart';

class SavedView extends StatelessWidget {
  final Set<String> savedSubjects;
  final Function(String key) onSubjectSelected;
  final Function(String key) onRemoveBookmark;

  const SavedView({
    super.key,
    required this.savedSubjects,
    required this.onSubjectSelected,
    required this.onRemoveBookmark,
  });

  String _findBranchForSubject(String subject) {
    for (final entry in branchSubjectsDb.entries) {
      if (entry.value.contains(subject)) {
        return entry.key;
      }
    }
    return "Computer Engineering";
  }

  @override
  Widget build(BuildContext context) {
    final list = savedSubjects.toList();

    return ValueListenableBuilder<String>(
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
                  Icon(Icons.bookmark_rounded, color: AppColors.primaryLight, size: 26),
                  const SizedBox(width: 10),
                  Text(
                    AppStrings.get('savedSubjects'),
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
                child: list.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final key = list[index];
                          return _buildSavedSubjectCard(context, key);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildEmptyState() {
    return ListView(
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
                    Icons.bookmark_border_rounded,
                    color: AppColors.primary,
                    size: 56,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.get('noSavedSubjects'),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Bookmark subjects inside the course viewer to access syllabus, notes, and lectures instantly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSavedSubjectCard(BuildContext context, String key) {
    final parts = key.split('|');
    final String branch;
    final String scheme;
    final String semester;
    final String subject;

    if (parts.length == 4) {
      branch = parts[0];
      scheme = parts[1];
      semester = parts[2];
      subject = parts[3];
    } else {
      // Fallback for legacy simple key (e.g. "JAVA")
      subject = key;
      branch = _findBranchForSubject(key);
      scheme = "K Scheme";
      semester = "4";
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryPale,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 20),
        ),
        title: Text(
          subject,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          "$branch • $scheme (Sem $semester)",
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.bookmark_remove_rounded, color: AppColors.redDanger, size: 20),
              tooltip: "Remove from Saved",
              onPressed: () => onRemoveBookmark(key),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 12),
          ],
        ),
        onTap: () => onSubjectSelected(key),
      ),
    );
  }
}
