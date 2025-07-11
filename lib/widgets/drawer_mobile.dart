import 'package:flutter/material.dart';
import 'package:portfolio/constants/nav_items.dart';


class DrawerMobile extends StatelessWidget {
  const DrawerMobile({super.key, required this.onNavItemTap,});
  final Function(int) onNavItemTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF0D1117),
      child: ListView(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0,),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close)
              ),
            ),
          ),
          for(int i = 0; i < navIcons.length; i++)
            ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 30.0,
                vertical: 10.0,
              ),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontFamily: 'SpaceGrotesk',
              ),
              onTap: () {
                onNavItemTap(i);
              },
              leading: Icon(navIcons[i]),
              title: Text(navTitles[i]),
            )
        ],
      ),
    );
  }
}
