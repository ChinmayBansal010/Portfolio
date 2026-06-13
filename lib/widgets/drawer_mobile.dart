import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/nav_items.dart';
import 'package:portfolio/widgets/site_logo.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({super.key, required this.onNavItemTap});

  final Function(int) onNavItemTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.88,
      child: Container(
        decoration: BoxDecoration(
          // Deep, near-opaque background — the nebula shows faintly through
          color: AppColors.background.withValues(alpha: 0.97),
          border: Border(
            left: BorderSide(
              color: AppColors.accent.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ───────────────────────────────────────────────
              _DrawerHeader()
                  .animate()
                  .fadeIn(duration: 280.ms)
                  .slideX(begin: 0.06, end: 0, curve: Curves.easeOut),

              // ── Nav items ─────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    children: navTitles.asMap().entries.map((e) {
                      final i = e.key;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: _NavItem(
                          index: i,
                          icon: navIcons[i],
                          label: navTitles[i],
                          onTap: () {
                            Navigator.of(context).pop();
                            onNavItemTap(i);
                          },
                        )
                            .animate()
                            .fadeIn(
                          duration: 340.ms,
                          delay: (60 + i * 55).ms,
                        )
                            .slideX(
                          begin: 0.07,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // ── Footer ────────────────────────────────────────────────
              _DrawerFooter()
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 12, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo + tagline stacked
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SiteLogo(),
              const SizedBox(height: 4),
              // Availability indicator
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF22C55E),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scaleXY(
                    begin: 0.7,
                    end: 1.3,
                    duration: 1200.ms,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Available for work',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF22C55E),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const Spacer(),

          // Close button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.borderStrong.withValues(alpha: 0.4),
                ),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textSecondary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav item ──────────────────────────────────────────────────────────────────
class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.index,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final int index;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.accent.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _pressed
                ? AppColors.accent.withValues(alpha: 0.3)
                : AppColors.borderStrong.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Index number — typographic accent
            SizedBox(
              width: 28,
              child: Text(
                '0${widget.index + 1}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: _pressed
                      ? AppColors.accent
                      : AppColors.textMuted,
                  letterSpacing: 0.5,
                  fontFamily: 'monospace',
                ),
              ),
            ),

            // Thin separator
            Container(
              width: 1,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 14),
              color: AppColors.borderStrong.withValues(alpha: 0.3),
            ),

            // Icon — small, not in a gradient box
            Icon(
              widget.icon,
              size: 18,
              color: _pressed ? AppColors.accent : AppColors.textSecondary,
            ),

            const SizedBox(width: 14),

            // Label
            Expanded(
              child: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: _pressed
                      ? AppColors.textPrimary
                      : AppColors.textPrimary.withValues(alpha: 0.85),
                ),
              ),
            ),

            // Arrow
            AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              transform: Matrix4.translationValues(
                _pressed ? 4 : 0,
                0,
                0,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: _pressed
                    ? AppColors.accent
                    : AppColors.textMuted.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Footer ────────────────────────────────────────────────────────────────────
class _DrawerFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.borderStrong.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Social row with labels
          Row(
            children: const [
              _SocialBtn(
                icon: Icons.code_rounded,
                label: 'GitHub',
                url: 'https://github.com/ChinmayBansal010',
              ),
              SizedBox(width: 10),
              _SocialBtn(
                icon: Icons.work_outline_rounded,
                label: 'LinkedIn',
                url: 'https://linkedin.com/in/xenoryx',
              ),
              SizedBox(width: 10),
              _SocialBtn(
                icon: Icons.mail_outline_rounded,
                label: 'Email',
                url: 'mailto:chinmay8521@gmail.com',
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Name + copyright — quiet
          Row(
            children: [
              Text(
                'Chinmay Bansal',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              Text(
                '© ${DateTime.now().year}',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialBtn extends StatefulWidget {
  const _SocialBtn({
    required this.icon,
    required this.label,
    required this.url,
  });

  final IconData icon;
  final String label;
  final String url;

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        launchUrl(Uri.parse(widget.url));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _pressed
                ? AppColors.accent.withValues(alpha: 0.3)
                : AppColors.borderStrong.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.icon,
              size: 14,
              color: _pressed ? AppColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _pressed
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}