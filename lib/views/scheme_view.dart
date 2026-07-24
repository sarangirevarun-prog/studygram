import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/swipe_back.dart';
import 'package:study_gram/models/branch_db.dart';

class SchemeView extends StatelessWidget {
  final String branchName;
  final VoidCallback onBack;
  final Function(String scheme) onSchemeSelected;

  const SchemeView({
    super.key,
    required this.branchName,
    required this.onBack,
    required this.onSchemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final branchInfo = diplomaBranchInfoDb[branchName];
    final branchTitle = branchInfo?.degree ?? branchName;

    return SwipeBackWrapper(
      child: Scaffold(
        backgroundColor: AppColors.bgMain,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onBack,
                      icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        branchName,
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
                      // Branch Info Banner
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
                            Text(
                              branchTitle,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "Select your academic syllabus scheme to access year-wise and semester-wise materials.",
                              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 28),
                      // Section Header
                      Text(
                        "Choose Syllabus Scheme",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 16),
                      // Schemes List
                      _buildSchemeCard(
                        context,
                        title: "K Scheme",
                        subtitle: "NEP-2020 Compliant Syllabus",
                        description: "Latest curriculum with restructured course contents, practical-oriented evaluations, and modern electives.",
                        isLatest: true,
                      ),
                      SizedBox(height: 14),
                      _buildSchemeCard(
                        context,
                        title: "I Scheme",
                        subtitle: "Previous MSBTE Curriculum",
                        description: "Standard credit-based grading structure, covering traditional engineering core concepts and projects.",
                        isLatest: false,
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

  Widget _buildSchemeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String description,
    required bool isLatest,
  }) {
    return InkWell(
      onTap: () => onSchemeSelected(title),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
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
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isLatest ? AppColors.primaryPale : AppColors.bluePale,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.assignment_turned_in_rounded,
                        color: isLatest ? AppColors.primary : AppColors.blueInfo,
                        size: 22,
                      ),
                    ),
                    SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isLatest)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.tealPale,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "LATEST",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.tealAccent,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 14),
            Text(
              description,
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
