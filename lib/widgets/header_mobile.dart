import 'package:flutter/material.dart';
import 'package:portfolio/widgets/site_logo.dart';

class HeaderMobile extends StatelessWidget {
  const HeaderMobile({
    super.key,
    this.onLogoTap,
    this.onMenuTap,
  });

  final VoidCallback? onLogoTap;
  final VoidCallback? onMenuTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: SiteLogo(
              onTap: onLogoTap,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onMenuTap,
            icon: Icon(
              Icons.menu,
              color: colorScheme.onSurface,
              size: 28,
            ),
            tooltip: 'Open menu',
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}