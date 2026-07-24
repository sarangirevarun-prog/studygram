import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/ambient_orbs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginView extends StatefulWidget {
  final Function(String email, String name) onEmailLoggedIn;
  final VoidCallback onCreateAccountTap;

  const LoginView({
    super.key,
    required this.onEmailLoggedIn,
    required this.onCreateAccountTap,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      if (_emailError != null && _emailController.text.contains('@')) {
        setState(() {
          _emailError = null;
        });
      }
    });

    _passwordController.addListener(() {
      if (_passwordError != null && _passwordController.text.length >= 6) {
        setState(() {
          _passwordError = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailSubmit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (!email.contains('@') || email.length < 5) {
      setState(() => _emailError = "Please enter a valid email address.");
      return;
    }
    if (password.length < 6) {
      setState(() => _passwordError = "Password must be at least 6 characters.");
      return;
    }

    setState(() {
      _emailError = null;
      _passwordError = null;
      _isLoading = true;
    });

    try {
      // Log In
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final displayName = credential.user?.displayName ?? email.split('@')[0];
      widget.onEmailLoggedIn(email, displayName);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      String message = e.message ?? e.code;
      if (e.code == 'invalid-credential' || e.code == 'user-not-found' || e.code == 'wrong-password') {
        message = "Incorrect password or account does not exist. If you don't have an account, tap 'Create Account' below to sign up.";
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

  Future<void> _handleForgotPassword() async {
    final email = _emailController.text.trim();
    if (!email.contains('@')) {
      setState(() => _emailError = "Please enter your email to request reset link.");
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password reset email sent! Check your inbox."),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to send reset email: ${e.toString()}"),
            backgroundColor: AppColors.redDanger,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        widget.onEmailLoggedIn(user.email ?? "", user.displayName ?? "Learner");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Google Sign-In failed: ${e.toString()}"),
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

    return AmbientOrbs(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 52),
            // Logo & Branding
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPale,
                    blurRadius: 24,
                    spreadRadius: 4,
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
            const SizedBox(height: 18),
            Text(
              "Studygram",
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "EDUCATION",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 4.0,
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 44),

            // Greeting Context
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome Learner..!",
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
                "Sign in using email and password",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 24),

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

            // Forgot Password Option
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLoading ? null : _handleForgotPassword,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryLight),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleEmailSubmit,
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
                            "Sign In",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Divider OR
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.borderCard, thickness: 1.5)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "OR",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMuted),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.borderCard, thickness: 1.5)),
              ],
            ),
            const SizedBox(height: 20),

            // Google Sign-In Button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: _isLoading ? null : _handleGoogleSignIn,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.borderCard, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: AppColors.bgCard,
                  foregroundColor: AppColors.textPrimary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "G",
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Continue with Google",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Toggle Sign In vs Sign Up
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account? ",
                  style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                ),
                GestureDetector(
                  onTap: widget.onCreateAccountTap,
                  child: Text(
                    "Create Account",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

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
                  Icon(Icons.verified_user_outlined, color: AppColors.primaryLight, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    "YOUR DATA IS 100% SECURE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                      color: AppColors.primaryLight.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            Text(
              "Privacy Policy  |  Terms of Service",
              style: TextStyle(
                fontSize: 13,
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
