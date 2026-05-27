import 'package:flutter/material.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/nav_items.dart';
import 'package:portfolio/widgets/site_logo.dart';

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
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(22, 10, 22, 12),
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          SiteLogo(onTap: () => onNavMenuTap(0)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.background.withValues(alpha: 0.26),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(navTitles.length, (index) {
                return _HeaderNavItem(
                  title: navTitles[index],
                  icon: navIcons[index],
                  onTap: () => onNavMenuTap(index),
                  isActive: index == activeIndex,
                );
              }),
            ),
          ),
          const SizedBox(width: 14),
          const _HeaderSignal(),
        ],
      ),
    );
  }
}

class _HeaderSignal extends StatelessWidget {
  const _HeaderSignal();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.success,
              boxShadow: [
                BoxShadow(
                  color: AppColors.success.withValues(alpha: 0.5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'AI / ML',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderNavItem extends StatefulWidget {
  const _HeaderNavItem({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.isActive,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  @override
  State<_HeaderNavItem> createState() => _HeaderNavItemState();
}

class _HeaderNavItemState extends State<_HeaderNavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isActive || _isHovering;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: widget.isActive ? AppColors.accentGradient : null,
            color: widget.isActive
                ? null
                : (_isHovering
                      ? AppColors.surface.withValues(alpha: 0.82)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: widget.isActive
                    ? AppColors.background
                    : (active ? AppColors.textPrimary : AppColors.textMuted),
              ),
              const SizedBox(width: 8),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: widget.isActive
                      ? FontWeight.w700
                      : FontWeight.w600,
                  color: widget.isActive
                      ? AppColors.background
                      : (active
                            ? AppColors.textPrimary
                            : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
