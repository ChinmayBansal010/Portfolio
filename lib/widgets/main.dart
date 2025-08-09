import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/navigation_helper.dart';
import 'package:portfolio/constants/size.dart';
import 'dart:math';

class CascadingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool startAnimation;
  final Duration staggerDelay;

  const CascadingText({
    super.key,
    required this.text,
    required this.style,
    required this.startAnimation,
    this.staggerDelay = Duration.zero,
  });

  @override
  State<CascadingText> createState() => _CascadingTextState();
}

class _CascadingTextState extends State<CascadingText> {
  final List<bool> _showCharacters = [];

  @override
  void initState() {
    super.initState();
    _showCharacters.addAll(List.filled(widget.text.length, false));
    if (widget.startAnimation) {
      _triggerAnimation();
    }
  }

  @override
  void didUpdateWidget(covariant CascadingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startAnimation && !oldWidget.startAnimation) {
      _triggerAnimation();
    }
  }

  void _triggerAnimation() async {
    await Future.delayed(widget.staggerDelay);
    for (int i = 0; i < widget.text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 35));
      if (!mounted) return;
      setState(() => _showCharacters[i] = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.text.length, (index) {
        return AnimatedOpacity(
          opacity: _showCharacters[index] ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: AnimatedSlide(
            offset: _showCharacters[index] ? Offset.zero : const Offset(0, 0.5),
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            child: Text(widget.text[index], style: widget.style),
          ),
        );
      }),
    );
  }
}

class MainSection extends StatefulWidget {
  const MainSection({super.key, required this.navbarKeys});
  final List<GlobalKey> navbarKeys;

  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection> with TickerProviderStateMixin {
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedChild({required Widget child, required double intervalStart, required Offset slideOffset}) {
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(intervalStart, 1.0, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: slideOffset, end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }

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
              _buildAnimatedChild(intervalStart: 0.2, slideOffset: const Offset(0, 0.5), child: _buildGreetingText()),
              const SizedBox(height: 16),
              _buildAnimatedChild(intervalStart: 0.4, slideOffset: const Offset(0, 0.5), child: _buildSubText()),
              const SizedBox(height: 20),
              _buildAnimatedChild(intervalStart: 0.5, slideOffset: const Offset(0, 0.5), child: _buildDescription()),
              const SizedBox(height: 30),
              _buildAnimatedChild(intervalStart: 0.6, slideOffset: const Offset(0, 0.5), child: _buildButtons()),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 1,
          child: _buildAnimatedChild(
            intervalStart: 0.0,
            slideOffset: Offset.zero,
            child: _buildLottieBox(height: 400),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildAnimatedChild(intervalStart: 0.0, slideOffset: Offset.zero, child: _buildLottieBox(height: 250)),
        const SizedBox(height: 30),
        _buildAnimatedChild(intervalStart: 0.3, slideOffset: const Offset(0, 0.5), child: _buildGreetingText(isCentered: true)),
        const SizedBox(height: 16),
        _buildAnimatedChild(intervalStart: 0.4, slideOffset: const Offset(0, 0.5), child: _buildSubText(isCentered: true)),
        const SizedBox(height: 20),
        _buildAnimatedChild(intervalStart: 0.5, slideOffset: const Offset(0, 0.5), child: _buildDescription(isCentered: true)),
        const SizedBox(height: 30),
        _buildAnimatedChild(intervalStart: 0.6, slideOffset: const Offset(0, 0.5), child: _buildButtons(isCentered: true)),
      ],
    );
  }

  Widget _buildLottieBox({required double height}) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E2B).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00FFF0).withValues(alpha: 0.2), width: 1),
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Color(0x9900FFB2), Color(0x999F00FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcATop,
        child: Lottie.asset('assets/animations/dev.json', fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildGreetingText({bool isCentered = false}) {
    final double fontSize = isCentered ? 28 : 40;
    final double lottieSize = fontSize * 2.5; // Adaptive lottie size

    final textStyle = Theme.of(context).textTheme.displayLarge!.copyWith(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF00FF9F),
      shadows: [Shadow(color: const Color(0xFF00FF9F).withValues(alpha: 0.2), blurRadius: 20)],
    );

    return Align(
      alignment: isCentered ? Alignment.center : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CascadingText(text: "Hi, I’m Chinmay Bansal ", startAnimation: true, style: textStyle),
          Lottie.asset(
            'assets/animations/waving_hand.json',
            height: lottieSize,
            width: lottieSize,
          ),
        ],
      ),
    );
  }

  Widget _buildSubText({bool isCentered = false}) {
    return _CyclingSubtext(isCentered: isCentered);
  }

  Widget _buildDescription({bool isCentered = false}) {
    return Text(
      "Crafting intelligent, cross-platform apps with stunning UIs and smart brains.",
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15, color: Colors.white70),
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
          onPressed: () => NavigationHelper.scrollToSection(context: context, navIndex: 2, navbarKeys: widget.navbarKeys),
        ),
        _AnimatedCTAButton(
          label: "Contact Me",
          icon: Icons.mail_outline,
          onPressed: () => NavigationHelper.scrollToSection(context: context, navIndex: 4, navbarKeys: widget.navbarKeys),
        ),
      ],
    );
  }
}

class _CyclingSubtext extends StatefulWidget {
  final bool isCentered;
  const _CyclingSubtext({required this.isCentered});

  @override
  State<_CyclingSubtext> createState() => _CyclingSubtextState();
}

class _CyclingSubtextState extends State<_CyclingSubtext> {
  static const List<String> _titles = [
    "AI Enthusiast",
    "ML Practitioner",
    "Android Developer",
    "Flutter Developer",
  ];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() => _currentIndex = (_currentIndex + 1) % _titles.length);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18, color: const Color(0xFF00FFB2));
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: child.key == ValueKey(_currentIndex) ? const Offset(0, 0.5) : const Offset(0, -0.5),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        _titles[_currentIndex],
        key: ValueKey(_currentIndex),
        textAlign: widget.isCentered ? TextAlign.center : TextAlign.start,
        style: style,
      ),
    );
  }
}

class _AnimatedCTAButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData icon;

  const _AnimatedCTAButton({required this.label, required this.onPressed, required this.icon});

  @override
  State<_AnimatedCTAButton> createState() => _AnimatedCTAButtonState();
}

class _AnimatedCTAButtonState extends State<_AnimatedCTAButton> with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final AnimationController _shineController;
  bool _isHovered = false;
  Offset _mousePos = Offset.zero;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _shineController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _scaleController.forward();
      _shineController.forward(from: 0.0);
    } else {
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) {
        _onHover(false);
        setState(() => _mousePos = Offset.zero);
      },
      onHover: (event) => setState(() => _mousePos = event.localPosition),
      cursor: SystemMouseCursors.click,
      child: LayoutBuilder(builder: (context, constraints) {
        final center = constraints.biggest.center(Offset.zero);
        final translate = _isHovered ? Offset.fromDirection((_mousePos - center).direction, min((_mousePos - center).distance, 8)) : Offset.zero;

        return TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(begin: Offset.zero, end: translate),
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: offset,
              child: child,
            );
          },
          child: GestureDetector(
            onTap: () {
              _showParticleBurst();
              widget.onPressed();
            },
            child: AnimatedBuilder(
              animation: _scaleController,
              builder: (context, child) => Transform.scale(scale: 1 + (_scaleController.value * 0.05), child: child),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _isHovered ? Colors.transparent : const Color(0xFF00FFB2).withValues(alpha: 0.6), width: 1),
                  boxShadow: _isHovered
                      ? [BoxShadow(color: const Color(0xFF00FFF0).withValues(alpha: 0.5), blurRadius: 16, offset: const Offset(0, 4))]
                      : [],
                  gradient: LinearGradient(
                    colors: _isHovered
                        ? [const Color(0xFF00FFF0), const Color(0xFF00FFB2)]
                        : [const Color(0xFF00FFB2), const Color(0xFF00D6C3)],
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _shineController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(constraints.maxWidth * -1.5 * (1 - _shineController.value), 0),
                            child: child,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.white.withValues(alpha: 0.0), Colors.white.withValues(alpha: 0.3), Colors.white.withValues(alpha: 0.0)],
                              stops: const [0.0, 0.5, 1.0],
                              transform: const GradientRotation(pi / 4),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
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
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showParticleBurst() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(renderBox.size.center(Offset.zero));
    final entry = OverlayEntry(
      builder: (context) => ParticleBurst(position: position),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 1), () => entry.remove());
  }
}

class ParticleBurst extends StatefulWidget {
  final Offset position;
  const ParticleBurst({super.key, required this.position});

  @override
  State<ParticleBurst> createState() => _ParticleBurstState();
}

class _ParticleBurstState extends State<ParticleBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..forward();
    final colors = [const Color(0xFF00FFF0), const Color(0xFF00FFB2), const Color(0xFF9F00FF), Colors.white];
    for (int i = 0; i < 30; i++) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = _random.nextDouble() * 5 + 2;
      _particles.add(_Particle(
        color: colors[_random.nextInt(colors.length)],
        velocity: Offset(cos(angle) * speed, sin(angle) * speed),
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: AnimatedBuilder(
        animation: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        builder: (context, child) {
          return Stack(
            children: _particles.map((p) {
              final progress = _controller.value;
              final Offset currentPos = p.velocity * progress * (15 * (1 - progress));
              final double opacity = (1.0 - progress).clamp(0.0, 1.0);
              return Transform.translate(
                offset: currentPos,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(color: p.color, shape: BoxShape.circle),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _Particle {
  final Color color;
  final Offset velocity;
  _Particle({required this.color, required this.velocity});
}