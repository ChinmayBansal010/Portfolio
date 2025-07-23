import 'package:flutter/material.dart';
import 'package:portfolio/widgets/site_logo.dart';
import 'package:portfolio/constants/nav_items.dart';

class HeaderDesktop extends StatelessWidget {
  final Function(int) onNavMenuTap;
  final int activeIndex;

  const HeaderDesktop({
    super.key,
    required this.onNavMenuTap,
    this.activeIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65.0,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.maxFinite,
      child: Row(
        children: [
          SiteLogo(
            onTap: () => onNavMenuTap(0),
          ),
          const Spacer(),

          for (int i = 0; i < navTitles.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: _HeaderNavItem(
                title: navTitles[i],
                onTap: () => onNavMenuTap(i),
                isActive: i == activeIndex,
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderNavItem extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  final bool isActive;

  const _HeaderNavItem({
    required this.title,
    required this.onTap,
    required this.isActive,
  });

  @override
  State<_HeaderNavItem> createState() => _HeaderNavItemState();
}

class _HeaderNavItemState extends State<_HeaderNavItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color textColor = widget.isActive
        ? const Color(0xFF00FF9F)
        : _isHovering
        ? const Color(0xFFC0FFEB)
        : Colors.white;

    final List<Shadow> textShadows = widget.isActive
        ? [
      const Shadow(color: Color(0xAA00FF9F), blurRadius: 10),
      const Shadow(color: Color(0x8800FF9F), blurRadius: 20),
    ]
        : _isHovering
        ? [const Shadow(color: Color(0x999B00FF), blurRadius: 10)]
        : [];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 4.0), // Reduced vertical padding
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: widget.isActive ? FontWeight.w800 : FontWeight.w600,
                  color: textColor,
                  shadows: textShadows,
                  fontFamily: 'SpaceGrotesk',
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                height: 2,
                width: widget.isActive || _isHovering ? (widget.title.length * 8.0 + 8) : 0,
                color: widget.isActive ? const Color(0xFF00FF9F) : const Color(0xAA9B00FF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}