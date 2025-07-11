import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0A0A), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Made by Chinmay Bansal",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w500,
              color: const Color(0xFF00FFF0),
              shadows: [
                Shadow(
                  color: const Color(0x6600FFF0),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () async {
                final url = Uri.parse("https://github.com/ChinmayBansal010/Portfolio");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white.withAlpha(2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withAlpha(20),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.code,
                      size: 18,
                      color: Color(0xFF00FFF0),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "View this portfolio on GitHub",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.white70,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Built with Flutter & 💻 Open Source Spirit",
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'SpaceGrotesk',
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
