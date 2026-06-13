import 'package:flutter/material.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 720;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.borderStrong.withValues(alpha: 0.25),
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 500,
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.06),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isCompact ? 24 : 44,
              vertical: isCompact ? 16 : 30,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1240),
                child: Column(
                  children: [
                    isCompact
                        ? _BottomRowCompact()
                        : _BottomRowDesktop(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom row — desktop ────────────────────────────────────────────────────
class _BottomRowDesktop extends StatelessWidget {
  const _BottomRowDesktop();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chinmay Bansal',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'Built with ',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                  ),
                ),
                _TechBadge(label: 'Flutter'),
                const SizedBox(width: 6),
                _TechBadge(label: 'Dart'),
              ],
            ),
          ],
        ),

        _ViewSourceButton(),

        Text(
          '© ${DateTime.now().year}',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

// ── Bottom row — compact ────────────────────────────────────────────────────
class _BottomRowCompact extends StatelessWidget {
  const _BottomRowCompact();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ViewSourceButton(),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chinmay Bansal',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Built with ',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                    _TechBadge(label: 'Flutter'),
                    const SizedBox(width: 6),
                    _TechBadge(label: 'Dart'),
                  ],
                ),
              ],
            ),
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
    );
  }
}

class _ViewSourceButton extends StatefulWidget {
  const _ViewSourceButton();

  @override
  State<_ViewSourceButton> createState() => _ViewSourceButtonState();
}

class _ViewSourceButtonState extends State<_ViewSourceButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => launchUrl(
          Uri.parse('https://github.com/ChinmayBansal010/Portfolio'),
          mode: LaunchMode.externalApplication,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.surface.withValues(alpha: 0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _isHovered
                  ? AppColors.borderStrong.withValues(alpha: 0.5)
                  : AppColors.border.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code_rounded,
                size: 15,
                color: _isHovered
                    ? AppColors.accent
                    : AppColors.textMuted,
              ),
              const SizedBox(width: 7),
              Text(
                'View source',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: _isHovered
                      ? AppColors.textSecondary
                      : AppColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TechBadge extends StatelessWidget {
  const _TechBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}