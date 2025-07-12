import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavigationHelper {
  static Future<void> scrollToSection({
    required BuildContext context,
    required int navIndex,
    required List<GlobalKey> navbarKeys,
  }) async {
    if (navIndex == 3) {
      final url = Uri.parse("https://chinmaybansal.hashnode.dev");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        return;
      }
    }

    await Future.delayed(Duration(milliseconds: 50));

    if (!context.mounted) return; // ✅ THIS is important

    if (navIndex < navbarKeys.length) {
      final key = navbarKeys[navIndex];
      if (key.currentContext != null) {
        Scrollable.ensureVisible(
          key.currentContext!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }
}
