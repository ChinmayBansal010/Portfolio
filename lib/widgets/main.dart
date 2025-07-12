import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/navigation_helper.dart';
import 'package:portfolio/constants/size.dart';

class MainSection extends StatelessWidget {
  const MainSection({super.key, required this.navbarKeys, required this.context});
  final List<GlobalKey> navbarKeys;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < kMinDesktopWidth;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 40,
        vertical: isMobile ? 40 : 60,
      ),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Text Section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingText(),
              const SizedBox(height: 16),
              _buildSubText(),
              const SizedBox(height: 20),
              _buildDescription(),
              const SizedBox(height: 30),
              _buildButtons(),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Right Lottie Animation
        Expanded(
          flex: 1,
          child: _buildLottieBox(height: 400),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLottieBox(height: 250),
        const SizedBox(height: 30),
        _buildGreetingText(isCentered: true),
        const SizedBox(height: 16),
        _buildSubText(isCentered: true),
        const SizedBox(height: 20),
        _buildDescription(isCentered: true),
        const SizedBox(height: 30),
        _buildButtons(isCentered: true),
      ],
    );
  }

  Widget _buildGreetingText({bool isCentered = false}) {
    return Text(
      "Hi, I’m Chinmay 👋",
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: isCentered ? 28 : 40,
        fontWeight: FontWeight.bold,
        fontFamily: 'SpaceGrotesk',
        color: const Color(0xFF00FF9F),
        shadows: [
          Shadow(
            color: const Color(0xFF00FF9F).withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSubText({bool isCentered = false}) {
    return const Text(
      "AI Enthusiast / ML Practitioner / Android Developer",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: Color(0xFF00FFB2),
        fontFamily: 'SpaceGrotesk',
      ),
    );
  }

  Widget _buildDescription({bool isCentered = false}) {
    return const Text(
      "Crafting intelligent, cross-platform apps with stunning UIs and smart brains.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white70,
        fontFamily: 'SpaceGrotesk',
      ),
    );
  }

  Widget _buildButtons({bool isCentered = false}) {
    return Row(
      mainAxisAlignment:
      isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        _AnimatedCTAButton(
          label: "View Projects",
          icon: Icons.code,
          onPressed: () {
            NavigationHelper.scrollToSection(
              context: context,
              navIndex: 2,
              navbarKeys: navbarKeys,
            );
          },
        ),
        const SizedBox(width: 20),
        _AnimatedCTAButton(
          label: "Contact Me",
          icon: Icons.mail_outline,
          onPressed: () {
            NavigationHelper.scrollToSection(
              context: context,
              navIndex: 4,
              navbarKeys: navbarKeys,
            );
          },
        ),
      ],
    );
  }

  Widget _buildLottieBox({required double height}) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x14000000), // black with alpha 20
        borderRadius: BorderRadius.circular(20),
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [
              Color(0x6600FFB2),
              Color(0x669F00FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcATop,
        child: Lottie.asset(
          'assets/animations/dev.json',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _AnimatedCTAButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const _AnimatedCTAButton({
    required this.label,
    required this.onPressed,
    required this.icon,
  });

  @override
  State<_AnimatedCTAButton> createState() => _AnimatedCTAButtonState();
}

class _AnimatedCTAButtonState extends State<_AnimatedCTAButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.05,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
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
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: _isHovered
                  ? const LinearGradient(
                colors: [Color(0xFF00FFF0), Color(0xFF00FFB2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
                  : const LinearGradient(
                colors: [Color(0xFF00FFB2), Color(0xFF00D6C3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: const Color(0x9900FFF0),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
                  : [],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.black, size: 18),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'SpaceGrotesk',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
