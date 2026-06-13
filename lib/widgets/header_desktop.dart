import 'package:flutter/material.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/nav_items.dart';
import 'package:portfolio/widgets/site_logo.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({
    super.key,
    required this.onNavMenuTap,
    this.activeIndex = 0,
  });

  final Function(int) onNavMenuTap;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 12, 32, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Logo ───────────────────────────────────────────────────
          SiteLogo(onTap: () => onNavMenuTap(0)),

          const Spacer(),

          // ── Pill nav ────────────────────────────────────────────────
          _PillNav(
            activeIndex: activeIndex,
            onTap: onNavMenuTap,
          ),

          const Spacer(),

          // ── Blog CTA ────────────────────────────────────────────────
          _BlogButton(),
        ],
      ),
    );
  }
}

// ── Pill nav — centered, floats on the frosted header ─────────────────────
class _PillNav extends StatelessWidget {
  const _PillNav({required this.activeIndex, required this.onTap});

  final int activeIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.borderStrong.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(navTitles.length, (i) {
          return _NavPill(
            label: navTitles[i],
            icon: navIcons[i],
            isActive: i == activeIndex,
            onTap: () => onTap(i),
          );
        }),
      ),
    );
  }
}

class _NavPill extends StatefulWidget {
  const _NavPill({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavPill> createState() => _NavPillState();
}

class _NavPillState extends State<_NavPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final lit = widget.isActive || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          decoration: BoxDecoration(
            // Active: solid accent fill. Hover: subtle surface.
            color: widget.isActive
                ? AppColors.accent
                : _hovered
                ? AppColors.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: widget.isActive
                ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 15,
                color: widget.isActive
                    ? AppColors.background
                    : lit
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
              ),
              const SizedBox(width: 7),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: widget.isActive
                      ? FontWeight.w700
                      : FontWeight.w600,
                  letterSpacing: 0.1,
                  color: widget.isActive
                      ? AppColors.background
                      : lit
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Blog button ────────────────────────────────────────────────────────────
class _BlogButton extends StatefulWidget {
  @override
  State<_BlogButton> createState() => _BlogButtonState();
}

class _BlogButtonState extends State<_BlogButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(blogUrl)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.surface
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? AppColors.borderStrong.withValues(alpha: 0.6)
                  : AppColors.borderStrong.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_stories_rounded,
                size: 15,
                color: _hovered
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
              ),
              const SizedBox(width: 7),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1,
                  color: _hovered
                      ? AppColors.textPrimary
                      : AppColors.textMuted,
                ),
                child: const Text('Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}