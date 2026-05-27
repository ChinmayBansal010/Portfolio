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
      duration: const Duration(milliseconds: 1150),
    );
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 150), () {
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
        isMobile ? 24 : 34,
        isMobile ? 20 : 32,
        isMobile ? 28 : 34,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.surfaceGlass, AppColors.backgroundElevated],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(color: AppColors.borderStrong),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.24),
                blurRadius: 30,
                offset: const Offset(0, 22),
              ),
            ],
          ),
          child: Stack(
            children: [
              const Positioned(top: 0, right: 0, child: _HeroGlow()),
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(painter: _HeroGridPainter()),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(isMobile ? 22 : 30),
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
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  label: 'AI ENGINEER',
                  icon: Icons.psychology_alt_rounded,
                ),
              ),
              const SizedBox(height: 18),
              _buildAnimatedChild(
                intervalStart: 0.08,
                slideOffset: const Offset(0, 0.22),
                child: _buildHeadline(),
              ),
              const SizedBox(height: 14),
              _buildAnimatedChild(
                intervalStart: 0.16,
                slideOffset: const Offset(0, 0.2),
                child: _buildSubText(),
              ),
              const SizedBox(height: 20),
              _buildAnimatedChild(
                intervalStart: 0.24,
                slideOffset: const Offset(0, 0.18),
                child: _buildDescription(),
              ),
              const SizedBox(height: 22),
              _buildAnimatedChild(
                intervalStart: 0.32,
                slideOffset: const Offset(0, 0.18),
                child: const _HeroFocusRow(),
              ),
              const SizedBox(height: 24),
              _buildAnimatedChild(
                intervalStart: 0.42,
                slideOffset: const Offset(0, 0.15),
                child: _buildMetrics(),
              ),
              const SizedBox(height: 28),
              _buildAnimatedChild(
                intervalStart: 0.5,
                slideOffset: const Offset(0, 0.14),
                child: _buildButtons(),
              ),
            ],
          ),
        ),
        const SizedBox(width: 30),
        Expanded(
          flex: 4,
          child: _buildAnimatedChild(
            intervalStart: 0.14,
            slideOffset: const Offset(0.06, 0),
            child: _HeroTechPanel(orbitController: _orbitController),
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
            label: 'AI ENGINEER',
            icon: Icons.psychology_alt_rounded,
          ),
        ),
        const SizedBox(height: 16),
        _buildAnimatedChild(
          intervalStart: 0.08,
          slideOffset: const Offset(0, 0.22),
          child: _buildHeadline(isMobile: true),
        ),
        const SizedBox(height: 14),
        _buildAnimatedChild(
          intervalStart: 0.16,
          slideOffset: const Offset(0, 0.2),
          child: _buildSubText(),
        ),
        const SizedBox(height: 18),
        _buildAnimatedChild(
          intervalStart: 0.24,
          slideOffset: const Offset(0, 0.18),
          child: _buildDescription(),
        ),
        const SizedBox(height: 20),
        _buildAnimatedChild(
          intervalStart: 0.32,
          slideOffset: const Offset(0, 0.18),
          child: const _HeroFocusRow(),
        ),
        const SizedBox(height: 22),
        _buildAnimatedChild(
          intervalStart: 0.42,
          slideOffset: const Offset(0, 0.15),
          child: _buildMetrics(),
        ),
        const SizedBox(height: 24),
        _buildAnimatedChild(
          intervalStart: 0.5,
          slideOffset: const Offset(0, 0.14),
          child: _buildButtons(),
        ),
        const SizedBox(height: 24),
        _buildAnimatedChild(
          intervalStart: 0.18,
          slideOffset: const Offset(0, 0.12),
          child: _HeroTechPanel(orbitController: _orbitController),
        ),
      ],
    );
  }

  Widget _buildHeadline({bool isMobile = false}) {
    return Text(
      'Building computer vision systems, deep learning workflows, and AI products that ship.',
      style: Theme.of(context).textTheme.displayLarge?.copyWith(
        fontSize: isMobile ? 34 : 54,
        fontWeight: FontWeight.w700,
        height: 1.02,
        letterSpacing: -1.35,
      ),
    );
  }

  Widget _buildSubText() {
    return const _CyclingSubtext();
  }

  Widget _buildDescription() {
    return Text(
      'Focused on real-time perception, model training, inference APIs, research loops, and the product layer that makes ML usable.',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        fontSize: 15.5,
        height: 1.68,
        color: AppColors.textSecondary,
      ),
    );
  }

  Widget _buildMetrics() {
    final totalSkills = categorizedSkills.values.fold<int>(
      0,
      (total, items) => total + items.length,
    );

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _MetricPill(
          value: '${projectItems.length}+',
          label: 'AI-led builds',
          icon: Icons.auto_awesome_rounded,
        ),
        _MetricPill(
          value: '${categorizedSkills.length}',
          label: 'core domains',
          icon: Icons.hub_rounded,
        ),
        _MetricPill(
          value: '$totalSkills',
          label: 'active skills',
          icon: Icons.layers_rounded,
        ),
      ],
    );
  }

  Widget _buildButtons() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _AnimatedCTAButton(
          label: 'View Work',
          icon: Icons.arrow_outward_rounded,
          isPrimary: true,
          onPressed: () => NavigationHelper.scrollToSection(
            context: context,
            navIndex: 2,
            navbarKeys: widget.navbarKeys,
          ),
        ),
        _AnimatedCTAButton(
          label: 'AI Stack',
          icon: Icons.psychology_alt_rounded,
          onPressed: () => NavigationHelper.scrollToSection(
            context: context,
            navIndex: 1,
            navbarKeys: widget.navbarKeys,
          ),
        ),
        _AnimatedCTAButton(
          label: 'Contact',
          icon: Icons.mail_outline_rounded,
          onPressed: () => NavigationHelper.scrollToSection(
            context: context,
            navIndex: 3,
            navbarKeys: widget.navbarKeys,
          ),
        ),
      ],
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: 260,
        width: 260,
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

class _HeroGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.12)
      ..strokeWidth = 1;

    for (double x = 24; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 24; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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
        color: AppColors.background.withValues(alpha: 0.30),
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
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroFocusRow extends StatelessWidget {
  const _HeroFocusRow();

  @override
  Widget build(BuildContext context) {
    const items = [
      'Computer Vision',
      'Deep Learning',
      'ROS / Robotics',
      'Inference APIs',
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.30),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            item,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
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
        color: AppColors.background.withValues(alpha: 0.32),
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

class _HeroTechPanel extends StatefulWidget {
  const _HeroTechPanel({required this.orbitController});

  final AnimationController orbitController;

  @override
  State<_HeroTechPanel> createState() => _HeroTechPanelState();
}

class _HeroTechPanelState extends State<_HeroTechPanel> {
  bool _isHovered = false;
  Offset _pointer = const Offset(180, 180);

  @override
  Widget build(BuildContext context) {
    final tiltX = _isHovered ? ((_pointer.dy - 190) / 190) * 0.05 : 0.0;
    final tiltY = _isHovered ? -((_pointer.dx - 180) / 180) * 0.05 : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      onHover: (event) => setState(() => _pointer = event.localPosition),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(tiltX)
          ..rotateY(tiltY),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.44),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: _isHovered ? AppColors.accentSoft : AppColors.borderStrong,
          ),
          boxShadow: [
            BoxShadow(
              color: (_isHovered ? AppColors.accentSoft : Colors.black)
                  .withValues(alpha: _isHovered ? 0.16 : 0.18),
              blurRadius: _isHovered ? 28 : 20,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Live Focus',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                const _StatusChip(label: 'AI / ML'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 240,
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
                animation: widget.orbitController,
                builder: (context, child) {
                  final angle = widget.orbitController.value * 2 * pi;
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 24 + sin(angle) * 12,
                        right: 34 + cos(angle) * 10,
                        child: const _OrbitalNode(label: 'Vision'),
                      ),
                      Positioned(
                        left: 24 + sin(angle + 1.3) * 10,
                        bottom: 36 + cos(angle + 0.8) * 12,
                        child: const _OrbitalNode(label: 'Models'),
                      ),
                      Positioned(
                        right: 28 + sin(angle + 2.1) * 8,
                        bottom: 42 + cos(angle + 2.1) * 10,
                        child: const _OrbitalNode(label: 'Agents'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: ShaderMask(
                          shaderCallback: (bounds) => AppColors
                              .accentGradientStrong
                              .createShader(bounds),
                          blendMode: BlendMode.srcATop,
                          child: Lottie.asset(
                            'assets/animations/dev.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const _SweepRing(),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 18),
            const _FocusRow(
              label: 'Primary',
              value: 'vision, inference, robotics',
            ),
            const SizedBox(height: 10),
            const _FocusRow(
              label: 'Delivery',
              value: 'APIs, demos, real-time UX',
            ),
            const SizedBox(height: 10),
            const _FocusRow(
              label: 'Side lane',
              value: 'Flutter / Android client work',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.success,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OrbitalNode extends StatelessWidget {
  const _OrbitalNode({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        )
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(0.96, 0.96),
          end: const Offset(1.04, 1.04),
          duration: 1400.ms,
        );
  }
}

class _SweepRing extends StatelessWidget {
  const _SweepRing();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child:
          Container(
                width: 188,
                height: 188,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.16),
                    width: 1.2,
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .custom(
                duration: 3.seconds,
                builder: (context, value, child) {
                  return Transform.rotate(angle: value * 2 * pi, child: child);
                },
              ),
    );
  }
}

class _FocusRow extends StatelessWidget {
  const _FocusRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 68,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
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
    'Computer Vision Engineer',
    'Deep Learning Builder',
    'ROS / Robotics Developer',
    'Inference API Developer',
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2100), (_) {
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
      duration: const Duration(milliseconds: 420),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.14),
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
              offset: Offset(0, -4 * _hoverController.value),
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
                        : AppColors.background.withValues(alpha: 0.20)),
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
                        blurRadius: 22,
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
