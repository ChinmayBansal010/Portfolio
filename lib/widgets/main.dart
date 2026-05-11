import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/navigation_helper.dart';
import 'package:portfolio/constants/project_data.dart';
import 'package:portfolio/constants/size.dart';
import 'package:portfolio/constants/skill_items.dart';

class MainSection extends StatefulWidget {
  const MainSection({super.key, required this.navbarKeys});

  final List<GlobalKey> navbarKeys;

  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _orbitController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _orbitController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedChild({
    required Widget child,
    required double intervalStart,
    required Offset slideOffset,
  }) {
    final animation = CurvedAnimation(
      parent: _entranceController,
      curve: Interval(intervalStart, 1.0, curve: Curves.easeOutCubic),
    );

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: slideOffset,
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < kMinDesktopWidth;

    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 20 : 32,
        isMobile ? 32 : 46,
        isMobile ? 20 : 32,
        isMobile ? 42 : 54,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.surfaceGlass, AppColors.backgroundElevated],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.borderStrong),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 30,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned(top: 0, right: 0, child: _HeroGlow()),
              Padding(
                padding: EdgeInsets.all(isMobile ? 22 : 34),
                child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAnimatedChild(
                intervalStart: 0.0,
                slideOffset: const Offset(0, 0.25),
                child: const _SectionBadge(
                  label: 'ENGINEERING PORTFOLIO',
                  icon: Icons.grid_view_rounded,
                ),
              ),
              const SizedBox(height: 18),
              _buildAnimatedChild(
                intervalStart: 0.08,
                slideOffset: const Offset(0, 0.25),
                child: _buildHeadline(),
              ),
              const SizedBox(height: 18),
              _buildAnimatedChild(
                intervalStart: 0.18,
                slideOffset: const Offset(0, 0.25),
                child: _buildSubText(),
              ),
              const SizedBox(height: 22),
              _buildAnimatedChild(
                intervalStart: 0.28,
                slideOffset: const Offset(0, 0.25),
                child: _buildDescription(),
              ),
              const SizedBox(height: 24),
              _buildAnimatedChild(
                intervalStart: 0.32,
                slideOffset: const Offset(0, 0.2),
                child: const _HeroSystemStats(),
              ),
              const SizedBox(height: 28),
              _buildAnimatedChild(
                intervalStart: 0.38,
                slideOffset: const Offset(0, 0.2),
                child: _buildDashboardMetrics(),
              ),
              const SizedBox(height: 32),
              _buildAnimatedChild(
                intervalStart: 0.48,
                slideOffset: const Offset(0, 0.18),
                child: _buildButtons(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 36),
        Expanded(
          flex: 4,
          child: _buildAnimatedChild(
            intervalStart: 0.1,
            slideOffset: const Offset(0.08, 0),
            child: _HeroOverviewPanel(orbitController: _orbitController),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedChild(
          intervalStart: 0.0,
          slideOffset: const Offset(0, 0.25),
          child: const _SectionBadge(
            label: 'ENGINEERING PORTFOLIO',
            icon: Icons.grid_view_rounded,
          ),
        ),
        const SizedBox(height: 18),
        _buildAnimatedChild(
          intervalStart: 0.08,
          slideOffset: const Offset(0, 0.25),
          child: _buildHeadline(isMobile: true),
        ),
        const SizedBox(height: 16),
        _buildAnimatedChild(
          intervalStart: 0.18,
          slideOffset: const Offset(0, 0.25),
          child: _buildSubText(),
        ),
        const SizedBox(height: 16),
        _buildAnimatedChild(
          intervalStart: 0.28,
          slideOffset: const Offset(0, 0.25),
          child: _buildDescription(),
        ),
        const SizedBox(height: 24),
        _buildAnimatedChild(
          intervalStart: 0.36,
          slideOffset: const Offset(0, 0.2),
          child: _buildDashboardMetrics(),
        ),
        const SizedBox(height: 26),
        _buildAnimatedChild(
          intervalStart: 0.44,
          slideOffset: const Offset(0, 0.18),
          child: _buildButtons(isCentered: false),
        ),
        const SizedBox(height: 28),
        _buildAnimatedChild(
          intervalStart: 0.14,
          slideOffset: const Offset(0, 0.12),
          child: _HeroOverviewPanel(orbitController: _orbitController),
        ),
      ],
    );
  }

  Widget _buildHeadline({bool isMobile = false}) {
    return Text(
      'Building polished Flutter interfaces and practical machine learning products.',
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontSize: isMobile ? 34 : 52,
        fontWeight: FontWeight.w700,
        height: 1.08,
        letterSpacing: -1.2,
      ),
    );
  }

  Widget _buildSubText() {
    return const _CyclingSubtext();
  }

  Widget _buildDescription() {
    return Text(
      'I work across application UI, backend APIs, and real-time ML workflows, with an emphasis on clean execution, responsive user experience, and production-ready structure.',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 15.5,
        height: 1.75,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildDashboardMetrics() {
    final totalSkills = categorizedSkills.values.fold<int>(
      0,
      (total, items) => total + items.length,
    );

    return Wrap(
      spacing: 14,
      runSpacing: 14,
      children: [
        _MetricPill(
          value: '${projectItems.length}+',
          label: 'featured builds',
          icon: Icons.rocket_launch_outlined,
        ),
        _MetricPill(
          value: '${categorizedSkills.length}',
          label: 'skill domains',
          icon: Icons.dashboard_outlined,
        ),
        _MetricPill(
          value: '$totalSkills',
          label: 'tools and stacks',
          icon: Icons.layers_outlined,
        ),
      ],
    );
  }

  Widget _buildButtons({bool isCentered = false}) {
    return Wrap(
      alignment: isCentered ? WrapAlignment.center : WrapAlignment.start,
      spacing: 14,
      runSpacing: 14,
      children: [
        _AnimatedCTAButton(
          label: 'View Projects',
          icon: Icons.arrow_outward_rounded,
          isPrimary: true,
          onPressed: () => NavigationHelper.scrollToSection(
            context: context,
            navIndex: 2,
            navbarKeys: widget.navbarKeys,
          ),
        ),
        _AnimatedCTAButton(
          label: 'Explore Skills',
          icon: Icons.analytics_outlined,
          onPressed: () => NavigationHelper.scrollToSection(
            context: context,
            navIndex: 1,
            navbarKeys: widget.navbarKeys,
          ),
        ),
        _AnimatedCTAButton(
          label: 'Contact Me',
          icon: Icons.mail_outline_rounded,
          onPressed: () => NavigationHelper.scrollToSection(
            context: context,
            navIndex: 4,
            navbarKeys: widget.navbarKeys,
          ),
        ),
      ],
    );
  }
}

class _ScanningLineEffect extends StatelessWidget {
  const _ScanningLineEffect();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container().animate(onPlay: (c) => c.repeat()).custom(
              duration: 3.seconds,
              builder: (context, value, child) {
                return Positioned(
                  top: value * constraints.maxHeight,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.accent.withValues(alpha: 0.5),
                          AppColors.accent,
                          AppColors.accent.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: 240,
        width: 240,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppColors.accentSoft.withValues(alpha: 0.22),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSystemStats extends StatelessWidget {
  const _HeroSystemStats();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.24),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatIndicator(label: "UI ENGINE", value: "STABLE", color: AppColors.success),
          _divider(),
          _StatIndicator(label: "ML CORE", value: "ACTIVE", color: AppColors.accent),
          _divider(),
          _StatIndicator(label: "LATENCY", value: "14ms", color: AppColors.accentSoft),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 16,
        width: 1,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        color: AppColors.border,
      );
}

class _StatIndicator extends StatelessWidget {
  const _StatIndicator({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).fade(duration: 800.ms),
            const SizedBox(width: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionBadge extends StatelessWidget {
  const _SectionBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.28),
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

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.value,
    required this.label,
    required this.icon,
  });

  final String value;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: AppColors.background),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroOverviewPanel extends StatelessWidget {
  const _HeroOverviewPanel({required this.orbitController});

  final AnimationController orbitController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Capability Overview',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Active',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [AppColors.surfaceAlt, AppColors.backgroundElevated],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: AnimatedBuilder(
              animation: orbitController,
              builder: (context, child) {
                final angle = orbitController.value * 2 * pi;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 26 + sin(angle) * 8,
                      right: 34 + cos(angle) * 8,
                      child: _StatusDot(color: AppColors.accentSoft),
                    ),
                    Positioned(
                      bottom: 28 + cos(angle) * 8,
                      left: 36 + sin(angle) * 8,
                      child: _StatusDot(color: AppColors.accentSecondary),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return AppColors.accentGradientStrong.createShader(
                            bounds,
                          );
                        },
                        blendMode: BlendMode.srcATop,
                        child: Lottie.asset(
                          'assets/animations/dev.json',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          const _OverviewRow(
            label: 'Focus',
            value: 'Flutter interfaces, API-backed products, ML pipelines',
          ),
          const SizedBox(height: 12),
          const _OverviewRow(
            label: 'Strength',
            value: 'Combining polished UX with real-time intelligence features',
          ),
          const SizedBox(height: 12),
          const _OverviewRow(
            label: 'Approach',
            value: 'Structured, fast-loading, user-centered implementation',
          ),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 14),
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 78,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _CyclingSubtext extends StatefulWidget {
  const _CyclingSubtext();

  @override
  State<_CyclingSubtext> createState() => _CyclingSubtextState();
}

class _CyclingSubtextState extends State<_CyclingSubtext> {
  static const List<String> _titles = [
    'Flutter Developer',
    'Machine Learning Builder',
    'Computer Vision Engineer',
    'Product-Focused Problem Solver',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2200), (timer) {
      if (mounted) {
        setState(() => _currentIndex = (_currentIndex + 1) % _titles.length);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: 18,
      color: AppColors.accent,
      fontWeight: FontWeight.w600,
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.18),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Text(
        _titles[_currentIndex],
        key: ValueKey(_currentIndex),
        style: style,
      ),
    );
  }
}

class _AnimatedCTAButton extends StatefulWidget {
  const _AnimatedCTAButton({
    required this.label,
    required this.onPressed,
    required this.icon,
    this.isPrimary = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData icon;
  final bool isPrimary;

  @override
  State<_AnimatedCTAButton> createState() => _AnimatedCTAButtonState();
}

class _AnimatedCTAButtonState extends State<_AnimatedCTAButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hoverController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleHover(bool hovering) {
    setState(() => _isHovered = hovering);
    if (hovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.isPrimary;

    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -3 * _hoverController.value),
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              gradient: isPrimary ? AppColors.accentGradient : null,
              color: isPrimary
                  ? null
                  : (_isHovered
                        ? AppColors.surface
                        : AppColors.background.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isPrimary ? Colors.transparent : AppColors.borderStrong,
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color:
                            (isPrimary
                                    ? AppColors.accent
                                    : AppColors.accentSoft)
                                .withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.icon,
                  size: 18,
                  color: isPrimary
                      ? AppColors.background
                      : AppColors.textPrimary,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isPrimary
                        ? AppColors.background
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
