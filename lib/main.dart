import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/pages/home.dart';
import 'package:portfolio/constants/size.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chinmay.dev',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SpaceGrotesk',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _shineController;
  late AnimationController _backgroundController;
  late AnimationController _glitchController;

  Offset _mousePosition = Offset.zero;
  bool _showText = false;
  bool _showWavingHand = false;
  final String _greetingTextDesktop = "Hi, I'm Chinmay Bansal";
  final String _greetingTextHi = "Hi,";
  final String _greetingTextName = "I'm Chinmay Bansal";
  final Duration _homePageTransitionDuration = const Duration(milliseconds: 600);

  final List<Particle> _particles = [];
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _backgroundController = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat();
    _glitchController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));

    for (int i = 0; i < 70; i++) {
      _particles.add(Particle(
        position: Offset(_random.nextDouble(), _random.nextDouble()),
        size: _random.nextDouble() * 1.8 + 0.5,
        speed: _random.nextDouble() * 0.005 + 0.002,
      ));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimationSequence());
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => _showText = true);

    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _showWavingHand = true);

    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _glitchController.forward().then((_) => _glitchController.reset());

    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.1, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: _homePageTransitionDuration,
      ),
    );
  }

  @override
  void dispose() {
    _shineController.dispose();
    _backgroundController.dispose();
    _glitchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final bool isWideScreen = screenSize.width >= kMinDesktopWidth;
    final double parallaxX = (_mousePosition.dx / screenSize.width - 0.5) * 40;
    final double parallaxY = (_mousePosition.dy / screenSize.height - 0.5) * 40;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: MouseRegion(
        onHover: (event) => setState(() => _mousePosition = event.position),
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _backgroundController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: DataRainPainter(
                      animationValue: _backgroundController.value,
                      particles: _particles,
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Opacity(
                opacity: 0.15,
                child: Lottie.asset('assets/animations/splash_bg.json', fit: BoxFit.cover),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [Colors.transparent, const Color(0xFF0A0A0A)],
                    stops: const [0.2, 1.0],
                  ),
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _glitchController,
              builder: (context, child) {
                final double glitchAmount = sin(_glitchController.value * pi) * 5;
                return Transform.translate(
                  offset: Offset(_random.nextDouble() * glitchAmount - glitchAmount / 2,
                      _random.nextDouble() * glitchAmount - glitchAmount / 2),
                  child: child,
                );
              },
              child: Center(
                child: Transform.translate(
                  offset: Offset(parallaxX, parallaxY),
                  child: isWideScreen
                      ? _buildDesktopLayout()
                      : _buildMobileLayout(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CascadingText(
          text: _greetingTextDesktop,
          startAnimation: _showText,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            letterSpacing: -1,
            fontFamily: 'SpaceGrotesk',
          ),
          shineController: _shineController,
        ),
        const SizedBox(width: 10),
        AnimatedOpacity(
          opacity: _showWavingHand ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: AnimatedScale(
            scale: _showWavingHand ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            child: Lottie.asset(
              'assets/animations/waving_hand.json',
              height: 150,
              width: 150,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CascadingText(
          text: _greetingTextHi,
          startAnimation: _showText,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            fontFamily: 'SpaceGrotesk',
          ),
          shineController: _shineController,
        ),
        const SizedBox(height: 10),
        CascadingText(
          text: _greetingTextName,
          startAnimation: _showText,
          staggerDelay: const Duration(milliseconds: 300),
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: 36,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.7),
            fontFamily: 'SpaceGrotesk',
          ),
        ),
        const SizedBox(height: 20),
        AnimatedOpacity(
          opacity: _showWavingHand ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 400),
          child: AnimatedScale(
            scale: _showWavingHand ? 1.0 : 0.5,
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            child: Lottie.asset(
              'assets/animations/waving_hand.json',
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}

class CascadingText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final bool startAnimation;
  final Duration staggerDelay;
  final AnimationController? shineController;

  const CascadingText({
    super.key,
    required this.text,
    required this.style,
    required this.startAnimation,
    this.staggerDelay = Duration.zero,
    this.shineController,
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
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => LinearGradient(
        colors: const [Color(0xFF00FFF0), Color(0xFF9F00FF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        transform: widget.shineController != null
            ? GradientRotation(widget.shineController!.value * 2 * pi)
            : null,
      ).createShader(bounds),
      child: Row(
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
      ),
    );
  }
}

class DataRainPainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles;
  DataRainPainter({required this.animationValue, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final yPos = (particle.position.dy + animationValue * particle.speed) % 1.0;
      final paint = Paint()..color = Colors.white.withValues(alpha: 0.5);
      canvas.drawCircle(Offset(particle.position.dx * size.width, yPos * size.height), particle.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DataRainPainter oldDelegate) => true;
}

class Particle {
  Offset position;
  final double size;
  final double speed;
  Particle({required this.position, required this.size, required this.speed});
}