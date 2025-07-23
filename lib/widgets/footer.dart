import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  static const double _verticalPadding = 40.0;
  static const double _horizontalPadding = 24.0;
  static const double _madeByTextSpacing = 10.0;
  static const double _builtWithTextSpacing = 6.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: _verticalPadding, horizontal: _horizontalPadding),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A0A0A), Color(0xFF0D1117)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Made by Chinmay Bansal",
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.w500,
              color: const Color(0xFF00FFF0),
              shadows: [
                Shadow(
                  color: const Color(0x6600FFF0),
                  blurRadius: 12,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          const SizedBox(height: _madeByTextSpacing),
          const _GitHubButton(),
          const SizedBox(height: _builtWithTextSpacing),
          Text(
            "Built with Flutter & 💻 Open Source Spirit",
            style: TextStyle(
              fontSize: 13,
              fontFamily: 'SpaceGrotesk',
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class _GitHubButton extends StatefulWidget {
  const _GitHubButton();

  @override
  State<_GitHubButton> createState() => _GitHubButtonState();
}

class _GitHubButtonState extends State<_GitHubButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _blurAnimation;
  late final Animation<double> _opacityAnimation;


  static const double _githubIconTextSpacing = 6.0;
  static const double _githubButtonPaddingH = 12.0;
  static const double _githubButtonPaddingV = 8.0;
  static const double _githubButtonRadius = 8.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _blurAnimation = Tween<double>(begin: 0.0, end: 12.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
        onTap: () async {
          final url = Uri.parse("https://github.com/ChinmayBansal010/Portfolio");
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        },
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: _githubButtonPaddingH, vertical: _githubButtonPaddingV),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(_githubButtonRadius),
                  color: Colors.white.withAlpha(2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00FFF0).withAlpha((_opacityAnimation.value * 40).toInt()),
                      blurRadius: _blurAnimation.value,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.code,
                      size: 18,
                      color: Color.lerp(const Color(0xFF00FFF0), Colors.white, _controller.value * 0.2),
                    ),
                    const SizedBox(width: _githubIconTextSpacing),
                    Text(
                      "View this portfolio on GitHub",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'SpaceGrotesk',
                        color: Color.lerp(Colors.white70, Colors.white, _controller.value * 0.5),
                        decoration: TextDecoration.underline,
                      ),
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