import 'package:flutter/material.dart';
import 'package:portfolio/constants/nav_items.dart';

class DrawerMobile extends StatelessWidget {
  const DrawerMobile({super.key, required this.onNavItemTap});
  final Function(int) onNavItemTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D1117),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Close Icon
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),

            const SizedBox(height: 10),

            // Menu Items
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: navTitles.length,
                separatorBuilder: (_, __) => const Divider(color: Colors.white10, thickness: 0.5, indent: 20, endIndent: 20),
                itemBuilder: (context, i) {
                  return _AnimatedNavItem(
                    icon: navIcons[i],
                    label: navTitles[i],
                    onTap: () {
                      Navigator.of(context).pop(); // close drawer
                      onNavItemTap(i); // handle nav tap
                    },
                  );
                },
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
    final hoverColor = const Color(0x33FFFFFF);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _isHovered ? hoverColor : Colors.transparent,
        child: ListTile(
          leading: Icon(widget.icon, color: const Color(0xFF00FFF0), size: 22),
          title: Text(
            widget.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontFamily: 'SpaceGrotesk',
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
