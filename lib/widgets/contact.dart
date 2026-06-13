import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/nav_items.dart';

class GetInTouchSection extends StatelessWidget {
  const GetInTouchSection({super.key, required this.navbarKey});

  final GlobalKey navbarKey;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 860;

    return Container(
      key: navbarKey,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 24 : 64,
        vertical: isCompact ? 56 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: isCompact
              ? _CompactLayout()
              : _DesktopLayout(),
        ),
      ),
    );
  }
}

// ── Desktop: left headline + right action panel ─────────────────────────────
class _DesktopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _LeftColumn(),
        ),
        const SizedBox(width: 64),
        Expanded(
          flex: 4,
          child: _RightPanel(),
        ),
      ],
    );
  }
}

// ── Mobile: stacked ──────────────────────────────────────────────────────────
class _CompactLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LeftColumn(),
        const SizedBox(height: 48),
        _RightPanel(),
      ],
    );
  }
}

// ── Left: headline, subtext, topic chips ────────────────────────────────────
class _LeftColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 860;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Availability pill
        _AvailabilityBadge()
            .animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),

        SizedBox(height: isCompact ? 20 : 28),

        // Headline
        Text(
          'Got an idea?\nLet\'s talk.',
          style: TextStyle(
            fontSize: isCompact ? 42 : 60,
            fontWeight: FontWeight.w900,
            height: 1.0,
            letterSpacing: isCompact ? -1.5 : -2.0,
            color: AppColors.textPrimary,
          ),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 80.ms)
            .slideY(begin: 0.07, end: 0, curve: Curves.easeOutCubic),

        SizedBox(height: isCompact ? 16 : 20),

        Text(
          'Open to internships, freelance builds, and research-heavy collaborations — especially in AI, computer vision, and robotics.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isCompact ? 14.5 : 16,
            height: 1.68,
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 140.ms),

        SizedBox(height: isCompact ? 28 : 36),

        // Topic chips — what you care about
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _TopicChip(label: 'AI systems'),
            _TopicChip(label: 'CV pipelines'),
            _TopicChip(label: 'ROS / robotics'),
            _TopicChip(label: 'ML products'),
          ],
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 200.ms),

        // Response time note — quiet, below chips
        SizedBox(height: isCompact ? 20 : 24),
        Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 13,
              color: AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              'Replies within 24 hours',
              style: TextStyle(
                fontSize: 12.5,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 250.ms),
      ],
    );
  }
}

// ── Right: email card + social links ────────────────────────────────────────
class _RightPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _EmailCard()
            .animate()
            .fadeIn(duration: 600.ms, delay: 100.ms)
            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

        const SizedBox(height: 16),

        _SocialRow()
            .animate()
            .fadeIn(duration: 500.ms, delay: 200.ms),
      ],
    );
  }
}

// ── Availability badge ───────────────────────────────────────────────────────
class _AvailabilityBadge extends StatefulWidget {
  @override
  State<_AvailabilityBadge> createState() => _AvailabilityBadgeState();
}

class _AvailabilityBadgeState extends State<_AvailabilityBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF16A34A).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF16A34A).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (_, _) => Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.lerp(
                  const Color(0xFF22C55E),
                  const Color(0xFF16A34A),
                  _pulse.value,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF22C55E)
                        .withValues(alpha: 0.5 * (1 - _pulse.value)),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Available for work',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF22C55E),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Topic chips ──────────────────────────────────────────────────────────────
class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderStrong.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

// ── Email card — the dominant action ────────────────────────────────────────
class _EmailCard extends StatefulWidget {
  @override
  State<_EmailCard> createState() => _EmailCardState();
}

class _EmailCardState extends State<_EmailCard> {
  bool _copied = false;

  Future<void> _copyEmail() async {
    await Clipboard.setData(
      const ClipboardData(text: 'chinmay8521@gmail.com'),
    );
    setState(() => _copied = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) setState(() => _copied = false);
  }

  Future<void> _sendEmail() async {
    await launchUrl(
      Uri.parse('mailto:chinmay8521@gmail.com'),
      mode: LaunchMode.platformDefault,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surfaceGlass, AppColors.backgroundElevated],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + label row
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradientStrong,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.mail_outline_rounded,
                  color: AppColors.background,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Best way to reach me',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Email address — large, selectable
          SelectableText(
            'chinmay8521@gmail.com',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),

          const SizedBox(height: 20),

          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Two action buttons
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  label: 'Send email',
                  icon: Icons.send_rounded,
                  isPrimary: true,
                  onTap: _sendEmail,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _ActionButton(
                  label: _copied ? 'Copied!' : 'Copy',
                  icon: _copied
                      ? Icons.check_rounded
                      : Icons.copy_outlined,
                  isPrimary: false,
                  onTap: _copyEmail,
                  confirmed: _copied,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.onTap,
    this.confirmed = false,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback onTap;
  final bool confirmed;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final Color fg = widget.isPrimary
        ? AppColors.background
        : widget.confirmed
        ? const Color(0xFF22C55E)
        : AppColors.textPrimary;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: widget.isPrimary ? AppColors.accentGradient : null,
            color: widget.isPrimary
                ? null
                : widget.confirmed
                ? const Color(0xFF16A34A).withValues(alpha: 0.1)
                : AppColors.surface.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: widget.isPrimary
                ? null
                : Border.all(
              color: widget.confirmed
                  ? const Color(0xFF22C55E).withValues(alpha: 0.4)
                  : AppColors.borderStrong.withValues(alpha: 0.5),
            ),
            boxShadow: _hovered && widget.isPrimary
                ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 15, color: fg),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Social row — GitHub + LinkedIn as quiet secondary links ─────────────────
class _SocialRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _SocialCard(
            icon: Icons.code_rounded,
            platform: 'GitHub',
            handle: 'ChinmayBansal010',
            url: 'https://github.com/ChinmayBansal010',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SocialCard(
            icon: Icons.work_outline_rounded,
            platform: 'LinkedIn',
            handle: 'bansalchinmay',
            url: 'https://www.linkedin.com/in/bansalchinmay',
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SocialCard(
            icon: Icons.auto_stories_rounded,
            platform: 'Blog',
            handle: 'hashnode',
            url: blogUrl,
          ),
        ),
      ],
    );
  }
}

class _SocialCard extends StatefulWidget {
  const _SocialCard({
    required this.icon,
    required this.platform,
    required this.handle,
    required this.url,
  });

  final IconData icon;
  final String platform;
  final String handle;
  final String url;

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(
          Uri.parse(widget.url),
          mode: LaunchMode.externalApplication,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.surface
                : AppColors.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withValues(alpha: 0.3)
                  : AppColors.borderStrong.withValues(alpha: 0.3),
            ),
            boxShadow: _hovered
                ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
                : [],
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: _hovered ? AppColors.accent : AppColors.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.platform,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _hovered
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        letterSpacing: 0.1,
                      ),
                    ),
                    Text(
                      widget.handle,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_outward_rounded,
                size: 13,
                color: _hovered
                    ? AppColors.accent
                    : AppColors.textMuted.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}