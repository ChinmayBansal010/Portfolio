// ignore_for_file: unused_import

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/skill_items.dart';

// One accent per category — gives each panel its own identity
const _categoryAccents = {
  'Programming Languages': Color(0xFF6C63FF),
  'Artificial Intelligence': Color(0xFF06B6D4),
  'Computer Vision': Color(0xFFF472B6),
  'Frontend Engineering': Color(0xFF34D399),
  'Backend & Databases': Color(0xFFFBBF24),
  'Robotics & Autonomous Systems': Color(0xFFA78BFA),
  'Developer Tools & DevOps': Color(0xFFFF8C69),
};

const List<String> _primaryCategories = [
  'Programming Languages',
  'Artificial Intelligence',
  'Computer Vision',
  'Frontend Engineering',
  'Backend & Databases',
  'Robotics & Autonomous Systems',
  'Developer Tools & DevOps',
];

class SkillSection extends StatelessWidget {
  const SkillSection({super.key, required this.navbarKey});

  final GlobalKey navbarKey;

  int get _totalSkills =>
      categorizedSkills.values.fold<int>(0, (sum, items) => sum + items.length);

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 860;

    return Container(
      key: navbarKey,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 24 : 64,
        vertical: isCompact ? 56 : 80,
      ),
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(totalSkills: _totalSkills, isCompact: isCompact),
            SizedBox(height: isCompact ? 40 : 56),
            _SkillBoard(isCompact: isCompact),
          ],
        ),
      ),
    );
  }
}

// ── Header ───────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.totalSkills, required this.isCompact});

  final int totalSkills;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow — same pattern as Projects for consistency
        Row(
          children: [
            Container(
              width: 32,
              height: 2,
              decoration: BoxDecoration(
                gradient: AppColors.accentGradientStrong,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'CAPABILITIES',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.5,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 500.ms)
            .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),

        SizedBox(height: isCompact ? 20 : 24),

        // Headline with inline skill count as a typographic accent
        isCompact
            ? _CompactHeadline(totalSkills: totalSkills)
            : _DesktopHeadline(totalSkills: totalSkills),

        SizedBox(height: isCompact ? 16 : 20),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            skillSectionDescription,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isCompact ? 14.5 : 16,
              height: 1.65,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 500.ms, delay: 160.ms),

        SizedBox(height: isCompact ? 20 : 28),

        // Category count row — data at a glance, no card needed
        _CategoryCountRow()
            .animate()
            .fadeIn(duration: 500.ms, delay: 220.ms),
      ],
    );
  }
}

class _DesktopHeadline extends StatelessWidget {
  const _DesktopHeadline({required this.totalSkills});
  final int totalSkills;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w900,
          height: 1.0,
          letterSpacing: -2.0,
          color: AppColors.textPrimary,
        ),
        children: [
          const TextSpan(text: 'What I\nwork with'),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 80.ms)
        .slideY(begin: 0.07, end: 0, curve: Curves.easeOutCubic);
  }
}

class _CompactHeadline extends StatelessWidget {
  const _CompactHeadline({required this.totalSkills});
  final int totalSkills;

  @override
  Widget build(BuildContext context) {
    return Text(
      'What I\nwork with',
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w900,
        height: 1.0,
        letterSpacing: -1.5,
        color: AppColors.textPrimary,
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 80.ms)
        .slideY(begin: 0.07, end: 0, curve: Curves.easeOutCubic);
  }
}

// Replaces the stats card — inline data, zero visual clutter
class _CategoryCountRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final entries = _primaryCategories.map((cat) {
      final count = categorizedSkills[cat]?.length ?? 0;
      final accent = _categoryAccents[cat] ?? AppColors.accent;
      return (cat.split(' ').first, count, accent);
    }).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: entry.$3.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: entry.$3.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: entry.$3,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                entry.$1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${entry.$2}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: entry.$3,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── Board ────────────────────────────────────────────────────────────────────
class _SkillBoard extends StatelessWidget {
  const _SkillBoard({required this.isCompact});
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1120) return const _DesktopSkillBoard();

    return LayoutBuilder(
      builder: (context, constraints) {
        final cols = constraints.maxWidth >= 760 ? 2 : 1;
        const spacing = 16.0;
        final itemW = cols == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: _primaryCategories.asMap().entries.map((e) {
            final cat = e.value;
            return SizedBox(
              width: itemW,
              child: _SkillPanel(
                category: cat,
                accent: _categoryAccents[cat] ?? AppColors.accent,
              )
                  .animate()
                  .fadeIn(duration: 600.ms, delay: (e.key * 80).ms)
                  .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
            );
          }).toList(),
        );
      },
    );
  }
}

class _DesktopSkillBoard extends StatelessWidget {
  const _DesktopSkillBoard();

  Widget _panel(String cat, int idx) {
    return _SkillPanel(
      category: cat,
      accent: _categoryAccents[cat] ?? AppColors.accent,
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: (idx * 70).ms)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    const s = 16.0;
    return Column(
      children: [
        // Row 1: 3 columns
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _panel('Programming Languages', 0)),
              const SizedBox(width: s),
              Expanded(child: _panel('Artificial Intelligence', 1)),
              const SizedBox(width: s),
              Expanded(child: _panel('Computer Vision', 2)),
            ],
          ),
        ),
        const SizedBox(height: s),
        // Row 2: 3 columns, last column stacked 2 smaller panels
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _panel('Frontend Engineering', 3)),
            const SizedBox(width: s),
            Expanded(child: _panel('Backend & Databases', 4)),
            const SizedBox(width: s),
            Expanded(
              child: Column(
                children: [
                  _panel('Robotics & Autonomous Systems', 5),
                  const SizedBox(height: s),
                  _panel('Developer Tools & DevOps', 6),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Skill Panel ───────────────────────────────────────────────────────────────
class _SkillPanel extends StatefulWidget {
  const _SkillPanel({required this.category, required this.accent});

  final String category;
  final Color accent;

  @override
  State<_SkillPanel> createState() => _SkillPanelState();
}

class _SkillPanelState extends State<_SkillPanel> {
  bool _hovered = false;
  Offset _mouse = const Offset(0.5, 0.5);

  @override
  Widget build(BuildContext context) {
    final meta = skillCategoryMeta[widget.category]!;
    final skills = categorizedSkills[widget.category]!;

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
        transform: Matrix4.translationValues(0, _hovered ? -5 : 0, 0),
        padding: const EdgeInsets.all(24),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surfaceGlass,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _hovered
                ? widget.accent.withValues(alpha: 0.4)
                : AppColors.borderStrong.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: _hovered
              ? [
            BoxShadow(
              color: widget.accent.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 16),
            ),
          ]
              : [],
        ),
        child: Stack(
          children: [
            // Mouse-follow spotlight
            if (_hovered)
              Positioned(
                left: _mouse.dx * 200 - 100,
                top: _mouse.dy * 200 - 100,
                child: IgnorePointer(
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          widget.accent.withValues(alpha: 0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: accent dot + title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Accent-colored icon square
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: widget.accent.withValues(alpha: _hovered ? 0.18 : 0.10),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.accent.withValues(alpha: _hovered ? 0.4 : 0.2),
                        ),
                      ),
                      child: Icon(
                        meta.icon,
                        color: widget.accent,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.category,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${skills.length} tools',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Accent rule — signals this panel's color identity
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        widget.accent.withValues(alpha: _hovered ? 0.6 : 0.2),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  meta.summary,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    height: 1.58,
                  ),
                ),

                const SizedBox(height: 18),

                // Skills
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: skills.map((skill) {
                    return SkillChip(
                      label: skill['title']!,
                      iconPath: skill['img'],
                      iconKey: skill['icon'],
                      accent: widget.accent,
                      parentHovered: _hovered,
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skill chip — flat, readable, accent on hover ──────────────────────────
class SkillChip extends StatefulWidget {
  const SkillChip({
    super.key,
    required this.label,
    required this.accent,
    required this.parentHovered,
    this.iconPath,
    this.iconKey,
  });

  final String label;
  final String? iconPath;
  final String? iconKey;
  final Color accent;
  final bool parentHovered;

  @override
  State<SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<SkillChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: Matrix4.translationValues(0, _hovered ? -2 : 0, 0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: _hovered
              ? widget.accent.withValues(alpha: 0.1)
              : AppColors.background.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered
                ? widget.accent.withValues(alpha: 0.35)
                : AppColors.border.withValues(alpha: 0.6),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SkillIcon(
              iconPath: widget.iconPath,
              iconKey: widget.iconKey,
              label: widget.label,
              accent: widget.accent,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _hovered ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillIcon extends StatelessWidget {
  const _SkillIcon({
    required this.label,
    required this.accent,
    required this.size,
    this.iconPath,
    this.iconKey,
  });

  final String label;
  final String? iconPath;
  final String? iconKey;
  final Color accent;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (iconPath != null) {
      return SvgPicture.asset(
        iconPath!,
        width: size,
        height: size,
        semanticsLabel: label,
      );
    }
    return Icon(
      _iconFor(iconKey),
      size: size,
      color: accent,
    );
  }

  IconData _iconFor(String? key) {
    return switch (key) {
      'camera'        => Icons.camera_alt_rounded,
      'image_search'  => Icons.image_search_rounded,
      'center_focus'  => Icons.center_focus_strong_rounded,
      'gesture'       => Icons.back_hand_rounded,
      'view_in_ar'    => Icons.view_in_ar_rounded,
      'schema'        => Icons.account_tree_rounded,
      'query_stats'   => Icons.query_stats_rounded,
      'article'       => Icons.article_outlined,
      'smart_toy'     => Icons.smart_toy_rounded,
      'repeat'        => Icons.repeat_rounded,
      'schedule_send' => Icons.schedule_send_rounded,
      'phone_android' => Icons.phone_android_rounded,
      'dns'           => Icons.dns_rounded,
      'sync'          => Icons.sync_rounded,
      _               => Icons.auto_awesome_rounded,
    };
  }
}

// Keep SkillCard exported for backward compat if used elsewhere
class SkillCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return SkillChip(
      label: label,
      iconPath: iconPath,
      iconKey: iconKey,
      accent: AppColors.accent,
      parentHovered: false,
    );
  }
}