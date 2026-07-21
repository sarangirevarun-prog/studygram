import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/swipe_back.dart';
import 'package:study_gram/widgets/pull_refresh.dart';

class SettingsView extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;
  final VoidCallback onBack;

  const SettingsView({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onBack,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late bool _darkModeValue;

  @override
  void initState() {
    super.initState();
    _darkModeValue = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return SwipeBackWrapper(
      child: Scaffold(
        backgroundColor: AppColors.bgMain,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onBack,
                      icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PullRefresh(
                  child: ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: [
                    // Appearance Section
                    _buildSectionHeader("Appearance"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: SwitchListTile(
                        value: _darkModeValue,
                        onChanged: (val) {
                          setState(() {
                            _darkModeValue = val;
                          });
                          widget.onThemeChanged(val);
                        },
                        title: Text(
                          "Dark Mode",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "Toggle clean dark appearance",
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                        ),
                        secondary: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _darkModeValue ? AppColors.primaryPale : AppColors.bluePale,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _darkModeValue ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                            color: _darkModeValue ? AppColors.primary : AppColors.blueInfo,
                            size: 18,
                          ),
                        ),
                        activeThumbColor: AppColors.primaryLight,
                        activeTrackColor: AppColors.primaryLight.withValues(alpha: 0.3),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Help & Support Section
                    _buildSectionHeader("Help & Support"),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: Column(
                        children: [
                          _buildFAQTile(
                            question: "How to download syllabus?",
                            answer: "Go to Course -> Branch -> Scheme selection -> Year & Semester selection to view and access your specific subjects list and reference materials.",
                          ),
                          _buildDivider(),
                          _buildFAQTile(
                            question: "Can I search for specific subjects?",
                            answer: "Yes! Use the search bar on the Home screen to quickly search for any subject module in the curriculum database.",
                          ),
                          _buildDivider(),
                          _buildFAQTile(
                            question: "How to change display name?",
                            answer: "Navigate to the Profile tab, tap the edit icon next to your name, type in your preferred display name, and click 'Save Changes' to update it.",
                          ),
                          _buildDivider(),
                          _buildFAQTile(
                            question: "Contact Support",
                            answer: "For queries, support, or feedback, you can contact us at support@studygram.org.in.",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // App Info
                    _buildSectionHeader("App Info"),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Studygram App",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Latest Release",
                                style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          Text(
                            "v1.0.0",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
                ),           // PullRefresh
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFAQTile({required String question, required String answer}) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textMuted,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.borderCard,
    );
  }
}
