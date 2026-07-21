import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/ambient_orbs.dart';

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
  String? _phoneError;   // null = no error visible

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
      if (_phoneError != null) {
        setState(() {
          _phoneError = digits.length == 10 ? null : _phoneError;
        });
      }
    });
  }

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
          padding: EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Country",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text("🇮🇳", style: TextStyle(fontSize: 24)),
                title: Text("India (+91)", style: TextStyle(color: AppColors.textPrimary)),
                onTap: () {
                  setState(() {
                    _selectedCountryCode = "+91";
                    _selectedFlag = "🇮🇳";
                  });
                  Navigator.pop(context);
                },
              ),
              Divider(height: 1, color: AppColors.borderCard),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text("🇺🇸", style: TextStyle(fontSize: 24)),
                title: Text("United States (+1)", style: TextStyle(color: AppColors.textPrimary)),
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
    return AmbientOrbs(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 52),
          // Logo & Branding
          Container(
            padding: EdgeInsets.all(18),
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
            child: Icon(
              Icons.school_rounded,
              color: AppColors.primaryLight,
              size: 56,
            ),
          ),
          SizedBox(height: 18),
          Text(
            "Studygram",
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 2),
          Text(
            "EDUCATION",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 4.0,
              color: AppColors.primaryLight,
            ),
          ),
          SizedBox(height: 44),
          // Greeting
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Welcome Learner..!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Let's continue your learning journey",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 28),
          // Phone Input Box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _phoneError != null
                    ? AppColors.redDanger
                    : AppColors.borderCard,
                width: _phoneError != null ? 2.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: _phoneError != null
                      ? AppColors.redDanger.withValues(alpha: 0.08)
                      : AppColors.primary.withValues(alpha: 0.04),
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
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                    child: Row(
                      children: [
                        Text(
                          _selectedFlag,
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 6),
                        Text(
                          _selectedCountryCode,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.textSecondary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(width: 1, height: 24, color: AppColors.borderCard),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    onChanged: (val) {
                      if (_phoneError != null) {
                        setState(() {
                          _phoneError = val.length == 10
                              ? null
                              : "Please enter a valid 10-digit mobile number.";
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Enter 10-digit mobile number",
                      hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      isDense: true,
                      counterText: "",   // hide the maxLength counter
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Inline error message ─────────────────────────────────────────
          if (_phoneError != null) ...[  
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 4),
                Icon(Icons.error_outline_rounded,
                    color: AppColors.redDanger, size: 15),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _phoneError!,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.redDanger,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 16),
          // Send OTP Button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                final phone = _phoneController.text.trim().replaceAll(RegExp(r'\D'), '');
                if (phone.length != 10) {
                  setState(() {
                    _phoneError = "Please enter a valid 10-digit mobile number.";
                  });
                  return;
                }
                setState(() => _phoneError = null);
                widget.onOtpSent("$_selectedCountryCode $phone");
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
              child: Row(
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
          SizedBox(height: 36),
          // Secure indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.primaryLight.withValues(alpha: 0.18)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified_user_outlined, color: AppColors.primaryLight, size: 14),
                SizedBox(width: 6),
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
          SizedBox(height: 48),
          Text(
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
    ),
    );
  }
}

