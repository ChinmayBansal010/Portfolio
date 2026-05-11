import 'package:flutter/material.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border.withValues(alpha: 0.3))),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _SocialIcon(icon: Icons.code_rounded, url: "https://github.com/ChinmayBansal010"),
              const SizedBox(width: 20),
              _SocialIcon(icon: Icons.work_outline_rounded, url: "https://linkedin.com/in/xenoryx"),
              const SizedBox(width: 20),
              _SocialIcon(icon: Icons.mail_outline_rounded, url: "mailto:chinmay8521@gmail.com"),
            ],
          ),
          const SizedBox(height: 32),
          const Text(
            'DESIGNED & ENGINEERED BY CHINMAY BANSAL',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 16),
          const _GitHubButton(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterBadge(label: "FLUTTER 3.29"),
              const SizedBox(width: 12),
              _FooterBadge(label: "DART 3.7"),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '© ${DateTime.now().year} — All rights reserved',
            style: const TextStyle(
              fontSize: 11,
              fontFamily: 'SpaceGrotesk',
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatefulWidget {
  const _SocialIcon({required this.icon, required this.url});
  final IconData icon;
  final String url;

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: IconButton(
        onPressed: () => launchUrl(Uri.parse(widget.url)),
        icon: Icon(
          widget.icon,
          color: _isHovered ? AppColors.accent : AppColors.textSecondary,
          size: 24,
        ),
      ),
    );
  }
}

class _FooterBadge extends StatelessWidget {
  const _FooterBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

class _GitHubButton extends StatefulWidget {
  const _GitHubButton();

  @override
  State<_GitHubButton> createState() => _GitHubButtonState();
}

class _GitHubButtonState extends State<_GitHubButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final url = Uri.parse(
            'https://github.com/ChinmayBansal010/Portfolio',
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
        child: Transform.translate(
          offset: Offset(0, _isHovered ? -3 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.surface
                  : AppColors.background.withValues(alpha: 0.32),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _isHovered ? AppColors.accentSoft : AppColors.border,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.code_rounded,
                  size: 18,
                  color: _isHovered
                      ? AppColors.accent
                      : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'View this portfolio on GitHub',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    color: _isHovered
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
