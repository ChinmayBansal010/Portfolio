import 'package:flutter/material.dart';

class NavigationHelper {
  static Future<void> scrollToSection({
    required BuildContext context,
    required int navIndex,
    required List<GlobalKey> navbarKeys,
  }) async {
    await Future.delayed(const Duration(milliseconds: 50));

    if (!context.mounted || navIndex >= navbarKeys.length) {
      return;
    }

    final key = navbarKeys[navIndex];
    if (key.currentContext != null) {
      await Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
        alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    }
  }
}
