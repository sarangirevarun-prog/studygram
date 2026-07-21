import 'package:flutter/material.dart';
import 'package:study_gram/theme/colors.dart';

/// Ambient corner glow orbs — decorative radial colour blobs placed at the
/// top-left and top-right (and optionally bottom) corners of a screen.
/// Completely non-interactive; lives behind all other content via a Stack.
class AmbientOrbs extends StatelessWidget {
  /// The content that sits on top of the orbs.
  final Widget child;

  /// Whether to also show a subtle orb at the bottom-right corner.
  final bool showBottomOrb;

  const AmbientOrbs({
    super.key,
    required this.child,
    this.showBottomOrb = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Orb: top-left — Emerald glow ─────────────────────────────────
        Positioned(
          top: -80,
          left: -80,
          child: _Orb(
            size: 240,
            color: AppColors.primaryLight.withValues(alpha: AppColors.isDark ? 0.15 : 0.10),
          ),
        ),

        // ── Orb: top-right — Amber/Gold glow ─────────────────────────────
        Positioned(
          top: -60,
          right: -80,
          child: _Orb(
            size: 200,
            color: AppColors.accent.withValues(alpha: AppColors.isDark ? 0.12 : 0.08),
          ),
        ),

        // ── Optional orb: bottom-right — Teal accent ─────────────────────
        if (showBottomOrb)
          Positioned(
            bottom: -100,
            right: -60,
            child: _Orb(
              size: 220,
              color: AppColors.tealAccent.withValues(alpha: AppColors.isDark ? 0.10 : 0.06),
            ),
          ),

        // ── Content on top ───────────────────────────────────────────────
        child,
      ],
    );
  }
}

/// A single soft radial-gradient glow circle.
class _Orb extends StatelessWidget {
  final double size;
  final Color color;

  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withValues(alpha: 0)],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}
