import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as v;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/navigation_helper.dart';
import 'package:portfolio/constants/project_data.dart';
import 'package:portfolio/constants/size.dart';
import 'package:portfolio/constants/skill_items.dart';

class MainSection extends StatefulWidget {
  const MainSection({
    super.key,
    required this.navbarKeys,
    required this.scrollController,
  });

  final List<GlobalKey> navbarKeys;
  final ScrollController scrollController;

  @override
  State<MainSection> createState() => _MainSectionState();
}

class _MainSectionState extends State<MainSection>
    with TickerProviderStateMixin {
  late final AnimationController _entrance;
  late final AnimationController _orbit;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _orbit = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _entrance.forward();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _orbit.dispose();
    super.dispose();
  }

  Widget _stagger({
    required Widget child,
    required double from,
    Offset slide = const Offset(0, 0.18),
  }) {
    final anim = CurvedAnimation(
      parent: _entrance,
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
    final isMobile = MediaQuery.of(context).size.width < kMinDesktopWidth;

    return AnimatedBuilder(
      animation: widget.scrollController,
      builder: (context, _) {
        final scroll = (widget.scrollController.hasClients &&
            widget.scrollController.position.hasContentDimensions)
            ? widget.scrollController.offset
            : 0.0;

        final exit = Curves.easeInOutQuart
            .transform((scroll / 600.0).clamp(0.0, 1.0));

        final matrix = Matrix4.identity()
          ..setEntry(3, 2, 0.0007)
          ..translateByVector3(v.Vector3(0.0, exit * -100.0, exit * 600.0))
          ..rotateX(exit * -14.0 * pi / 180.0);

        return Transform(
          transform: matrix,
          alignment: Alignment.center,
          child: Opacity(
            opacity: (1.0 - exit * 1.4).clamp(0.0, 1.0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 24 : 64,
                isMobile ? 32 : 48,
                isMobile ? 24 : 64,
                isMobile ? 40 : 56,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1240),
                  child: isMobile
                      ? _MobileLayout(stagger: _stagger, orbit: _orbit,
                      navbarKeys: widget.navbarKeys)
                      : _DesktopLayout(stagger: _stagger, orbit: _orbit,
                      navbarKeys: widget.navbarKeys),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── Desktop layout ────────────────────────────────────────────────────────────
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.stagger,
    required this.orbit,
    required this.navbarKeys,
  });

  final Widget Function({
  required Widget child,
  required double from,
  Offset slide,
  }) stagger;
  final AnimationController orbit;
  final List<GlobalKey> navbarKeys;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left — headline + copy + CTAs
        Expanded(
          flex: 6,
          child: _LeftContent(stagger: stagger, navbarKeys: navbarKeys),
        ),
        const SizedBox(width: 56),
        // Right — status card
        Expanded(
          flex: 4,
          child: stagger(
            from: 0.2,
            slide: const Offset(0.05, 0),
            child: _StatusCard(orbit: orbit),
          ),
        ),
      ],
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.stagger,
    required this.orbit,
    required this.navbarKeys,
  });

  final Widget Function({
  required Widget child,
  required double from,
  Offset slide,
  }) stagger;
  final AnimationController orbit;
  final List<GlobalKey> navbarKeys;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LeftContent(stagger: stagger, navbarKeys: navbarKeys),
        const SizedBox(height: 36),
        stagger(
          from: 0.5,
          child: _StatusCard(orbit: orbit),
        ),
      ],
    );
  }
}

// ── Left column ───────────────────────────────────────────────────────────────
class _LeftContent extends StatelessWidget {
  const _LeftContent({required this.stagger, required this.navbarKeys});

  final Widget Function({
  required Widget child,
  required double from,
  Offset slide,
  }) stagger;
  final List<GlobalKey> navbarKeys;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < kMinDesktopWidth;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow
        stagger(
          from: 0.0,
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'AI ENGINEER  ·  COMPUTER VISION  ·  ROS',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: isMobile ? 20 : 28),

        // Massive headline — two lines, max impact
        stagger(
          from: 0.06,
          slide: const Offset(0, 0.12),
          child: _Headline(isMobile: isMobile),
        ),

        SizedBox(height: isMobile ? 20 : 24),

        // Cycling role title
        stagger(
          from: 0.18,
          child: const _CyclingSubtext(),
        ),

        SizedBox(height: isMobile ? 16 : 20),

        // Single clean description — one job
        stagger(
          from: 0.24,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Text(
              'Building perception systems, training pipelines, and inference APIs that make ML usable in production.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: isMobile ? 15 : 16.5,
                height: 1.65,
              ),
            ),
          ),
        ),

        SizedBox(height: isMobile ? 28 : 36),

        // Two decisive CTAs only
        stagger(
          from: 0.32,
          child: _CTARow(navbarKeys: navbarKeys),
        ),

        SizedBox(height: isMobile ? 28 : 40),

        // Metrics — horizontal, no icon boxes
        stagger(
          from: 0.42,
          child: const _MetricsRow(),
        ),
      ],
    );
  }
}

// ── Headline ──────────────────────────────────────────────────────────────────
class _Headline extends StatelessWidget {
  const _Headline({required this.isMobile});
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: isMobile ? 46 : 72,
          fontWeight: FontWeight.w900,
          height: 0.95,
          letterSpacing: isMobile ? -2.0 : -3.0,
          color: AppColors.textPrimary,
        ),
        children: const [
          TextSpan(text: 'I build\n'),
          TextSpan(text: 'AI '),
          // Accent word
          TextSpan(
            text: 'systems',
            style: TextStyle(
              color: Color(0xFF6C63FF), // AppColors.accent
              fontStyle: FontStyle.italic,
            ),
          ),
          TextSpan(text: '\nthat ship.'),
        ],
      ),
    );
  }
}

// ── CTA row — two buttons, decisive ──────────────────────────────────────────
class _CTARow extends StatelessWidget {
  const _CTARow({required this.navbarKeys});
  final List<GlobalKey> navbarKeys;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _CTAButton(
          label: 'View work',
          icon: Icons.arrow_outward_rounded,
          isPrimary: true,
          onTap: () => NavigationHelper.scrollToSection(
            context: context,
            navIndex: 2,
            navbarKeys: navbarKeys,
          ),
        ),
        _CTAButton(
          label: 'Get in touch',
          icon: Icons.mail_outline_rounded,
          onTap: () => NavigationHelper.scrollToSection(
            context: context,
            navIndex: 3,
            navbarKeys: navbarKeys,
          ),
        ),
      ],
    );
  }
}

class _CTAButton extends StatefulWidget {
  const _CTAButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  State<_CTAButton> createState() => _CTAButtonState();
}

class _CTAButtonState extends State<_CTAButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          transform: Matrix4.translationValues(0, _hovered ? -3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          decoration: BoxDecoration(
            gradient: widget.isPrimary ? AppColors.accentGradientStrong : null,
            color: widget.isPrimary
                ? null
                : _hovered
                ? AppColors.surface
                : AppColors.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: widget.isPrimary
                ? null
                : Border.all(
              color: _hovered
                  ? AppColors.borderStrong
                  : AppColors.borderStrong.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: _hovered
                ? [
              BoxShadow(
                color: widget.isPrimary
                    ? AppColors.accent.withValues(alpha: 0.35)
                    : Colors.black.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: widget.isPrimary
                      ? AppColors.background
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                widget.icon,
                size: 16,
                color: widget.isPrimary
                    ? AppColors.background
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Metrics — flat, no icon boxes ────────────────────────────────────────────
class _MetricsRow extends StatelessWidget {
  const _MetricsRow();

  @override
  Widget build(BuildContext context) {
    final totalSkills = categorizedSkills.values
        .fold<int>(0, (s, items) => s + items.length);

    final items = [
      ('${projectItems.length}+', 'projects'),
      ('${categorizedSkills.length}', 'domains'),
      ('$totalSkills', 'skills'),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.asMap().entries.map((e) {
        final i = e.key;
        final item = e.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (i > 0)
              Container(
                width: 1,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                color: AppColors.borderStrong.withValues(alpha: 0.4),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.$1,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.0,
                    letterSpacing: -1.0,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.$2,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textMuted,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ],
        );
      }).toList(),
    );
  }
}

// ── Status card — right panel ─────────────────────────────────────────────────
class _StatusCard extends StatefulWidget {
  const _StatusCard({required this.orbit});
  final AnimationController orbit;

  @override
  State<_StatusCard> createState() => _StatusCardState();
}

class _StatusCardState extends State<_StatusCard> {
  bool _hovered = false;
  Offset _mouse = const Offset(0.5, 0.5);

  @override
  Widget build(BuildContext context) {
    final tX = _hovered ? ((_mouse.dy - 0.5) * -0.06) : 0.0;
    final tY = _hovered ? ((_mouse.dx - 0.5) * 0.06) : 0.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() {
        _hovered = false;
        _mouse = const Offset(0.5, 0.5);
      }),
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(e.position);
        setState(() {
          _mouse = Offset(
            local.dx / box.size.width,
            local.dy / box.size.height,
          );
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(tX)
          ..rotateY(tY),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withValues(alpha: 0.3)
                : AppColors.borderStrong.withValues(alpha: 0.5),
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.1),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card header
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF22C55E),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scaleXY(begin: 0.8, end: 1.2, duration: 1400.ms),
                const SizedBox(width: 8),
                Text(
                  'Available for work',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF22C55E),
                  ),
                ),
                const Spacer(),
                Text(
                  'IN · 2026',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Lottie animation in a contained box
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.4),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Orbital nodes around the lottie
                  AnimatedBuilder(
                    animation: widget.orbit,
                    builder: (_, _) {
                      final a = widget.orbit.value * 2 * pi;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: 16 + sin(a) * 14,
                            right: 20 + cos(a) * 10,
                            child: const _Node(label: 'Vision'),
                          ),
                          Positioned(
                            left: 16 + sin(a + 1.4) * 10,
                            bottom: 20 + cos(a + 1.0) * 12,
                            child: const _Node(label: 'Models'),
                          ),
                          Positioned(
                            right: 20 + sin(a + 2.2) * 8,
                            bottom: 32 + cos(a + 2.2) * 10,
                            child: const _Node(label: 'ROS'),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(28),
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.accentGradientStrong.createShader(bounds),
                      blendMode: BlendMode.srcATop,
                      child: Lottie.asset(
                        'assets/animations/dev.json',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Terminal-style focus lines
            _TerminalLine(label: 'focus', value: 'vision · inference · robotics'),
            const SizedBox(height: 10),
            _TerminalLine(label: 'stack', value: 'Python · C++ · Flutter · ROS2'),
            const SizedBox(height: 10),
            _TerminalLine(label: 'open\xa0to', value: 'roles, builds, collabs'),

            const SizedBox(height: 20),

            // Divider
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Skill domain chips — compact
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: const [
                _DomainChip(label: 'Deep Learning'),
                _DomainChip(label: 'CV pipelines'),
                _DomainChip(label: 'Inference APIs'),
                _DomainChip(label: 'Flutter'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Node extends StatelessWidget {
  const _Node({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(begin: 0.95, end: 1.05, duration: 1600.ms);
  }
}

class _TerminalLine extends StatelessWidget {
  const _TerminalLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '→',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 52,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
              fontFamily: 'monospace',
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _DomainChip extends StatelessWidget {
  const _DomainChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.18),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

// ── Cycling subtext ────────────────────────────────────────────────────────────
class _CyclingSubtext extends StatefulWidget {
  const _CyclingSubtext();

  @override
  State<_CyclingSubtext> createState() => _CyclingSubtextState();
}

class _CyclingSubtextState extends State<_CyclingSubtext> {
  static const _titles = [
    'Computer Vision Engineer',
    'Deep Learning Builder',
    'ROS / Robotics Developer',
    'Inference API Developer',
  ];

  int _i = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 2200), (_) {
      if (mounted) setState(() => _i = (_i + 1) % _titles.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 380),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween(
            begin: const Offset(0, 0.12),
            end: Offset.zero,
          ).animate(anim),
          child: child,
        ),
      ),
      child: Text(
        _titles[_i],
        key: ValueKey(_i),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.accent,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}