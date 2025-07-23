import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/frosted_header.dart';
import 'package:portfolio/constants/navigation_helper.dart';
import 'package:portfolio/constants/size.dart';
import 'package:portfolio/widgets/contact.dart';
import 'package:portfolio/widgets/drawer_mobile.dart';
import 'package:portfolio/widgets/footer.dart';
import 'package:portfolio/widgets/header_desktop.dart';
import 'package:portfolio/widgets/header_mobile.dart';
import 'package:portfolio/widgets/main.dart';
import 'package:portfolio/widgets/project.dart';
import 'package:portfolio/widgets/skill.dart';
import 'dart:math';
import 'package:portfolio/constants/nav_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();

  final List<GlobalKey> navbarKeys = List.generate(navTitles.length, (index) => GlobalKey());

  int _currentActiveNavIndex = 0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_updateActiveNavIndex);
  }

  void _updateActiveNavIndex() {
    double headerBottomEdge = 65.0;
    double activationLine = headerBottomEdge + 20.0;

    int detectedActiveIndex = 0;

    if (scrollController.offset <= 10.0) {
      detectedActiveIndex = 0;
    } else if (scrollController.offset >= scrollController.position.maxScrollExtent - 5) {
      detectedActiveIndex = navbarKeys.length - 1;
      if (navbarKeys.isNotEmpty && navbarKeys[navbarKeys.length -1].currentContext != null) {
      }
    } else {
      for (int i = 0; i < navbarKeys.length; i++) {
        if (i == 3) continue;

        final keyContext = navbarKeys[i].currentContext;
        if (keyContext == null) continue;

        final RenderBox renderBox = keyContext.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);

        final double sectionTopRelativeToViewport = position.dy;
        final double sectionBottomRelativeToViewport = position.dy + renderBox.size.height;

        if (sectionTopRelativeToViewport <= activationLine && sectionBottomRelativeToViewport > activationLine) {
          detectedActiveIndex = i;
          break;
        }
      }
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent - 50 &&
        detectedActiveIndex != navbarKeys.length -1 && navbarKeys.length > 1) {
      final lastKeyContext = navbarKeys.last.currentContext;
      if (lastKeyContext != null) {
        detectedActiveIndex = navbarKeys.length - 1;
      }
    }

    if (_currentActiveNavIndex != detectedActiveIndex) {
      setState(() {
        _currentActiveNavIndex = detectedActiveIndex;
      });
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_updateActiveNavIndex);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= kMinDesktopWidth;

        return Scaffold(
          key: scaffoldKey,
          endDrawer: isDesktop
              ? null
              : DrawerMobile(
            onNavItemTap: (int navIndex) {
              scaffoldKey.currentState?.closeEndDrawer();
              NavigationHelper.scrollToSection(
                context: context,
                navIndex: navIndex,
                navbarKeys: navbarKeys,
              );
              setState(() {
                _currentActiveNavIndex = navIndex;
              });
            },
          ),
          body: Stack(
            children: [
              Positioned.fill(
                top: 60,
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(key: navbarKeys[0]),

                      MainSection(
                        navbarKeys: navbarKeys,
                        context: context,
                      ),

                      const LottieSectionSeparator(),

                      SkillSection(navbarKey: navbarKeys[1]),

                      const LottieSectionSeparator(),

                      ProjectSection(navbarKey: navbarKeys[2]),

                      const LottieSectionSeparator(),

                      GetInTouchSection(navbarKey: navbarKeys[4]),
                      const Footer(),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: FrostedHeaderWrapper(
                    child: isDesktop
                        ? HeaderDesktop(
                      onNavMenuTap: (int navIndex) {
                        NavigationHelper.scrollToSection(
                          context: context,
                          navIndex: navIndex,
                          navbarKeys: navbarKeys,
                        );
                        if (navIndex != 3) {
                          setState(() {
                            _currentActiveNavIndex = navIndex;
                          });
                        }
                      },
                      activeIndex: _currentActiveNavIndex,
                    )
                        : HeaderMobile(
                      onLogoTap: () {
                        NavigationHelper.scrollToSection(
                          context: context,
                          navIndex: 0,
                          navbarKeys: navbarKeys,
                        );
                        setState(() {
                          _currentActiveNavIndex = 0;
                        });
                      },
                      onMenuTap: () {
                        scaffoldKey.currentState?.openEndDrawer();
                      },
                    )
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LottieSectionSeparator extends StatelessWidget {
  const LottieSectionSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double maxSeparatorWidth = 700.0;
    final double minScreenPercentage = 0.6;
    final double minSeparatorWidth = 250.0;

    final double maxSeparatorHeight = 150.0;
    final double minSeparatorHeight = 80.0;
    final double heightToWidthRatio = 0.25;

    final double desiredWidth = min(max(screenWidth * minScreenPercentage, minSeparatorWidth), maxSeparatorWidth);
    final double adaptiveCalculatedHeight = desiredWidth * heightToWidthRatio;

    final double finalHeight = min(max(adaptiveCalculatedHeight, minSeparatorHeight), maxSeparatorHeight);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      child: Lottie.asset(
        'assets/animations/section_separator.json',
        height: finalHeight,
        width: desiredWidth,
        fit: BoxFit.contain,
        repeat: true,
      ),
    );
  }
}