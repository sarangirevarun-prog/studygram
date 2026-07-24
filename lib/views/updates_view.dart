import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/widgets/pull_refresh.dart';

class UpdatesView extends StatelessWidget {
  const UpdatesView({super.key});

  @override
  Widget build(BuildContext context) {
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
                      Icon(Icons.campaign_rounded, color: AppColors.primaryLight, size: 26),
                      const SizedBox(width: 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                children: [
                  // Prominent Ad Banner (Ad put by user)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "SPECIAL OFFER",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Get Premium Notes & Solved Papers",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Access full syllabus question banks and model answer solutions for MSBTE winter exams.",
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Explore Premium",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Useful Announcements",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Announcement Item 1
                  _buildUpdateCard(
                    icon: Icons.notifications_active_outlined,
                    iconColor: AppColors.accent,
                    title: "Winter Semester Exam Schedule",
                    time: "2 hours ago",
                    description: "The official MSBTE winter exam dates have been declared. Practicals begin next week. Access timetables inside the curriculum catalog.",
                  ),

                  // Announcement Item 2
                  _buildUpdateCard(
                    icon: Icons.library_books_outlined,
                    iconColor: AppColors.blueInfo,
                    title: "New K-Scheme Notes Added",
                    time: "1 day ago",
                    description: "Curriculum notes and solved lab manuals for Semester 3 Computer Engineering (K-Scheme) are now uploaded and ready to download.",
                  ),

                  // Announcement Item 3
                  _buildUpdateCard(
                    icon: Icons.group_outlined,
                    iconColor: AppColors.tealAccent,
                    title: "Join studygram Telegram Channel",
                    time: "3 days ago",
                    description: "Connect with over 15,000+ diploma and technical students. Get instant updates on syllabus, answers, and important exam notices.",
                  ),

                  const SizedBox(height: 20),

                  // Footer Logo
                  Center(
                    child: Opacity(
                      opacity: 0.6,
                      child: Column(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.bgCard,
                              border: Border.all(color: AppColors.borderCard),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                "assets/logo/sglogo.jpeg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Studygram Education",
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              ),             // PullRefresh
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildUpdateCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String time,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              time,
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
