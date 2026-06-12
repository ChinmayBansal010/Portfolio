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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final List<GlobalKey> navbarKeys = List.generate(navTitles.length, (_) => GlobalKey());

  final ValueNotifier<int> _currentActiveNavIndex = ValueNotifier<int>(0);
  bool _isScrollingProgrammatically = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    _currentActiveNavIndex.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!mounted || _isScrollingProgrammatically) return;
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
    _isScrollingProgrammatically = true;
    _currentActiveNavIndex.value = navIndex;
    await NavigationHelper.scrollToSection(
      context: context,
      navIndex: navIndex,
      navbarKeys: navbarKeys,
    );
    await Future.delayed(const Duration(milliseconds: 650));
    if (mounted) _isScrollingProgrammatically = false;
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
            children: [
              Positioned.fill(
                child: _NebulaBackground(
                  scrollController: scrollController,
                ),
              ),

              Positioned.fill(
                child: _PerspectiveGridPainterWidget(
                  scrollController: scrollController,
                ),
              ),

              Positioned.fill(
                child: _CinematicStarField(
                  scrollController: scrollController,
                  particleCount: isDesktop ? 700 : 300,
                ),
              ),

              Positioned.fill(
                child: _ConstellationLayer(
                  scrollController: scrollController,
                  nodeCount: isDesktop ? 60 : 30,
                ),
              ),

              Positioned.fill(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: isDesktop ? 104 : 92, key: navbarKeys[0]),
                      MainSection(
                        navbarKeys: navbarKeys,
                        scrollController: scrollController,
                      ),
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

              // ── Layer 5: Frosted header + scroll progress ─────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: FrostedHeaderWrapper(
                  backgroundColor: AppColors.background,
                  backgroundAlpha: 88,
                  blurSigma: 24,
                  enableBorder: true,
                  height: isDesktop ? 94 : 84,
                  child: Stack(
                    children: [
                      ValueListenableBuilder<int>(
                        valueListenable: _currentActiveNavIndex,
                        builder: (context, activeIndex, _) => isDesktop
                            ? HeaderDesktop(
                          onNavMenuTap: _navigateToSection,
                          activeIndex: activeIndex,
                        )
                            : HeaderMobile(
                          onLogoTap: () => _navigateToSection(0),
                          onMenuTap: () =>
                              scaffoldKey.currentState?.openEndDrawer(),
                        ),
                      ),
                      // Animated scroll progress bar
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: AnimatedBuilder(
                          animation: scrollController,
                          builder: (context, _) {
                            final maxScroll = (scrollController.hasClients && scrollController.position.hasContentDimensions)
                                ? scrollController.position.maxScrollExtent
                                : 0.0;
                            final progress = maxScroll == 0
                                ? 0.0
                                : (scrollController.offset / maxScroll)
                                .clamp(0.0, 1.0);
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 60),
                              height: 2,
                              width: MediaQuery.of(context).size.width * progress,
                              decoration: BoxDecoration(
                                gradient: AppColors.accentGradientStrong,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent.withValues(alpha: 0.6),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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


class _NebulaBackground extends StatefulWidget {
  final ScrollController scrollController;
  const _NebulaBackground({required this.scrollController});

  @override
  State<_NebulaBackground> createState() => _NebulaBackgroundState();
}

class _NebulaBackgroundState extends State<_NebulaBackground>
    with SingleTickerProviderStateMixin {
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

  @override
  void paint(Canvas canvas, Size size) {
    // Slow-breathing dual nebula
    final hue1 = 260.0 + sin(t * 0.15) * 20;
    final hue2 = 195.0 + cos(t * 0.1) * 15;
    final alpha1 = 0.055 + sin(t * 0.2) * 0.015;
    final alpha2 = 0.04 + cos(t * 0.17) * 0.01;

    final scrollShift = scrollOffset * 0.22;
    final center1 = Offset(size.width * 0.3, size.height * 0.4 - scrollShift);
    final center2 = Offset(size.width * 0.75, size.height * 0.6 - scrollShift * 0.7);

    final g1 = RadialGradient(
      colors: [
        HSLColor.fromAHSL(alpha1, hue1, 0.7, 0.35).toColor(),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: center1, radius: size.width * 0.55));

    final g2 = RadialGradient(
      colors: [
        HSLColor.fromAHSL(alpha2, hue2, 0.65, 0.3).toColor(),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: center2, radius: size.width * 0.45));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..shader = g1);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..shader = g2);
  }

  @override
  bool shouldRepaint(_NebulaPainter old) => old.t != t || old.scrollOffset != scrollOffset;
}

class _PerspectiveGridPainterWidget extends StatelessWidget {
  final ScrollController scrollController;
  const _PerspectiveGridPainterWidget({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scrollController,
      builder: (context, _) {
        final offset = (scrollController.hasClients && scrollController.position.hasContentDimensions)
            ? scrollController.offset
            : 0.0;
        return CustomPaint(
          painter: _PerspectiveGridPainter(scrollOffset: offset),
          size: Size.infinite,
        );
      },
    );
  }
}

class _PerspectiveGridPainter extends CustomPainter {
  final double scrollOffset;
  _PerspectiveGridPainter({required this.scrollOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final vanishX = size.width / 2;
    final vanishY = size.height * 0.68;
    final scroll = scrollOffset * 0.001;
    const lineCount = 14;

    final linePaint = Paint()..strokeWidth = 0.5;

    for (int i = 0; i <= lineCount; i++) {
      final t = i / lineCount;
      final endX = (t - 0.5) * size.width * 2.4;
      final alpha = 0.025 + 0.015 * sin(scroll + i * 0.4);
      final grad = ui.Gradient.linear(
        Offset(vanishX, vanishY),
        Offset(vanishX + endX, size.height),
        [
          const Color(0x00000000),
          Color.fromRGBO(108, 99, 255, alpha),
          const Color(0x00000000),
        ],
        [0.0, 0.5, 1.0],
      );
      linePaint.shader = grad;
      canvas.drawLine(
          Offset(vanishX, vanishY), Offset(vanishX + endX, size.height), linePaint);
    }

    for (int row = 1; row <= 9; row++) {
      final r = row / 9;
      final ease = r * r;
      final y = vanishY + (size.height - vanishY) * ease;
      final xSpan = size.width * 1.2 * ease;
      final alpha = (0.02 + 0.01 * sin(scroll * 2 + row * 0.5)) *
          (1 - (y - vanishY) / (size.height - vanishY) * 0.4);
      final grad = ui.Gradient.linear(
        Offset(vanishX - xSpan, y),
        Offset(vanishX + xSpan, y),
        [
          const Color(0x00000000),
          Color.fromRGBO(108, 99, 255, alpha),
          Color.fromRGBO(108, 99, 255, alpha),
          const Color(0x00000000),
        ],
        [0.0, 0.15, 0.85, 1.0],
      );
      linePaint.shader = grad;
      canvas.drawLine(Offset(vanishX - xSpan, y), Offset(vanishX + xSpan, y), linePaint);
    }
  }

  @override
  bool shouldRepaint(_PerspectiveGridPainter old) =>
      old.scrollOffset != scrollOffset;
}


class _StarParticle {
  late double x, y, z, ox, oy, twinkle, twinkleSpeed, radius;
  late Color baseColor;

  static final _rng = Random();
  static const _fov = 450.0;
  static const _depth = 4000.0;
  static const _colors = [
    Color(0xFF6C63FF),
    Color(0xFF06B6D4),
    Color(0xFFA78BFA),
    Color(0xFFF472B6),
  ];

  _StarParticle() {
    _reset(init: true);
  }

  void _reset({bool init = false}) {
    ox = x = (_rng.nextDouble() - 0.5) * 3200;
    oy = y = (_rng.nextDouble() - 0.5) * 3200;
    z = init ? _rng.nextDouble() * _depth : _depth;
    twinkle = _rng.nextDouble() * pi * 2;
    twinkleSpeed = 0.025 + _rng.nextDouble() * 0.04;
    radius = 0.5 + _rng.nextDouble() * 2.0;
    baseColor = _colors[_rng.nextInt(_colors.length)];
  }

  void update({required double scrollDelta, required double idleT}) {
    z -= scrollDelta * 1.2 + 0.35;
    twinkle += twinkleSpeed;
    if (z < -_fov) _reset();
  }

  void draw(Canvas canvas, Size size, double mouseX, double mouseY) {
    if (z < -_fov + 10) return;
    final scale = _fov / (_fov + z);
    final parallaxX = (mouseX - 0.5) * 50 * scale;
    final parallaxY = (mouseY - 0.5) * 50 * scale;
    final px = size.width / 2 + x * scale + parallaxX;
    final py = size.height / 2 + y * scale + parallaxY;
    if (px < -8 || px > size.width + 8 || py < -8 || py > size.height + 8) return;

    final depth = (1.0 - z / _depth).clamp(0.0, 1.0);
    final twinkleVal = 0.5 + 0.5 * sin(twinkle);
    final alpha = depth * (0.4 + 0.6 * twinkleVal) * 0.92;
    final r = max(0.3, radius * scale * (0.7 + 0.3 * twinkleVal));

    final c = baseColor.withValues(alpha: alpha);
    final paint = Paint()
      ..color = c
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(px, py), r, paint);

    // Glow halo for bright foreground stars
    if (depth > 0.65 && r > 1.0) {
      canvas.drawCircle(
        Offset(px, py),
        r * 2.5,
        Paint()
          ..color = baseColor.withValues(alpha: alpha * 0.12)
          ..style = PaintingStyle.fill,
      );
    }
  }
}

class _CinematicStarField extends StatefulWidget {
  final ScrollController scrollController;
  final int particleCount;

  const _CinematicStarField({
    required this.scrollController,
    this.particleCount = 600,
  });

  @override
  State<_CinematicStarField> createState() => _CinematicStarFieldState();
}

class _CinematicStarFieldState extends State<_CinematicStarField>
    with SingleTickerProviderStateMixin {
  late List<_StarParticle> _particles;
  late Ticker _ticker;
  double _idleT = 0;
  double _lastScrollOffset = 0;
  double _mouseX = 0.5, _mouseY = 0.5;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(widget.particleCount, (_) => _StarParticle());
    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    _idleT = elapsed.inMilliseconds / 1000.0;
    final currentOffset = (widget.scrollController.hasClients && widget.scrollController.position.hasContentDimensions)
        ? widget.scrollController.offset
        : 0.0;
    final scrollDelta = currentOffset - _lastScrollOffset;
    _lastScrollOffset = currentOffset;
    for (final p in _particles) {
      p.update(scrollDelta: scrollDelta, idleT: _idleT);
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
        painter: _StarFieldPainter(
          particles: _particles,
          mouseX: _mouseX,
          mouseY: _mouseY,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _StarFieldPainter extends CustomPainter {
  final List<_StarParticle> particles;
  final double mouseX, mouseY;
  _StarFieldPainter({required this.particles, required this.mouseX, required this.mouseY});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      p.draw(canvas, size, mouseX, mouseY);
    }
  }

  @override
  bool shouldRepaint(_StarFieldPainter old) => true;
}

class _ConstellationNode {
  late double x, y, vx, vy;
  final _rng = Random();

  _ConstellationNode() {
    x = _rng.nextDouble();
    y = _rng.nextDouble();
    vx = (_rng.nextDouble() - 0.5) * 0.00008;
    vy = (_rng.nextDouble() - 0.5) * 0.00008;
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

  const _ConstellationLayer({
    required this.scrollController,
    this.nodeCount = 50,
  });

  @override
  State<_ConstellationLayer> createState() => _ConstellationLayerState();
}

class _ConstellationLayerState extends State<_ConstellationLayer>
    with SingleTickerProviderStateMixin {
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
          painter: _ConstellationPainterFull(
            nodes: _nodes,
            mouseX: _mouseX,
            mouseY: _mouseY,
          ),
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

  _ConstellationPainterFull({
    required this.nodes,
    required this.mouseX,
    required this.mouseY,
  });

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
      for (int j = i + 1; j < positions.length; j++) {
        final b = positions[j];
        final dx = b.dx - a.dx, dy = b.dy - a.dy;
        final distSq = dx * dx + dy * dy;
        if (distSq <= maxDistSq) {
          final alpha = (1 - sqrt(distSq) / maxDist) * 0.07;
          linePaint.color = Color.fromRGBO(167, 139, 250, alpha);
          canvas.drawLine(a, b, linePaint);
        }
      }

      // Cursor magnetism lines
      final cdx = a.dx - mxPx, cdy = a.dy - myPx;
      final cDistSq = cdx * cdx + cdy * cdy;
      if (cDistSq <= (maxDist * 1.8) * (maxDist * 1.8)) {
        final cDist = sqrt(cDistSq);
        final alpha = (1 - cDist / (maxDist * 1.8)) * 0.22;
        linePaint.color = Color.fromRGBO(108, 99, 255, alpha);
        canvas.drawLine(a, Offset(mxPx, myPx), linePaint);
      }

      dotPaint.color = const Color(0x28A78BFA);
      canvas.drawCircle(a, nodes[i].vx.abs() * 50000 + 0.9, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ConstellationPainterFull old) => true;
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
          // Glowing gradient line
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
          // Pulsing center orb
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

// ─────────────────────────────────────────────────────────────────────────────
// Interactive constellation background (for sub-widgets / cards)
// ─────────────────────────────────────────────────────────────────────────────

class InteractiveConstellationBackground extends StatefulWidget {
  const InteractiveConstellationBackground({super.key});

  @override
  State<InteractiveConstellationBackground> createState() =>
      _InteractiveConstellationBackgroundState();
}

class _InteractiveConstellationBackgroundState
    extends State<InteractiveConstellationBackground>
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
    _starLayers = List.generate(3, (i) => _StarLayer(
      layerIndex: i,
      dotCount: _calcDotCount(size.width, i),
      random: _random,
    ));
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
                ..._starLayers.map((layer) => Positioned.fill(
                  child: CustomPaint(
                    painter: _ConstellationSubPainter(
                      dots: layer.dots,
                      maxConnectionDistance: _calcConnectionDist(size.width, layer.layerIndex),
                      pointerPosition: _pointerPosition,
                      layerIndex: layer.layerIndex,
                    ),
                  ),
                )),
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
      : dots = List.generate(dotCount, (_) => _Dot(
    x: random.nextDouble(), y: random.nextDouble(),
    vx: (random.nextDouble() - 0.5) * 0.0001 * (layerIndex + 1),
    vy: (random.nextDouble() - 0.5) * 0.0001 * (layerIndex + 1),
    radius: random.nextDouble() * (1 + layerIndex) + 0.9,
  ));

  void updatePositions() { for (final d in dots) {
    d.updatePosition();
  } }
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
    final px = Offset((pointerPosition.dx - 0.5) * parallaxFactor,
        (pointerPosition.dy - 0.5) * parallaxFactor);
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()..strokeWidth = 0.8;
    final maxDistSq = maxConnectionDistance * maxConnectionDistance;

    final positions = dots.map((d) => Offset(
      (d.x + px.dx) * size.width,
      (d.y + px.dy) * size.height,
    )).toList();

    for (int i = 0; i < positions.length; i++) {
      dotPaint.color = AppColors.textSecondary.withValues(
          alpha: (0.7 - layerIndex * 0.18).clamp(0.15, 0.7));
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