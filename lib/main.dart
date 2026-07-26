import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/size.dart';
import 'package:portfolio/pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chinmay Bansal',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: baseTheme.colorScheme.copyWith(
          surface: AppColors.surface,
          primary: AppColors.accent,
          secondary: AppColors.accentSoft,
          outline: AppColors.border,
        ),
        textTheme: baseTheme.textTheme.apply(
          fontFamily: 'SpaceGrotesk',
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      builder: (context, child) => _AppCursorShell(child: child ?? const SizedBox.shrink()),
      home: const SplashScreen(),
    );
  }
}

// ── Custom cursor (unchanged) ─────────────────────────────────────────────────
class _AppCursorShell extends StatefulWidget {
  const _AppCursorShell({required this.child});
  final Widget child;

  @override
  State<_AppCursorShell> createState() => _AppCursorShellState();
}

class _AppCursorShellState extends State<_AppCursorShell> with SingleTickerProviderStateMixin {
  late final AnimationController _followController;
  Offset _pointer = const Offset(-100, -100);
  Offset _trail = const Offset(-100, -100);
  bool _visible = false;
  bool _pressed = false;

  bool get _enableCustomCursor {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows => true,
      TargetPlatform.macOS => true,
      TargetPlatform.linux => true,
      _ => false,
    };
  }

  @override
  void initState() {
    super.initState();
    _followController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )
      ..addListener(() {
        if (!_visible || _trail == _pointer) return;
        setState(() => _trail = Offset.lerp(_trail, _pointer, 0.18) ?? _pointer);
      })
      ..repeat();
  }

  @override
  void dispose() {
    _followController.dispose();
    super.dispose();
  }

  void _updatePointer(PointerEvent e) => setState(() => _pointer = e.position);

  @override
  Widget build(BuildContext context) {
    if (!_enableCustomCursor) return widget.child;
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (e) => setState(() {
        _visible = true;
        _pointer = e.position;
        _trail = e.position;
      }),
      onHover: _updatePointer,
      onExit: (_) => setState(() => _visible = false),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerMove: _updatePointer,
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            RepaintBoundary(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 140),
                  child: Stack(children: [
                    Transform.translate(
                      offset: Offset(_trail.dx - 22, _trail.dy - 22),
                      child: AnimatedScale(
                        scale: _pressed ? 0.75 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOutBack,
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentSoft.withValues(alpha: 0.05),
                                border: Border.all(
                                  color: AppColors.accentSoft.withValues(alpha: _pressed ? 0.6 : 0.42),
                                  width: _pressed ? 2.0 : 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentSoft.withValues(alpha: 0.16),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(_pointer.dx - 7, _pointer.dy - 7),
                      child: AnimatedScale(
                        scale: _pressed ? 0.5 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.accentGradientStrong,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: _pressed ? 0.8 : 0.38),
                                blurRadius: _pressed ? 12 : 18,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Splash screen ─────────────────────────────────────────────────────────────
// The whole point of this rewrite: the splash should feel like the opening
// shot of the SAME scene the home page lives in (deep space, nebula, a
// singularity), not a separate branded loading screen that gets swapped out.
// So the background here reuses the same visual language as HomePage's cosmic
// layers, and the transition crossfades + zooms rather than hard-cutting.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _cosmos; // drives nebula/starfield/singularity time
  late final AnimationController _progress;
  late final AnimationController _outro; // fades foreground content before nav

  bool _leaving = false;

  static const _contentReadyDelay = Duration(milliseconds: 3200);
  static const _outroLength = Duration(milliseconds: 650);
  static const _transitionLength = Duration(milliseconds: 1100);

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _cosmos = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    _outro = AnimationController(vsync: this, duration: _outroLength);

    Future.delayed(_contentReadyDelay, () async {
      if (!mounted) return;
      // 1. Fade the foreground UI out first — the cosmic background keeps
      //    running underneath, so nothing just vanishes.
      setState(() => _leaving = true);
      await _outro.forward();
      if (!mounted) return;

      // 2. Only now hand off to HomePage, with a transition that continues
      //    the same motion language (fade + gentle push-in) instead of an
      //    instant swap.
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, animation, __, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween(begin: 1.05, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
          transitionDuration: _transitionLength,
        ),
      );
    });
  }

  @override
  void dispose() {
    _intro.dispose();
    _cosmos.dispose();
    _progress.dispose();
    _outro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= kMinDesktopWidth;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1 — deep space wash (same tone as HomePage's background)
          const _DeepSpaceWashSplash(),

          // Layer 2 — drifting nebula fields
          AnimatedBuilder(
            animation: _cosmos,
            builder: (_, __) => CustomPaint(
              painter: _SplashNebulaPainter(t: _cosmos.value * 60),
            ),
          ),

          // Layer 3 — starfield
          AnimatedBuilder(
            animation: _cosmos,
            builder: (_, __) => CustomPaint(
              painter: _SplashStarfieldPainter(t: _cosmos.value * 60, seed: 7),
            ),
          ),

          // Layer 4 — vignette so text stays legible over the stars
          const Positioned.fill(child: _SplashVignette()),

          // Layer 5 — the actual content, fading out smoothly before nav
          AnimatedBuilder(
            animation: _outro,
            builder: (_, child) {
              final fade = 1.0 - Curves.easeIn.transform(_outro.value);
              final lift = _outro.value * 18;
              return Opacity(
                opacity: fade,
                child: Transform.translate(offset: Offset(0, -lift), child: child),
              );
            },
            child: isWide
                ? _WideContent(intro: _intro, progress: _progress, cosmos: _cosmos)
                : _NarrowContent(intro: _intro, progress: _progress, cosmos: _cosmos),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared cosmic background pieces (deliberately mirrors HomePage's tone so the
// splash reads as "the same universe, zoomed in" rather than a separate app).
// ─────────────────────────────────────────────────────────────────────────────

class _DeepSpaceWashSplash extends StatelessWidget {
  const _DeepSpaceWashSplash();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: const Alignment(0.3, -0.4),
          radius: 1.4,
          colors: [
            Color.lerp(AppColors.background, const Color(0xFF120B24), 0.55)!,
            AppColors.background,
            const Color(0xFF05050A),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
    );
  }
}

class _SplashVignette extends StatelessWidget {
  const _SplashVignette();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.25,
          colors: [
            Colors.transparent,
            AppColors.background.withValues(alpha: 0.55),
          ],
          stops: const [0.45, 1.0],
        ),
      ),
    );
  }
}

class _SplashNebulaPainter extends CustomPainter {
  final double t;
  _SplashNebulaPainter({required this.t});

  void _blob(Canvas canvas, Size size, Offset center, double radius, double hue, double alpha) {
    final shader = RadialGradient(
      colors: [
        HSLColor.fromAHSL(alpha, hue, 0.68, 0.34).toColor(),
        Colors.transparent,
      ],
      stops: const [0.0, 1.0],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), Paint()..shader = shader);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final hue1 = 258.0 + sin(t * 0.12) * 18;
    final alpha1 = 0.07 + sin(t * 0.18) * 0.018;
    final c1 = Offset(size.width * (0.28 + sin(t * 0.05) * 0.06), size.height * (0.32 + cos(t * 0.07) * 0.05));
    _blob(canvas, size, c1, size.width * 0.6, hue1, alpha1);

    final hue2 = 198.0 + cos(t * 0.09) * 14;
    final alpha2 = 0.05 + cos(t * 0.15) * 0.014;
    final c2 = Offset(size.width * (0.78 + cos(t * 0.04) * 0.05), size.height * (0.68 + sin(t * 0.06) * 0.05));
    _blob(canvas, size, c2, size.width * 0.5, hue2, alpha2);
  }

  @override
  bool shouldRepaint(_SplashNebulaPainter old) => old.t != t;
}

class _SplashStar {
  final double x, y, radius, twinkleSpeed, phase;
  final Color color;
  _SplashStar(Random rng)
      : x = rng.nextDouble(),
        y = rng.nextDouble(),
        radius = 0.5 + rng.nextDouble() * 1.6,
        twinkleSpeed = 0.4 + rng.nextDouble() * 0.8,
        phase = rng.nextDouble() * 2 * pi,
        color = [
          const Color(0xFF6C63FF),
          const Color(0xFF06B6D4),
          const Color(0xFFA78BFA),
          Colors.white,
        ][rng.nextInt(4)];
}

class _SplashStarfieldPainter extends CustomPainter {
  final double t;
  final int seed;
  static final Map<int, List<_SplashStar>> _cache = {};

  _SplashStarfieldPainter({required this.t, required this.seed});

  List<_SplashStar> _starsFor(int count) {
    return _cache.putIfAbsent(seed, () {
      final rng = Random(seed);
      return List.generate(count, (_) => _SplashStar(rng));
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    final stars = _starsFor(220);
    for (final s in stars) {
      final twinkle = 0.5 + 0.5 * sin(t * s.twinkleSpeed + s.phase);
      final alpha = (0.25 + 0.55 * twinkle).clamp(0.0, 1.0);
      final p = Offset(s.x * size.width, s.y * size.height);
      canvas.drawCircle(p, s.radius, Paint()..color = s.color.withValues(alpha: alpha));
    }
  }

  @override
  bool shouldRepaint(_SplashStarfieldPainter old) => old.t != t;
}

// ── Wide layout ───────────────────────────────────────────────────────────────
class _WideContent extends StatelessWidget {
  const _WideContent({required this.intro, required this.progress, required this.cosmos});
  final AnimationController intro;
  final AnimationController progress;
  final AnimationController cosmos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 72),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(flex: 5, child: _LeftStatement(intro: intro, progress: progress)),
          const SizedBox(width: 56),
          Expanded(flex: 5, child: _RightVisual(intro: intro, progress: progress, cosmos: cosmos)),
        ],
      ),
    );
  }
}

// ── Narrow layout ─────────────────────────────────────────────────────────────
class _NarrowContent extends StatelessWidget {
  const _NarrowContent({required this.intro, required this.progress, required this.cosmos});
  final AnimationController intro;
  final AnimationController progress;
  final AnimationController cosmos;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          _LeftStatement(intro: intro, progress: progress, centered: true),
          const SizedBox(height: 40),
          _RightVisual(intro: intro, progress: progress, cosmos: cosmos, compact: true),
        ],
      ),
    );
  }
}

// ── Left: name + headline + progress + chips ─────────────────────────────────
class _LeftStatement extends StatelessWidget {
  const _LeftStatement({
    required this.intro,
    required this.progress,
    this.centered = false,
  });
  final AnimationController intro;
  final AnimationController progress;
  final bool centered;

  Widget _stagger(Widget child, double from, {Offset slide = const Offset(0, 0.10)}) {
    final anim = CurvedAnimation(
      parent: intro,
      curve: Interval(from, 1.0, curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween(begin: slide, end: Offset.zero).animate(anim),
        child: child,
      ),
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
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.55),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 9),
              Text(
                'CHINMAY BANSAL  ·  AVAILABLE',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.2,
                  color: AppColors.textMuted,
                ),
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
            style: TextStyle(
              fontSize: 58,
              fontWeight: FontWeight.w900,
              height: 0.96,
              letterSpacing: -2.2,
              color: AppColors.textPrimary,
            ),
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
              style: TextStyle(
                fontSize: 14.5,
                color: AppColors.textMuted,
                height: 1.62,
                letterSpacing: 0.1,
              ),
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

// ── Terminal log ──────────────────────────────────────────────────────────────
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
              Text(
                'boot.sh',
                style: TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'monospace'),
              ),
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
                              color: isLast
                                  ? const Color(0xFF22C55E).withValues(alpha: 0.8)
                                  : AppColors.textMuted,
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

  Widget _dot(Color color) => Container(
    width: 9,
    height: 9,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.7)),
  );
}

// ── Progress bar ──────────────────────────────────────────────────────────────
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
                Text(
                  '$pct%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.accent,
                    fontFamily: 'monospace',
                  ),
                ),
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
                          boxShadow: [
                            BoxShadow(color: AppColors.accent.withValues(alpha: 0.5), blurRadius: 6),
                          ],
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

// ── Right: lottie hero + singularity loader + signal chips ────────────────────
// The radar sweep from the old version had nothing to do with the rest of the
// site. This replaces it with a small orbiting "singularity" — a miniature,
// friendlier preview of the black hole that anchors HomePage — so by the time
// the user lands on the real page, they've already seen its visual signature.
class _RightVisual extends StatelessWidget {
  const _RightVisual({
    required this.intro,
    required this.progress,
    required this.cosmos,
    this.compact = false,
  });
  final AnimationController intro;
  final AnimationController progress;
  final AnimationController cosmos;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(parent: intro, curve: const Interval(0.12, 1.0, curve: Curves.easeOutCubic));
    final lottieSz = compact ? 240.0 : 340.0;

    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween(begin: const Offset(0.05, 0), end: Offset.zero).animate(anim),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: lottieSz,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: cosmos,
                      builder: (_, __) => CustomPaint(
                        painter: _SingularityLoaderPainter(t: cosmos.value * 60),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: lottieSz * 0.5,
                  //   height: lottieSz * 0.5,
                  //   child: ShaderMask(
                  //     shaderCallback: (bounds) => AppColors.accentGradientStrong.createShader(bounds),
                  //     blendMode: BlendMode.modulate,
                  //     // child: Lottie.asset(
                  //     //   'assets/animations/waving_hand.json',
                  //     //   repeat: true,
                  //     //   fit: BoxFit.contain,
                  //     // ),
                  //   ),
                  // ),
                  AnimatedBuilder(
                    animation: progress,
                    builder: (_, __) {
                      final a = progress.value * 2 * pi;
                      final r = lottieSz * 0.44;
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
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

// ── Status row below visual ───────────────────────────────────────────────────
class _StatusRow extends StatelessWidget {
  const _StatusRow();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('MODE', 'VISION'),
      ('STACK', 'ROS · ML'),
      ('STATE', 'LIVE'),
    ];
    return Row(
      children: items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return Expanded(
          child: Row(
            children: [
              if (i > 0)
                Container(
                  width: 1,
                  height: 28,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  color: AppColors.borderStrong.withValues(alpha: 0.25),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item.$1,
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textMuted,
                        letterSpacing: 1.5,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.$2,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 0.2,
                      ),
                    ),
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

// ── Singularity loader painter ────────────────────────────────────────────────
// A compact preview of the black hole from HomePage: a slow-rotating,
// Doppler-tinted accretion ring around a soft dark core with a subtle photon
// edge. Small, calm, and thematically identical to what's coming next.
class _SingularityLoaderPainter extends CustomPainter {
  final double t;
  _SingularityLoaderPainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxR = min(size.width, size.height) * 0.46;
    final coreR = maxR * 0.34;
    final rotation = t * 0.5;

    // Ambient bloom
    canvas.drawCircle(
      center,
      maxR,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.accent.withValues(alpha: 0.16),
            Colors.transparent,
          ],
          stops: const [0.3, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: maxR))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Disk ring — asymmetric brightness for a touch of Doppler beaming
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    canvas.scale(1.0, 0.4);
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.4
      ..shader = SweepGradient(
        colors: [
          AppColors.accentWarm.withValues(alpha: 0.15),
          AppColors.accent.withValues(alpha: 0.85),
          AppColors.accentSecondary.withValues(alpha: 0.35),
          AppColors.accentWarm.withValues(alpha: 0.15),
        ],
        stops: const [0.0, 0.3, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: maxR * 0.86));
    canvas.drawCircle(Offset.zero, maxR * 0.86, ringPaint);
    canvas.restore();

    // Photon ring
    canvas.drawCircle(
      center,
      coreR * 1.12,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..color = Colors.white.withValues(alpha: 0.7),
    );

    // Core
    canvas.drawCircle(
      center,
      coreR,
      Paint()
        ..shader = RadialGradient(
          colors: [const Color(0xFF020408), Colors.black],
        ).createShader(Rect.fromCircle(center: center, radius: coreR)),
    );

    // A handful of orbiting embers for life
    for (int i = 0; i < 5; i++) {
      final a = rotation * (1.4 + i * 0.15) + i * (2 * pi / 5);
      final r = maxR * (0.58 + 0.28 * ((i % 3) / 2));
      final p = Offset(center.dx + cos(a) * r, center.dy + sin(a) * r * 0.4);
      final twinkle = 0.5 + 0.5 * sin(t * 2 + i);
      canvas.drawCircle(p, 1.6 + twinkle, Paint()..color = AppColors.accentSoft.withValues(alpha: 0.5 + 0.4 * twinkle));
    }
  }

  @override
  bool shouldRepaint(covariant _SingularityLoaderPainter old) => old.t != t;
}