import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/swipe_back.dart';
import 'package:study_gram/widgets/pull_refresh.dart';

class SubjectsView extends StatefulWidget {
  final String selectedBranch;
  final String selectedScheme;
  final int selectedYear;
  final int selectedSemester;
  final List<String> subjects;
  final VoidCallback onBack;
  final Function(String) onSubjectSelected;

  const SubjectsView({
    super.key,
    required this.selectedBranch,
    required this.selectedScheme,
    required this.selectedYear,
    required this.selectedSemester,
    required this.subjects,
    required this.onBack,
    required this.onSubjectSelected,
  });

  @override
  State<SubjectsView> createState() => _SubjectsViewState();
}

class _SubjectsViewState extends State<SubjectsView> {
  String _searchQuery = "";
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allSubjects = widget.subjects;
    final filteredSubjects = allSubjects
        .where((subject) => subject.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return SwipeBackWrapper(
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              // Header Row
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedBranch,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "${widget.selectedScheme} • Year ${widget.selectedYear} • Semester ${widget.selectedSemester}",
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
          // Search Field
          Container(
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: "Search subjects...",
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
                prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 18),
                prefixIconConstraints: BoxConstraints(minWidth: 38, minHeight: 18),
                suffixIcon: _searchQuery.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = "";
                          });
                        },
                        child: Icon(Icons.close, color: AppColors.textSecondary, size: 18),
                      )
                    : null,
                suffixIconConstraints: BoxConstraints(minWidth: 34, minHeight: 18),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Course Modules",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: 10),
          Expanded(
            child: PullRefresh(
              child: filteredSubjects.isEmpty
                  ? Center(
                      child: Text(
                        "No matching subjects found.",
                        style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                    )
                  : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = filteredSubjects[index];
                      final accentColor = index % 3 == 0
                          ? AppColors.primaryLight
                          : (index % 3 == 1 ? AppColors.accent : AppColors.tealAccent);

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.borderCard),
                        ),
                        child: ListTile(
                          onTap: () => widget.onSubjectSelected(subject),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: accentColor,
                              size: 22,
                            ),
                          ),
                          title: Text(
                            subject,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: AppColors.primaryLight,
                            size: 14,
                          ),
                        ),
                      );
                     },
                   ),          // ListView.builder
              ),                // PullRefresh
            ),                  // Expanded
          ],
      ), // Column
    ), // Padding
    ), // SafeArea
    ); // SwipeBackWrapper
  }
}
