import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF08111F);
  static const Color backgroundElevated = Color(0xFF0D1728);
  static const Color surface = Color(0xFF111D31);
  static const Color surfaceAlt = Color(0xFF17253B);
  static const Color surfaceGlass = Color(0xCC13233B);
  static const Color border = Color(0xFF273B5B);
  static const Color borderStrong = Color(0xFF3A547B);
  static const Color accent = Color(0xFF5EEAD4);
  static const Color accentSoft = Color(0xFF22C7E6);
  static const Color accentSecondary = Color(0xFF7C9CFF);
  static const Color accentWarm = Color(0xFFF7C984);
  static const Color textPrimary = Color(0xFFF4F7FB);
  static const Color textSecondary = Color(0xFFC0CDDE);
  static const Color textMuted = Color(0xFF90A3BD);
  static const Color success = Color(0xFF6EE7B7);

  static const LinearGradient pageGlow = LinearGradient(
    colors: [Color(0xFF0D1728), Color(0xFF08111F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentSoft],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradientStrong = LinearGradient(
    colors: [accent, accentSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
