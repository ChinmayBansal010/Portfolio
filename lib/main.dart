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
      builder: (context, child) =>
          _AppCursorShell(child: child ?? const SizedBox.shrink()),
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

class _AppCursorShellState extends State<_AppCursorShell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _followController;
  Offset _pointer = const Offset(-100, -100);
  Offset _trail = const Offset(-100, -100);
  bool _visible = false;
  bool _pressed = false;

  bool get _enableCustomCursor {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows => true,
      TargetPlatform.macOS   => true,
      TargetPlatform.linux   => true,
      _                      => false,
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
        setState(
                () => _trail = Offset.lerp(_trail, _pointer, 0.18) ?? _pointer);
      })
      ..repeat();
  }

  @override
  void dispose() {
    _followController.dispose();
    super.dispose();
  }

  void _updatePointer(PointerEvent e) =>
      setState(() => _pointer = e.position);

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
                            filter:
                            ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentSoft
                                    .withValues(alpha: 0.05),
                                border: Border.all(
                                  color: AppColors.accentSoft.withValues(
                                      alpha: _pressed ? 0.6 : 0.42),
                                  width: _pressed ? 2.0 : 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentSoft
                                        .withValues(alpha: 0.16),
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
                                color: AppColors.accent.withValues(
                                    alpha: _pressed ? 0.8 : 0.38),
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
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _orb;
  late final AnimationController _progress;

  static const _splashDelay      = Duration(milliseconds: 3600);
  static const _transitionLength = Duration(milliseconds: 900);

  @override
  void initState() {
    super.initState();
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _orb = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();

    _progress = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    Future.delayed(_splashDelay, () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const HomePage(),
          transitionsBuilder: (_, anim, _, child) {
            final curved = CurvedAnimation(
                parent: anim, curve: Curves.easeOutQuart);
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween(begin: 1.04, end: 1.0).animate(curved),
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
    _orb.dispose();
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide =
        MediaQuery.of(context).size.width >= kMinDesktopWidth;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Layer 1 — static dot grid + gradient
          RepaintBoundary(
            child: CustomPaint(painter: const _StaticBackgroundPainter()),
          ),

          // Layer 2 — animated ambient orbs
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _orb,
              builder: (_, _) => CustomPaint(
                painter: _AnimatedOrbPainter(progress: _orb.value),
              ),
            ),
          ),

          // Layer 3 — very subtle lottie texture behind everything
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.10,
                child: Lottie.asset(
                  'assets/animations/splash_bg.json',
                  fit: BoxFit.cover,
                  repeat: true,
                ),
              ),
            ),
          ),

          // Layer 4 — vignette
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.3,
                  colors: [
                    AppColors.accentSoft.withValues(alpha: 0.10),
                    Colors.transparent,
                    AppColors.background.withValues(alpha: 0.85),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          // Layer 5 — content
          isWide
              ? _WideContent(intro: _intro, progress: _progress)
              : _NarrowContent(intro: _intro, progress: _progress),
        ],
      ),
    );
  }
}

// ── Wide layout ───────────────────────────────────────────────────────────────
class _WideContent extends StatelessWidget {
  const _WideContent({required this.intro, required this.progress});
  final AnimationController intro;
  final AnimationController progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 72),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: statement
          Expanded(
            flex: 5,
            child: _LeftStatement(intro: intro, progress: progress),
          ),
          const SizedBox(width: 56),
          // Right: lottie hero + radar + log
          Expanded(
            flex: 5,
            child: _RightVisual(intro: intro, progress: progress),
          ),
        ],
      ),
    );
  }
}

// ── Narrow layout ─────────────────────────────────────────────────────────────
class _NarrowContent extends StatelessWidget {
  const _NarrowContent({required this.intro, required this.progress});
  final AnimationController intro;
  final AnimationController progress;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        children: [
          _LeftStatement(intro: intro, progress: progress, centered: true),
          const SizedBox(height: 40),
          _RightVisual(intro: intro, progress: progress, compact: true),
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
    final align =
    centered ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final textAlign = centered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: align,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Eyebrow — name + availability
        _stagger(
          Row(
            mainAxisAlignment: centered
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
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

        // Headline — big, tight, three lines
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

        // Subline
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

        // Terminal log — kept, but refined
        _stagger(
          _TerminalLog(progress: progress),
          0.26,
        ),

        const SizedBox(height: 28),

        // Progress bar
        _stagger(
          _ProgressBar(progress: progress, centered: centered),
          0.38,
        ),
      ],
    );
  }
}

// ── Terminal log ──────────────────────────────────────────────────────────────
class _TerminalLog extends StatelessWidget {
  const _TerminalLog({required this.progress});
  final AnimationController progress;

  static const _logs = [
    ('[Vision]',  'Initializing perception graph'),
    ('[Models]',  'Loading inference nodes'),
    ('[ROS]',     'Linking robot channels'),
    ('[APIs]',    'Securing transport layer'),
    ('[UI]',      'Rendering interactive shell'),
    ('[Ready]',   'Portfolio system online'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.30),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Terminal title bar
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
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: progress,
            builder: (_, _) {
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
                            color: isLast
                                ? const Color(0xFF22C55E)
                                : AppColors.accent,
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          entry.$1,
                          style: TextStyle(
                            color: isLast
                                ? const Color(0xFF22C55E)
                                : AppColors.accent.withValues(alpha: 0.7),
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
                                  ? const Color(0xFF22C55E)
                                  .withValues(alpha: 0.8)
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
    decoration:
    BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.7)),
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
      builder: (_, _) {
        final pct = (progress.value * 100).round();
        return Column(
          crossAxisAlignment: centered
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: centered
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Text(
                  'Loading',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontFamily: 'monospace',
                  ),
                ),
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
                    Container(
                      color:
                      AppColors.borderStrong.withValues(alpha: 0.25),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.value,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradientStrong,
                          boxShadow: [
                            BoxShadow(
                              color:
                              AppColors.accent.withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
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

// ── Right: lottie hero + radar underlay + signal chips ────────────────────────
class _RightVisual extends StatelessWidget {
  const _RightVisual({
    required this.intro,
    required this.progress,
    this.compact = false,
  });
  final AnimationController intro;
  final AnimationController progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final anim = CurvedAnimation(
      parent: intro,
      curve: const Interval(0.12, 1.0, curve: Curves.easeOutCubic),
    );

    final lottieSz = compact ? 240.0 : 340.0;

    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween(begin: const Offset(0.05, 0), end: Offset.zero)
            .animate(anim),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Main visual: radar behind, lottie in front ──────────────
            SizedBox(
              height: lottieSz,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Full-size radar
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: progress,
                      builder: (_, _) => CustomPaint(
                        painter: _RadarPainter(progress: progress.value),
                      ),
                    ),
                  ),

                  // Waving hand lottie — centred, generous size
                  SizedBox(
                    width: lottieSz * 0.72,
                    height: lottieSz * 0.72,
                    child: ShaderMask(
                      shaderCallback: (bounds) => AppColors
                          .accentGradientStrong
                          .createShader(bounds),
                      blendMode: BlendMode.modulate,
                      child: Lottie.asset(
                        'assets/animations/waving_hand.json',
                        repeat: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  // Floating orbital nodes
                  AnimatedBuilder(
                    animation: progress,
                    builder: (_, _) {
                      final a = progress.value * 2 * pi;
                      final r = lottieSz * 0.42;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          _floatNode('Vision',   a,         r),
                          _floatNode('Models',   a + 2.09,  r),
                          _floatNode('ROS',      a + 4.19,  r),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Status row ────────────────────────────────────────────────
            _StatusRow(),
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
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.10),
            blurRadius: 10,
          ),
        ],
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
  @override
  Widget build(BuildContext context) {
    const items = [
      ('MODE',  'VISION'),
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

// ── Radar painter ─────────────────────────────────────────────────────────────
class _RadarPainter extends CustomPainter {
  const _RadarPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final maxR   = min(size.width, size.height) * 0.46;

    // Concentric rings
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(
        center,
        maxR * i / 4,
        Paint()
          ..style      = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..color      = AppColors.accent.withValues(alpha: 0.05 + i * 0.02),
      );
    }

    // Cross hairs
    final cross = Paint()
      ..color      = AppColors.accent.withValues(alpha: 0.06)
      ..strokeWidth = 0.8;
    canvas.drawLine(Offset(center.dx, center.dy - maxR),
        Offset(center.dx, center.dy + maxR), cross);
    canvas.drawLine(Offset(center.dx - maxR, center.dy),
        Offset(center.dx + maxR, center.dy), cross);

    // Sweep
    final sweepAngle = -pi / 2 + progress * 2 * pi;
    const wedge = pi * 0.5;
    final rect = Rect.fromCircle(center: center, radius: maxR);

    canvas.drawArc(
      rect,
      sweepAngle - wedge,
      wedge,
      true,
      Paint()
        ..shader = SweepGradient(
          center: Alignment.center,
          startAngle: sweepAngle - wedge,
          endAngle: sweepAngle,
          colors: [
            Colors.transparent,
            AppColors.accent.withValues(alpha: 0.0),
            AppColors.accent.withValues(alpha: 0.14),
          ],
          stops: const [0.0, 0.55, 1.0],
        ).createShader(rect)
        ..style = PaintingStyle.fill,
    );

    // Leading edge
    canvas.drawLine(
      center,
      Offset(center.dx + cos(sweepAngle) * maxR,
          center.dy + sin(sweepAngle) * maxR),
      Paint()
        ..color      = AppColors.accent.withValues(alpha: 0.45)
        ..strokeWidth = 1.2,
    );

    // Blips
    final blips = [
      (0.22, 0.30 * pi),
      (0.48, 1.05 * pi),
      (0.68, -0.15 * pi),
      (0.85, 0.78 * pi),
    ];
    for (final b in blips) {
      if (progress < b.$1) continue;
      final fade = ((progress - b.$1) * 8).clamp(0.0, 1.0);
      final bOff = Offset(
        center.dx + cos(b.$2) * maxR * b.$1,
        center.dy + sin(b.$2) * maxR * b.$1,
      );
      canvas.drawCircle(bOff, 5 * (1 - fade * 0.4),
          Paint()..color = AppColors.accent.withValues(alpha: 0.10 * fade));
      canvas.drawCircle(bOff, 2.5,
          Paint()..color = AppColors.accent.withValues(alpha: 0.9 * fade));
    }

    // Centre
    canvas.drawCircle(center, 3,
        Paint()..color = AppColors.accent);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter old) =>
      old.progress != progress;
}

// ── Static background ─────────────────────────────────────────────────────────
class _StaticBackgroundPainter extends CustomPainter {
  const _StaticBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.background, AppColors.backgroundElevated],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
    final dot = Paint()
      ..color = AppColors.border.withValues(alpha: 0.16)
      ..style = PaintingStyle.fill;
    const gap = 44.0;
    for (double x = 0; x <= size.width; x += gap) {
      for (double y = 0; y <= size.height; y += gap) {
        canvas.drawCircle(Offset(x, y), 0.9, dot);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StaticBackgroundPainter _) => false;
}

// ── Animated orb painter ──────────────────────────────────────────────────────
class _AnimatedOrbPainter extends CustomPainter {
  const _AnimatedOrbPainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    _orb(canvas,
        Offset(size.width * (0.18 + sin(progress * 2 * pi) * 0.05),
            size.height * (0.22 + cos(progress * 2 * pi) * 0.04)),
        size.shortestSide * 0.52,
        AppColors.accentSoft,
        0.20);

    _orb(canvas,
        Offset(size.width * 0.86, size.height * 0.76),
        size.shortestSide * 0.38,
        AppColors.accentSecondary,
        0.13);
  }

  void _orb(Canvas c, Offset center, double r, Color color, double alpha) {
    c.drawCircle(
      center,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [color.withValues(alpha: alpha), Colors.transparent],
        ).createShader(Rect.fromCircle(center: center, radius: r)),
    );
  }

  @override
  bool shouldRepaint(covariant _AnimatedOrbPainter old) =>
      old.progress != progress;
}