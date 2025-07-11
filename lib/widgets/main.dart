import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/constants/size.dart';

class MainSection extends StatelessWidget {
  const MainSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < kMinDesktopWidth;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 40,
        vertical: isMobile ? 40 : 60,
      ),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Text Section
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingText(),
              const SizedBox(height: 16),
              _buildSubText(),
              const SizedBox(height: 20),
              _buildDescription(),
              const SizedBox(height: 30),
              _buildButtons(),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Right Lottie Animation
        Expanded(
          flex: 1,
          child: _buildLottieBox(height: 400),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildLottieBox(height: 250),
        const SizedBox(height: 30),
        _buildGreetingText(isCentered: true),
        const SizedBox(height: 16),
        _buildSubText(isCentered: true),
        const SizedBox(height: 20),
        _buildDescription(isCentered: true),
        const SizedBox(height: 30),
        _buildButtons(isCentered: true),
      ],
    );
  }

  Widget _buildGreetingText({bool isCentered = false}) {
    return Text(
      "Hi, I’m Chinmay 👋",
      textAlign: isCentered ? TextAlign.center : TextAlign.start,
      style: TextStyle(
        fontSize: isCentered ? 28 : 40,
        fontWeight: FontWeight.bold,
        fontFamily: 'SpaceGrotesk',
        color: const Color(0xFF00FF9F),
        shadows: [
          Shadow(
            color: const Color(0xFF00FF9F).withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildSubText({bool isCentered = false}) {
    return const Text(
      "AI Enthusiast / ML Practitioner / Android Developer",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: Color(0xFF00FFB2),
        fontFamily: 'SpaceGrotesk',
      ),
    );
  }

  Widget _buildDescription({bool isCentered = false}) {
    return const Text(
      "Crafting intelligent, cross-platform apps with stunning UIs and smart brains.",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 15,
        color: Colors.white70,
        fontFamily: 'SpaceGrotesk',
      ),
    );
  }

  Widget _buildButtons({bool isCentered = false}) {
    return Row(
      mainAxisAlignment: isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FFB2),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("View Projects"),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00FFB2),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text("Contact Me"),
        ),
      ],
    );
  }

  Widget _buildLottieBox({required double height}) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x14000000), // black with alpha 20
        borderRadius: BorderRadius.circular(20),
      ),
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [
              Color(0x6600FFB2),
              Color(0x669F00FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcATop,
        child: Lottie.asset(
          'assets/animations/dev.json',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
