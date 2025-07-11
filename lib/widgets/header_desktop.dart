import 'package:flutter/material.dart';
import 'package:portfolio/widgets/site_logo.dart';
import 'package:portfolio/constants/nav_items.dart';

class HeaderDesktop extends StatelessWidget {
  const HeaderDesktop({super.key, required this.onNavMenuTap,});
  final Function(int) onNavMenuTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      width: double.maxFinite,
      child: Row(
        children: [
          SiteLogo(
            onTap: () {},
          ),
          const Spacer(),

          for (int i = 0; i < navTitles.length; i++)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: TextButton(
                onPressed: () {
                  onNavMenuTap(i);
                },
                child: Text(
                  navTitles[i],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontFamily: 'SpaceGrotesk',
                    color: Color(0xAA9B00FF), // Deep violet-magenta
                    shadows: [
                      Shadow(
                        color: Color(0x999B00FF),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
