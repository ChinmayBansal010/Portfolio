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
    final TextStyle mainTextStyle = Theme.of(context).textTheme.displayLarge!.copyWith(
      fontSize: isCentered ? 28 : 40,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF00FF9F),
      shadows: [
        Shadow(
          color: const Color(0xFF00FF9F).withAlpha(50),
          blurRadius: 20,
          offset: const Offset(0, 2),
        ),
      ],
    );

    return Align(
      alignment: isCentered ? Alignment.center : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Hi, I’m Chinmay Bansal",
            textAlign: TextAlign.start,
            style: mainTextStyle,
          ),
          const SizedBox(width: 5),
          Lottie.asset(
            'assets/animations/waving_hand.json',
            height: isCentered ? 80 : 150,
            width: isCentered ? 80 : 150,
            repeat: true,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }


  Widget _buildSubText({bool isCentered = false}) {
    return Text(
      "AI Enthusiast / ML Practitioner / Android Developer",
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontSize: 18,
        color: const Color(0xFF00FFB2),
      ),
    );
  }

  Widget _buildDescription({bool isCentered = false}) {
    return Text(
      "Crafting intelligent, cross-platform apps with stunning UIs and smart brains.",
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        fontSize: 15,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildButtons({bool isCentered = false}) {
    return Wrap(
      alignment: isCentered ? WrapAlignment.center : WrapAlignment.start,
      spacing: 16,
      runSpacing: 16,
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
        color: const Color(0xFF1A1E2B).withAlpha((255 * 0.5).round()),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00FFF0).withAlpha((255 * 0.2).round()), width: 1),
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [
              Color(0x9900FFB2),
              Color(0x999F00FF),
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
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
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
          animation: _controller,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
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
                  color: const Color(0x9900FFF0).withAlpha((_controller.value * 255 * 0.8).round()),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
                  : [],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered ? Colors.transparent : const Color(0xFF00FFB2).withAlpha((255 * 0.6).round()),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.icon, color: Colors.black, size: 19),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
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