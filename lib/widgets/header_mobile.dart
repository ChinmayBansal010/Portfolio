import 'package:flutter/material.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/nav_items.dart';
import 'package:portfolio/widgets/site_logo.dart';
import 'package:url_launcher/url_launcher.dart';

class HeaderMobile extends StatelessWidget {
  const HeaderMobile({super.key, this.onLogoTap, this.onMenuTap});

  final VoidCallback? onLogoTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ── Logo ─────────────────────────────────────────────────────
          SiteLogo(onTap: onLogoTap),

          const Spacer(),

          // ── Blog link — quiet text button ────────────────────────────
          _BlogButton(),

          const SizedBox(width: 10),

          // ── Menu button ───────────────────────────────────────────────
          _MenuButton(onTap: onMenuTap),
        ],
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
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        launchUrl(Uri.parse(blogUrl));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.surface
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _pressed
                ? AppColors.borderStrong.withValues(alpha: 0.5)
                : AppColors.borderStrong.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 14,
              color: _pressed ? AppColors.textPrimary : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              'Blog',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _pressed ? AppColors.textPrimary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Menu / hamburger button ────────────────────────────────────────────────
class _MenuButton extends StatefulWidget {
  const _MenuButton({this.onTap});
  final VoidCallback? onTap;

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: _pressed
                ? AppColors.accent.withValues(alpha: 0.35)
                : AppColors.borderStrong.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.menu_rounded,
          size: 19,
          color: _pressed ? AppColors.accent : AppColors.textSecondary,
        ),
      ),
    );
  }
}