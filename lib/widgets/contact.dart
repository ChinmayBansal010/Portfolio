import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class GetInTouchSection extends StatelessWidget {
  const GetInTouchSection({super.key, required this.navbarKey});

  final GlobalKey navbarKey;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 940;

    return Container(
      key: navbarKey,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 32,
        vertical: isCompact ? 28 : 36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Container(
            padding: EdgeInsets.all(isCompact ? 22 : 28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.surfaceGlass, AppColors.backgroundElevated],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.borderStrong),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 24,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: isCompact
                ? const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ContactIntro(),
                      SizedBox(height: 22),
                      _ContactPrimaryCard(),
                      SizedBox(height: 16),
                      _ContactMetaRow(),
                      SizedBox(height: 16),
                      _ContactLinkGrid(),
                    ],
                  )
                : const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: _ContactIntro()),
                      SizedBox(width: 28),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _ContactPrimaryCard(),
                            SizedBox(height: 16),
                            _ContactMetaRow(),
                            SizedBox(height: 16),
                            _ContactLinkGrid(),
                          ],
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

class _ContactIntro extends StatelessWidget {
  const _ContactIntro();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mail_outline_rounded,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'CONTACT',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Let’s talk about AI, computer vision, or ML product work.',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.08,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Use email if you want to discuss a role, a build, or a research-heavy product idea. LinkedIn and GitHub are here for context.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: const [
            _SignalChip(text: 'AI systems'),
            _SignalChip(text: 'CV pipelines'),
            _SignalChip(text: 'ROS / robotics'),
            _SignalChip(text: 'ML product builds'),
          ],
        ),
      ],
    );
  }
}

class _SignalChip extends StatelessWidget {
  const _SignalChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ContactPrimaryCard extends StatelessWidget {
  const _ContactPrimaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surfaceAlt, AppColors.surfaceGlass],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accentSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradientStrong,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.email_outlined,
                  color: AppColors.background,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Best route',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'chinmay8521@gmail.com',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'For internships, collaborations, and project discussions.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _PrimaryContactAction(
                mode: _PrimaryContactMode.email,
                icon: Icons.send_rounded,
                label: 'Send Email',
              ),
              _PrimaryContactAction(
                mode: _PrimaryContactMode.copy,
                icon: Icons.copy_all_rounded,
                label: 'Copy Email',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum _PrimaryContactMode { email, copy }

class _PrimaryContactAction extends StatelessWidget {
  const _PrimaryContactAction({
    required this.mode,
    required this.icon,
    required this.label,
  });

  final _PrimaryContactMode mode;
  final IconData icon;
  final String label;

  Future<void> _handleTap(BuildContext context) async {
    const email = 'chinmay8521@gmail.com';
    if (mode == _PrimaryContactMode.copy) {
      await Clipboard.setData(const ClipboardData(text: email));
      return;
    }

    await launchUrl(
      Uri.parse('mailto:$email'),
      mode: LaunchMode.platformDefault,
    );
    await Clipboard.setData(const ClipboardData(text: email));
  }

  @override
  Widget build(BuildContext context) {
    final isPrimary = mode == _PrimaryContactMode.email;
    return InkWell(
      onTap: () => _handleTap(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: isPrimary ? AppColors.accentGradient : null,
          color: isPrimary
              ? null
              : AppColors.background.withValues(alpha: 0.34),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? Colors.transparent : AppColors.borderStrong,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isPrimary ? AppColors.background : AppColors.textPrimary,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isPrimary ? AppColors.background : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactMetaRow extends StatelessWidget {
  const _ContactMetaRow();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: const [
        _ContactMetaCard(title: 'Focus', value: 'AI, CV, ROS, backend'),
        _ContactMetaCard(title: 'Reply style', value: 'direct and technical'),
        _ContactMetaCard(title: 'Use case', value: 'roles, builds, collabs'),
      ],
    );
  }
}

class _ContactMetaCard extends StatelessWidget {
  const _ContactMetaCard({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactLinkGrid extends StatelessWidget {
  const _ContactLinkGrid();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _ContactLinkCard(
          icon: Icons.work_outline_rounded,
          title: 'LinkedIn',
          label: 'linkedin.com/in/bansalchinmay',
          url: 'https://www.linkedin.com/in/bansalchinmay',
        ),
        _ContactLinkCard(
          icon: Icons.code_rounded,
          title: 'GitHub',
          label: 'github.com/ChinmayBansal010',
          url: 'https://github.com/ChinmayBansal010',
        ),
      ],
    );
  }
}

class _ContactLinkCard extends StatefulWidget {
  const _ContactLinkCard({
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
  State<_ContactLinkCard> createState() => _ContactLinkCardState();
}

class _ContactLinkCardState extends State<_ContactLinkCard> {
  bool _isHovered = false;

  Future<void> _handleTap(BuildContext context) async {
    if (!await launchUrl(
          Uri.parse(widget.url),
          mode: LaunchMode.externalApplication,
        ) &&
        context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open link.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardWidth = width < 640 ? double.infinity : 260.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _handleTap(context),
        child: Transform.translate(
          offset: Offset(0, _isHovered ? -5 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: cardWidth,
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
                        color: AppColors.accentSoft.withValues(alpha: 0.16),
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
                    gradient: AppColors.accentGradientStrong,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(widget.icon, color: AppColors.background),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                          const Icon(
                            Icons.arrow_outward_rounded,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.label,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }
}
