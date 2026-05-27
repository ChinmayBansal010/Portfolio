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
      width: MediaQuery.of(context).size.width * 0.84,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.96),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            bottomLeft: Radius.circular(24),
          ),
          border: Border(
            left: BorderSide(color: AppColors.accent.withValues(alpha: 0.18)),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 22, 16, 16),
                child: Row(
                  children: [
                    const SiteLogo(),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.08, end: 0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Text(
                  'AI-first portfolio',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: navTitles.length,
                  itemBuilder: (context, i) {
                    return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _DrawerNavItem(
                            icon: navIcons[i],
                            label: navTitles[i],
                            onTap: () {
                              Navigator.of(context).pop();
                              onNavItemTap(i);
                            },
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 320.ms, delay: (70 * i).ms)
                        .slideX(begin: 0.08, end: 0);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.55),
                  border: Border(
                    top: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _SocialIconButton(
                          icon: Icons.code_rounded,
                          url: 'https://github.com/ChinmayBansal010',
                        ),
                        _SocialIconButton(
                          icon: Icons.work_outline_rounded,
                          url: 'https://linkedin.com/in/xenoryx',
                        ),
                        _SocialIconButton(
                          icon: Icons.mail_outline_rounded,
                          url: 'mailto:chinmay8521@gmail.com',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '© ${DateTime.now().year} Chinmay Bansal',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  const _SocialIconButton({required this.icon, required this.url});

  final IconData icon;
  final String url;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchUrl(Uri.parse(url)),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.52),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, color: AppColors.accent, size: 20),
      ),
    );
  }
}

class _DrawerNavItem extends StatefulWidget {
  const _DrawerNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<_DrawerNavItem> createState() => _DrawerNavItemState();
}

class _DrawerNavItemState extends State<_DrawerNavItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.accent.withValues(alpha: 0.10)
              : AppColors.background.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _pressed ? AppColors.accentSoft : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.icon, color: AppColors.background, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
