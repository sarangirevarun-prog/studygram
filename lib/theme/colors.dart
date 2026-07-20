import 'package:flutter/material.dart';

/// ─── Studygram Design System ───────────────────────────────────────────────
/// A cohesive light theme palette built around Emerald Green + Slate neutrals.
///
/// Backgrounds  : Soft slate-grey tints (not mint) → clean, professional
/// Cards        : Pure white with crisp shadows
/// Primary      : Emerald 600/500 for buttons & active states
/// Text         : Rich charcoal → mid grey → light grey hierarchy
/// Accents      : Amber gold for scores/badges, sky blue for info
class AppColors {
  // ── Backgrounds ─────────────────────────────────────────────────────────
  /// Main scaffold background — very light warm slate, not pure white
  static const Color bgMain  = Color(0xFFF1F5F9);
  /// Card / surface background — pure white for elevation contrast
  static const Color bgCard  = Color(0xFFFFFFFF);
  /// Subtle card border — slate-tinted, not green-tinted
  static const Color borderCard = Color(0xFFE2E8F0);

  // ── Brand Primary — Emerald ──────────────────────────────────────────────
  /// Deep emerald — used for primary buttons, active nav, headings
  static const Color primary       = Color(0xFF059669);
  /// Mid emerald — icons, accent text, chip borders
  static const Color primaryLight  = Color(0xFF10B981);
  /// Very pale emerald — chip fills, card tints
  static const Color primaryPale   = Color(0xFFD1FAE5);
  /// Glow / shadow for emerald elements
  static final  Color primaryGlow  = const Color(0xFF059669).withValues(alpha: 0.18);

  // ── Brand Secondary — Amber / Gold ───────────────────────────────────────
  /// Amber — scores, highlight badges, star ratings
  static const Color accent     = Color(0xFFF59E0B);
  /// Pale amber fill for badges
  static const Color accentPale = Color(0xFFFEF3C7);

  // ── Text Hierarchy ───────────────────────────────────────────────────────
  /// Rich charcoal — headings, bold labels
  static const Color textPrimary   = Color(0xFF0F172A);
  /// Mid slate — body copy, descriptions
  static const Color textSecondary = Color(0xFF475569);
  /// Light slate — placeholders, timestamps, helper text
  static const Color textMuted     = Color(0xFF94A3B8);

  // ── Semantic / Functional ────────────────────────────────────────────────
  static const Color redDanger  = Color(0xFFEF4444);
  static const Color redPale    = Color(0xFFFEE2E2);
  static const Color blueInfo   = Color(0xFF3B82F6);
  static const Color bluePale   = Color(0xFFDBEAFE);
  static const Color tealAccent = Color(0xFF0D9488);
  static const Color tealPale   = Color(0xFFCCFBF1);

  // ── Outer device-frame canvas ────────────────────────────────────────────
  /// Desktop outer background behind the phone frame
  static const Color outerCanvas = Color(0xFF1E293B);
}
