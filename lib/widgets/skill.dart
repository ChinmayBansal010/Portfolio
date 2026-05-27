import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/skill_items.dart';

const List<String> _primaryCategories = [
  'Programming Languages',
  'Artificial Intelligence',
  'Computer Vision',
  'Frontend Engineering',
  'Backend & Databases',
];

class SkillSection extends StatelessWidget {
  const SkillSection({super.key, required this.navbarKey});

  final GlobalKey navbarKey;

  int get _totalSkills =>
      categorizedSkills.values.fold<int>(0, (sum, items) => sum + items.length);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 860;

    return Container(
      key: navbarKey,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 32,
        vertical: isCompact ? 28 : 36,
      ),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1280),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(totalSkills: _totalSkills),
            const SizedBox(height: 18),
            const _SkillSignalRow(),
            const SizedBox(height: 20),
            _SkillBoard(isCompact: isCompact),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.totalSkills});

  final int totalSkills;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 860;

    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.84),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.psychology_alt_rounded,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'AI STACK',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          skillSectionTitle,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.08,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Text(
            skillSectionDescription,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.65,
            ),
          ),
        ),
      ],
    );

    final statsCard = Container(
      width: isCompact ? double.infinity : 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.surfaceGlass, AppColors.backgroundElevated],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderStrong),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$totalSkills',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'active skills',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Text(
            'Organized as one tech stack with a balanced desktop layout.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textMuted,
              height: 1.55,
            ),
          ),
        ],
      ),
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [heading, const SizedBox(height: 16), statsCard],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: heading),
        const SizedBox(width: 24),
        statsCard,
      ],
    );
  }
}

class _SkillSignalRow extends StatelessWidget {
  const _SkillSignalRow();

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Computer Vision', 'real-time perception'),
      ('Deep Learning', 'training + inference'),
      ('ROS', 'robot stacks + control flows'),
      ('Apps', 'product-ready delivery'),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: items.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.$1,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.$2,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SkillBoard extends StatelessWidget {
  const _SkillBoard({required this.isCompact});

  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1120) {
      return const _DesktopSkillBoard();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final categories = [
          ..._primaryCategories,
          'Robotics & Autonomous Systems',
          'Developer Tools & DevOps',
        ];
        final columns = constraints.maxWidth >= 1180
            ? 3
            : constraints.maxWidth >= 760
            ? 2
            : 1;
        const spacing = 18.0;
        final itemWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: categories.asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;
            final meta = skillCategoryMeta[category]!;
            final skills = categorizedSkills[category]!;

            return SizedBox(
              width: itemWidth,
              child:
                  _PrimarySkillPanel(
                        title: category,
                        summary: meta.summary,
                        icon: meta.icon,
                        skills: skills,
                      )
                      .animate()
                      .fadeIn(
                        duration: 700.ms,
                        delay: (index * 80).ms,
                        curve: Curves.easeOutCubic,
                      )
                      .slideY(begin: 0.06, end: 0),
            );
          }).toList(),
        );
      },
    );
  }
}

class _DesktopSkillBoard extends StatelessWidget {
  const _DesktopSkillBoard();

  @override
  Widget build(BuildContext context) {
    const spacing = 18.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - (spacing * 2)) / 3;

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _AnimatedSkillPanel(
                    index: 0,
                    child: _buildPrimaryPanel('Programming Languages'),
                  ),
                ),
                const SizedBox(width: spacing),
                Expanded(
                  child: _AnimatedSkillPanel(
                    index: 1,
                    child: _buildPrimaryPanel('Artificial Intelligence'),
                  ),
                ),
                const SizedBox(width: spacing),
                Expanded(
                  child: _AnimatedSkillPanel(
                    index: 2,
                    child: _buildPrimaryPanel('Computer Vision'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: spacing),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _AnimatedSkillPanel(
                    index: 3,
                    child: _buildPrimaryPanel('Frontend Engineering'),
                  ),
                ),
                const SizedBox(width: spacing),
                Expanded(
                  child: _AnimatedSkillPanel(
                    index: 4,
                    child: _buildPrimaryPanel('Backend & Databases'),
                  ),
                ),
                const SizedBox(width: spacing),
                SizedBox(
                  width: itemWidth,
                  child: Column(
                    children: [
                      _AnimatedSkillPanel(
                        index: 5,
                        child: _buildPrimaryPanelWithValues(
                          title: 'Robotics & Autonomous Systems',
                          summary:
                              skillCategoryMeta['Robotics & Autonomous Systems']!
                                  .summary,
                          icon:
                              skillCategoryMeta['Robotics & Autonomous Systems']!
                                  .icon,
                          skills:
                              categorizedSkills['Robotics & Autonomous Systems']!,
                        ),
                      ),
                      const SizedBox(height: spacing),
                      _AnimatedSkillPanel(
                        index: 6,
                        child: _buildPrimaryPanelWithValues(
                          title: 'Developer Tools & DevOps',
                          summary:
                              skillCategoryMeta['Developer Tools & DevOps']!
                                  .summary,
                          icon: skillCategoryMeta['Developer Tools & DevOps']!
                              .icon,
                          skills:
                              categorizedSkills['Developer Tools & DevOps']!,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildPrimaryPanel(String category) {
    final meta = skillCategoryMeta[category]!;
    return _buildPrimaryPanelWithValues(
      title: category,
      summary: meta.summary,
      icon: meta.icon,
      skills: categorizedSkills[category]!,
    );
  }

  Widget _buildPrimaryPanelWithValues({
    required String title,
    required String summary,
    required IconData icon,
    required List<Map<String, String>> skills,
  }) {
    return _PrimarySkillPanel(
      title: title,
      summary: summary,
      icon: icon,
      skills: skills,
    );
  }
}

class _AnimatedSkillPanel extends StatelessWidget {
  const _AnimatedSkillPanel({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(
          duration: 700.ms,
          delay: (index * 80).ms,
          curve: Curves.easeOutCubic,
        )
        .slideY(begin: 0.06, end: 0);
  }
}

class _PrimarySkillPanel extends StatefulWidget {
  const _PrimarySkillPanel({
    required this.title,
    required this.summary,
    required this.icon,
    required this.skills,
  });

  final String title;
  final String summary;
  final IconData icon;
  final List<Map<String, String>> skills;

  @override
  State<_PrimarySkillPanel> createState() => _PrimarySkillPanelState();
}

class _PrimarySkillPanelState extends State<_PrimarySkillPanel> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Transform.translate(
        offset: Offset(0, _isHovered ? -6 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(22),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.surfaceGlass, AppColors.backgroundElevated],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: _isHovered ? AppColors.accentSoft : AppColors.borderStrong,
            ),
            boxShadow: [
              BoxShadow(
                color: (_isHovered ? AppColors.accentSoft : Colors.black)
                    .withValues(alpha: _isHovered ? 0.12 : 0.16),
                blurRadius: _isHovered ? 24 : 18,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _PanelBeamPainter(
                      glowX: 90,
                      intensity: _isHovered ? 1.0 : 0.35,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          gradient: AppColors.accentGradientStrong,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.22),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          color: AppColors.background,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    height: 1.15,
                                  ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${widget.skills.length} items',
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(
                                    color: AppColors.accent,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.summary,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textMuted,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.skills.map((skill) {
                      return SkillCard(
                        iconPath: skill['img'],
                        iconKey: skill['icon'],
                        label: skill['title']!,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelBeamPainter extends CustomPainter {
  const _PanelBeamPainter({required this.glowX, required this.intensity});

  final double glowX;
  final double intensity;

  @override
  void paint(Canvas canvas, Size size) {
    final glowRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final glowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.accent.withValues(alpha: 0.02 * intensity),
          AppColors.accentSoft.withValues(alpha: 0.10 * intensity),
          Colors.transparent,
        ],
        stops: const [0.0, 0.25, 1.0],
      ).createShader(glowRect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(glowRect, const Radius.circular(28)),
      glowPaint,
    );

    final linePaint = Paint()
      ..color = AppColors.accentSoft.withValues(alpha: 0.10 * intensity)
      ..strokeWidth = 1;

    for (double y = 22; y < size.height; y += 26) {
      canvas.drawLine(
        Offset(max(0, glowX - 42), y),
        Offset(min(size.width, glowX + 42), y),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _PanelBeamPainter oldDelegate) {
    return oldDelegate.glowX != glowX || oldDelegate.intensity != intensity;
  }
}

class SkillCard extends StatefulWidget {
  const SkillCard({
    super.key,
    required this.label,
    this.iconPath,
    this.iconKey,
  });

  final String label;
  final String? iconPath;
  final String? iconKey;

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 520;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Transform.translate(
        offset: Offset(0, _isHovered ? -4 : 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 12 : 14,
            vertical: isCompact ? 12 : 14,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.surfaceAlt
                : AppColors.background.withValues(alpha: 0.38),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _isHovered ? AppColors.accentSoft : AppColors.border,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.accentSoft.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SkillBadgeVisual(
                iconPath: widget.iconPath,
                iconKey: widget.iconKey,
                label: widget.label,
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillBadgeVisual extends StatelessWidget {
  const _SkillBadgeVisual({required this.label, this.iconPath, this.iconKey});

  final String label;
  final String? iconPath;
  final String? iconKey;

  @override
  Widget build(BuildContext context) {
    const boxSize = 40.0;
    const padding = 8.0;
    const iconSize = 20.0;

    return Container(
      height: boxSize,
      width: boxSize,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: iconPath != null
          ? SvgPicture.asset(iconPath!, semanticsLabel: 'Skill icon for $label')
          : Icon(
              _materialIconFor(iconKey),
              size: iconSize,
              color: AppColors.accent,
            ),
    );
  }

  IconData _materialIconFor(String? key) {
    switch (key) {
      case 'camera':
        return Icons.camera_alt_rounded;
      case 'image_search':
        return Icons.image_search_rounded;
      case 'center_focus':
        return Icons.center_focus_strong_rounded;
      case 'gesture':
        return Icons.back_hand_rounded;
      case 'view_in_ar':
        return Icons.view_in_ar_rounded;
      case 'schema':
        return Icons.account_tree_rounded;
      case 'query_stats':
        return Icons.query_stats_rounded;
      case 'article':
        return Icons.article_outlined;
      case 'smart_toy':
        return Icons.smart_toy_rounded;
      case 'repeat':
        return Icons.repeat_rounded;
      case 'schedule_send':
        return Icons.schedule_send_rounded;
      case 'phone_android':
        return Icons.phone_android_rounded;
      case 'dns':
        return Icons.dns_rounded;
      case 'sync':
        return Icons.sync_rounded;
      default:
        return Icons.auto_awesome_rounded;
    }
  }
}
