import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';
import 'package:study_gram/widgets/ak_bot_drawer.dart';
import 'package:study_gram/services/ak_assistant_service.dart';

class AKFloatingButton extends StatefulWidget {
  final Map<String, dynamic> appContext;
  final Function(AKAction action) onExecuteAction;

  const AKFloatingButton({
    super.key,
    required this.appContext,
    required this.onExecuteAction,
  });

  @override
  State<AKFloatingButton> createState() => _AKFloatingButtonState();
}

class _AKFloatingButtonState extends State<AKFloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _openAKBot() {
    AKBotDrawer.show(
      context,
      appContext: widget.appContext,
      onExecuteAction: widget.onExecuteAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 85,
      right: 18,
      child: GestureDetector(
        onTap: _openAKBot,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final scale = 1.0 + (_pulseController.value * 0.08);
            final glow = 6.0 + (_pulseController.value * 8.0);
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryLight.withValues(alpha: 0.5),
                      blurRadius: glow,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 2),
                      const Text(
                        "AK",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
