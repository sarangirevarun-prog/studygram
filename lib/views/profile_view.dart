import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/widgets/swipe_back.dart';
import 'package:study_gram/widgets/user_avatar.dart';

class ProfileView extends StatefulWidget {
  final ValueNotifier<String> userNameNotifier;
  final ValueNotifier<String?> userAvatarNotifier;
  final String email;
  final VoidCallback onBack;
  final Function(String) onUpdateName;
  final Function(String?) onUpdateAvatar;
  final VoidCallback onAboutUsTap;
  final VoidCallback onSuggestionTap;
  final VoidCallback onMoreAppsTap;
  final VoidCallback onSettingsTap;
  final VoidCallback onLogout;

  const ProfileView({
    super.key,
    required this.userNameNotifier,
    required this.userAvatarNotifier,
    required this.email,
    required this.onBack,
    required this.onUpdateName,
    required this.onUpdateAvatar,
    required this.onAboutUsTap,
    required this.onSuggestionTap,
    required this.onMoreAppsTap,
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



  void _showUrlDialog() {
    final urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.bgCard,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Paste Image Link", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: urlController,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: "https://example.com/avatar.jpg",
              labelText: "Direct Image URL",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                final url = urlController.text.trim();
                if (url.isNotEmpty) {
                  widget.onUpdateAvatar(url);
                  Navigator.pop(ctx);
                }
              },
              child: Text("Save", style: TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _showPresetAvatarsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderCard,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Choose Avatar",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: Icon(Icons.close_rounded, color: AppColors.textMuted, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    itemCount: PresetAvatars.list.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.82,
                    ),
                    itemBuilder: (context, index) {
                      final preset = PresetAvatars.list[index];
                      return GestureDetector(
                        onTap: () {
                          widget.onUpdateAvatar(preset.id);
                          Navigator.pop(ctx);
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: preset.colors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: preset.colors.first.withValues(alpha: 0.25),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Icon(preset.icon, color: Colors.white, size: 24),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              preset.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAvatarOptionsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.borderCard,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Profile Picture Options",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accentPale,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.face_rounded, color: AppColors.accent, size: 20),
                ),
                title: Text("Choose Student Avatar", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showPresetAvatarsSheet();
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.tealPale,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.link_rounded, color: AppColors.tealAccent, size: 20),
                ),
                title: Text("Paste Image Link", style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(ctx);
                  _showUrlDialog();
                },
              ),
              if (widget.userAvatarNotifier.value != null)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.redPale,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.delete_outline_rounded, color: AppColors.redDanger, size: 20),
                  ),
                  title: Text("Remove Picture", style: TextStyle(color: AppColors.redDanger, fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.pop(ctx);
                    widget.onUpdateAvatar(null);
                  },
                ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
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
                        // Header Row with Back button & Screen Title
                        Row(
                          children: [
                            IconButton(
                              onPressed: widget.onBack,
                              icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                              padding: EdgeInsets.zero,
                              alignment: Alignment.centerLeft,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              AppStrings.get('profile'),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
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
                              ValueListenableBuilder<String?>(
                                valueListenable: widget.userAvatarNotifier,
                                builder: (context, avatarVal, _) {
                                  return UserAvatar(
                                    avatarPathOrUrl: avatarVal,
                                    userName: userName,
                                    radius: 32,
                                    showEditBadge: false,
                                    onTap: _showAvatarOptionsSheet,
                                  );
                                },
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
                          icon: Icons.rate_review_outlined,
                          title: AppStrings.get('appSuggestions'),
                          onTap: widget.onSuggestionTap,
                          color: AppColors.tealAccent,
                        ),
                        _buildMenuTile(
                          icon: Icons.grid_view_rounded,
                          title: AppStrings.get('moreEducationApps'),
                          onTap: widget.onMoreAppsTap,
                          color: AppColors.accent,
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
