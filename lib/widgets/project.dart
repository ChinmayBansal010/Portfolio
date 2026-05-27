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
        horizontal: isCompact ? 20 : 32,
        vertical: isCompact ? 46 : 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _ProjectSectionHeader(),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 1100 ? 2 : 1;
                  const spacing = 24.0;
                  final itemWidth = columns == 1
                      ? constraints.maxWidth
                      : (constraints.maxWidth - spacing) / 2;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: projectItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final project = entry.value;

                      return SizedBox(
                        width: itemWidth,
                        child:
                            _ProjectTile(
                                  index: index,
                                  title: project['title'] as String,
                                  description: project['description'] as String,
                                  url: project['url'] as String,
                                  icon: project['icon'] as IconData,
                                  tags: (project['tags'] as List<dynamic>)
                                      .cast<String>(),
                                )
                                .animate()
                                .fadeIn(
                                  duration: 800.ms,
                                  delay: (index * 150).ms,
                                )
                                .slideY(
                                  begin: 0.1,
                                  end: 0,
                                  curve: Curves.easeOutCubic,
                                ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 40),
              const Center(child: GitHubCTAButton()),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProjectSectionHeader extends StatelessWidget {
  const _ProjectSectionHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.borderStrong),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.work_outline_rounded,
                size: 16,
                color: AppColors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'SELECTED WORK',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Projects that combine interface thinking, backend structure, and intelligent product behavior.',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.12,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            'Each project is designed to be demonstrable, practical, and implementation-heavy, with an emphasis on systems that users can actually interact with.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectTile extends StatefulWidget {
  const _ProjectTile({
    required this.index,
    required this.title,
    required this.description,
    required this.url,
    required this.icon,
    required this.tags,
  });

  final int index;
  final String title;
  final String description;
  final String url;
  final IconData icon;
  final List<String> tags;

  @override
  State<_ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<_ProjectTile> {
  bool _isHovered = false;
  Offset _mousePosition = Offset.zero;

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // 3D Tilt calculation
    final double rotateX = _isHovered ? (_mousePosition.dy - 0.5) * -0.15 : 0;
    final double rotateY = _isHovered ? (_mousePosition.dx - 0.5) * 0.15 : 0;

    return MouseRegion(
      onEnter: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      onHover: (event) {
        final box = context.findRenderObject() as RenderBox;
        final localPos = box.globalToLocal(event.position);
        setState(() {
          _mousePosition = Offset(
            localPos.dx / box.size.width,
            localPos.dy / box.size.height,
          );
        });
      },
      child: GestureDetector(
        onTap: () => _launchURL(widget.url),
        child: TweenAnimationBuilder<v.Vector3>(
          duration: const Duration(milliseconds: 200),
          tween: Tween(
            begin: v.Vector3.zero(),
            end: v.Vector3(rotateX, rotateY, 0),
          ),
          builder: (context, value, child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateX(value.x)
                ..rotateY(value.y),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _isHovered ? AppColors.surface : AppColors.surfaceGlass,
                  AppColors.backgroundElevated,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: _isHovered
                    ? AppColors.accent.withValues(alpha: 0.6)
                    : AppColors.borderStrong.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                if (_isHovered)
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    blurRadius: 40,
                    offset: Offset(
                      (_mousePosition.dx - 0.5) * 20,
                      (_mousePosition.dy - 0.5) * 20 + 15,
                    ),
                  ),
              ],
            ),
            child: Stack(
              children: [
                // Reactive Spotlight Glow
                if (_isHovered)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment(
                        (_mousePosition.dx - 0.5) * 2,
                        (_mousePosition.dy - 0.5) * 2,
                      ),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppColors.accent.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                // Project Serial Number
                Positioned(
                  top: 0,
                  right: 0,
                  child:
                      Text(
                            "#0${widget.index + 1}",
                            style: TextStyle(
                              color: AppColors.accent.withValues(alpha: 0.15),
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'monospace',
                            ),
                          )
                          .animate(target: _isHovered ? 1 : 0)
                          .slideX(begin: 0, end: -0.1),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isHovered
                                  ? AppColors.accent.withValues(alpha: 0.3)
                                  : AppColors.border,
                            ),
                            boxShadow: [
                              if (_isHovered)
                                BoxShadow(
                                  color: AppColors.accent.withValues(
                                    alpha: 0.2,
                                  ),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            color: AppColors.accent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 60,
                            ), // Add padding to avoid overlap with #0X
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 22,
                                        height: 1.2,
                                        color: _isHovered
                                            ? AppColors.accent
                                            : null,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: _isHovered
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                        height: 1.6,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "TECHNOLOGY STACK",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textMuted,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: widget.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _isHovered
                                ? AppColors.accent.withValues(alpha: 0.08)
                                : AppColors.background.withValues(alpha: 0.38),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _isHovered
                                  ? AppColors.accent.withValues(alpha: 0.2)
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            tag,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: _isHovered
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
        child: Transform.translate(
          offset: Offset(0, _isHovered ? -4 : 0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              gradient: _isHovered ? AppColors.accentGradient : null,
              color: _isHovered
                  ? null
                  : AppColors.surface.withValues(alpha: 0.84),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: _isHovered ? Colors.transparent : AppColors.borderStrong,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.code_rounded,
                  color: _isHovered ? AppColors.background : AppColors.accent,
                ),
                const SizedBox(width: 10),
                Text(
                  'View more on GitHub',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _isHovered
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
