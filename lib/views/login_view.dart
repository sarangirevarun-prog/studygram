import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';

class LoginView extends StatefulWidget {
  final Function(String) onOtpSent;
  const LoginView({super.key, required this.onOtpSent});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _phoneController = TextEditingController();
  String _selectedCountryCode = "+91";
  String _selectedFlag = "🇮🇳";

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showCountrySelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Country",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Text("🇮🇳", style: TextStyle(fontSize: 24)),
                title: const Text("India (+91)", style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  setState(() {
                    _selectedCountryCode = "+91";
                    _selectedFlag = "🇮🇳";
                  });
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1, color: Color(0xFFE2E8F0)),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)),
                title: const Text("United States (+1)", style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  setState(() {
                    _selectedCountryCode = "+1";
                    _selectedFlag = "🇺🇸";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 52),
          // Logo & Branding
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primaryPale,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPale,
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.school_rounded,
              color: AppColors.primaryLight,
              size: 56,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "Studygram",
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            "EDUCATION",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 4.0,
              color: AppColors.primaryLight,
            ),
          ),
          const SizedBox(height: 44),
          // Greeting
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Welcome Back!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Let's continue your learning journey",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 28),
          // Phone Input Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderCard, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Country Code Picker
                InkWell(
                  onTap: _showCountrySelector,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                    child: Row(
                      children: [
                        Text(
                          _selectedFlag,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _selectedCountryCode,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(width: 1, height: 24, color: AppColors.borderCard),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Enter your mobile number",
                      hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          // Send OTP Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                final phone = _phoneController.text.trim();
                if (phone.isNotEmpty) {
                  widget.onOtpSent("$_selectedCountryCode $phone");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AppColors.primaryLight.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Send OTP",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 36),
          // Secure indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.18)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user_outlined, color: AppColors.primaryLight, size: 14),
                const SizedBox(width: 6),
                Text(
                  "YOUR DATA IS 100% SECURE",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                    color: AppColors.primaryLight.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            "Privacy Policy  |  Terms of Service",
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textMuted,
              decoration: TextDecoration.underline,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

