import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Bounce-out scale animation for the logo
    _logoScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    // Smooth fade-in for the logo container
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    // Delayed fade-in for title/subtitle text
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.65, curve: Curves.easeIn),
      ),
    );

    // Linear progress bar loader animation matching 3 seconds
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgCard,
      body: Stack(
        children: [
          // Background soft gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: AppColors.isDark
                      ? const [
                          Color(0xFF0B111E), // Dark navy (bgMain)
                          Color(0xFF0F1A2E), // Slightly lighter navy
                          Color(0xFF0A1F1A), // Deep emerald tint
                        ]
                      : const [
                          Color(0xFFFFFFFF),
                          Color(0xFFF8FAFC), // Slate 50
                          Color(0xFFECFDF5), // Emerald 50 tint
                        ],
                ),
              ),
            ),
          ),
          // Centered logo and texts
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          width: 112,
                          height: 112,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryLight.withValues(alpha: 0.22),
                                blurRadius: 36,
                                spreadRadius: 6,
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
                      ),
                    ),
                    SizedBox(height: 24),
                    // Animated Brand Title
                    Opacity(
                      opacity: _textOpacity.value,
                      child: Column(
                        children: [
                          Text(
                            "Studygram",
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "EDUCATION",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 4.5,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    // Sleek progress bar indicator
                    Container(
                      height: 4,
                      width: 145,
                      decoration: BoxDecoration(
                        color: AppColors.borderCard,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Stack(
                        children: [
                          FractionallySizedBox(
                            widthFactor: _progressValue.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(alpha: 0.35),
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                     SizedBox(height: 18),
                    Text(
                      "Empowering Learning Journey",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
