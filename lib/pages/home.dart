import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/frosted_header.dart';
import 'package:portfolio/constants/nav_items.dart';
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
    (_) => GlobalKey(),
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
    if (!mounted) {
      return;
    }

    final maxScroll = scrollController.position.maxScrollExtent;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    setState(() {
      _scrollProgress = maxScroll == 0
          ? 0
          : (scrollController.offset / maxScroll).clamp(0.0, 1.0);
      _showBackToTop = scrollController.offset > 580;
    });

    if (_isScrollingProgrammatically) {
      return;
    }

    const activationLine = 130.0;
    int detectedActiveIndex = _currentActiveNavIndex;

    if (scrollController.offset <= 24) {
      detectedActiveIndex = 0;
    } else if (scrollController.offset >= maxScroll - 80) {
      detectedActiveIndex = navbarKeys.length - 1;
    } else {
      double bestScore = double.infinity;

      for (int i = 0; i < navbarKeys.length; i++) {
        final keyContext = navbarKeys[i].currentContext;
        if (keyContext == null) {
          continue;
        }

        final renderBox = keyContext.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final sectionTop = position.dy;
        final sectionBottom = sectionTop + renderBox.size.height;

        if (i == navbarKeys.length - 1 && sectionTop <= viewportHeight * 0.55) {
          detectedActiveIndex = i;
          break;
        }

        if (sectionBottom <= activationLine - 24) {
          continue;
        }

        final score = (sectionTop - activationLine).abs();
        if (score < bestScore) {
          bestScore = score;
          detectedActiveIndex = i;
        }
      }
    }

    if (_currentActiveNavIndex != detectedActiveIndex) {
      setState(() => _currentActiveNavIndex = detectedActiveIndex);
    }
  }

  Future<void> _navigateToSection(int navIndex) async {
    setState(() {
      _isScrollingProgrammatically = true;
      _currentActiveNavIndex = navIndex;
    });

    await NavigationHelper.scrollToSection(
      context: context,
      navIndex: navIndex,
      navbarKeys: navbarKeys,
    );

    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) {
      setState(() => _isScrollingProgrammatically = false);
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
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(
                        height: isDesktop ? 104 : 92,
                        key: navbarKeys[0],
                      ),
                      MainSection(navbarKeys: navbarKeys)
                          .animate()
                          .fadeIn(duration: 720.ms, curve: Curves.easeOutCubic)
                          .slideY(begin: 0.08, end: 0),
                      const LottieSectionSeparator(),
                      SkillSection(navbarKey: navbarKeys[1]),
                      const LottieSectionSeparator(),
                      ProjectSection(navbarKey: navbarKeys[2]),
                      const LottieSectionSeparator(),
                      GetInTouchSection(navbarKey: navbarKeys[3]),
                      const SizedBox(height: 16),
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
                  backgroundAlpha: 104,
                  blurSigma: 16,
                  enableBorder: true,
                  height: isDesktop ? 94 : 84,
                  child: Stack(
                    children: [
                      isDesktop
                          ? HeaderDesktop(
                              onNavMenuTap: _navigateToSection,
                              activeIndex: _currentActiveNavIndex,
                            )
                          : HeaderMobile(
                              onLogoTap: () => _navigateToSection(0),
                              onMenuTap: () =>
                                  scaffoldKey.currentState?.openEndDrawer(),
                            ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          height: 2.5,
                          width:
                              MediaQuery.of(context).size.width *
                              _scrollProgress,
                          decoration: BoxDecoration(
                            gradient: AppColors.accentGradientStrong,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.45),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 18,
                bottom: 18,
                child: AnimatedScale(
                  scale: _showBackToTop ? 1 : 0,
                  duration: const Duration(milliseconds: 220),
                  child: FloatingActionButton(
                    onPressed: () => _navigateToSection(0),
                    backgroundColor: AppColors.accent,
                    elevation: 10,
                    child: const Icon(
                      Icons.north_rounded,
                      color: AppColors.background,
                    ),
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
  const LottieSectionSeparator({super.key, this.repeat = true});

  final bool repeat;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final lineWidth = screenWidth < 720
        ? screenWidth * 0.86
        : min(screenWidth * 0.9, 1180.0);
    final lottieWidth = screenWidth < 720 ? screenWidth * 0.62 : 760.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth < 720 ? 18 : 22),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: lineWidth,
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.borderStrong.withValues(alpha: 0.55),
                  AppColors.accentSoft,
                  AppColors.borderStrong.withValues(alpha: 0.55),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Opacity(
            opacity: 0.58,
            child: Lottie.asset(
              'assets/animations/section_separator.json',
              width: lottieWidth,
              height: 88,
              repeat: repeat,
              fit: BoxFit.contain,
            ),
          ),
          Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.6),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1.18, 1.18),
                duration: 1100.ms,
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
    final scale = (width / 400.0).clamp(1.0, 4.0);
    final count = (baseCount * sqrt(scale)).round();
    return (count / (layerIndex + 1)).round() + (layerIndex * 15);
  }

  void _updatePointer(PointerEvent event, Size size) {
    if (!mounted) {
      return;
    }

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

class _Dot {
  _Dot({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.radius,
  });

  double x;
  double y;
  double vx;
  double vy;
  double radius;

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

  final int layerIndex;
  final List<_Dot> dots;

  void updatePositions() {
    for (final dot in dots) {
      dot.updatePosition();
    }
  }
}

double _calculateConnectionDistance(double width, int layerIndex) {
  final baseDist = 120 * sqrt(width / 400.0).clamp(1.0, 2.0);
  return baseDist / (layerIndex + 1);
}

class _ConstellationPainter extends CustomPainter {
  _ConstellationPainter({
    required this.dots,
    required this.maxConnectionDistance,
    required this.pointerPosition,
    required this.layerIndex,
  });

  final List<_Dot> dots;
  final double maxConnectionDistance;
  final Offset pointerPosition;
  final int layerIndex;
  final Paint _dotPaint = Paint()..style = PaintingStyle.fill;
  final Paint _linePaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    final parallaxFactor = 0.05 * (layerIndex + 1);
    final pointerParallax = Offset(
      (pointerPosition.dx - 0.5) * parallaxFactor,
      (pointerPosition.dy - 0.5) * parallaxFactor,
    );

    for (final dot in dots) {
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

    final maxDistSq = pow(maxConnectionDistance, 2).toDouble();

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
        final distSq = pow(p2.dx - p1.dx, 2) + pow(p2.dy - p1.dy, 2);

        if (distSq <= maxDistSq) {
          final opacity = 1.0 - (sqrt(distSq) / maxConnectionDistance);
          _linePaint.color = AppColors.borderStrong.withValues(
            alpha: opacity * 0.42,
          );
          _linePaint.strokeWidth = 1.0;
          canvas.drawLine(p1, p2, _linePaint);
        }
      }
    }

    final pointerPx = Offset(
      pointerPosition.dx * size.width,
      pointerPosition.dy * size.height,
    );
    for (final dot in dots) {
      final p = Offset(
        (dot.x + pointerParallax.dx) * size.width,
        (dot.y + pointerParallax.dy) * size.height,
      );
      final distSq = pow(p.dx - pointerPx.dx, 2) + pow(p.dy - pointerPx.dy, 2);

      if (distSq <= maxDistSq) {
        final opacity = 1.0 - (sqrt(distSq) / maxConnectionDistance);
        _linePaint.color = AppColors.accentSoft.withValues(
          alpha: opacity * 0.55,
        );
        _linePaint.strokeWidth = 1.0;
        canvas.drawLine(pointerPx, p, _linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) => true;
}

class _NebulaPainter extends CustomPainter {
  const _NebulaPainter({required this.pointerPosition});

  final Offset pointerPosition;

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
