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
    final keyContext = key.currentContext;
    if (keyContext != null) {
      final renderBox = keyContext.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);

      final scrollable = Scrollable.of(keyContext);
      final currentOffset = scrollable.position.pixels;

      final targetOffset = currentOffset + position.dy - 100.0;

      await scrollable.position.animateTo(
        targetOffset.clamp(0, scrollable.position.maxScrollExtent),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }
}
