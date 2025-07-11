import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GetInTouchSection extends StatelessWidget {
  final GlobalKey navbarKey;
  const GetInTouchSection({super.key, required this.navbarKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: navbarKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0A0A), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Get in Touch",
            style: TextStyle(
              fontSize: 30,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00FFF0),
              shadows: [
                Shadow(
                  color: const Color(0x8800FFF0),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Have a project in mind, a question to ask, or just want to connect?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          const SizedBox(height: 36),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: const [
              _ContactButton(
                icon: Icons.email,
                label: "chinmay8521@gmail.com",
                url: "mailto:chinmay8521@gmail.com",
              ),
              _ContactButton(
                icon: Icons.alternate_email,
                label: "ChinmayB010",
                url: "https://twitter.com/ChinmayB010",
              ),
              _ContactButton(
                icon: Icons.link,
                label: "LinkedIn",
                url: "https://linkedin.com/in/xenoryx",
              ),
              _ContactButton(
                icon: Icons.code,
                label: "GitHub",
                url: "https://github.com/ChinmayBansal010",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(_isHovered ? 1.05 : 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: _isHovered
                ? const LinearGradient(
              colors: [Color(0xFF00FFF0), Color(0xFF9F00FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            border: Border.all(color: const Color(0xFF00FFF0), width: 1.2),
            color: _isHovered ? Colors.white.withAlpha(3) : Colors.white.withAlpha(15),
            boxShadow: _isHovered
                ? [
              const BoxShadow(
                color: Color(0xAA00FFF0),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
              const BoxShadow(
                color: Color(0x669F00FF),
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 20, color: const Color(0xFF00FFF0)),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
