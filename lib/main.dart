// ─────────────────────────────────────────────────────────────────────────
// main.dart
// ─────────────────────────────────────────────────────────────────────────
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:portfolio/constants/colors.dart';
import 'package:portfolio/pages/home.dart'; // now exports HomeShell

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark(useMaterial3: true);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chinmay Bansal',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: baseTheme.colorScheme.copyWith(
          surface: AppColors.surface,
          primary: AppColors.accent,
          secondary: AppColors.accentSoft,
          outline: AppColors.border,
        ),
        textTheme: baseTheme.textTheme.apply(
          fontFamily: 'SpaceGrotesk',
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      builder: (context, child) => _AppCursorShell(child: child ?? const SizedBox.shrink()),
      // No second route. Splash is now an overlay state inside HomeShell,
      // so there is never a Navigator transition to fade/cut through.
      home: const HomeShell(),
    );
  }
}

// ── Custom cursor (unchanged from your version) ────────────────────────────
class _AppCursorShell extends StatefulWidget {
  const _AppCursorShell({required this.child});
  final Widget child;

  @override
  State<_AppCursorShell> createState() => _AppCursorShellState();
}

class _AppCursorShellState extends State<_AppCursorShell> with SingleTickerProviderStateMixin {
  late final AnimationController _followController;
  Offset _pointer = const Offset(-100, -100);
  Offset _trail = const Offset(-100, -100);
  bool _visible = false;
  bool _pressed = false;

  bool get _enableCustomCursor {
    if (kIsWeb) return true;
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows => true,
      TargetPlatform.macOS => true,
      TargetPlatform.linux => true,
      _ => false,
    };
  }

  @override
  void initState() {
    super.initState();
    _followController = AnimationController(vsync: this, duration: const Duration(milliseconds: 16))
      ..addListener(() {
        if (!_visible || _trail == _pointer) return;
        setState(() => _trail = Offset.lerp(_trail, _pointer, 0.18) ?? _pointer);
      })
      ..repeat();
  }

  @override
  void dispose() {
    _followController.dispose();
    super.dispose();
  }

  void _updatePointer(PointerEvent e) => setState(() => _pointer = e.position);

  @override
  Widget build(BuildContext context) {
    if (!_enableCustomCursor) return widget.child;
    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (e) => setState(() {
        _visible = true;
        _pointer = e.position;
        _trail = e.position;
      }),
      onHover: _updatePointer,
      onExit: (_) => setState(() => _visible = false),
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerMove: _updatePointer,
        onPointerDown: (_) => setState(() => _pressed = true),
        onPointerUp: (_) => setState(() => _pressed = false),
        child: Stack(
          fit: StackFit.expand,
          children: [
            widget.child,
            RepaintBoundary(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: _visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 140),
                  child: Stack(children: [
                    Transform.translate(
                      offset: Offset(_trail.dx - 22, _trail.dy - 22),
                      child: AnimatedScale(
                        scale: _pressed ? 0.75 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOutBack,
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentSoft.withValues(alpha: 0.05),
                                border: Border.all(
                                  color: AppColors.accentSoft.withValues(alpha: _pressed ? 0.6 : 0.42),
                                  width: _pressed ? 2.0 : 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentSoft.withValues(alpha: 0.16),
                                    blurRadius: 16,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(_pointer.dx - 7, _pointer.dy - 7),
                      child: AnimatedScale(
                        scale: _pressed ? 0.5 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOut,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: AppColors.accentGradientStrong,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: _pressed ? 0.8 : 0.38),
                                blurRadius: _pressed ? 12 : 18,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}