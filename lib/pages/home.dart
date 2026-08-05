// pages/home.dart
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
import 'package:portfolio/widgets/black_hole_orb.dart';

double _easeInOutCubic(double t) {
  t = t.clamp(0.0, 1.0);
  return t < 0.5 ? 4 * t * t * t : 1 - pow(-2 * t + 2, 3) / 2;
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final List<GlobalKey> navbarKeys = List.generate(navTitles.length, (_) => GlobalKey());
  final ValueNotifier<int> _currentActiveNavIndex = ValueNotifier<int>(0);
  bool _isScrollingProgrammatically = false;

  late final AnimationController _bootIntro;
  late final AnimationController _bootProgress;
  late final AnimationController _reveal;
  bool _revealStarted = false;
  bool _splashDone = false;

  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _splashOrbAnchorKey = GlobalKey();
  Rect? _splashOrbRect;
  late final Ticker _measureTicker;
  late final Ticker _orbTimeTicker;
  double _orbTime = 0;

  static const _contentReadyDelay = Duration(milliseconds: 3200);
  static const _revealLength = Duration(milliseconds: 1400);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);

    _bootIntro = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
    _bootProgress = AnimationController(vsync: this, duration: const Duration(milliseconds: 2800))..forward();
    _reveal = AnimationController(vsync: this, duration: _revealLength);

    _measureTicker = createTicker((_) => _measureSplashOrb())..start();
    _orbTimeTicker = createTicker((elapsed) {
      if (mounted) setState(() => _orbTime = elapsed.inMilliseconds / 1000.0);
    })..start();

    Future.delayed(_contentReadyDelay, () async {
      if (!mounted) return;
      setState(() => _revealStarted = true);
      await _reveal.forward();
      if (!mounted) return;
      setState(() => _splashDone = true);
      _measureTicker.stop();
    });
  }

  void _measureSplashOrb() {
    if (_reveal.isCompleted) return;
    final anchorCtx = _splashOrbAnchorKey.currentContext;
    final stackCtx = _stackKey.currentContext;
    if (anchorCtx == null || stackCtx == null) return;
    final anchorBox = anchorCtx.findRenderObject() as RenderBox?;
    final stackBox = stackCtx.findRenderObject() as RenderBox?;
    if (anchorBox == null || stackBox == null || !anchorBox.attached) return;
    final topLeft = anchorBox.localToGlobal(Offset.zero, ancestor: stackBox);
    final rect = topLeft & anchorBox.size;
    if (_splashOrbRect != rect) {
      setState(() => _splashOrbRect = rect);
    }
  }

  Rect _homeOrbRect(Size stackSize, double scrollProgress, double bobX, double bobY) {
    final diameter = stackSize.shortestSide * 0.62;
    final centerX = stackSize.width * 0.85 - (scrollProgress * stackSize.width * 0.12) + bobX;
    final centerY = stackSize.height * 0.24 + (scrollProgress * stackSize.height * 0.52) + bobY;
    return Rect.fromCenter(center: Offset(centerX, centerY), width: diameter, height: diameter);
  }

  void _onScroll() {
    if (!mounted || _isScrollingProgrammatically || !_splashDone) return;
    if (!scrollController.hasClients || !scrollController.position.hasContentDimensions) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    const activationLine = 130.0;
    int detectedActiveIndex = _currentActiveNavIndex.value;
    if (scrollController.offset <= 24) {
      detectedActiveIndex = 0;
    } else if (scrollController.offset >= maxScroll - 80) {
      detectedActiveIndex = navbarKeys.length - 1;
    } else {
      double bestScore = double.infinity;
      for (int i = 0; i < navbarKeys.length; i++) {
        final keyContext = navbarKeys[i].currentContext;
        if (keyContext == null) continue;
        final renderBox = keyContext.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final sectionTop = position.dy;
        final sectionBottom = sectionTop + renderBox.size.height;
        if (i == navbarKeys.length - 1 && sectionTop <= viewportHeight * 0.55) {
          detectedActiveIndex = i;
          break;
        }
        if (sectionBottom <= activationLine - 24) continue;
        final score = (sectionTop - activationLine).abs();
        if (score < bestScore) {
          bestScore = score;
          detectedActiveIndex = i;
        }
      }
    }
    if (_currentActiveNavIndex.value != detectedActiveIndex) {
      _currentActiveNavIndex.value = detectedActiveIndex;
    }
  }

  Future<void> _navigateToSection(int navIndex) async {
    if (!_splashDone) return;
    _isScrollingProgrammatically = true;
    _currentActiveNavIndex.value = navIndex;
    await NavigationHelper.scrollToSection(context: context, navIndex: navIndex, navbarKeys: navbarKeys);
    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) _isScrollingProgrammatically = false;
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _currentActiveNavIndex.dispose();
    _bootIntro.dispose();
    _bootProgress.dispose();
    _reveal.dispose();
    _measureTicker.dispose();
    _orbTimeTicker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= kMinDesktopWidth;
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.background,
          endDrawer: isDesktop
              ? null
              : DrawerMobile(
            onNavItemTap: (int navIndex) {
              scaffoldKey.currentState?.closeEndDrawer();
              _navigateToSection(navIndex);
            },
          ),
          body: Stack(
            key: _stackKey,
            children: [
              Positioned.fill(child: const _DeepSpaceWash()),
              Positioned.fill(child: _NebulaBackground(scrollController: scrollController)),
              Positioned.fill(child: _PerspectiveGridPainterWidget(scrollController: scrollController)),
              Positioned.fill(
                child: _CinematicStarField(
                  scrollController: scrollController,
                  particleCount: isDesktop ? 700 : 300,
                ),
              ),

              AnimatedBuilder(
                animation: Listenable.merge([_reveal, scrollController]),
                builder: (context, _) {
                  final size = constraints.biggest;
                  final hasScroll = scrollController.hasClients && scrollController.position.hasContentDimensions;
                  final offset = hasScroll ? scrollController.offset : 0.0;
                  final maxScroll = hasScroll && scrollController.position.maxScrollExtent > 0
                      ? scrollController.position.maxScrollExtent
                      : 1.0;
                  final rawProgress = (offset / maxScroll).clamp(0.0, 1.0);
                  final scrollProgress = _splashDone ? _easeInOutCubic(rawProgress) : 0.0;
                  final bobX = sin(_orbTime * 0.12) * size.width * 0.012;
                  final bobY = cos(_orbTime * 0.09) * size.height * 0.01;

                  final homeRect = _homeOrbRect(size, scrollProgress, bobX, bobY);

                  if (_splashDone) {
                    return Positioned.fromRect(rect: homeRect, child: const BlackHoleOrb());
                  }
                  final fromRect = _splashOrbRect ?? homeRect;
                  final t = Curves.easeInOutCubic.transform(_reveal.value);
                  final rect = Rect.lerp(fromRect, homeRect, t)!;
                  return Positioned.fromRect(rect: rect, child: const BlackHoleOrb());
                },
              ),

              Positioned.fill(
                child: _ConstellationLayer(scrollController: scrollController, nodeCount: isDesktop ? 60 : 30),
              ),

              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !_splashDone,
                  child: AnimatedBuilder(
                    animation: _reveal,
                    builder: (context, child) => Opacity(
                      opacity: Curves.easeIn.transform(_reveal.value),
                      child: child,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: isDesktop ? 104 : 92, key: navbarKeys[0]),
                          MainSection(navbarKeys: navbarKeys, scrollController: scrollController),
                          const SizedBox(height: 120),
                          SkillSection(navbarKey: navbarKeys[1]),
                          const SizedBox(height: 80),
                          ProjectSection(navbarKey: navbarKeys[2]),
                          const SizedBox(height: 80),
                          GetInTouchSection(navbarKey: navbarKeys[3]),
                          const SizedBox(height: 16),
                          const Footer(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              if (!_splashDone)
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: _revealStarted,
                    child: AnimatedBuilder(
                      animation: _reveal,
                      builder: (context, child) {
                        final fade = 1.0 - Curves.easeIn.transform(_reveal.value);
                        return Opacity(opacity: fade, child: child);
                      },
                      child: isDesktop
                          ? _WideContent(
                        intro: _bootIntro,
                        progress: _bootProgress,
                        orbAnchorKey: _splashOrbAnchorKey,
                      )
                          : _NarrowContent(
                        intro: _bootIntro,
                        progress: _bootProgress,
                        orbAnchorKey: _splashOrbAnchorKey,
                      ),
                    ),
                  ),
                ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _reveal,
                  builder: (context, child) => Opacity(
                    opacity: Curves.easeIn.transform(_reveal.value),
                    child: IgnorePointer(ignoring: !_splashDone, child: child),
                  ),
                  child: FrostedHeaderWrapper(
                    backgroundColor: AppColors.background,
                    backgroundAlpha: 88,
                    blurSigma: 24,
                    enableBorder: true,
                    height: isDesktop ? 94 : 84,
                    child: ValueListenableBuilder<int>(
                      valueListenable: _currentActiveNavIndex,
                      builder: (context, activeIndex, _) => isDesktop
                          ? HeaderDesktop(onNavMenuTap: _navigateToSection, activeIndex: activeIndex)
                          : HeaderMobile(
                        onLogoTap: () => _navigateToSection(0),
                        onMenuTap: () => scaffoldKey.currentState?.openEndDrawer(),
                      ),
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

class _DeepSpaceWash extends StatelessWidget {
  const _DeepSpaceWash();
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            Color.lerp(AppColors.background, const Color(0xFF0A0714), 0.6)!,
            Color.lerp(AppColors.background, const Color(0xFF06060C), 0.85)!,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}

class _NebulaBackground extends StatefulWidget {
  final ScrollController scrollController;
  const _NebulaBackground({required this.scrollController});
  @override
  State<_NebulaBackground> createState() => _NebulaBackgroundState();
}

class _NebulaBackgroundState extends State<_NebulaBackground> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _t = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      if (mounted) setState(() => _t = elapsed.inMilliseconds / 1000.0);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.scrollController,
      builder: (context, _) {
        final offset = (widget.scrollController.hasClients && widget.scrollController.position.hasContentDimensions)
            ? widget.scrollController.offset
            : 0.0;
        return CustomPaint(painter: _NebulaPainter(t: _t, scrollOffset: offset));
      },
    );
  }
}

class _NebulaPainter extends CustomPainter {
  final double t;
  final double scrollOffset;
  _NebulaPainter({required this.t, required this.scrollOffset});

  void _blob(Canvas canvas, Size size, Offset center, double radius, double hue, double sat, double light, double alpha) {
    final shader = RadialGradient(
      colors: [
        HSLColor.fromAHSL(alpha, hue, sat, light).toColor(),
        HSLColor.fromAHSL(alpha * 0.4, hue, sat, light).toColor(),
        Colors.transparent,
      ],
      stops: const [0.0, 0.45, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = shader);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scrollShift = scrollOffset * 0.22;
    final hue1 = 260.0 + sin(t * 0.15) * 20;
    final alpha1 = 0.06 + sin(t * 0.2) * 0.016;
    final c1 = Offset(size.width * (0.3 + sin(t * 0.05) * 0.05), size.height * 0.4 - scrollShift + cos(t * 0.07) * 30);
    _blob(canvas, size, c1, size.width * 0.55, hue1, 0.7, 0.35, alpha1);

    final hue2 = 195.0 + cos(t * 0.1) * 15;
    final alpha2 = 0.042 + cos(t * 0.17) * 0.012;
    final c2 = Offset(size.width * (0.75 + cos(t * 0.04) * 0.04), size.height * 0.6 - scrollShift * 0.7 + sin(t * 0.06) * 26);
    _blob(canvas, size, c2, size.width * 0.45, hue2, 0.65, 0.3, alpha2);

    final hue3 = 320.0 + sin(t * 0.08) * 12;
    final alpha3 = 0.022 + sin(t * 0.11 + 1.2) * 0.008;
    final c3 = Offset(size.width * (0.5 + sin(t * 0.03 + 2) * 0.15), size.height * (0.85 - scrollShift * 0.4 / size.height));
    _blob(canvas, size, c3, size.width * 0.4, hue3, 0.6, 0.4, alpha3.clamp(0.0, 1.0));
  }

  @override
  bool shouldRepaint(_NebulaPainter old) => old.t != t || old.scrollOffset != scrollOffset;
}

class _PerspectiveGridPainterWidget extends StatefulWidget {
  final ScrollController scrollController;
  const _PerspectiveGridPainterWidget({required this.scrollController});
  @override
  State<_PerspectiveGridPainterWidget> createState() => _PerspectiveGridPainterWidgetState();
}

class _PerspectiveGridPainterWidgetState extends State<_PerspectiveGridPainterWidget> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _t = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      if (mounted) setState(() => _t = elapsed.inMilliseconds / 1000.0);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.scrollController,
      builder: (context, _) {
        final offset = (widget.scrollController.hasClients && widget.scrollController.position.hasContentDimensions)
            ? widget.scrollController.offset
            : 0.0;
        return CustomPaint(painter: _PerspectiveGridPainter(scrollOffset: offset, t: _t), size: Size.infinite);
      },
    );
  }
}

class _PerspectiveGridPainter extends CustomPainter {
  final double scrollOffset;
  final double t;
  _PerspectiveGridPainter({required this.scrollOffset, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final vanishX = size.width / 2;
    final vanishY = size.height * 0.68;
    final scroll = scrollOffset * 0.001;
    const lineCount = 14;
    final pulse = 0.5 + 0.5 * sin(t * 0.35);
    final linePaint = Paint()..strokeWidth = 0.5;

    for (int i = 0; i <= lineCount; i++) {
      final lt = i / lineCount;
      final endX = (lt - 0.5) * size.width * 2.4;
      final alpha = (0.024 + 0.016 * sin(scroll + i * 0.4)) * (0.75 + 0.25 * pulse);
      final grad = ui.Gradient.linear(
        Offset(vanishX, vanishY),
        Offset(vanishX + endX, size.height),
        [const Color(0x00000000), Color.fromRGBO(108, 99, 255, alpha), const Color(0x00000000)],
        [0.0, 0.5, 1.0],
      );
      linePaint.shader = grad;
      canvas.drawLine(Offset(vanishX, vanishY), Offset(vanishX + endX, size.height), linePaint);
    }

    for (int row = 1; row <= 9; row++) {
      final r = row / 9;
      final ease = _easeInOutCubic(r * r);
      final y = vanishY + (size.height - vanishY) * ease;
      final xSpan = size.width * 1.2 * ease;
      final alpha = (0.018 + 0.01 * sin(scroll * 2 + row * 0.5)) * (1 - (y - vanishY) / (size.height - vanishY) * 0.4);
      final grad = ui.Gradient.linear(
        Offset(vanishX - xSpan, y),
        Offset(vanishX + xSpan, y),
        [const Color(0x00000000), Color.fromRGBO(108, 99, 255, alpha), Color.fromRGBO(108, 99, 255, alpha), const Color(0x00000000)],
        [0.0, 0.15, 0.85, 1.0],
      );
      linePaint.shader = grad;
      canvas.drawLine(Offset(vanishX - xSpan, y), Offset(vanishX + xSpan, y), linePaint);
    }

    final glow = ui.Gradient.radial(Offset(vanishX, vanishY), 140, [
      Color.fromRGBO(108, 99, 255, 0.05 * (0.6 + 0.4 * pulse)),
      Colors.transparent,
    ]);
    canvas.drawCircle(Offset(vanishX, vanishY), 140, Paint()..shader = glow);
  }

  @override
  bool shouldRepaint(_PerspectiveGridPainter old) => old.scrollOffset != scrollOffset || old.t != t;
}

class _StarParticle {
  late double x, y, z, twinkle, twinkleSpeed, radius;
  double prevScreenX = 0, prevScreenY = 0;
  bool hasPrev = false;
  late Color baseColor;

  static final _rng = Random();
  static const _fov = 450.0;
  static const _depth = 4000.0;
  static const _colors = [
    Color(0xFF6C63FF),
    Color(0xFF06B6D4),
    Color(0xFFA78BFA),
    Color(0xFFF472B6),
    Color(0xFFFFFFFF),
  ];

  _StarParticle() {
    _reset(init: true);
  }

  void _reset({bool init = false}) {
    x = (_rng.nextDouble() - 0.5) * 3200;
    y = (_rng.nextDouble() - 0.5) * 3200;
    z = init ? _rng.nextDouble() * _depth : _depth;
    twinkle = _rng.nextDouble() * pi * 2;
    twinkleSpeed = 0.025 + _rng.nextDouble() * 0.04;
    radius = 0.5 + _rng.nextDouble() * 2.0;
    baseColor = _colors[_rng.nextInt(_colors.length)];
    hasPrev = false;
  }

  void update({required double scrollDelta}) {
    z -= scrollDelta * 1.2 + 0.35;
    twinkle += twinkleSpeed;
    if (z < -_fov) _reset();
  }

  void draw(Canvas canvas, Size size, double mouseX, double mouseY, double scrollVelocity) {
    if (z < -_fov + 10) return;
    final scale = _fov / (_fov + z);
    final parallaxX = (mouseX - 0.5) * 50 * scale;
    final parallaxY = (mouseY - 0.5) * 50 * scale;
    final px = size.width / 2 + x * scale + parallaxX;
    final py = size.height / 2 + y * scale + parallaxY;
    if (px < -8 || px > size.width + 8 || py < -8 || py > size.height + 8) {
      hasPrev = false;
      return;
    }

    final depth = (1.0 - z / _depth).clamp(0.0, 1.0);
    final twinkleVal = 0.5 + 0.5 * sin(twinkle);
    final alpha = depth * (0.4 + 0.6 * twinkleVal) * 0.92;
    final r = max(0.3, radius * scale * (0.7 + 0.3 * twinkleVal));
    final c = baseColor.withValues(alpha: alpha);

    final speedFactor = (scrollVelocity.abs() * scale).clamp(0.0, 40.0);
    if (hasPrev && speedFactor > 2.5 && depth > 0.25) {
      final trailPaint = Paint()
        ..strokeCap = StrokeCap.round
        ..strokeWidth = r * 1.4
        ..shader = ui.Gradient.linear(Offset(prevScreenX, prevScreenY), Offset(px, py), [Colors.transparent, c]);
      canvas.drawLine(Offset(prevScreenX, prevScreenY), Offset(px, py), trailPaint);
    } else {
      canvas.drawCircle(Offset(px, py), r, Paint()..color = c);
      if (depth > 0.65 && r > 1.0) {
        canvas.drawCircle(Offset(px, py), r * 2.5, Paint()..color = baseColor.withValues(alpha: alpha * 0.12));
      }
    }

    prevScreenX = px;
    prevScreenY = py;
    hasPrev = true;
  }
}

class _CinematicStarField extends StatefulWidget {
  final ScrollController scrollController;
  final int particleCount;
  const _CinematicStarField({required this.scrollController, this.particleCount = 600});
  @override
  State<_CinematicStarField> createState() => _CinematicStarFieldState();
}

class _CinematicStarFieldState extends State<_CinematicStarField> with SingleTickerProviderStateMixin {
  late List<_StarParticle> _particles;
  late Ticker _ticker;
  double _lastScrollOffset = 0;
  double _scrollVelocity = 0;
  double _mouseX = 0.5, _mouseY = 0.5;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(widget.particleCount, (_) => _StarParticle());
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    final currentOffset = (widget.scrollController.hasClients && widget.scrollController.position.hasContentDimensions)
        ? widget.scrollController.offset
        : 0.0;
    final scrollDelta = currentOffset - _lastScrollOffset;
    _lastScrollOffset = currentOffset;
    _scrollVelocity = _scrollVelocity * 0.85 + scrollDelta * 0.15;
    for (final p in _particles) {
      p.update(scrollDelta: scrollDelta);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: (e) {
        final size = MediaQuery.sizeOf(context);
        _mouseX = e.localPosition.dx / size.width;
        _mouseY = e.localPosition.dy / size.height;
      },
      child: CustomPaint(
        painter: _StarFieldPainter(particles: _particles, mouseX: _mouseX, mouseY: _mouseY, scrollVelocity: _scrollVelocity),
        size: Size.infinite,
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  final List<_StarParticle> particles;
  final double mouseX, mouseY, scrollVelocity;
  _StarFieldPainter({required this.particles, required this.mouseX, required this.mouseY, required this.scrollVelocity});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      p.draw(canvas, size, mouseX, mouseY, scrollVelocity);
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter old) => true;
}

class _ConstellationNode {
  late double x, y, vx, vy, depth;
  final _rng = Random();

  _ConstellationNode() {
    x = _rng.nextDouble();
    y = _rng.nextDouble();
    vx = (_rng.nextDouble() - 0.5) * 0.00008;
    vy = (_rng.nextDouble() - 0.5) * 0.00008;
    depth = _rng.nextDouble();
  }

  void update() {
    x = (x + vx).clamp(0.0, 1.0);
    y = (y + vy).clamp(0.0, 1.0);
    if (x <= 0 || x >= 1) vx = -vx;
    if (y <= 0 || y >= 1) vy = -vy;
  }
}

class _ConstellationLayer extends StatefulWidget {
  final ScrollController scrollController;
  final int nodeCount;
  const _ConstellationLayer({required this.scrollController, this.nodeCount = 50});
  @override
  State<_ConstellationLayer> createState() => _ConstellationLayerState();
}

class _ConstellationLayerState extends State<_ConstellationLayer> with SingleTickerProviderStateMixin {
  late List<_ConstellationNode> _nodes;
  late Ticker _ticker;
  double _mouseX = 0.5, _mouseY = 0.5;

  @override
  void initState() {
    super.initState();
    _nodes = List.generate(widget.nodeCount, (_) => _ConstellationNode());
    _ticker = createTicker((_) {
      if (!mounted) return;
      for (final n in _nodes) {
        n.update();
      }
      setState(() {});
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: (e) {
        final size = MediaQuery.sizeOf(context);
        _mouseX = e.localPosition.dx / size.width;
        _mouseY = e.localPosition.dy / size.height;
      },
      child: IgnorePointer(
        child: CustomPaint(
          painter: _ConstellationPainterFull(nodes: _nodes, mouseX: _mouseX, mouseY: _mouseY),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _ConstellationPainterFull extends CustomPainter {
  final List<_ConstellationNode> nodes;
  final double mouseX, mouseY;
  static const maxDist = 100.0;
  _ConstellationPainterFull({required this.nodes, required this.mouseX, required this.mouseY});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()..strokeWidth = 0.6;
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final maxDistSq = maxDist * maxDist;
    final mxPx = mouseX * size.width;
    final myPx = mouseY * size.height;
    final positions = nodes.map((n) => Offset(n.x * size.width, n.y * size.height)).toList();

    for (int i = 0; i < positions.length; i++) {
      final a = positions[i];
      final depthDim = 0.5 + 0.5 * nodes[i].depth;

      for (int j = i + 1; j < positions.length; j++) {
        final b = positions[j];
        final dx = b.dx - a.dx, dy = b.dy - a.dy;
        final distSq = dx * dx + dy * dy;
        if (distSq <= maxDistSq) {
          final alpha = (1 - sqrt(distSq) / maxDist) * 0.07 * depthDim;
          linePaint.color = Color.fromRGBO(167, 139, 250, alpha);
          canvas.drawLine(a, b, linePaint);
        }
      }

      final cdx = a.dx - mxPx, cdy = a.dy - myPx;
      final cDistSq = cdx * cdx + cdy * cdy;
      if (cDistSq <= (maxDist * 1.8) * (maxDist * 1.8)) {
        final cDist = sqrt(cDistSq);
        final alpha = (1 - cDist / (maxDist * 1.8)) * 0.22;
        linePaint.color = Color.fromRGBO(108, 99, 255, alpha);
        canvas.drawLine(a, Offset(mxPx, myPx), linePaint);
      }

      dotPaint.color = Color.fromRGBO(167, 139, 250, 0.16 * depthDim);
      canvas.drawCircle(a, nodes[i].vx.abs() * 50000 + 0.9, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainterFull old) => true;
}

class _WideContent extends StatelessWidget {
  const _WideContent({required this.intro, required this.progress, required this.orbAnchorKey});
  final AnimationController intro;
  final AnimationController progress;
  final GlobalKey orbAnchorKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 72),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: _LeftStatement(intro: intro, progress: progress)),
          const SizedBox(width: 56),
          Expanded(flex: 5, child: _RightVisual(intro: intro, progress: progress, orbAnchorKey: orbAnchorKey)),
        ],
      ),
    );
  }
}

class _NarrowContent extends StatelessWidget {
  const _NarrowContent({required this.intro, required this.progress, required this.orbAnchorKey});
  final AnimationController intro;
  final AnimationController progress;
  final GlobalKey orbAnchorKey;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          _LeftStatement(intro: intro, progress: progress, centered: true),
          const SizedBox(height: 40),
          _RightVisual(intro: intro, progress: progress, orbAnchorKey: orbAnchorKey, compact: true),
        ],
      ),
    );
  }
}

class _LeftStatement extends StatelessWidget {
  const _LeftStatement({required this.intro, required this.progress, this.centered = false});
  final AnimationController intro;
  final AnimationController progress;
  final bool centered;

  Widget _stagger(Widget child, double from, {Offset slide = const Offset(0, 0.10)}) {
    final anim = CurvedAnimation(parent: intro, curve: Interval(from, 1.0, curve: Curves.easeOutCubic));
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(position: Tween(begin: slide, end: Offset.zero).animate(anim), child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final align = centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
      children: [
        _stagger(
          Row(
            mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF22C55E),
                  boxShadow: [BoxShadow(color: const Color(0xFF22C55E).withValues(alpha: 0.55), blurRadius: 8, spreadRadius: 1)],
                ),
              ),
              const SizedBox(width: 9),
              Text(
                'CHINMAY BANSAL  ·  AVAILABLE',
                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, letterSpacing: 2.2, color: AppColors.textMuted),
              ),
            ],
          ),
          0.0,
        ),
        const SizedBox(height: 24),
        _stagger(
          Text(
            'Computer vision\n& AI systems\nthat ship.',
            textAlign: textAlign,
            style: TextStyle(fontSize: 58, fontWeight: FontWeight.w900, height: 0.96, letterSpacing: -2.2, color: AppColors.textPrimary),
          ),
          0.07,
          slide: const Offset(0, 0.08),
        ),
        const SizedBox(height: 22),
        _stagger(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text(
              'Real-time perception · deep learning · ROS · inference APIs',
              textAlign: textAlign,
              style: TextStyle(fontSize: 14.5, color: AppColors.textMuted, height: 1.62, letterSpacing: 0.1),
            ),
          ),
          0.16,
        ),
        const SizedBox(height: 32),
        _stagger(_TerminalLog(progress: progress), 0.26),
        const SizedBox(height: 28),
        _stagger(_ProgressBar(progress: progress, centered: centered), 0.38),
      ],
    );
  }
}

class _TerminalLog extends StatelessWidget {
  const _TerminalLog({required this.progress});
  final AnimationController progress;

  static const _logs = [
    ('[Vision]', 'Initializing perception graph'),
    ('[Models]', 'Loading inference nodes'),
    ('[ROS]', 'Linking robot channels'),
    ('[APIs]', 'Securing transport layer'),
    ('[UI]', 'Rendering interactive shell'),
    ('[Ready]', 'Portfolio system online'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _dot(const Color(0xFFFF5F56)),
              const SizedBox(width: 6),
              _dot(const Color(0xFFFFBD2E)),
              const SizedBox(width: 6),
              _dot(const Color(0xFF27C93F)),
              const SizedBox(width: 12),
              Text('boot.sh', style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'monospace')),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: progress,
            builder: (_, __) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _logs.asMap().entries.map((e) {
                  final i = e.key;
                  final entry = e.value;
                  final threshold = i / (_logs.length + 1);
                  final visible = progress.value >= threshold;
                  if (!visible) return const SizedBox.shrink();
                  final isLast = i == _logs.length - 1;
                  return Padding(
                    padding: EdgeInsets.only(bottom: i < _logs.length - 1 ? 5 : 0),
                    child: Row(
                      children: [
                        Text(
                          isLast ? '✓ ' : '› ',
                          style: TextStyle(
                            color: isLast ? const Color(0xFF22C55E) : AppColors.accent,
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          entry.$1,
                          style: TextStyle(
                            color: isLast ? const Color(0xFF22C55E) : AppColors.accent.withValues(alpha: 0.7),
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            entry.$2,
                            style: TextStyle(
                              color: isLast ? const Color(0xFF22C55E).withValues(alpha: 0.8) : AppColors.textMuted,
                              fontFamily: 'monospace',
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) =>
      Container(width: 9, height: 9, decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.7)));
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, this.centered = false});
  final AnimationController progress;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (_, __) {
        final pct = (progress.value * 100).round();
        return Column(
          crossAxisAlignment: centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Text('Loading', style: TextStyle(fontSize: 11, color: AppColors.textMuted, fontFamily: 'monospace')),
                const SizedBox(width: 8),
                Text('$pct%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.accent, fontFamily: 'monospace')),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: centered ? double.infinity : 300,
              height: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1),
                child: Stack(
                  children: [
                    Container(color: AppColors.borderStrong.withValues(alpha: 0.25)),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradientStrong,
                          boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.5), blurRadius: 6)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RightVisual extends StatelessWidget {
  const _RightVisual({
    required this.intro,
    required this.progress,
    required this.orbAnchorKey,
    this.compact = false,
  });
  final AnimationController intro;
  final AnimationController progress;
  final GlobalKey orbAnchorKey;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(parent: intro, curve: const Interval(0.12, 1.0, curve: Curves.easeOutCubic));
    final orbSz = compact ? 240.0 : 340.0;

    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween(begin: const Offset(0.05, 0), end: Offset.zero).animate(anim),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                width: orbSz,
                height: orbSz,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(child: SizedBox(key: orbAnchorKey)),
                    AnimatedBuilder(
                      animation: progress,
                      builder: (_, __) {
                        final a = progress.value * 2 * pi;
                        final r = orbSz * 0.44;
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            _floatNode('Vision', a, r),
                            _floatNode('Models', a + 2.09, r),
                            _floatNode('ROS', a + 4.19, r),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const _StatusRow(),
          ],
        ),
      ),
    );
  }

  Widget _floatNode(String label, double angle, double radius) {
    return Transform.translate(
      offset: Offset(cos(angle) * radius, sin(angle) * radius),
      child: _OrbitalChip(label: label),
    );
  }
}

class _OrbitalChip extends StatelessWidget {
  const _OrbitalChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.28)),
        boxShadow: [BoxShadow(color: AppColors.accent.withValues(alpha: 0.10), blurRadius: 10)],
      ),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 0.2)),
    );
  }
}

class _StatusRow extends StatelessWidget {
  const _StatusRow();

  @override
  Widget build(BuildContext context) {
    const items = [('MODE', 'VISION'), ('STACK', 'ROS · ML'), ('STATE', 'LIVE')];
    return Row(
      children: items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return Expanded(
          child: Row(
            children: [
              if (i > 0)
                Container(width: 1, height: 28, margin: const EdgeInsets.symmetric(horizontal: 12), color: AppColors.borderStrong.withValues(alpha: 0.25)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(item.$1, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: AppColors.textMuted, letterSpacing: 1.5, fontFamily: 'monospace')),
                    const SizedBox(height: 3),
                    Text(item.$2, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.textPrimary, letterSpacing: 0.2)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class LottieSectionSeparator extends StatelessWidget {
  const LottieSectionSeparator({super.key, this.repeat = true});

  final bool repeat;

  @override
  Widget build(BuildContext context) {
    final sw = MediaQuery.sizeOf(context).width;
    final lineWidth = sw < 720 ? sw * 0.86 : min(sw * 0.9, 1180.0);
    final lottieWidth = sw < 720 ? sw * 0.62 : 760.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: sw < 720 ? 18 : 22),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: lineWidth,
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.borderStrong.withValues(alpha: 0.4),
                  AppColors.accentSoft,
                  AppColors.borderStrong.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: Lottie.asset(
              'assets/animations/section_separator.json',
              width: lottieWidth,
              height: 88,
              repeat: repeat,
              fit: BoxFit.contain,
            ),
          ),
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent,
                  AppColors.accentSoft.withValues(alpha: 0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.7),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
              ],
            ),
          )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(
            begin: const Offset(0.8, 0.8),
            end: const Offset(1.3, 1.3),
            duration: 1200.ms,
            curve: Curves.easeInOut,
          )
              .then()
              .shimmer(
            duration: 1800.ms,
            color: AppColors.accentSoft.withValues(alpha: 0.6),
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

class _InteractiveConstellationBackgroundState extends State<InteractiveConstellationBackground>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late List<_StarLayer> _starLayers;
  final Random _random = Random();
  Offset _pointerPosition = const Offset(0.5, 0.5);
  double _lastInitializedWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _starLayers = [];
    _ticker = createTicker((_) {
      if (!mounted) return;
      setState(() {
        for (var layer in _starLayers) {
          layer.updatePositions();
        }
      });
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _reinitializeLayersIfNeeded(Size size) {
    if ((size.width - _lastInitializedWidth).abs() < 10 && _starLayers.isNotEmpty) return;
    _starLayers = List.generate(
      3,
          (i) => _StarLayer(
        layerIndex: i,
        dotCount: _calcDotCount(size.width, i),
        random: _random,
      ),
    );
    _lastInitializedWidth = size.width;
  }

  int _calcDotCount(double width, int layerIndex) {
    final scale = (width / 400.0).clamp(1.0, 4.0);
    final count = (30.0 * sqrt(scale)).round();
    return (count / (layerIndex + 1)).round() + (layerIndex * 15);
  }

  void _updatePointer(PointerEvent event, Size size) {
    if (!mounted) return;
    setState(() {
      _pointerPosition = Offset(
        (event.localPosition.dx / size.width).clamp(0.0, 1.0),
        (event.localPosition.dy / size.height).clamp(0.0, 1.0),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        _reinitializeLayersIfNeeded(size);
        return Listener(
          onPointerHover: (e) => _updatePointer(e, size),
          onPointerMove: (e) => _updatePointer(e, size),
          child: IgnorePointer(
            child: Stack(
              children: [
                ..._starLayers.map(
                      (layer) => Positioned.fill(
                    child: CustomPaint(
                      painter: _ConstellationSubPainter(
                        dots: layer.dots,
                        maxConnectionDistance: _calcConnectionDist(size.width, layer.layerIndex),
                        pointerPosition: _pointerPosition,
                        layerIndex: layer.layerIndex,
                      ),
                    ),
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
  double x, y, vx, vy, radius;
  _Dot({required this.x, required this.y, required this.vx, required this.vy, required this.radius});

  void updatePosition() {
    x = (x + vx).clamp(0.0, 1.0);
    y = (y + vy).clamp(0.0, 1.0);
    if (x <= 0 || x >= 1) vx = -vx;
    if (y <= 0 || y >= 1) vy = -vy;
  }
}

class _StarLayer {
  final int layerIndex;
  final List<_Dot> dots;

  _StarLayer({required this.layerIndex, required int dotCount, required Random random})
      : dots = List.generate(
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
    for (final d in dots) {
      d.updatePosition();
    }
  }
}

double _calcConnectionDist(double width, int layerIndex) =>
    (120 * sqrt((width / 400.0).clamp(1.0, 2.0))) / (layerIndex + 1);

class _ConstellationSubPainter extends CustomPainter {
  final List<_Dot> dots;
  final double maxConnectionDistance;
  final Offset pointerPosition;
  final int layerIndex;

  _ConstellationSubPainter({
    required this.dots,
    required this.maxConnectionDistance,
    required this.pointerPosition,
    required this.layerIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final parallaxFactor = 0.05 * (layerIndex + 1);
    final px = Offset(
      (pointerPosition.dx - 0.5) * parallaxFactor,
      (pointerPosition.dy - 0.5) * parallaxFactor,
    );
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()..strokeWidth = 0.8;
    final maxDistSq = maxConnectionDistance * maxConnectionDistance;

    final positions = dots
        .map((d) => Offset(
      (d.x + px.dx) * size.width,
      (d.y + px.dy) * size.height,
    ))
        .toList();

    for (int i = 0; i < positions.length; i++) {
      dotPaint.color =
          AppColors.textSecondary.withValues(alpha: (0.7 - layerIndex * 0.18).clamp(0.15, 0.7));
      canvas.drawCircle(positions[i], dots[i].radius, dotPaint);
    }

    for (int i = 0; i < positions.length; i++) {
      for (int j = i + 1; j < positions.length; j++) {
        final dx = positions[j].dx - positions[i].dx;
        final dy = positions[j].dy - positions[i].dy;
        final distSq = dx * dx + dy * dy;
        if (distSq <= maxDistSq) {
          final alpha = (1 - sqrt(distSq) / maxConnectionDistance) * 0.35;
          linePaint.color = AppColors.borderStrong.withValues(alpha: alpha);
          canvas.drawLine(positions[i], positions[j], linePaint);
        }
      }
    }

    final mxPx = Offset(pointerPosition.dx * size.width, pointerPosition.dy * size.height);
    for (int i = 0; i < positions.length; i++) {
      final dx = positions[i].dx - mxPx.dx;
      final dy = positions[i].dy - mxPx.dy;
      final distSq = dx * dx + dy * dy;
      if (distSq <= maxDistSq) {
        final alpha = (1 - sqrt(distSq) / maxConnectionDistance) * 0.5;
        linePaint.color = AppColors.accentSoft.withValues(alpha: alpha);
        canvas.drawLine(mxPx, positions[i], linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationSubPainter old) => true;
}