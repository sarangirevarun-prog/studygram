import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/swipe_back.dart';
import 'package:study_gram/models/branch_db.dart';

class YearSemView extends StatefulWidget {
  final String branchName;
  final String scheme;
  final VoidCallback onBack;
  final Function(int year, int semester, List<String> subjects) onSemesterSelected;

  const YearSemView({
    super.key,
    required this.branchName,
    required this.scheme,
    required this.onBack,
    required this.onSemesterSelected,
  });

  @override
  State<YearSemView> createState() => _YearSemViewState();
}

class _YearSemViewState extends State<YearSemView> {
  int _selectedYear = 1; // Default to 1st Year

  // Get semesters for the active year
  List<int> get semestersForSelectedYear {
    if (_selectedYear == 1) return [1, 2];
    if (_selectedYear == 2) return [3, 4];
    return [5, 6];
  }

  @override
  Widget build(BuildContext context) {
    // Lookup branch info details if available
    final branchInfo = diplomaBranchInfoDb[widget.branchName];
    final branchTitle = branchInfo?.degree ?? widget.branchName;

    return SwipeBackWrapper(
      child: Scaffold(
        backgroundColor: AppColors.bgMain,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.branchName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Branch Banner
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.borderCard),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    branchTitle,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPale,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    widget.scheme,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              branchInfo?.description ?? "Access specialized course materials, reference documents and modules.",
                              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28),
                      // Year Selection Section
                      Text(
                        "Select Academic Year",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildYearCard(1, "1st Year")),
                          SizedBox(width: 10),
                          Expanded(child: _buildYearCard(2, "2nd Year")),
                          SizedBox(width: 10),
                          Expanded(child: _buildYearCard(3, "3rd Year")),
                        ],
                      ),
                      SizedBox(height: 28),
                      // Semester Selection Section
                      Text(
                        "Choose Semester",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 12),
                      Column(
                        children: semestersForSelectedYear.map((sem) {
                          return _buildSemesterTile(sem);
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildYearCard(int year, String title) {
    final isSelected = _selectedYear == year;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedYear = year;
        });
      },
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryPale : AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryLight : AppColors.borderCard,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_month_rounded,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              size: 24,
            ),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterTile(int semester) {
    // Get subjects list for the semester from the DB
    final branchData = branchSemestersDb[widget.branchName];
    final schemeData = branchData?[widget.scheme];
    final yearData = schemeData?[_selectedYear];
    final subjects = yearData?[semester] ?? [];
    final subjectCount = subjects.length;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: ListTile(
        onTap: () => widget.onSemesterSelected(_selectedYear, semester, subjects),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryPale,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.menu_book_rounded,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        title: Text(
          "Semester $semester",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        subtitle: Text(
          "$subjectCount ${subjectCount == 1 ? 'Subject' : 'Subjects'} available",
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: AppColors.primaryLight,
          size: 14,
        ),
      ),
    );
  }
}
