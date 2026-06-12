import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/constants/project_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vector_math/vector_math_64.dart' as v;

class ProjectSection extends StatelessWidget {
  const ProjectSection({super.key, required this.navbarKey});

  final GlobalKey navbarKey;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.of(context).size.width < 820;

    return Container(
      key: navbarKey,
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 20 : 48,
        vertical: isCompact ? 56 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProjectSectionHeader(isCompact: isCompact),
              SizedBox(height: isCompact ? 48 : 64),
              ...projectItems.asMap().entries.map((entry) {
                final index = entry.key;
                final project = entry.value;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < projectItems.length - 1
                        ? (isCompact ? 24 : 32)
                        : 0,
                  ),
                  child: _FeaturedProjectCard(
                    index: index,
                    title: project['title'] as String,
                    description: project['description'] as String,
                    url: project['url'] as String,
                    icon: project['icon'] as IconData,
                    tags: (project['tags'] as List<dynamic>).cast<String>(),
                    isCompact: isCompact,
                  )
                      .animate()
                      .fadeIn(
                    duration: 700.ms,
                    delay: (index * 120).ms,
                  )
                      .slideY(
                    begin: 0.08,
                    end: 0,
                    duration: 700.ms,
                    delay: (index * 120).ms,
                    curve: Curves.easeOutCubic,
                  ),
                );
              }),
              SizedBox(height: isCompact ? 48 : 64),
              Center(
                child: const GitHubCTAButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectSectionHeader extends StatelessWidget {
  const _ProjectSectionHeader({required this.isCompact});
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow label
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
              'SELECTED WORK',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
        SizedBox(height: isCompact ? 20 : 24),
        // Main headline — big, bold, owning the page
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: isCompact ? 36 : 56,
              height: 1.05,
              letterSpacing: -1.5,
              color: AppColors.textPrimary,
            ),
            children: const [
              TextSpan(text: 'Things I\n'),
              TextSpan(text: "built."),
            ],
          ),
        ),
        SizedBox(height: isCompact ? 16 : 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            'Interface thinking, backend structure, intelligent behavior — each project is implementation-heavy and built to be used.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isCompact ? 15 : 17,
              height: 1.65,
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedProjectCard extends StatefulWidget {
  const _FeaturedProjectCard({
    required this.index,
    required this.title,
    required this.description,
    required this.url,
    required this.icon,
    required this.tags,
    required this.isCompact,
  });

  final int index;
  final String title;
  final String description;
  final String url;
  final IconData icon;
  final List<String> tags;
  final bool isCompact;

  @override
  State<_FeaturedProjectCard> createState() => _FeaturedProjectCardState();
}

class _FeaturedProjectCardState extends State<_FeaturedProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  Offset _mousePos = Offset.zero;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowAnimation = CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ${widget.url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double rotateX =
    _isHovered ? (_mousePos.dy - 0.5) * -0.06 : 0;
    final double rotateY =
    _isHovered ? (_mousePos.dx - 0.5) * 0.06 : 0;

    // Accent colors cycle per project for variety
    final accentColors = [
      AppColors.accent,
      const Color(0xFF06B6D4),
      const Color(0xFFA78BFA),
      const Color(0xFFF472B6),
    ];
    final cardAccent = accentColors[widget.index % accentColors.length];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _mousePos = Offset.zero;
      }),
      onHover: (e) {
        final box = context.findRenderObject() as RenderBox;
        final local = box.globalToLocal(e.position);
        setState(() {
          _mousePos = Offset(
            local.dx / box.size.width,
            local.dy / box.size.height,
          );
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launch,
        child: TweenAnimationBuilder<v.Vector3>(
          duration: const Duration(milliseconds: 250),
          tween: Tween(
            begin: v.Vector3.zero(),
            end: v.Vector3(rotateX, rotateY, 0),
          ),
          builder: (context, rot, child) => Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0008)
              ..rotateX(rot.x)
              ..rotateY(rot.y),
            alignment: Alignment.center,
            child: child,
          ),
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _isHovered
                        ? cardAccent.withValues(alpha: 0.55)
                        : AppColors.borderStrong.withValues(alpha: 0.45),
                    width: 1.5,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _isHovered
                        ? [
                      AppColors.surface,
                      AppColors.backgroundElevated,
                    ]
                        : [
                      AppColors.surfaceGlass,
                      AppColors.backgroundElevated,
                    ],
                  ),
                  boxShadow: _isHovered
                      ? [
                    BoxShadow(
                      color: cardAccent.withValues(alpha: 0.18),
                      blurRadius: 60,
                      spreadRadius: -8,
                      offset: const Offset(0, 24),
                    ),
                  ]
                      : [],
                ),
                child: child,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Reactive mouse-follow spotlight
                  if (_isHovered)
                    Positioned(
                      left: _mousePos.dx *
                          (MediaQuery.of(context).size.width.clamp(
                            0,
                            1240,
                          ) -
                              200) -
                          100,
                      top: _mousePos.dy * 300 - 100,
                      child: IgnorePointer(
                        child: Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                cardAccent.withValues(alpha: 0.07),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  Padding(
                    padding: EdgeInsets.all(widget.isCompact ? 24 : 36),
                    child: widget.isCompact
                        ? _CardBodyCompact(
                      index: widget.index,
                      title: widget.title,
                      description: widget.description,
                      icon: widget.icon,
                      tags: widget.tags,
                      isHovered: _isHovered,
                      cardAccent: cardAccent,
                    )
                        : _CardBodyDesktop(
                      index: widget.index,
                      title: widget.title,
                      description: widget.description,
                      icon: widget.icon,
                      tags: widget.tags,
                      isHovered: _isHovered,
                      cardAccent: cardAccent,
                    ),
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

// ── Desktop layout: giant index number left, content right ─────────────────
class _CardBodyDesktop extends StatelessWidget {
  const _CardBodyDesktop({
    required this.index,
    required this.title,
    required this.description,
    required this.icon,
    required this.tags,
    required this.isHovered,
    required this.cardAccent,
  });

  final int index;
  final String title;
  final String description;
  final IconData icon;
  final List<String> tags;
  final bool isHovered;
  final Color cardAccent;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left: giant ordinal number ──────────────────────────────────
          SizedBox(
            width: 140,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Big number
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.w900,
                    height: 0.9,
                    letterSpacing: -4,
                    color: isHovered
                        ? cardAccent.withValues(alpha: 0.25)
                        : AppColors.textPrimary.withValues(alpha: 0.07),
                  ),
                  child: Text(
                    '${(index + 1).toString().padLeft(2, '0')}',
                  ),
                ),
                // Vertical accent line
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 2,
                  height: isHovered ? 48 : 32,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        cardAccent,
                        cardAccent.withValues(alpha: 0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),

          // ── Vertical divider ────────────────────────────────────────────
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(vertical: 4),
            color: AppColors.borderStrong.withValues(alpha: 0.3),
          ),
          const SizedBox(width: 36),

          // ── Right: all content ──────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon in a styled container
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: isHovered
                            ? cardAccent.withValues(alpha: 0.12)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isHovered
                              ? cardAccent.withValues(alpha: 0.4)
                              : AppColors.border,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(icon, color: cardAccent, size: 26),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 250),
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              letterSpacing: -0.5,
                              color: isHovered
                                  ? cardAccent
                                  : AppColors.textPrimary,
                            ),
                            child: Text(title),
                          ),
                          const SizedBox(height: 4),
                          // Arrow indicator
                          AnimatedOpacity(
                            opacity: isHovered ? 1 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Row(
                              children: [
                                Text(
                                  'View project',
                                  style: TextStyle(
                                    color: cardAccent,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: cardAccent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Top accent bar — full width, thin, vivid
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  height: 1.5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cardAccent.withValues(alpha: isHovered ? 0.7 : 0.2),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  description,
                  style: TextStyle(
                    color: isHovered
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                    fontSize: 15.5,
                    height: 1.68,
                  ),
                ),

                const SizedBox(height: 28),

                // Tech stack
                _TechStack(tags: tags, isHovered: isHovered, accent: cardAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mobile/compact layout: stacked ────────────────────────────────────────
class _CardBodyCompact extends StatelessWidget {
  const _CardBodyCompact({
    required this.index,
    required this.title,
    required this.description,
    required this.icon,
    required this.tags,
    required this.isHovered,
    required this.cardAccent,
  });

  final int index;
  final String title;
  final String description;
  final IconData icon;
  final List<String> tags;
  final bool isHovered;
  final Color cardAccent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Small index badge
            Text(
              '${(index + 1).toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: cardAccent.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 1,
              width: 24,
              color: cardAccent.withValues(alpha: 0.3),
            ),
            const Spacer(),
            Icon(icon, color: cardAccent, size: 22),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1.15,
            letterSpacing: -0.4,
            color: isHovered ? cardAccent : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                cardAccent.withValues(alpha: isHovered ? 0.7 : 0.2),
                Colors.transparent,
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.5,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 20),
        _TechStack(tags: tags, isHovered: isHovered, accent: cardAccent),
      ],
    );
  }
}

// ── Shared tech stack chip row ─────────────────────────────────────────────
class _TechStack extends StatelessWidget {
  const _TechStack({
    required this.tags,
    required this.isHovered,
    required this.accent,
  });

  final List<String> tags;
  final bool isHovered;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STACK',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.textMuted,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.asMap().entries.map((e) {
            final i = e.key;
            final tag = e.value;
            return AnimatedContainer(
              duration: Duration(milliseconds: 200 + i * 40),
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
              decoration: BoxDecoration(
                color: isHovered
                    ? accent.withValues(alpha: 0.1)
                    : AppColors.background.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isHovered
                      ? accent.withValues(alpha: 0.28)
                      : AppColors.border.withValues(alpha: 0.7),
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: isHovered
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  letterSpacing: 0.2,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── GitHub CTA ─────────────────────────────────────────────────────────────
class GitHubCTAButton extends StatefulWidget {
  const GitHubCTAButton({super.key});

  @override
  State<GitHubCTAButton> createState() => _GitHubCTAButtonState();
}

class _GitHubCTAButtonState extends State<GitHubCTAButton> {
  bool _isHovered = false;

  Future<void> _launchGitHub() async {
    final url = Uri.parse('https://github.com/ChinmayBansal010');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchGitHub,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            gradient: _isHovered ? AppColors.accentGradient : null,
            color: _isHovered ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _isHovered
                  ? Colors.transparent
                  : AppColors.borderStrong,
              width: 1.5,
            ),
            boxShadow: _isHovered
                ? [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 24,
                offset: const Offset(0, 8),
              )
            ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.code_rounded,
                size: 18,
                color: _isHovered ? AppColors.background : AppColors.accent,
              ),
              const SizedBox(width: 10),
              Text(
                'More on GitHub',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: _isHovered
                      ? AppColors.background
                      : AppColors.textPrimary,
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform:
                Matrix4.translationValues(_isHovered ? 4 : 0, 0, 0),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: _isHovered ? AppColors.background : AppColors.accent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}