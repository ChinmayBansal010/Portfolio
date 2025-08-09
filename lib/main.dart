import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/pages/home.dart';
import 'package:portfolio/constants/size.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chinmay.dev',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'SpaceGrotesk',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _typingControllerDesktop;
  late Animation<int> _typingAnimationDesktop;
  late AnimationController _typingControllerHi;
  late Animation<int> _typingAnimationHi;
  late AnimationController _typingControllerName;
  late Animation<int> _typingAnimationName;
  late AnimationController _cursorBlinkController;
  bool _showWavingHand = false;
  bool _showCursor = false;
  final String _greetingTextDesktop = "Hi, I'm Chinmay Bansal";
  final String _greetingTextHi = "Hi,";
  final String _greetingTextName = "I'm Chinmay Bansal";
  final Duration _typingForwardDuration = const Duration(milliseconds: 1500);
  final Duration _wavingHandDisplayDuration = const Duration(milliseconds: 1500);
  final Duration _typingReverseDuration = const Duration(milliseconds: 800);
  final Duration _homePageTransitionDuration = const Duration(milliseconds: 800);

  @override
  void initState() {
    super.initState();
    _typingControllerDesktop = AnimationController(vsync: this, duration: _typingForwardDuration);
    _typingAnimationDesktop = IntTween(begin: 0, end: _greetingTextDesktop.length).animate(_typingControllerDesktop);
    _typingControllerHi = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _typingAnimationHi = IntTween(begin: 0, end: _greetingTextHi.length).animate(_typingControllerHi);
    _typingControllerName = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _typingAnimationName = IntTween(begin: 0, end: _greetingTextName.length).animate(_typingControllerName);
    _cursorBlinkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAnimationSequence());
  }

  Future<void> _startAnimationSequence() async {
    final bool isWideScreen = MediaQuery.of(context).size.width >= kMinDesktopWidth;
    if (isWideScreen) {
      await _typingControllerDesktop.forward();
      if (!mounted) return;
      setState(() => _showCursor = true);
      _cursorBlinkController.repeat(reverse: true);
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      setState(() {
        _showWavingHand = true;
        _showCursor = false;
      });
      _cursorBlinkController.stop();
      await Future.delayed(_wavingHandDisplayDuration);
      if (!mounted) return;
      _typingControllerDesktop.duration = _typingReverseDuration;
      await _typingControllerDesktop.reverse();
    } else {
      await _typingControllerHi.forward();
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 200));
      await _typingControllerName.forward();
      if (!mounted) return;
      setState(() => _showWavingHand = true);
      await Future.delayed(_wavingHandDisplayDuration);
      if (!mounted) return;
      await _typingControllerName.reverse();
      await _typingControllerHi.reverse();
    }
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomePage(),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation), child: child),
          );
        },
        transitionDuration: _homePageTransitionDuration,
      ),
    );
  }

  @override
  void dispose() {
    _typingControllerDesktop.dispose();
    _typingControllerHi.dispose();
    _typingControllerName.dispose();
    _cursorBlinkController.dispose();
    super.dispose();
  }

  Widget _buildCursor() {
    return AnimatedBuilder(
      animation: _cursorBlinkController,
      builder: (_, __) {
        return Opacity(
          opacity: _cursorBlinkController.value < 0.5 ? 0.0 : 1.0,
          child: Container(width: 3, height: 48, color: Colors.white, margin: const EdgeInsets.only(left: 4)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width >= kMinDesktopWidth;
    final double desktopHandSize = 200.0;
    final double mobileHandSize = 120.0;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Lottie.asset('assets/animations/splash_bg.json', fit: BoxFit.cover, repeat: true),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isWideScreen)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedBuilder(
                        animation: _typingAnimationDesktop,
                        builder: (_, __) {
                          String currentText = _greetingTextDesktop.substring(0, _typingAnimationDesktop.value);
                          return Text(
                            currentText,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 10, color: Colors.white.withAlpha(40))],
                              fontFamily: 'SpaceGrotesk',
                            ),
                          );
                        },
                      ),
                      if (_showCursor) _buildCursor(),
                      if (_showWavingHand)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Lottie.asset(
                            'assets/animations/waving_hand.json',
                            height: desktopHandSize,
                            width: desktopHandSize,
                            repeat: true,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  )
                else
                  Column(
                    children: [
                      AnimatedBuilder(
                        animation: _typingAnimationHi,
                        builder: (_, __) {
                          String currentHi = _greetingTextHi.substring(0, _typingAnimationHi.value.clamp(0, _greetingTextHi.length));
                          return Text(
                            currentHi,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [Shadow(blurRadius: 10, color: Colors.white.withAlpha(40))],
                              fontFamily: 'SpaceGrotesk',
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      AnimatedBuilder(
                        animation: _typingAnimationName,
                        builder: (_, __) {
                          String currentName = _greetingTextName.substring(0, _typingAnimationName.value.clamp(0, _greetingTextName.length));
                          return Text(
                            currentName,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 36,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withAlpha(90),
                              fontFamily: 'SpaceGrotesk',
                            ),
                          );
                        },
                      ),
                      if (_showWavingHand)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Lottie.asset(
                            'assets/animations/waving_hand.json',
                            height: mobileHandSize,
                            width: mobileHandSize,
                            repeat: true,
                            fit: BoxFit.contain,
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
