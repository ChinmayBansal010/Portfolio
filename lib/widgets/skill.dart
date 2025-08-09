import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/constants/skill_items.dart';
import 'dart:math';

class SkillSection extends StatelessWidget {
  final GlobalKey navbarKey;

  const SkillSection({super.key, required this.navbarKey});

  Widget _buildCapsuleHeader(BuildContext context, String title, {Animation<double>? rotationAnimation}) {
    return Center(
      child: SizedBox(
        width: 320,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              colors: [Color(0xFF00FFF0), Color(0xFF9F00FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00FFF0).withValues(alpha: 0.5),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(color: Colors.white30, blurRadius: 2, offset: Offset(0, 1)),
                  ],
                ),
              ),
              if (rotationAnimation != null) ...[
                const SizedBox(width: 8),
                RotationTransition(
                  turns: Tween(begin: 0.0, end: 0.5).animate(rotationAnimation),
                  child: const Icon(Icons.expand_more, color: Colors.black),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDesktopSkillGroups(BuildContext context) {
    return categorizedSkills.entries.map((entry) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          _buildCapsuleHeader(context, entry.key),
          const SizedBox(height: 30),
          Center(
            child: Wrap(
              spacing: 32,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: entry.value.map((skill) {
                return SkillCard(
                  iconPath: skill["img"]!,
                  label: skill["title"]!,
                );
              }).toList(),
            ),
          ),
        ],
      );
    }).toList();
  }

  List<Widget> _buildMobileSkillGroups(BuildContext context) {
    return categorizedSkills.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: _ExpandableSkillGroup(
          title: entry.key,
          skills: entry.value,
          capsuleHeaderBuilder: (animation) => _buildCapsuleHeader(
            context,
            entry.key,
            rotationAnimation: animation,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width > 800;

    return Container(
      key: navbarKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'My Skillset',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: const Color(0xFF42F4E8),
                shadows: [
                  Shadow(color: const Color(0xFF42F4E8).withValues(alpha: 0.6), blurRadius: 16),
                  Shadow(color: const Color(0xFF00FFB2).withValues(alpha: 0.4), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            ...isWide ? _buildDesktopSkillGroups(context) : _buildMobileSkillGroups(context),
          ],
        ),
      ),
    );
  }
}

class _ExpandableSkillGroup extends StatefulWidget {
  final String title;
  final List<Map<String, String>> skills;
  final Widget Function(Animation<double> animation) capsuleHeaderBuilder;

  const _ExpandableSkillGroup({
    required this.title,
    required this.skills,
    required this.capsuleHeaderBuilder,
  });

  @override
  State<_ExpandableSkillGroup> createState() => _ExpandableSkillGroupState();
}

class _ExpandableSkillGroupState extends State<_ExpandableSkillGroup> with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _expanded = !_expanded;
      if (_expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  List<Widget> _buildStaggeredSkillCards() {
    return widget.skills.asMap().entries.map((entry) {
      final int index = entry.key;
      final Map<String, String> skill = entry.value;
      final double intervalStart = (index / widget.skills.length) * 0.5;
      final double intervalEnd = intervalStart + 0.5;
      final Animation<double> cardAnimation = CurvedAnimation(
        parent: _controller,
        curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOutCubic),
      );

      return AnimatedBuilder(
        animation: cardAnimation,
        builder: (context, child) => Opacity(
          opacity: cardAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - cardAnimation.value) * 30),
            child: SkillCard(iconPath: skill["img"]!, label: skill["title"]!),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(onTap: _toggleExpansion, child: widget.capsuleHeaderBuilder(_animation)),
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1.0,
          child: FadeTransition(
            opacity: _animation,
            child: _expanded
                ? Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: SizedBox(
                width: double.infinity,
                child: Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: _buildStaggeredSkillCards(),
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}

class SkillCard extends StatefulWidget {
  final String iconPath;
  final String label;

  const SkillCard({super.key, required this.iconPath, required this.label});

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  double _tiltX = 0;
  double _tiltY = 0;
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event) {
    if (!mounted) return;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(event.position);
    final Size size = box.size;
    final double dx = (localPosition.dx - size.width / 2) / (size.width / 2);
    final double dy = (localPosition.dy - size.height / 2) / (size.height / 2);

    setState(() {
      _tiltX = dy * (pi / 20);
      _tiltY = -dx * (pi / 20);
    });
  }

  void _resetTilt() {
    if (!mounted) return;
    setState(() {
      _tiltX = 0;
      _tiltY = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 800;
    final double cardWidth = isMobile ? 105 : 130;
    final double cardHeight = isMobile ? 115 : 140;
    final double iconSize = isMobile ? 38 : 48;
    final double fontSize = isMobile ? 13 : 14;

    return AnimatedScale(
      scale: _isHovered ? 1.08 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) {
          _resetTilt();
          setState(() => _isHovered = false);
        },
        onHover: _onHover,
        child: AnimatedBuilder(
          animation: _shimmerController,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: SweepGradient(
                  center: Alignment.center,
                  transform: GradientRotation(_shimmerController.value * 2 * pi),
                  colors: [
                    const Color(0xFF00FFF0).withValues(alpha: 0.9),
                    const Color(0xFF00FFF0).withValues(alpha: 0.1),
                    const Color(0xFF9F00FF).withValues(alpha: 0.9),
                    const Color(0xFF9F00FF).withValues(alpha: 0.1),
                    const Color(0xFF00FFF0).withValues(alpha: 0.9),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(1.5),
              child: child,
            );
          },
          child: Container(
            width: cardWidth,
            height: cardHeight,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10141C), Color(0xFF1A1E2B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: _isHovered
                  ? [
                BoxShadow(color: const Color(0xFF9F00FF).withValues(alpha: 0.5), blurRadius: 24, offset: const Offset(0, 6)),
                BoxShadow(color: const Color(0xFF00FFF0).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, -2)),
              ]
                  : [],
            ),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(_tiltX)
                ..rotateY(_tiltY),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.translate(
                    offset: Offset(_tiltY * -20, _tiltX * 20),
                    child: SvgPicture.asset(
                      widget.iconPath,
                      width: iconSize,
                      height: iconSize,
                      semanticsLabel: 'Skill icon for ${widget.label}',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: fontSize),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}