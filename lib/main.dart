import 'dart:math';

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
      title: 'Chinmay.dev',
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
      home: const SplashScreen(),
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
  late final AnimationController _logController;
  final Duration _homePageTransitionDuration = const Duration(
    milliseconds: 800,
  );

  final List<String> _loadingLogs = [
    "[System] Booting kernel...",
    "[Modules] Initializing UI layers",
    "[Assets] Mapping celestial coordinates",
    "[Network] Establishing secure handshake",
    "[Render] Building 3D interaction matrices",
    "[System] Portfolio dashboard online",
  ];

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();
    _logController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..forward();

    Future.delayed(const Duration(milliseconds: 3400), () {
      if (!mounted) {
        return;
      }
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
                scale: Tween<double>(begin: 1.05, end: 1.0).animate(fade),
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
    _logController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width >= kMinDesktopWidth;
    final contentWidth = isWide
        ? min(size.width * 0.74, 1080.0)
        : size.width - 40;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _orbController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _DashboardSplashPainter(
                    progress: _orbController.value,
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.12,
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
                  radius: 1.2,
                  colors: [
                    AppColors.accentSoft.withValues(alpha: 0.10),
                    Colors.transparent,
                    AppColors.background,
                  ],
                  stops: const [0.0, 0.45, 1.0],
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
                  curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
                ),
                child: SlideTransition(
                  position:
                      Tween<Offset>(
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
      fontSize: isWide ? 56 : 40,
      fontWeight: FontWeight.w700,
      height: 1.05,
      letterSpacing: -1.4,
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
        _DashboardBadge(
          label: 'PORTFOLIO DASHBOARD',
          icon: Icons.dashboard_customize_rounded,
        ),
        const SizedBox(height: 22),
        Text(
          'Designing thoughtful apps,\nbuilding practical AI systems.',
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: titleStyle,
        ),
        const SizedBox(height: 18),
        Text(
          'Launching a cleaner showcase for Flutter, machine learning, and product-focused engineering work.',
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: summaryStyle,
        ),
        const SizedBox(height: 30),
        if (isWide) _buildLogs(context),
        const SizedBox(height: 26),
        Wrap(
          alignment: isWide ? WrapAlignment.start : WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: const [
            _InlineMetric(label: 'Flutter UI'),
            _InlineMetric(label: 'Computer Vision'),
            _InlineMetric(label: 'Production APIs'),
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

  Widget _buildLogs(BuildContext context) {
    final logs = [
      "[System] Booting kernel...",
      "[Modules] Initializing UI layers",
      "[Assets] Mapping celestial coordinates",
      "[Network] Establishing secure handshake",
      "[Render] Building 3D interaction matrices",
      "[System] Portfolio dashboard online",
    ];

    return Container(
      width: 400,
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
                      Text(
                        "> ",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        logs[i],
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontFamily: 'monospace',
                          fontSize: 12,
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
                      'Preparing dashboard modules and interaction layers.',
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
            height: 170,
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
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.85,
                  child: Lottie.asset(
                    'assets/animations/waving_hand.json',
                    repeat: true,
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
                  height: 126,
                  width: 126,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Experience load progress',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.textSecondary),
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
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
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

class _DashboardSplashPainter extends CustomPainter {
  const _DashboardSplashPainter({required this.progress});

  final double progress;

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

    final orbPaint = Paint()
      ..shader =
          RadialGradient(
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
      ..shader =
          RadialGradient(
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
  bool shouldRepaint(covariant _DashboardSplashPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
