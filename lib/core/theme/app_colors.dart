import 'package:flutter/material.dart';

/// Palette de couleurs SaveBabe
/// Convertie depuis les tokens OKLCH du projet Lovable (styles.css)
abstract final class AppColors {
  // ── Primary ────────────────────────────────────────────────
  static const Color primary = Color(0xFF3B57D4);
  static const Color primaryForeground = Color(0xFFFAFAFA);
  static const Color primaryDark = Color(0xFF7B93E8);
  static const Color primaryForegroundDark = Color(0xFF1A2035);

  // ── Secondary ──────────────────────────────────────────────
  static const Color secondary = Color(0xFFE8EDFB);
  static const Color secondaryForeground = Color(0xFF2E4099);
  static const Color secondaryDark = Color(0xFF2D3A6B);
  static const Color secondaryForegroundDark = Color(0xFFCDD5F5);

  // ── Accent (rose pâle) ─────────────────────────────────────
  static const Color accent = Color(0xFFFAEAF0);
  static const Color accentForeground = Color(0xFFB5385E);
  static const Color accentDark = Color(0xFF4A2235);
  static const Color accentForegroundDark = Color(0xFFE8A0BB);

  // ── Pink ───────────────────────────────────────────────────
  static const Color pink = Color(0xFFE0557F);
  static const Color pinkDark = Color(0xFFE87BA0);

  // ── Success ────────────────────────────────────────────────
  static const Color success = Color(0xFF3DAB6A);
  static const Color successSoft = Color(0xFFE2F5EC);
  static const Color successDark = Color(0xFF5DC98A);
  static const Color successSoftDark = Color(0xFF1A3D2B);

  // ── Destructive ────────────────────────────────────────────
  static const Color destructive = Color(0xFFD94F2A);
  static const Color destructiveForeground = Color(0xFFFAFAFA);
  static const Color destructiveDark = Color(0xFFE87055);
  static const Color destructiveForegroundDark = Color(0xFFFAFAFA);

  // ── Background / Card ──────────────────────────────────────
  static const Color background = Color(0xFFF3F5FB);
  static const Color card = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1C2040);
  static const Color cardDark = Color(0xFF262C52);

  // ── Foreground / Text ──────────────────────────────────────
  static const Color foreground = Color(0xFF1E2A5E);
  static const Color foregroundDark = Color(0xFFF0F2FA);
  static const Color mutedForeground = Color(0xFF7A85A8);
  static const Color mutedForegroundDark = Color(0xFF9BA5CC);

  // ── Muted ──────────────────────────────────────────────────
  static const Color muted = Color(0xFFECEFF8);
  static const Color mutedDark = Color(0xFF252B50);

  // ── Border / Input ─────────────────────────────────────────
  static const Color border = Color(0xFFDEE3F4);
  static const Color input = Color(0xFFDEE3F4);
  static const Color borderDark = Color(0x1AFFFFFF);
  static const Color inputDark = Color(0x26FFFFFF);

  // ── Ring (focus) ───────────────────────────────────────────
  static const Color ring = Color(0xFF3B57D4);
  static const Color ringDark = Color(0xFF7B93E8);

  // ── Shadow ─────────────────────────────────────────────────
  static const Color primaryShadow = Color(0x403B57D4);
  static const Color cardShadow = Color(0x0A1E2A5E);

  // ── Aliases de commodité ───────────────────────────────────
  static const Color darkPrimary = primaryDark;
  static const Color darkCard = cardDark;
  static const Color cardForeground = foreground;
  static const Color darkCardForeground = foregroundDark;
  static const Color darkMutedForeground = mutedForegroundDark;
  static const Color darkBorder = borderDark;
  static const Color darkPink = pinkDark;
}
