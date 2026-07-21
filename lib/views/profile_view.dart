import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/swipe_back.dart';

class ProfileView extends StatefulWidget {
  final String userName;
  final String phoneNumber;
  final VoidCallback onBack;
  final Function(String) onUpdateName;
  final VoidCallback onAboutUsTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onLogout;

  const ProfileView({
    super.key,
    required this.userName,
    required this.phoneNumber,
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
  late String _localName;

  @override
  void initState() {
    super.initState();
    _localName = widget.userName;
  }

  @override
  void didUpdateWidget(covariant ProfileView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userName != widget.userName) {
      setState(() {
        _localName = widget.userName;
      });
    }
  }

  void _showEditProfileDialog() {
    final editController = TextEditingController(text: _localName);
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
                  setState(() {
                    _localName = name;
                  });
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

  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: AppColors.primaryPale,
                            child: Text(
                              _getInitials(_localName),
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
                                        _localName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _showEditProfileDialog,
                                      child: Icon(Icons.edit_outlined, color: AppColors.primaryLight, size: 18),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.phoneNumber.isNotEmpty ? widget.phoneNumber : "+91 98765 43210",
                                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Divider(height: 1, color: AppColors.borderCard),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("MEMBER LEVEL", style: TextStyle(fontSize: 9, color: AppColors.textMuted, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          const SizedBox(height: 4),
                          Text("Expert Scholar", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Text("Menu Options", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                _buildMenuTile(
                  icon: Icons.person_outline_rounded,
                  title: "Edit Display Name",
                  onTap: _showEditProfileDialog,
                  color: AppColors.blueInfo,
                ),
                _buildMenuTile(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: widget.onSettingsTap,
                  color: AppColors.primary,
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
          ),
        ),
      ),
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
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted, size: 12),
      ),
    );
  }
}
