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
      builder: (context, child) {
        return _AppCursorShell(child: child ?? const SizedBox.shrink());
      },
      home: const SplashScreen(),
    );
  }
}

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
    )..addListener(() {
      if (!_visible || _trail == _pointer) return;
      setState(() {
        _trail = Offset.lerp(_trail, _pointer, 0.18) ?? _pointer;
      });
    })
      ..repeat();
  }

  @override
  void dispose() {
    _followController.dispose();
    super.dispose();
  }

  void _updatePointer(PointerEvent event) {
    setState(() => _pointer = event.position);
  }

  @override
  Widget build(BuildContext context) {
    if (!_enableCustomCursor) {
      return widget.child;
    }

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (event) {
        setState(() {
          _visible = true;
          _pointer = event.position;
          _trail = event.position;
        });
      },
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
            // Isolate high-frequency cursor repaints from the main widget tree
            RepaintBoundary(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 140),
                  child: Stack(
                    children: [
                      // Outer Trail (Glassmorphism + Hardware Translate)
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
                      // Inner Pointer (Core)
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _orbController;
  late final AnimationController _progressController;
  final Duration _homePageTransitionDuration = const Duration(
    milliseconds: 820,
  );

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..forward();

    Future.delayed(const Duration(milliseconds: 3550), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const HomePage(),
          transitionsBuilder: (_, animation, _, child) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutQuart,
            );
            return FadeTransition(
              opacity: fade,
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.04, end: 1.0).animate(fade),
                child: child,
              ),
            );
          },
          transitionDuration: _homePageTransitionDuration,
        ),
      );
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    _orbController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= kMinDesktopWidth;
    final contentWidth = isWide
        ? min(size.width * 0.76, 1120.0)
        : size.width - 40;

    return Scaffold(
      body: Stack(
        children: [
          // Static background cache (Gradient + Grid)
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(
                painter: const _StaticBackgroundPainter(),
              ),
            ),
          ),
          // Dynamic Orb Layer
          Positioned.fill(
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _orbController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _AnimatedOrbPainter(
                      progress: _orbController.value,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.14,
                child: Lottie.asset(
                  'assets/animations/splash_bg.json',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topCenter,
                  radius: 1.24,
                  colors: [
                    AppColors.accentSoft.withValues(alpha: 0.12),
                    Colors.transparent,
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.42, 1.0],
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: contentWidth,
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: _introController,
                  curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.08),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _introController,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: _SplashContent(
                    isWide: isWide,
                    progress: _progressController,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent({required this.isWide, required this.progress});

  final bool isWide;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.displayLarge?.copyWith(
      fontSize: isWide ? 60 : 42,
      fontWeight: FontWeight.w700,
      height: 1.02,
      letterSpacing: -1.6,
    );

    final summaryStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: AppColors.textSecondary,
      height: 1.6,
      fontSize: isWide ? 16 : 14,
    );

    final leading = Column(
      crossAxisAlignment: isWide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _DashboardBadge(
          label: 'AI PORTFOLIO SYSTEM',
          icon: Icons.psychology_alt_rounded,
        ),
        const SizedBox(height: 22),
        Text(
          'Computer vision,\nrobotics, and AI systems\nthat feel shipped.',
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: titleStyle,
        ),
        const SizedBox(height: 18),
        Text(
          'Booting an interface focused on perception, deep learning, inference APIs, and product-ready ML.',
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: summaryStyle,
        ),
        const SizedBox(height: 22),
        _buildSignalStrip(context),
        const SizedBox(height: 30),
        if (isWide) _buildLogs(context),
        const SizedBox(height: 26),
        Wrap(
          alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: const [
            _InlineMetric(label: 'Computer Vision'),
            _InlineMetric(label: 'ROS Systems'),
            _InlineMetric(label: 'Inference APIs'),
          ],
        ),
      ],
    );

    final sidePanel = _SplashStatusPanel(progress: progress);

    if (isWide) {
      return Row(
        children: [
          Expanded(flex: 6, child: leading),
          const SizedBox(width: 36),
          Expanded(flex: 4, child: sidePanel),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [leading, const SizedBox(height: 28), sidePanel],
    );
  }

  Widget _buildSignalStrip(BuildContext context) {
    const signals = [
      ('AI', 'active'),
      ('CV', 'real-time'),
      ('ROS', 'integrated'),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: signals.map((signal) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.30),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.borderStrong.withValues(alpha: 0.65),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                signal.$1,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                signal.$2,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLogs(BuildContext context) {
    final logs = [
      '[Vision] Initializing perception graph',
      '[Models] Loading inference nodes',
      '[ROS] Linking robot channels',
      '[APIs] Securing transport layer',
      '[UI] Rendering interactive shell',
      '[Ready] Portfolio system online',
    ];

    return Container(
      width: 420,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < logs.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: AnimatedBuilder(
                animation: progress,
                builder: (context, _) {
                  final show = progress.value >= (i / (logs.length + 1));
                  if (!show) return const SizedBox.shrink();
                  return Row(
                    children: [
                      const Text(
                        '> ',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          logs[i],
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _SplashStatusPanel extends StatelessWidget {
  const _SplashStatusPanel({required this.progress});

  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderStrong),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.24),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: AppColors.accentGradientStrong,
                ),
                child: const Icon(
                  Icons.auto_graph_rounded,
                  color: AppColors.background,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Session Booting',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Preparing live modules, motion layers, and AI signal blocks.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 194,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.6),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.surfaceAlt.withValues(alpha: 0.55),
                          AppColors.background.withValues(alpha: 0.12),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: progress,
                    builder: (context, _) => CustomPaint(
                      painter: _SplashRadarPainter(progress: progress.value),
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.88,
                  child: Lottie.asset(
                    'assets/animations/waving_hand.json',
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  height: 132,
                  width: 132,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: const [
              Expanded(child: _MiniStat(label: 'MODE', value: 'VISION')),
              SizedBox(width: 10),
              Expanded(child: _MiniStat(label: 'STACK', value: 'ROS / ML')),
              SizedBox(width: 10),
              Expanded(child: _MiniStat(label: 'STATE', value: 'LIVE')),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Experience load progress',
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: progress,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: progress.value,
                      minHeight: 8,
                      backgroundColor: AppColors.surfaceAlt,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(progress.value * 100).round()}% loaded',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textMuted),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardBadge extends StatelessWidget {
  const _DashboardBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.accent),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineMetric extends StatelessWidget {
  const _InlineMetric({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SplashRadarPainter extends CustomPainter {
  const _SplashRadarPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) * 0.34;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = AppColors.borderStrong.withValues(alpha: 0.42);

    for (double factor = 0.45; factor <= 1; factor += 0.18) {
      canvas.drawCircle(center, radius * factor, ringPaint);
    }

    final sweepAngle = (-pi / 2) + (progress * 2 * pi);
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        startAngle: sweepAngle,
        endAngle: sweepAngle + (pi / 3),
        colors: [
          Colors.transparent,
          AppColors.accentSoft.withValues(alpha: 0.06),
          AppColors.accent.withValues(alpha: 0.18),
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, sweepPaint);

    final pingPaint = Paint()
      ..color = AppColors.accent.withValues(alpha: 0.78)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 3; i++) {
      final angle = (progress * 2 * pi) + (i * 1.8);
      final dot = Offset(
        center.dx + cos(angle) * radius * (0.45 + (i * 0.15)),
        center.dy + sin(angle) * radius * (0.45 + (i * 0.15)),
      );
      canvas.drawCircle(dot, 3.5, pingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplashRadarPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Computes the static background layer (Gradient & Grid).
/// Wrapped in a RepaintBoundary, this is painted exactly once.
class _StaticBackgroundPainter extends CustomPainter {
  const _StaticBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.background, AppColors.backgroundElevated],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.24)
      ..strokeWidth = 1;

    const grid = 40.0;
    for (double x = 0; x <= size.width; x += grid) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += grid) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StaticBackgroundPainter oldDelegate) => false;
}

/// Computes the dynamic orb layers. This repaints every frame but avoids
/// recalculating the heavier background grid instructions.
class _AnimatedOrbPainter extends CustomPainter {
  const _AnimatedOrbPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final orbPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentSoft.withValues(alpha: 0.24),
          AppColors.accent.withValues(alpha: 0.12),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(
            size.width * (0.22 + (sin(progress * 2 * pi) * 0.06)),
            size.height * (0.18 + (cos(progress * 2 * pi) * 0.04)),
          ),
          radius: size.shortestSide * 0.44,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.22, size.height * 0.18),
      size.shortestSide * 0.44,
      orbPaint,
    );

    final orbPaintRight = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.accentSecondary.withValues(alpha: 0.16),
          Colors.transparent,
        ],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.84, size.height * 0.74),
          radius: size.shortestSide * 0.38,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.84, size.height * 0.74),
      size.shortestSide * 0.38,
      orbPaintRight,
    );
  }

  @override
  bool shouldRepaint(covariant _AnimatedOrbPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}