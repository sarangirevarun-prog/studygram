import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';

class PresetAvatarInfo {
  final String id;
  final String label;
  final IconData icon;
  final List<Color> colors;
  final String category;

  const PresetAvatarInfo({
    required this.id,
    required this.label,
    required this.icon,
    required this.colors,
    required this.category,
  });
}

class PresetAvatars {
  static const List<PresetAvatarInfo> list = [
    // ── Boys ──
    PresetAvatarInfo(
      id: 'preset:boy_student',
      label: 'Male Student',
      icon: Icons.face_5_rounded,
      colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
      category: 'Boys',
    ),
    PresetAvatarInfo(
      id: 'preset:boy_tech',
      label: 'Tech Boy',
      icon: Icons.computer_rounded,
      colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
      category: 'Boys',
    ),
    PresetAvatarInfo(
      id: 'preset:boy_cool',
      label: 'Cool Guy',
      icon: Icons.headphones_rounded,
      colors: [Color(0xFF4338CA), Color(0xFF6366F1)],
      category: 'Boys',
    ),
    PresetAvatarInfo(
      id: 'preset:boy_gamer',
      label: 'Gamer Boy',
      icon: Icons.sports_esports_rounded,
      colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
      category: 'Boys',
    ),

    // ── Girls ──
    PresetAvatarInfo(
      id: 'preset:girl_student',
      label: 'Female Student',
      icon: Icons.face_3_rounded,
      colors: [Color(0xFFBE185D), Color(0xFFEC4899)],
      category: 'Girls',
    ),
    PresetAvatarInfo(
      id: 'preset:girl_tech',
      label: 'Tech Girl',
      icon: Icons.terminal_rounded,
      colors: [Color(0xFF7E22CE), Color(0xFFA855F7)],
      category: 'Girls',
    ),
    PresetAvatarInfo(
      id: 'preset:girl_scholar',
      label: 'Scholar Girl',
      icon: Icons.auto_stories_rounded,
      colors: [Color(0xFF047857), Color(0xFF10B981)],
      category: 'Girls',
    ),
    PresetAvatarInfo(
      id: 'preset:girl_creative',
      label: 'Creative Girl',
      icon: Icons.palette_rounded,
      colors: [Color(0xFFC2410C), Color(0xFFF97316)],
      category: 'Girls',
    ),

    // ── Teachers ──
    PresetAvatarInfo(
      id: 'preset:teacher_male',
      label: 'Male Teacher',
      icon: Icons.cast_for_education_rounded,
      colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
      category: 'Teachers',
    ),
    PresetAvatarInfo(
      id: 'preset:teacher_female',
      label: 'Female Teacher',
      icon: Icons.menu_book_rounded,
      colors: [Color(0xFF831843), Color(0xFFDB2777)],
      category: 'Teachers',
    ),
    PresetAvatarInfo(
      id: 'preset:professor',
      label: 'Professor',
      icon: Icons.psychology_rounded,
      colors: [Color(0xFF134E4A), Color(0xFF0D9488)],
      category: 'Teachers',
    ),
    PresetAvatarInfo(
      id: 'preset:mentor',
      label: 'Mentor',
      icon: Icons.supervisor_account_rounded,
      colors: [Color(0xFFB45309), Color(0xFFF59E0B)],
      category: 'Teachers',
    ),

    // ── Achievers & Scholars ──
    PresetAvatarInfo(
      id: 'preset:scholar',
      label: 'Scholar',
      icon: Icons.school_rounded,
      colors: [Color(0xFF059669), Color(0xFF10B981)],
      category: 'Achievers',
    ),
    PresetAvatarInfo(
      id: 'preset:coder',
      label: 'Coder',
      icon: Icons.code_rounded,
      colors: [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
      category: 'Achievers',
    ),
    PresetAvatarInfo(
      id: 'preset:graduate',
      label: 'Graduate',
      icon: Icons.workspace_premium_rounded,
      colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
      category: 'Achievers',
    ),
    PresetAvatarInfo(
      id: 'preset:hero',
      label: 'Star Student',
      icon: Icons.star_rounded,
      colors: [Color(0xFF0891B2), Color(0xFF06B6D4)],
      category: 'Achievers',
    ),
    PresetAvatarInfo(
      id: 'preset:rocket',
      label: 'Innovator',
      icon: Icons.rocket_launch_rounded,
      colors: [Color(0xFFEA580C), Color(0xFFF97316)],
      category: 'Achievers',
    ),
  ];

  static PresetAvatarInfo? getById(String id) {
    try {
      return list.firstWhere((item) => item.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<PresetAvatarInfo> getByCategory(String cat) {
    return list.where((item) => item.category == cat).toList();
  }
}

class UserAvatar extends StatelessWidget {
  final String? avatarPathOrUrl;
  final String userName;
  final double radius;
  final bool showEditBadge;
  final VoidCallback? onTap;

  const UserAvatar({
    super.key,
    required this.avatarPathOrUrl,
    required this.userName,
    this.radius = 24,
    this.showEditBadge = false,
    this.onTap,
  });

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
    final size = radius * 2;

    Widget avatarContent = _buildAvatarContent(size);

    Widget avatarWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(child: avatarContent),
    );

    if (showEditBadge) {
      avatarWidget = Stack(
        children: [
          avatarWidget,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.bgCard, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  Widget _buildAvatarContent(double size) {
    final val = avatarPathOrUrl?.trim();

    if (val == null || val.isEmpty) {
      return _buildInitialsFallback(size);
    }

    // 1. Preset Avatars
    if (val.startsWith('preset:')) {
      final preset = PresetAvatars.getById(val);
      if (preset != null) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: preset.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Icon(
              preset.icon,
              color: Colors.white,
              size: size * 0.52,
            ),
          ),
        );
      }
    }

    // 2. Network Image URL
    if (val.startsWith('http://') || val.startsWith('https://')) {
      return Image.network(
        val,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildInitialsFallback(size),
      );
    }

    // 3. Base64 encoded image
    if (val.startsWith('data:image') || val.length > 200) {
      try {
        final cleanBase64 = val.contains(',') ? val.split(',').last : val;
        final bytes = base64Decode(cleanBase64);
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildInitialsFallback(size),
        );
      } catch (_) {}
    }

    // 4. Local File Path
    try {
      final file = File(val);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildInitialsFallback(size),
        );
      }
    } catch (_) {}

    return _buildInitialsFallback(size);
  }

  Widget _buildInitialsFallback(double size) {
    return Container(
      color: AppColors.primaryPale,
      child: Center(
        child: Text(
          _getInitials(userName),
          style: TextStyle(
            color: AppColors.primaryLight,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.38,
          ),
        ),
      ),
    );
  }
}
