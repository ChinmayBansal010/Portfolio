import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:portfolio/pages/home.dart';
import 'package:portfolio/constants/size.dart'; // Assuming kMinDesktopWidth is defined here

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
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
  late AnimationController _typingController;
  late Animation<int> _typingAnimation;
  late AnimationController _cursorBlinkController;
  late AnimationController _loadingController;

  bool _showWavingHand = false;
  bool _showCursor = false;

  final String _greetingText = "Hi, I'm Chinmay";
  final Duration _typingForwardDuration = const Duration(milliseconds: 1500);
  final Duration _wavingHandDisplayDuration = const Duration(milliseconds: 1500);
  final Duration _typingReverseDuration = const Duration(milliseconds: 800);
  final Duration _homePageTransitionDuration = const Duration(milliseconds: 500);

  @override
  void initState() {
    super.initState();

    _typingController = AnimationController(
      vsync: this,
      duration: _typingForwardDuration,
    );

    _typingAnimation = IntTween(begin: 0, end: _greetingText.length).animate(_typingController);

    _cursorBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: _typingForwardDuration + _wavingHandDisplayDuration + _typingReverseDuration + _homePageTransitionDuration,
    )..forward();

    _typingController.forward().then((_) async {
      if (mounted) {
        setState(() {
          _showCursor = true;
        });
        _cursorBlinkController.repeat(reverse: true);

        await Future.delayed(const Duration(milliseconds: 500));

        setState(() {
          _showWavingHand = true;
          _showCursor = false;
        });
        _cursorBlinkController.stop();

        await Future.delayed(_wavingHandDisplayDuration);

        if (mounted) {
          _typingController.duration = _typingReverseDuration;
          await _typingController.reverse().orCancel;

          if (mounted) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return ScaleTransition(
                    scale: animation,
                    child: child,
                  );
                },
                transitionDuration: _homePageTransitionDuration,
              ),
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _typingController.dispose();
    _cursorBlinkController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= kMinDesktopWidth;
    final double desktopHandSize = 200.0;
    final double mobileHandSize = 120.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Lottie.asset(
                'assets/animations/splash_bg.json',
                fit: BoxFit.cover,
                repeat: true,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _typingAnimation,
                      builder: (context, child) {
                        String currentText = _greetingText.substring(0, _typingAnimation.value);
                        return Text(
                          currentText,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'SpaceGrotesk',
                          ),
                        );
                      },
                    ),
                    if (_showCursor)
                      AnimatedBuilder(
                        animation: _cursorBlinkController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _cursorBlinkController.value < 0.5 ? 0.0 : 1.0,
                            child: Container(
                              width: 3,
                              height: 48,
                              color: Colors.white,
                              margin: const EdgeInsets.only(left: 4),
                            ),
                          );
                        },
                      ),
                    if (_showWavingHand && isDesktop)
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
                ),
                if (_showWavingHand && !isDesktop)
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
                const SizedBox(height: 50),
                AnimatedBuilder(
                  animation: _loadingController,
                  builder: (context, child) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: LinearProgressIndicator(
                        value: _loadingController.value,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00FF9F)),
                        backgroundColor: Colors.white12,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}