import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class GetInTouchSection extends StatelessWidget {
  const GetInTouchSection({super.key, required this.navbarKey});

  final GlobalKey navbarKey;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 800;

    return Container(
      key: navbarKey,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 32,
        vertical: isCompact ? 48 : 62,
      ),
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Container(
            padding: EdgeInsets.all(isCompact ? 22 : 30),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.surfaceGlass, AppColors.backgroundElevated],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.borderStrong),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.78),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.borderStrong),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.chat_outlined,
                        size: 16,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'CONTACT',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.textSecondary,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  "Let's discuss a product, internship, or collaboration opportunity.",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.12,
                    letterSpacing: -0.8,
                  ),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 780),
                  child: Text(
                    'If you want someone who can think through UI, implementation details, and ML-backed features in the same workflow, reach out here.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.7,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    _ContactButton(
                      icon: Icons.email_outlined,
                      title: 'Email',
                      label: 'chinmay8521@gmail.com',
                      url: 'mailto:chinmay8521@gmail.com',
                    ),
                    _ContactButton(
                      icon: Icons.work_outline_rounded,
                      title: 'LinkedIn',
                      label: 'linkedin.com/in/xenoryx',
                      url: 'https://linkedin.com/in/xenoryx',
                    ),
                    _ContactButton(
                      icon: Icons.code_rounded,
                      title: 'GitHub',
                      label: 'github.com/ChinmayBansal010',
                      url: 'https://github.com/ChinmayBansal010',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactButton extends StatefulWidget {
  const _ContactButton({
    required this.icon,
    required this.title,
    required this.label,
    required this.url,
  });

  final IconData icon;
  final String title;
  final String label;
  final String url;

  @override
  State<_ContactButton> createState() => _ContactButtonState();
}

class _ContactButtonState extends State<_ContactButton> {
  bool _isHovered = false;

  Future<void> _handleTap() async {
    final uri = Uri.parse(widget.url);

    if (widget.url.startsWith('mailto:')) {
      final clipboardData = ClipboardData(text: widget.label);
      try {
        final launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
        await Clipboard.setData(clipboardData);
        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email copied to clipboard.')),
          );
        }
      } catch (_) {
        await Clipboard.setData(clipboardData);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email copied to clipboard.')),
          );
        }
      }
      return;
    }

    if (!await launchUrl(uri, mode: LaunchMode.platformDefault) && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: _handleTap,
          child: Transform.translate(
            offset: Offset(0, _isHovered ? -4 : 0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 320,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: _isHovered
                    ? AppColors.surface
                    : AppColors.background.withValues(alpha: 0.34),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: _isHovered ? AppColors.accentSoft : AppColors.border,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.accentSoft.withValues(alpha: 0.14),
                          blurRadius: 20,
                          offset: const Offset(0, 12),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(widget.icon, color: AppColors.background),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.label,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                height: 1.5,
                              ),
                        ),
                      ],
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
