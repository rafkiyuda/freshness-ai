import 'package:flutter/material.dart';

class AppColors {
  // Background
  static const bgMain = Color(0xFFF1F5F9);       // Page background (Slate 100)
  static const bgCard = Color(0xFFFFFFFF);        // Card background
  static const bgTertiary = Color(0xFFF8FAFC);    // Subtle inner bg (Slate 50)
  static const bgSidebar = Color(0xFF0F172A);     // Dark header/nav (Slate 900)

  // Typography
  static const textPrimary = Color(0xFF0F172A);   // Main text (Slate 900)
  static const textSecondary = Color(0xFF475569); // Secondary (Slate 600)
  static const textMuted = Color(0xFF64748B);     // Muted (Slate 500)
  static const textInverse = Color(0xFFFFFFFF);   // On dark backgrounds

  // Border
  static const borderColor = Color(0xFFE2E8F0);  // Default (Slate 200)
  static const borderFocus = Color(0xFF3B82F6);   // Focus ring (Blue 500)

  // Brand
  static const brandPrimary = Color(0xFF0090D7);  // KongsiLogi Blue
  static const brandHover = Color(0xFF007BB8);     // Hover
  static const accentPrimary = Color(0xFF01B5BD);  // KongsiLogi Teal

  // Status
  static const statusSuccess = Color(0xFF10B981); // Emerald 500 (FRESH)
  static const statusWarning = Color(0xFFF59E0B); // Amber 500 (WARNING)
  static const statusError = Color(0xFFEF4444);   // Red 500 (CRITICAL)

  // Freshness-specific
  static const freshGreen = Color(0xFF10B981);
  static const freshYellow = Color(0xFFF59E0B);
  static const freshRed = Color(0xFFEF4444);
}

class AppRadius {
  static const card = 20.0;
  static const input = 12.0;
  static const sm = 10.0;
  static const button = 12.0;
  static const chip = 8.0;
}

class AppShadows {
  static final card = [
    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 4)),
    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 3),
  ];
}
