import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class GetInTouchSection extends StatelessWidget {
  final GlobalKey navbarKey;
  const GetInTouchSection({super.key, required this.navbarKey});

  @override
  Widget build(BuildContext context) {
    final isMobileSmall = MediaQuery.of(context).size.width < 450;
    final TextTheme textTheme = Theme.of(context).textTheme;

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
            style: textTheme.displayLarge?.copyWith(
              color: const Color(0xFF00FFF0),
              shadows: const [
                Shadow(
                  color: Color(0x8800FFF0),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Have a project in mind, a question to ask, or just want to connect?",
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 36),
          Wrap(
            direction: isMobileSmall ? Axis.vertical : Axis.horizontal,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 20,
            runSpacing: 20,
            children: const [
              _ContactButton(
                icon: Icons.email,
                label: "chinmay8521@gmail.com",
                url: "mailto:chinmay8521@gmail.com",
                color: Color(0xFF00FFF0),
              ),
              _ContactButton(
                icon: Icons.alternate_email,
                label: "@ChinmayB010",
                url: "https://twitter.com/ChinmayB010",
                color: Color(0xFF9F00FF),
              ),
              _ContactButton(
                icon: Icons.link,
                label: "LinkedIn",
                url: "https://linkedin.com/in/xenoryx",
                color: Color(0xFF00FFF0),
              ),
              _ContactButton(
                icon: Icons.code,
                label: "GitHub",
                url: "https://github.com/ChinmayBansal010",
                color: Color(0xFF9F00FF),
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
  final Color color;

  const _ContactButton({
    required this.icon,
    required this.label,
    required this.url,
    required this.color,
  });

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _isHovered = false;

  Future<void> _handleTap() async {
    final Uri uri = Uri.parse(widget.url);

    if (widget.url.startsWith("mailto:")) {
      try {
        if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          // Launched successfully
        } else {
          await Clipboard.setData(ClipboardData(text: widget.label));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Email copied to clipboard!",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Color(0xFF00FFF0),
              ),
            );
          }
        }
      } catch (e) {
        await Clipboard.setData(ClipboardData(text: widget.label));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Failed to open email client. Email copied!",
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Color(0xFF00FFF0),
            ),
          );
        }
      }
    } else {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Could not launch link.",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _handleTap,
          child: Tooltip(
            message: 'Click to open/copy: ${widget.label}',
            waitDuration: const Duration(milliseconds: 400),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()..scale(_isHovered ? 1.08 : 1.0),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: _isHovered
                    ? LinearGradient(
                  colors: [widget.color, const Color(0xFF9F00FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                border: Border.all(
                  color: _isHovered ? Colors.transparent : widget.color,
                  width: 1.5,
                ),
                color: _isHovered
                    ? Colors.transparent
                    : const Color.fromARGB(20, 255, 255, 255),
                boxShadow: _isHovered
                    ? [
                  BoxShadow(
                    color: widget.color.withAlpha(0xAA),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: const Color(0x669F00FF),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.icon, size: 22, color: _isHovered ? Colors.black : widget.color),
                  const SizedBox(width: 12),
                  Text(
                    widget.label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _isHovered ? Colors.black : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}