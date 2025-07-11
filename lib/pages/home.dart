import 'package:flutter/material.dart';
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
  final List<GlobalKey> navbarKeys = List.generate(4, (index) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          key: scaffoldKey,
          endDrawer: constraints.maxWidth >= kMinDesktopWidth
            ? null
            : DrawerMobile(onNavItemTap: (int navIndex){
              scaffoldKey.currentState?.closeEndDrawer();
              scrollToSection(navIndex);
            },),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0A0A0A),
                  Color(0xFF0D1117),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(key: navbarKeys.first),

                  if (constraints.maxWidth>=kMinDesktopWidth)
                    HeaderDesktop(onNavMenuTap: (int navIndex){
                      scrollToSection(navIndex);
                    },)
                  else
                    HeaderMobile(
                      onLogoTap: () {},
                      onMenuTap: () {
                        scaffoldKey.currentState?.openEndDrawer();
                      },
                    ),

                  const MainSection(),

                  SkillSection(navbarKey: navbarKeys[1]),

                  const SizedBox(height: 30,),

                  ProjectSection(navbarKey: navbarKeys[2]),

                  const SizedBox(height: 30,),

                  GetInTouchSection(navbarKey: navbarKeys[3]),

                  const SizedBox(height: 30,),

                  const Footer(),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  void scrollToSection(int navIndex){
    if(navIndex == 4) {
      return;
    }

    final key = navbarKeys[navIndex];
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut
    );

  }
}
