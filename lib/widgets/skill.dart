import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/constants/skill_items.dart';
import 'dart:math';

class SkillSection extends StatelessWidget {
  final GlobalKey navbarKey;
  const SkillSection({super.key, required this.navbarKey});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1000;

    return Container(
      key: navbarKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100), // ✅ Keep centered, max width
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'My Skillset',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF42F4E8),
                shadows: [
                  Shadow(
                    color: const Color(0x9942F4E8),
                    blurRadius: 16,
                    offset: const Offset(0, 0),
                  ),
                  const Shadow(
                    color: Color(0x9900FFB2),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: categorizedSkills.entries.map((entry) {
                return Column(
                  children: [
                    const SizedBox(height: 40),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 500),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Gradient Capsule
                            Container(
                              height: 38,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF00FFF0),
                                    Color(0xFF9F00FF),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x8800FFF0),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                            ),
                            // Text
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'SpaceGrotesk',
                                color: Colors.black,
                                shadows: [
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
                    ),
                    const SizedBox(height: 20),

                    // ✅ Skill Cards Wrap
                    Wrap(
                      spacing: isWide ? 32 : 20, // More spacing in wide screens
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
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
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
    final center = size.center(Offset.zero);
    final dx = (event.localPosition.dx - center.dx) / size.width;
    final dy = (event.localPosition.dy - center.dy) / size.height;
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
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox;
        _onHover(event, box.size);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: 130,
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [
              Color(0xFF10141C),
              Color(0xFF1A1E2B),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0x8842F4E8),
            width: 1.5,
          ),
          boxShadow: _isHovered
              ? [
            const BoxShadow(
              color: Color(0xFF9F00FF), // magenta glow
              blurRadius: 24,
              offset: Offset(0, 6),
            ),
            const BoxShadow(
              color: Color(0x6600FFF0), // cyan highlight
              blurRadius: 16,
              offset: Offset(0, -2),
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
              ),
              const SizedBox(height: 12),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'SpaceGrotesk',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}