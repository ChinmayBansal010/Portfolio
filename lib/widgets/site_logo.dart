import 'package:flutter/material.dart';

class SiteLogo extends StatefulWidget {
  const SiteLogo({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  State<SiteLogo> createState() => _SiteLogoState();
}

class _SiteLogoState extends State<SiteLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _blurAnimation;
  late Animation<double> _shadowOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _blurAnimation = Tween<double>(begin: 8.0, end: 16.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _shadowOpacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Text(
                'Chinmay.dev',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF00FFB2),
                  shadows: [
                    Shadow(
                      color: const Color(0xFF00FFB2).withAlpha((_shadowOpacityAnimation.value*10).toInt()),
                      blurRadius: _blurAnimation.value,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}