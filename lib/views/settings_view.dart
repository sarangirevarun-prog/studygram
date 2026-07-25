import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/theme/l10n.dart';
import 'package:study_gram/widgets/swipe_back.dart';
import 'package:study_gram/widgets/pull_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsView extends StatefulWidget {
  final bool isDarkMode;
  final String selectedLanguage;
  final Function(bool) onThemeChanged;
  final Function(String) onLanguageChanged;
  final VoidCallback onBack;

  const SettingsView({
    super.key,
    required this.isDarkMode,
    required this.selectedLanguage,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.onBack,
  });

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late bool _darkModeValue;

  Future<void> _launchContactUrl(String urlStr) async {
    final uri = Uri.parse(urlStr);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  String _getDisplayLanguageName(String code) {
    if (code == "Hindi") return "हिंदी (Hindi)";
    if (code == "Marathi") return "मराठी (Marathi)";
    return "English (Default)";
  }

  void _showLanguageDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final languages = [
          {"code": "English", "name": "English", "sub": "Default Language", "flag": "🇬🇧"},
          {"code": "Hindi", "name": "हिंदी (Hindi)", "sub": "हिन्दी भाषा", "flag": "🇮🇳"},
          {"code": "Marathi", "name": "मराठी (Marathi)", "sub": "मराठी भाषा", "flag": "🇮🇳"},
        ];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.get('selectLanguage'),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close, color: AppColors.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...languages.map((lang) {
                final isSelected = widget.selectedLanguage == lang["code"];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryPale.withValues(alpha: 0.3) : AppColors.bgMain,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryLight : AppColors.borderCard,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      widget.onLanguageChanged(lang["code"]!);
                    },
                    leading: Text(lang["flag"]!, style: const TextStyle(fontSize: 22)),
                    title: Text(
                      lang["name"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.primaryLight : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      lang["sub"]!,
                      style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle_rounded, color: AppColors.primaryLight, size: 20)
                        : null,
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _darkModeValue = widget.isDarkMode;
  }

  @override
  void didUpdateWidget(covariant SettingsView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isDarkMode != widget.isDarkMode) {
      _darkModeValue = widget.isDarkMode;
    }
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
                          fontSize: 20,
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "Toggle clean dark appearance",
                          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
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
                    // Language Section
                    _buildSectionHeader(AppStrings.get('language')),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.borderCard),
                      ),
                      child: ListTile(
                        onTap: _showLanguageDialog,
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.tealPale,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.language_rounded, color: AppColors.tealAccent, size: 18),
                        ),
                        title: Text(
                          AppStrings.get('selectLanguage'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          _getDisplayLanguageName(widget.selectedLanguage),
                          style: TextStyle(fontSize: 13, color: AppColors.primaryLight, fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.textMuted),
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
                            answerWidget: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "For queries, support, or feedback, feel free to reach out directly via WhatsApp, Instagram, or Email:",
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () => _launchContactUrl("https://wa.me/91varun_vs24"),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF25D366).withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFF25D366), size: 16),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("WhatsApp Support", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                                            Text("@varun_vs24", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () => _launchContactUrl("https://instagram.com/varun_vs205"),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(7),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE1306C).withValues(alpha: 0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(Icons.camera_alt_rounded, color: Color(0xFFE1306C), size: 16),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Instagram Direct", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                                            Text("@varun_vs205", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryLight)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Latest Release",
                                style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                          Text(
                            "v1.0.0",
                            style: TextStyle(
                              fontSize: 15,
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
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildFAQTile({
    required String question,
    String? answer,
    Widget? answerWidget,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        iconColor: AppColors.primary,
        collapsedIconColor: AppColors.textMuted,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: answerWidget ??
                Text(
                  answer ?? "",
                  style: TextStyle(
                    fontSize: 13.5,
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
