import 'package:flutter/material.dart';
import 'package:portfolio/constants/nav_items.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({super.key, required this.onNavItemTap});
  final Function(int) onNavItemTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Drawer(
      backgroundColor: colorScheme.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 16),
                child: IconButton(
                  icon: Icon(Icons.close, color: colorScheme.onSurface),
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: 'Close menu',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: navTitles.length,
                separatorBuilder: (_, __) => Divider(
                  color: colorScheme.onSurface.withAlpha((255 * 0.1).round()),
                  thickness: 0.5,
                  indent: 20,
                  endIndent: 20,
                ),
                itemBuilder: (context, i) {
                  return _AnimatedNavItem(
                    icon: navIcons[i],
                    label: navTitles[i],
                    onTap: () {
                      Navigator.of(context).pop();
                      onNavItemTap(i);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '© 2025 Your Name',
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withAlpha((255 * 0.6).round()),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AnimatedNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends State<_AnimatedNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _isHovered ? colorScheme.primary.withAlpha((255 * 0.15).round()) : Colors.transparent,
        child: ListTile(
          leading: Icon(widget.icon, color: colorScheme.primary, size: 24),
          title: Text(
            widget.label,
            style: textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}