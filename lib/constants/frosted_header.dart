import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedHeaderWrapper extends StatelessWidget {
  final Widget child;
  final double height;
  final double blurSigma;
  final int backgroundAlpha; // from 0 to 255
  final bool enableShadow;
  final Color backgroundColor;

  const FrostedHeaderWrapper({
    super.key,
    required this.child,
    this.height = 60.0,
    this.blurSigma = 10.0,
    this.backgroundAlpha = 80, // About 30% transparency
    this.enableShadow = true,
    this.backgroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blurSigma,
            sigmaY: blurSigma,
          ),
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor.withAlpha(backgroundAlpha),
              boxShadow: enableShadow
                  ? [
                BoxShadow(
                  color: Colors.black.withAlpha(60),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
                  : [],
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
