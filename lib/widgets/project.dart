import 'package:flutter/material.dart';
import 'package:portfolio/constants/project_data.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectSection extends StatelessWidget {
  final GlobalKey navbarKey;
  const ProjectSection({super.key, required this.navbarKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: navbarKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Projects',
            style: const TextStyle(
              fontSize: 32,
              fontFamily: 'SpaceGrotesk',
              fontWeight: FontWeight.bold,
              color: Color(0xFF00FFF0),
              height: 1.2,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  color: Color(0x8800FFF0),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(builder: (context, constraints) {
            const double cardSpacing = 24.0;
            return Wrap(
              spacing: cardSpacing,
              runSpacing: cardSpacing,
              alignment: WrapAlignment.center,
              children: List.generate(projectItems.length, (index) {
                final project = projectItems[index];
                return _AnimatedProjectTileWrapper(
                  index: index,
                  child: LayoutBuilder(
                    builder: (context, cardConstraints) {
                      double maxWidth = cardConstraints.maxWidth < 500
                          ? cardConstraints.maxWidth
                          : 400;

                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 260,
                          maxWidth: maxWidth,
                        ),
                        child: _ProjectTile(
                          title: project["title"]!,
                          description: project["description"]!,
                          url: project["url"]!,
                          tags: project["tags"] ?? [],
                        ),
                      );
                    },
                  ),
                );
              }),
            );
          }),
          const SizedBox(height: 30),
          const GitHubCTAButton(),
        ],
      ),
    );
  }
}

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

class _AnimatedProjectTileWrapper extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedProjectTileWrapper({
    required this.child,
    required this.index,
  });

  @override
  State<_AnimatedProjectTileWrapper> createState() =>
      _AnimatedProjectTileWrapperState();
}

class _AnimatedProjectTileWrapperState
    extends State<_AnimatedProjectTileWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    final delay = Duration(milliseconds: 100 * widget.index);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        delay.inMilliseconds / _animationController.duration!.inMilliseconds,
        1.0,
        curve: Curves.easeOutCubic,
      ),
    ));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        delay.inMilliseconds / _animationController.duration!.inMilliseconds,
        1.0,
        curve: Curves.easeIn,
      ),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

class _ProjectTile extends StatefulWidget {
  final String title;
  final String description;
  final String url;
  final List<String> tags;

  const _ProjectTile({
    required this.title,
    required this.description,
    required this.url,
    required this.tags,
  });

  @override
  State<_ProjectTile> createState() => _ProjectTileState();
}

class _ProjectTileState extends State<_ProjectTile>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _shadowColorAnimation;
  late Animation<double> _shadowBlurAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(milliseconds: 250), vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _shadowColorAnimation = ColorTween(
        begin: const Color(0x2200FFF0), end: const Color(0x5500FFF0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _shadowBlurAnimation = Tween<double>(begin: 10.0, end: 24.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter(_) {
    setState(() => isHovered = true);
    _controller.forward();
  }

  void _onExit(_) {
    setState(() => isHovered = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 500;

    return MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: SystemMouseCursors.click,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: () async => await launchURL(widget.url),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F121A), Color(0xFF181C26)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF00FFF0), width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: _shadowColorAnimation.value!,
                      blurRadius: _shadowBlurAnimation.value,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF00FFF0),
                        fontFamily: 'SpaceGrotesk',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.white70,
                      ),
                      maxLines: isMobile ? 5 : 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    if (widget.tags.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.tags.map((tag) {
                            return Chip(
                              label: Text(tag),
                              backgroundColor: Colors.deepPurple.shade900,
                              labelStyle: const TextStyle(color: Colors.white),
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                            );
                          }).toList(),
                        ),
                      ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () async => await launchURL(widget.url),
                        child: const Icon(Icons.open_in_new,
                            size: 18, color: Color(0xFF9F00FF)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GitHubCTAButton extends StatefulWidget {
  const GitHubCTAButton({super.key});

  @override
  State<GitHubCTAButton> createState() => _GitHubCTAButtonState();
}

class _GitHubCTAButtonState extends State<GitHubCTAButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.05).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchGitHub() async {
    final url = Uri.parse('https://github.com/ChinmayBansal010');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: _launchGitHub,
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnim.value,
            child: child,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              border: Border.all(color: const Color(0xFF00FFF0), width: 1),
              borderRadius: BorderRadius.circular(14),
              boxShadow: _isHovered
                  ? [
                BoxShadow(
                  color: const Color(0x9900FFF0),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.code, color: Color(0xFF00FFF0)),
                SizedBox(width: 10),
                Text(
                  "View more on GitHub",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
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
