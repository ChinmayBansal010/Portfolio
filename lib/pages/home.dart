import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/frosted_header.dart';
import 'package:portfolio/constants/navigation_helper.dart';
import 'package:portfolio/constants/size.dart';
import 'package:portfolio/widgets/contact.dart';
import 'package:portfolio/widgets/drawer_mobile.dart';
import 'package:portfolio/widgets/footer.dart';
import 'package:portfolio/widgets/header_desktop.dart';
import 'package:portfolio/widgets/header_mobile.dart';
import 'package:portfolio/widgets/main.dart';
import 'package:portfolio/widgets/project.dart';
import 'package:portfolio/widgets/skill.dart';
import 'package:portfolio/constants/nav_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final List<GlobalKey> navbarKeys = List.generate(
    navTitles.length,
    (index) => GlobalKey(),
  );

  int _currentActiveNavIndex = 0;
  bool _isScrollingProgrammatically = false;

  double _scrollProgress = 0.0;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (mounted) {
      setState(() {
        _scrollProgress = (scrollController.offset /
                scrollController.position.maxScrollExtent)
            .clamp(0.0, 1.0);
        _showBackToTop = scrollController.offset > 600;
      });
    }

    if (_isScrollingProgrammatically) return;

    const double scrollEndBuffer = 50.0;
    const double activationLine = 100.0;

    int detectedActiveIndex = _currentActiveNavIndex;

    if (scrollController.offset <= 20.0) {
      detectedActiveIndex = 0;
    } else if (scrollController.offset >=
        scrollController.position.maxScrollExtent - scrollEndBuffer) {
      detectedActiveIndex = navbarKeys.length - 1;
    } else {
      for (int i = 0; i < navbarKeys.length; i++) {
        if (i == 3) continue;

        final keyContext = navbarKeys[i].currentContext;
        if (keyContext == null) continue;

        final RenderBox renderBox = keyContext.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        final double sectionTop = position.dy;
        final double sectionBottom = sectionTop + renderBox.size.height;

        if (sectionTop <= activationLine && sectionBottom > activationLine) {
          detectedActiveIndex = i;
          break;
        }
      }
    }

    if (_currentActiveNavIndex != detectedActiveIndex) {
      setState(() {
        _currentActiveNavIndex = detectedActiveIndex;
      });
    }
  }

  Future<void> _navigateToSection(int navIndex) async {
    if (navIndex == 3) {
      NavigationHelper.scrollToSection(
        context: context,
        navIndex: navIndex,
        navbarKeys: navbarKeys,
      );
      return;
    }

    setState(() {
      _isScrollingProgrammatically = true;
      _currentActiveNavIndex = navIndex;
    });

    await NavigationHelper.scrollToSection(
      context: context,
      navIndex: navIndex,
      navbarKeys: navbarKeys,
    );

    // Wait for the scroll animation to complete (duration is 500ms in NavigationHelper)
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isScrollingProgrammatically = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= kMinDesktopWidth;

        return Scaffold(
          key: scaffoldKey,
          endDrawer: isDesktop
              ? null
              : DrawerMobile(
                  onNavItemTap: (int navIndex) {
                    scaffoldKey.currentState?.closeEndDrawer();
                    _navigateToSection(navIndex);
                  },
                ),
          body: Stack(
            children: [
              const Positioned.fill(
                child: InteractiveConstellationBackground(),
              ),
              Positioned.fill(
                top: 0,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(height: 90, key: navbarKeys[0]),
                      MainSection(navbarKeys: navbarKeys)
                          .animate()
                          .fadeIn(duration: 800.ms, curve: Curves.easeOutCubic)
                          .slideY(begin: 0.1, end: 0, duration: 800.ms),
                      const LottieSectionSeparator(),
                      SkillSection(navbarKey: navbarKeys[1])
                          .animate()
                          .fadeIn(
                            duration: 1000.ms,
                            curve: Curves.easeOutCubic,
                            delay: 200.ms,
                          )
                          .slideY(begin: 0.05, end: 0),
                      const LottieSectionSeparator(),
                      ProjectSection(navbarKey: navbarKeys[2])
                          .animate()
                          .fadeIn(
                            duration: 1000.ms,
                            curve: Curves.easeOutCubic,
                            delay: 300.ms,
                          )
                          .slideY(begin: 0.05, end: 0),
                      const LottieSectionSeparator(),
                      GetInTouchSection(navbarKey: navbarKeys[4])
                          .animate()
                          .fadeIn(
                            duration: 1000.ms,
                            curve: Curves.easeOutCubic,
                            delay: 400.ms,
                          )
                          .slideY(begin: 0.05, end: 0),
                      const Footer(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: FrostedHeaderWrapper(
                  backgroundColor: AppColors.background,
                  backgroundAlpha: 100,
                  blurSigma: 14,
                  enableBorder: true,
                  height: 90,
                  child: Stack(
                    children: [
                      isDesktop
                          ? HeaderDesktop(
                              onNavMenuTap: _navigateToSection,
                              activeIndex: _currentActiveNavIndex,
                            )
                          : HeaderMobile(
                              onLogoTap: () => _navigateToSection(0),
                              onMenuTap: () {
                                scaffoldKey.currentState?.openEndDrawer();
                              },
                            ),
                      // Scroll Progress Line
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          height: 2,
                          width: MediaQuery.of(context).size.width * _scrollProgress,
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradient,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.5),
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Back to Top Button
              Positioned(
                bottom: 30,
                right: 30,
                child: AnimatedScale(
                  scale: _showBackToTop ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: FloatingActionButton(
                    onPressed: () => _navigateToSection(0),
                    backgroundColor: AppColors.accent,
                    elevation: 10,
                    child: const Icon(Icons.arrow_upward, color: AppColors.background),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LottieSectionSeparator extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Alignment alignment;
  final bool repeat;

  const LottieSectionSeparator({
    super.key,
    this.padding = const EdgeInsets.symmetric(vertical: 64.0),
    this.alignment = Alignment.center,
    this.repeat = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Padding(
      padding: padding,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. Core Energy Pulse
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat()).scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.5, 1.5),
            duration: 2.seconds,
            curve: Curves.easeOut,
          ).fadeOut(duration: 2.seconds),

          // 2. Technical Beam
          Container(
            height: 1,
            width: (screenWidth * 0.6).clamp(240.0, 900.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.accent.withValues(alpha: 0.4),
                  AppColors.accent,
                  AppColors.accent.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat()).shimmer(
            duration: 3.seconds,
            color: Colors.white.withValues(alpha: 0.3),
          ),

          // 3. Floating Particles (Lottie)
          Opacity(
            opacity: 0.6,
            child: Lottie.asset(
              'assets/animations/section_separator.json',
              width: isMobile ? 280 : 500,
              height: 120,
              fit: BoxFit.contain,
              repeat: repeat,
            ),
          ),

          // 4. Central Hub
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.8),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.2, 1.2),
            duration: 1.seconds,
          ),
        ],
      ),
    );
  }
}

class InteractiveConstellationBackground extends StatefulWidget {
  const InteractiveConstellationBackground({super.key});

  @override
  State<InteractiveConstellationBackground> createState() =>
      _InteractiveConstellationBackgroundState();
}

class _InteractiveConstellationBackgroundState
    extends State<InteractiveConstellationBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_StarLayer> _starLayers;
  final Random _random = Random();
  Offset _pointerPosition = const Offset(0.5, 0.5);
  Offset _lastPointerPosition = const Offset(0.5, 0.5);
  double _lastInitializedWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _starLayers = [];
    _controller =
        AnimationController(vsync: this, duration: const Duration(days: 1))
          ..addListener(() {
            if (mounted) {
              setState(() {
                for (var layer in _starLayers) {
                  layer.updatePositions();
                }
              });
            }
          })
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _reinitializeLayersIfNeeded(Size size) {
    if ((size.width - _lastInitializedWidth).abs() < 10 &&
        _starLayers.isNotEmpty) {
      return;
    }

    _starLayers = [];
    const layerCount = 3;
    for (int i = 0; i < layerCount; i++) {
      _starLayers.add(
        _StarLayer(
          layerIndex: i,
          dotCount: _calculateDotCount(size.width, i),
          random: _random,
        ),
      );
    }
    _lastInitializedWidth = size.width;
  }

  int _calculateDotCount(double width, int layerIndex) {
    const baseCount = 30.0;
    final double scale = (width / 400.0).clamp(1.0, 4.0);
    final count = (baseCount * sqrt(scale)).round();
    return (count / (layerIndex + 1)).round() + (layerIndex * 15);
  }

  void _updatePointer(PointerEvent event, Size size) {
    if (!mounted) return;
    setState(() {
      _pointerPosition = Offset(
        (event.localPosition.dx / size.width).clamp(0.0, 1.0),
        (event.localPosition.dy / size.height).clamp(0.0, 1.0),
      );
      _lastPointerPosition = _pointerPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        _reinitializeLayersIfNeeded(size);

        return Listener(
          onPointerHover: (event) => _updatePointer(event, size),
          onPointerMove: (event) => _updatePointer(event, size),
          onPointerDown: (event) => _updatePointer(event, size),
          onPointerUp: (_) =>
              setState(() => _pointerPosition = _lastPointerPosition),
          child: IgnorePointer(
            ignoring: true,
            child: Stack(
              children: [
                ..._starLayers.map(
                  (layer) => Positioned.fill(
                    child: CustomPaint(
                      painter: _ConstellationPainter(
                        dots: layer.dots,
                        maxConnectionDistance: _calculateConnectionDistance(
                          size.width,
                          layer.layerIndex,
                        ),
                        pointerPosition: _pointerPosition,
                        layerIndex: layer.layerIndex,
                      ),
                    ),
                  ),
                ),
                // Nebula/Gas layer for 3D tint
                Positioned.fill(
                  child: CustomPaint(
                    painter: _NebulaPainter(pointerPosition: _pointerPosition),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Data models for layers and dots
class _Dot {
  double x;
  double y;
  double vx;
  double vy;
  double radius;

  _Dot({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
  });

  void updatePosition() {
    x += vx;
    y += vy;
    if (x < 0) x = 1;
    if (x > 1) x = 0;
    if (y < 0) y = 1;
    if (y > 1) y = 0;
  }
}

class _StarLayer {
  final int layerIndex;
  final List<_Dot> dots;

  _StarLayer({
    required this.layerIndex,
    required int dotCount,
    required Random random,
  }) : dots = List.generate(
         dotCount,
         (_) => _Dot(
           x: random.nextDouble(),
           y: random.nextDouble(),
           vx: (random.nextDouble() - 0.5) * 0.0001 * (layerIndex + 1),
           vy: (random.nextDouble() - 0.5) * 0.0001 * (layerIndex + 1),
           radius: random.nextDouble() * (1 + layerIndex) + 0.9,
         ),
       );

  void updatePositions() {
    for (var dot in dots) {
      dot.updatePosition();
    }
  }
}

double _calculateConnectionDistance(double width, int layerIndex) {
  final baseDist = 120 * sqrt(width / 400.0).clamp(1.0, 2.0);
  return baseDist / (layerIndex + 1);
}

// Custom Painters
class _ConstellationPainter extends CustomPainter {
  final List<_Dot> dots;
  final double maxConnectionDistance;
  final Offset pointerPosition;
  final int layerIndex;

  final Paint _dotPaint = Paint()..style = PaintingStyle.fill;
  final Paint _linePaint = Paint();

  _ConstellationPainter({
    required this.dots,
    required this.maxConnectionDistance,
    required this.pointerPosition,
    required this.layerIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double parallaxFactor = 0.05 * (layerIndex + 1);
    final pointerParallax = Offset(
      (pointerPosition.dx - 0.5) * parallaxFactor,
      (pointerPosition.dy - 0.5) * parallaxFactor,
    );

    for (var dot in dots) {
      final pos = Offset(
        (dot.x + pointerParallax.dx) * size.width,
        (dot.y + pointerParallax.dy) * size.height,
      );
      canvas.drawCircle(
        pos,
        dot.radius,
        _dotPaint
          ..color = AppColors.textSecondary.withValues(
            alpha: (0.75 - (layerIndex * 0.18)).clamp(0.18, 0.75),
          ),
      );
    }

    final double maxDistSq = pow(maxConnectionDistance, 2).toDouble();

    for (var i = 0; i < dots.length; i++) {
      final p1 = Offset(
        (dots[i].x + pointerParallax.dx) * size.width,
        (dots[i].y + pointerParallax.dy) * size.height,
      );
      for (var j = i + 1; j < dots.length; j++) {
        final p2 = Offset(
          (dots[j].x + pointerParallax.dx) * size.width,
          (dots[j].y + pointerParallax.dy) * size.height,
        );
        final num distSq = pow(p2.dx - p1.dx, 2) + pow(p2.dy - p1.dy, 2);

        if (distSq <= maxDistSq) {
          final double opacity = 1.0 - (sqrt(distSq) / maxConnectionDistance);
          _linePaint.color = AppColors.borderStrong.withValues(
            alpha: opacity * 0.42,
          );
          _linePaint.strokeWidth = 1.0;
          canvas.drawLine(p1, p2, _linePaint);
        }
      }
    }

    // Connect dots to the pointer for an interactive effect
    final pointerPx = Offset(
      pointerPosition.dx * size.width,
      pointerPosition.dy * size.height,
    );
    for (var dot in dots) {
      final p = Offset(
        (dot.x + pointerParallax.dx) * size.width,
        (dot.y + pointerParallax.dy) * size.height,
      );
      final num distSq =
          pow(p.dx - pointerPx.dx, 2) + pow(p.dy - pointerPx.dy, 2);

      if (distSq <= maxDistSq) {
        final double opacity = 1.0 - (sqrt(distSq) / maxConnectionDistance);
        _linePaint.color = AppColors.accentSoft.withValues(
          alpha: opacity * 0.55,
        );
        _linePaint.strokeWidth = 1.0;
        canvas.drawLine(pointerPx, p, _linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) {
    return true;
  }
}

class _NebulaPainter extends CustomPainter {
  final Offset pointerPosition;

  _NebulaPainter({required this.pointerPosition});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentSoft.withValues(alpha: 0.06),
          AppColors.accentSecondary.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
        center: Alignment(
          (pointerPosition.dx - 0.5) * 2,
          (pointerPosition.dy - 0.5) * 2,
        ),
        radius: 0.9,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant _NebulaPainter oldDelegate) {
    return oldDelegate.pointerPosition != pointerPosition;
  }
}
