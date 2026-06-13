import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:portfolio/constants/colors.dart';

class FrostedHeaderWrapper extends StatelessWidget {
  const FrostedHeaderWrapper({
    super.key,
    required this.child,
    this.height = 80.0,
    this.blurSigma = 24.0,
    this.backgroundAlpha = 88,
    this.enableShadow = false,
    this.enableBorder = true,
    this.backgroundColor = AppColors.background,
  });

  final Widget child;
  final double height;
  final double blurSigma;
  final int backgroundAlpha;
  final bool enableShadow;
  final bool enableBorder;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            // Slightly lighter at top, heavier at bottom — mimics depth
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                backgroundColor.withValues(alpha: backgroundAlpha / 255 * 0.85),
                backgroundColor.withValues(alpha: backgroundAlpha / 255),
              ],
            ),
            border: enableBorder
                ? Border(
              bottom: BorderSide(
                // Gradient border via a thin line — accent-tinted, not flat white
                color: AppColors.borderStrong.withValues(alpha: 0.18),
                width: 1.0,
              ),
            )
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}