import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/ambient_orbs.dart';
import 'package:study_gram/widgets/swipe_back.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  final Function(String email, String name) onEmailLoggedIn;
  final VoidCallback onBackToLoginTap;

  const RegisterView({
    super.key,
    required this.onEmailLoggedIn,
    required this.onBackToLoginTap,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _nameError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      if (_nameError != null) {
        setState(() => _nameError = null);
      }
    });

    _emailController.addListener(() {
      if (_emailError != null) {
        setState(() => _emailError = null);
      }
    });

    _passwordController.addListener(() {
      if (_passwordError != null) {
        setState(() => _passwordError = null);
      }
      if (_confirmPasswordError != null &&
          _confirmPasswordController.text == _passwordController.text) {
        setState(() => _confirmPasswordError = null);
      }
    });

    _confirmPasswordController.addListener(() {
      if (_confirmPasswordError != null) {
        setState(() => _confirmPasswordError = null);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegisterSubmit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    bool hasError = false;

    if (name.isEmpty) {
      setState(() => _nameError = "Please enter your full name.");
      hasError = true;
    }
    if (!email.contains('@') || email.length < 5) {
      setState(() => _emailError = "Please enter a valid email address.");
      hasError = true;
    }
    if (password.length < 6) {
      setState(() => _passwordError = "Password must be at least 6 characters.");
      hasError = true;
    }
    if (confirmPassword != password) {
      setState(() => _confirmPasswordError = "Passwords do not match.");
      hasError = true;
    }

    if (hasError) return;

    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _isLoading = true;
    });

    try {
      // Register Account
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
      }
      
      // Log in Firestore
      try {
        await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': DateTime.now().toIso8601String(),
        });
      } catch (_) {}

      widget.onEmailLoggedIn(email, name);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = e.message ?? e.code;
      if (e.code == 'email-already-in-use') {
        message = "This email is already registered. Please go back and Sign In.";
      } else if (e.code == 'invalid-email') {
        message = "Please enter a valid email address.";
      } else if (e.code == 'weak-password') {
        message = "The password is too weak. Please use a stronger password.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.redDanger,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.redDanger,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecorationTheme = InputDecoration(
      filled: true,
      fillColor: AppColors.bgCard,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.borderCard, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.primaryLight, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.redDanger, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: AppColors.redDanger, width: 2.0),
      ),
      hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 16),
      prefixIconColor: AppColors.textMuted,
      suffixIconColor: AppColors.textMuted,
    );

    return SwipeBackWrapper(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.bgMain,
          body: AmbientOrbs(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  // Back Button to Login
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: widget.onBackToLoginTap,
                      icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 24),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Logo & Branding
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPale,
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        "assets/logo/sglogo.jpeg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Studygram",
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Greeting Context
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Sign up to start saving and learning",
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name Field
                  TextField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    decoration: inputDecorationTheme.copyWith(
                      hintText: "Enter your full name",
                      prefixIcon: const Icon(Icons.person_rounded, size: 20),
                      errorText: _nameError,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    decoration: inputDecorationTheme.copyWith(
                      hintText: "Enter your email",
                      prefixIcon: const Icon(Icons.email_rounded, size: 20),
                      errorText: _emailError,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    decoration: inputDecorationTheme.copyWith(
                      hintText: "Enter password",
                      prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      errorText: _passwordError,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                    decoration: inputDecorationTheme.copyWith(
                      hintText: "Confirm password",
                      prefixIcon: const Icon(Icons.lock_rounded, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, size: 20),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      errorText: _confirmPasswordError,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Register Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegisterSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primaryLight.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Create Account",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Link back to Sign In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                      ),
                      GestureDetector(
                        onTap: widget.onBackToLoginTap,
                        child: Text(
                          "Sign In",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
