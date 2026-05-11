import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedHeaderWrapper extends StatelessWidget {
  final Widget child;
  final double height;
  final double blurSigma;
  final int backgroundAlpha;
  final bool enableShadow;
  final bool enableBorder;
  final Color backgroundColor;

  const FrostedHeaderWrapper({
    super.key,
    required this.child,
    this.height = 80.0,
    this.blurSigma = 10.0,
    this.backgroundAlpha = 30,
    this.enableShadow = true,
    this.enableBorder = false,
    this.backgroundColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: backgroundColor.withAlpha(backgroundAlpha),
              border: enableBorder
                  ? Border(
                    bottom: BorderSide(
                      color: Colors.white.withAlpha(20),
                      width: 1.0,
                    ),
                  )
                  : null,
              boxShadow:
                  enableShadow
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
