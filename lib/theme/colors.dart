import 'package:flutter/material.dart';

/// ─── Studygram Design System ───────────────────────────────────────────────
/// A dynamic theme palette supporting both light and dark modes.
class AppColors {
  static bool isDark = false;

  // ── Backgrounds ─────────────────────────────────────────────────────────
  static Color get bgMain => isDark ? const Color(0xFF0B111E) : const Color(0xFFF1F5F9);
  static Color get bgCard => isDark ? const Color(0xFF172033) : const Color(0xFFFFFFFF);
  static Color get borderCard => isDark ? const Color(0xFF28354E) : const Color(0xFFE2E8F0);

  // ── Brand Primary — Emerald ──────────────────────────────────────────────
  static Color get primary => const Color(0xFF059669);
  static Color get primaryLight => const Color(0xFF10B981);
  static Color get primaryPale => isDark ? const Color(0xFF064E3B) : const Color(0xFFD1FAE5);
  static Color get primaryGlow => const Color(0xFF059669).withValues(alpha: 0.18);

  // ── Brand Secondary — Amber / Gold ───────────────────────────────────────
  static Color get accent => const Color(0xFFF59E0B);
  static Color get accentPale => isDark ? const Color(0xFF78350F) : const Color(0xFFFEF3C7);

  // ── Text Hierarchy ───────────────────────────────────────────────────────
  static Color get textPrimary => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);
  static Color get textSecondary => isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
  static Color get textMuted => isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

  // ── Semantic / Functional ────────────────────────────────────────────────
  static Color get redDanger => const Color(0xFFEF4444);
  static Color get redPale => isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
  static Color get blueInfo => const Color(0xFF3B82F6);
  static Color get bluePale => isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE);
  static Color get tealAccent => const Color(0xFF0D9488);
  static Color get tealPale => isDark ? const Color(0xFF115E59) : const Color(0xFFCCFBF1);

  // ── Outer device-frame canvas ────────────────────────────────────────────
  static Color get outerCanvas => const Color(0xFF0F172A); // Keep outer canvas dark slate
}
