import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/swipe_back_wrapper.dart';

class AboutUsView extends StatelessWidget {
  final VoidCallback onBack;
  const AboutUsView({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return SwipeBackWrapper(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 20),
          // Heading branding
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.school, color: AppColors.primaryLight, size: 48),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Studygram Education",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Version 2.0.0 (Flutter App)",
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "About the Platform",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 10),
          const Text(
            "Studygram is an educational dashboard designed to simplify course learning, subject reference material access, and practice quiz assessment for Technical Engineering departments. We strive to present high fidelity mock models with dynamic learning pathways.",
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 30),
          const Text(
            "Our Development Team",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          _buildDeveloperCard("Amit Patil", "Senior Systems Architect", "amit@studygram.com"),
          _buildDeveloperCard("Nisha Sharma", "Lead UX/UI Designer", "nisha@studygram.com"),
          const SizedBox(height: 20),
        ],
      ),
    ), // SingleChildScrollView
    ), // SafeArea
    ); // SwipeBackWrapper
  }

  Widget _buildDeveloperCard(String name, String role, String email) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: const Icon(Icons.person_outline_rounded, color: AppColors.primaryLight),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  role,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}





