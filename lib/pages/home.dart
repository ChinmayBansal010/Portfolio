import 'package:flutter/material.dart';
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrollController = ScrollController();
  final List<GlobalKey> navbarKeys = List.generate(5, (index) => GlobalKey());

  @override
  void dispose() {
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
            },
          ),
          body: Stack(
            children: [
              // Scrollable content
              Positioned.fill(
                top: 60, // reserve space for header
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      SizedBox(key: navbarKeys.first),

                      // Your sections
                      MainSection(navbarKeys: navbarKeys, context: context,),
                      SkillSection(navbarKey: navbarKeys[1]),
                      ProjectSection(navbarKey: navbarKeys[2]),
                      GetInTouchSection(navbarKey: navbarKeys[4]),
                      const Footer(),
                    ],
                  ),
                ),
              ),

              // Sticky header (mobile OR desktop)
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
                    },
                  )
                  : HeaderMobile(
                    onLogoTap: () {
                      NavigationHelper.scrollToSection(
                        context: context,
                        navIndex: 0,
                        navbarKeys: navbarKeys,
                      );
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


