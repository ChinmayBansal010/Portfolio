import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/constants/skill_items.dart';
import 'dart:math';

class SkillSection extends StatelessWidget {
  final GlobalKey navbarKey;

  const SkillSection({super.key, required this.navbarKey});

  Widget _buildCapsuleHeader(BuildContext context, String title) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF00FFF0), // Original color
                    const Color(0xFF9F00FF), // Original color
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00FFF0).withAlpha((255 * 0.5).round()), // Original color with alpha
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black, // Original color
                shadows: const [
                  Shadow(
                    color: Colors.white30,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
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
          const SizedBox(height: 20),
          Center(
            child: Wrap(
              spacing: 32,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: entry.value.map((skill) {
                return AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: 1.0,
                  child: SkillCard(
                    iconPath: skill["img"]!,
                    label: skill["title"]!,
                  ),
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
          capsuleHeaderBuilder: () => _buildCapsuleHeader(context, entry.key),
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
                color: const Color(0xFF42F4E8), // Original color
                shadows: [
                  Shadow(
                    color: const Color(0x9942F4E8).withAlpha((255 * 0.6).round()), // Original color with alpha
                    blurRadius: 16,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    color: const Color(0x9900FFB2).withAlpha((255 * 0.4).round()), // Original color with alpha
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
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
  final Widget Function() capsuleHeaderBuilder;

  const _ExpandableSkillGroup({
    required this.title,
    required this.skills,
    required this.capsuleHeaderBuilder,
  });

  @override
  State<_ExpandableSkillGroup> createState() => _ExpandableSkillGroupState();
}

class _ExpandableSkillGroupState extends State<_ExpandableSkillGroup>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
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

      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double intervalStart = (index / widget.skills.length) * 0.5;
          final double intervalEnd = intervalStart + 0.5;

          final Animation<double> cardAnimation = CurvedAnimation(
            parent: _controller,
            curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOutCubic),
          );

          return Opacity(
            opacity: cardAnimation.value,
            child: Transform.translate(
              offset: Offset(0, (1 - cardAnimation.value) * 30),
              child: SkillCard(
                iconPath: skill["img"]!,
                label: skill["title"]!,
              ),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _toggleExpansion,
          child: widget.capsuleHeaderBuilder(),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
          child: ClipRect(
            child: SizeTransition(
              sizeFactor: _animation,
              axisAlignment: -1.0,
              child: FadeTransition(
                opacity: _animation,
                child: _expanded
                    ? Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
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
          ),
        ),
      ],
    );
  }
}

class SkillCard extends StatefulWidget {
  final String iconPath;
  final String label;

  const SkillCard({
    super.key,
    required this.iconPath,
    required this.label,
  });

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  bool _isHovered = false;
  double _x = 0;
  double _y = 0;

  void _onHover(PointerEvent event, Size size) {
    final Offset center = size.center(Offset.zero);
    final double dx = (event.localPosition.dx - center.dx) / size.width;
    final double dy = (event.localPosition.dy - center.dy) / size.height;
    setState(() {
      _x = dy * 10;
      _y = -dx * 10;
    });
  }

  void _resetTilt() {
    setState(() {
      _x = 0;
      _y = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) {
        _resetTilt();
        setState(() => _isHovered = false);
      },
      onHover: (PointerEvent event) {
        final RenderBox box = context.findRenderObject() as RenderBox;
        _onHover(event, box.size);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 130,
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF10141C), // Original color
              Color(0xFF1A1E2B), // Original color
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0x8842F4E8).withAlpha((255 * 0.53).round()), // Original color with alpha (0x88 is ~0.53)
            width: 1.5,
          ),
          boxShadow: _isHovered
              ? [
            BoxShadow(
              color: const Color(0xFF9F00FF), // Original color
              blurRadius: 24,
              offset: const Offset(0, 6),
            ),
            BoxShadow(
              color: const Color(0x6600FFF0).withAlpha((255 * 0.4).round()), // Original color with alpha (0x66 is ~0.4)
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ]
              : [],
        ),
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(_x * pi / 180)
            ..rotateY(_y * pi / 180),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.iconPath,
                width: 48,
                height: 48,
                semanticsLabel: 'Skill icon for ${widget.label}',
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}