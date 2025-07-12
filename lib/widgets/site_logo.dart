import 'package:flutter/material.dart';

class SiteLogo extends StatelessWidget {
  const SiteLogo({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Text(
        'Chinmay.dev',
        style: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Color(0xFF00FFB2),
          shadows: [
            Shadow(
              color: Color(0x9900FFB2),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
