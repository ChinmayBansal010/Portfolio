import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
  final List<GlobalKey> navbarKeys = List.generate(navTitles.length, (index) => GlobalKey());

  int _currentActiveNavIndex = 0;

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
    const double scrollEndBuffer = 50.0;
    const double activationLine = 85.0;

    int detectedActiveIndex = _currentActiveNavIndex;

    if (scrollController.offset <= 10.0) {
      detectedActiveIndex = 0;
    } else if (scrollController.offset >= scrollController.position.maxScrollExtent - scrollEndBuffer) {
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
              NavigationHelper.scrollToSection(
                context: context,
                navIndex: navIndex,
                navbarKeys: navbarKeys,
              );
              if (navIndex != 3) {
                setState(() => _currentActiveNavIndex = navIndex);
              }
            },
          ),
          body: Stack(
            children: [
              const Positioned.fill(
                child: InteractiveConstellationBackground(),
              ),
              Positioned.fill(
                top: 60,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(key: navbarKeys[0]),
                      MainSection(navbarKeys: navbarKeys, context: context),
                      const LottieSectionSeparator(),
                      SkillSection(navbarKey: navbarKeys[1]),
                      const LottieSectionSeparator(),
                      ProjectSection(navbarKey: navbarKeys[2]),
                      const LottieSectionSeparator(),
                      GetInTouchSection(navbarKey: navbarKeys[4]),
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
                  child: isDesktop
                      ? HeaderDesktop(
                    onNavMenuTap: (navIndex) {
                      NavigationHelper.scrollToSection(
                        context: context,
                        navIndex: navIndex,
                        navbarKeys: navbarKeys,
                      );
                      if (navIndex != 3) {
                        setState(() => _currentActiveNavIndex = navIndex);
                      }
                    },
                    activeIndex: _currentActiveNavIndex,
                  )
                      : HeaderMobile(
                    onLogoTap: () {
                      NavigationHelper.scrollToSection(
                        context: context,
                        navIndex: 0,
                        navbarKeys: navbarKeys,
                      );
                      setState(() => _currentActiveNavIndex = 0);
                    },
                    onMenuTap: () {
                      scaffoldKey.currentState?.openEndDrawer();
                    },
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
    this.padding = const EdgeInsets.symmetric(vertical: 40.0),
    this.alignment = Alignment.center,
    this.repeat = true,
  });

  static const double _maxWidth = 700.0;
  static const double _minWidth = 250.0;
  static const double _widthScreenFraction = 0.6;
  static const double _maxHeight = 150.0;
  static const double _minHeight = 80.0;
  static const double _aspectRatio = 0.25;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = (screenWidth * _widthScreenFraction).clamp(_minWidth, _maxWidth);
    final height = (width * _aspectRatio).clamp(_minHeight, _maxHeight);

    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: Lottie.asset(
          'assets/animations/section_separator.json',
          width: width,
          height: height,
          fit: BoxFit.contain,
          repeat: repeat,
        ),
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
  late List<_Dot> _dots;
  final Random _random = Random();
  Offset? _pointerPosition;
  double _lastInitializedWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _dots = [];
    _controller = AnimationController(vsync: this, duration: const Duration(days: 1))
      ..addListener(() {
        if (mounted) {
          setState(() {
            for (var dot in _dots) {
              dot.updatePosition();
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

  void _reinitializeDotsIfNeeded(Size size) {
    if ((size.width - _lastInitializedWidth).abs() < 10 && _dots.isNotEmpty) {
      return;
    }

    final int dotCount = _calculateDotCount(size.width);
    _dots = List.generate(
      dotCount,
          (_) => _Dot(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        vx: (_random.nextDouble() - 0.5) * 0.0004,
        vy: (_random.nextDouble() - 0.5) * 0.0004,
      ),
    );
    _lastInitializedWidth = size.width;
  }

  int _calculateDotCount(double width) {
    const double baseCount = 50.0;
    final double scale = (width / 400.0).clamp(1.0, 4.0);
    return (baseCount * sqrt(scale)).round();
  }

  double _calculateConnectionDistance(double width) {
    return (120 * sqrt(width / 400.0)).clamp(120.0, 250.0);
  }

  void _updatePointer(PointerEvent event, Size size) {
    if (!mounted) return;
    setState(() {
      _pointerPosition = Offset(
        event.localPosition.dx / size.width,
        event.localPosition.dy / size.height,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        _reinitializeDotsIfNeeded(size);

        final double connectionDistance = _calculateConnectionDistance(size.width);

        return Listener(
          onPointerHover: (event) => _updatePointer(event, size),
          onPointerMove: (event) => _updatePointer(event, size),
          onPointerDown: (event) => _updatePointer(event, size),
          onPointerUp: (_) => setState(() => _pointerPosition = null),
          child: IgnorePointer(
            ignoring: true,
            child: CustomPaint(
              painter: _ConstellationPainter(
                dots: _dots,
                maxConnectionDistance: connectionDistance,
                pointerPosition: _pointerPosition,
              ),
              child: Container(),
            ),
          ),
        );
      },
    );
  }
}

class _Dot {
  double x;
  double y;
  double vx;
  double vy;

  _Dot({required this.x, required this.y, required this.vx, required this.vy});

  void updatePosition() {
    x += vx;
    y += vy;

    if (x < 0 || x > 1) vx *= -1;
    if (y < 0 || y > 1) vy *= -1;
  }
}

class _ConstellationPainter extends CustomPainter {
  final List<_Dot> dots;
  final double maxConnectionDistance;
  final Offset? pointerPosition;

  final Paint _dotPaint = Paint()..style = PaintingStyle.fill;
  final Paint _linePaint = Paint();

  _ConstellationPainter({
    required this.dots,
    required this.maxConnectionDistance,
    required this.pointerPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _dotPaint.color = Colors.white.withAlpha(100);

    for (var dot in dots) {
      final pos = Offset(dot.x * size.width, dot.y * size.height);
      canvas.drawCircle(pos, 1.5, _dotPaint);
    }

    final double maxDistSq = pow(maxConnectionDistance, 2).toDouble();

    for (var i = 0; i < dots.length; i++) {
      final p1 = Offset(dots[i].x * size.width, dots[i].y * size.height);
      for (var j = i + 1; j < dots.length; j++) {
        final p2 = Offset(dots[j].x * size.width, dots[j].y * size.height);
        final num distSq = pow(p2.dx - p1.dx, 2) + pow(p2.dy - p1.dy, 2);

        if (distSq <= maxDistSq) {
          final double opacity = 1.0 - (sqrt(distSq) / maxConnectionDistance);
          _linePaint.color = Colors.white.withAlpha((opacity * 50).round());
          _linePaint.strokeWidth = 1.0;
          canvas.drawLine(p1, p2, _linePaint);
        }
      }
    }

    if (pointerPosition != null) {
      final pointerPx = Offset(pointerPosition!.dx * size.width, pointerPosition!.dy * size.height);
      for (var dot in dots) {
        final p = Offset(dot.x * size.width, dot.y * size.height);
        final num distSq = pow(p.dx - pointerPx.dx, 2) + pow(p.dy - pointerPx.dy, 2);

        if (distSq <= maxDistSq) {
          final double opacity = 1.0 - (sqrt(distSq) / maxConnectionDistance);
          _linePaint.color = Colors.white.withAlpha((opacity * 120).round());
          _linePaint.strokeWidth = 1.0;
          canvas.drawLine(pointerPx, p, _linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) {
    return true;
  }
}