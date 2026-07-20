import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/swipe_back_wrapper.dart';

class ProfileView extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final int quizScore;
  final VoidCallback onBack;
  final Function(String) onUpdateName;
  final VoidCallback onAboutUsTap;
  final VoidCallback onLogout;

  const ProfileView({
    super.key,
    required this.userName,
    required this.phoneNumber,
    required this.quizScore,
    required this.onBack,
    required this.onUpdateName,
    required this.onAboutUsTap,
    required this.onLogout,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _showEditProfileDialog() {
    final editController = TextEditingController(text: widget.userName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Edit Profile", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: editController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: "Display Name",
              labelStyle: const TextStyle(color: AppColors.textSecondary),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderCard),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: AppColors.redDanger)),
            ),
            TextButton(
              onPressed: () {
                final name = editController.text.trim();
                if (name.isNotEmpty) {
                  widget.onUpdateName(name);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save Changes", style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

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
              // Back button
              IconButton(
                onPressed: widget.onBack,
                icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 16),
          // Profile card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.borderCard),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.primaryPale,
                      child: const Text(
                        "VS",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.userName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                ),
                              ),
                              GestureDetector(
                                onTap: _showEditProfileDialog,
                                child: const Icon(Icons.edit_outlined, color: AppColors.primaryLight, size: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.phoneNumber.isNotEmpty ? widget.phoneNumber : "+91 98765 43210",
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("MEMBER LEVEL", style: TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        SizedBox(height: 4),
                        Text("Expert Scholar", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.accentPale,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.bolt, color: AppColors.accent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "${widget.quizScore} pts",
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.accent, fontFamily: 'Outfit'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text("Menu Options", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          _buildMenuTile(
            icon: Icons.person_outline_rounded,
            title: "Edit Display Name",
            onTap: _showEditProfileDialog,
            color: AppColors.blueInfo,
          ),
          _buildMenuTile(
            icon: Icons.info_outline_rounded,
            title: "About Us Info",
            onTap: widget.onAboutUsTap,
            color: AppColors.primaryLight,
          ),
          _buildMenuTile(
            icon: Icons.logout_rounded,
            title: "Sign Out",
            onTap: widget.onLogout,
            color: AppColors.redDanger,
          ),
          const SizedBox(height: 24),
        ],
      ),
    ), // SingleChildScrollView
    ), // SafeArea
    ); // SwipeBackWrapper
  }


  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderCard),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 12),
      ),
    );
  }
}


