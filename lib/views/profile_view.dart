import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/widgets/swipe_back.dart';

class ProfileView extends StatefulWidget {
  final ValueNotifier<String> userNameNotifier;
  final String email;
  final VoidCallback onBack;
  final Function(String) onUpdateName;
  final VoidCallback onAboutUsTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onLogout;

  const ProfileView({
    super.key,
    required this.userNameNotifier,
    required this.email,
    required this.onBack,
    required this.onUpdateName,
    required this.onAboutUsTap,
    required this.onSettingsTap,
    required this.onLogout,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  void _showEditProfileDialog(String currentName) {
    final editController = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Edit Profile", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: editController,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: "Display Name",
              labelStyle: TextStyle(color: AppColors.textSecondary),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderCard),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: AppColors.redDanger)),
            ),
            TextButton(
              onPressed: () {
                final name = editController.text.trim();
                if (name.isNotEmpty) {
                  widget.onUpdateName(name);
                  Navigator.pop(context);
                }
              },
              child: Text("Save Changes", style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
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

  void _confirmLogout(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: AppColors.borderCard),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.redDanger.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded, color: AppColors.redDanger, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                "Confirm Logout",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to log out of Studygram?",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
                widget.onLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redDanger,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              ),
              child: const Text(
                "Logout",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppStrings.languageNotifier,
      builder: (context, currentLang, _) {
        return ValueListenableBuilder<String>(
          valueListenable: widget.userNameNotifier,
          builder: (context, userName, child) {
            return SwipeBackWrapper(
              child: Scaffold(
                backgroundColor: AppColors.bgMain,
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        // Back button
                        IconButton(
                          onPressed: widget.onBack,
                          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
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
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: AppColors.primaryPale,
                                child: Text(
                                  _getInitials(userName),
                                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
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
                                            userName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => _showEditProfileDialog(userName),
                                          child: Icon(Icons.edit_outlined, color: AppColors.primaryLight, size: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.email,
                                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text("Menu Options", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        const SizedBox(height: 12),
                        _buildMenuTile(
                          icon: Icons.person_outline_rounded,
                          title: "Edit Display Name",
                          onTap: () => _showEditProfileDialog(userName),
                          color: AppColors.blueInfo,
                        ),
                        _buildMenuTile(
                          icon: Icons.settings_outlined,
                          title: AppStrings.get('settings'),
                          onTap: widget.onSettingsTap,
                          color: AppColors.primary,
                        ),
                        _buildMenuTile(
                          icon: Icons.info_outline_rounded,
                          title: AppStrings.get('aboutUs'),
                          onTap: widget.onAboutUsTap,
                          color: AppColors.primaryLight,
                        ),
                        _buildMenuTile(
                          icon: Icons.logout_rounded,
                          title: AppStrings.get('logout'),
                          onTap: () => _confirmLogout(context),
                          color: AppColors.redDanger,
                        ),
                        const SizedBox(height: 24),
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
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 12),
      ),
    );
  }
}
