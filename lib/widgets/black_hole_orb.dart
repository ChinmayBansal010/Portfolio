import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:portfolio/constants/colors.dart';

/// A single continuously-running clock shared by every [BlackHoleOrb]
/// instance in the app. Individual widget instances get disposed and
/// recreated (e.g. during a Hero flight between routes), but reading time
/// from here instead of from each widget's own elapsed-since-mount means the
/// disk's rotation phase never resets — it just keeps spinning as if it was
/// always the same object.
class AppClock {
  AppClock._();
  static final DateTime _start = DateTime.now();
  static double seconds() => DateTime.now().difference(_start).inMicroseconds / 1e6;
}

class _OrbParticle {
  double angle;
  double radius; // 0 (event horizon) .. 1 (outer disk edge)
  final double baseAngularSpeed;
  final double size;
  final double brightnessSeed;

  _OrbParticle({required int seed})
      : angle = Random(seed).nextDouble() * 2 * pi,
        radius = 0.32 + Random(seed + 17).nextDouble() * 0.68,
        baseAngularSpeed = 0.35 + Random(seed + 31).nextDouble() * 0.55,
        size = 0.6 + Random(seed + 47).nextDouble() * 1.6,
        brightnessSeed = Random(seed + 61).nextDouble();

  void update(double dt) {
    final angularSpeed = baseAngularSpeed * (1.6 - radius);
    angle += angularSpeed * dt;
    if (angle > 2 * pi) angle -= 2 * pi;
    radius -= dt * 0.028 * (1.3 - radius);
    if (radius < 0.18) {
      radius = 1.0;
      angle = Random().nextDouble() * 2 * pi;
    }
  }
}

/// A self-contained, continuously-animating black hole — rotating accretion
/// disk with Doppler-tinted orbiting particles, lensing arcs, a photon ring,
/// and a soft event horizon. It sizes itself entirely from the parent's
/// constraints (via [LayoutBuilder]), so wrapping it in a [Hero] with the
/// same tag on two different screens lets Flutter smoothly fly, resize, and
/// reposition the *same* black hole between them instead of cross-fading two
/// unrelated paintings.
class BlackHoleOrb extends StatefulWidget {
  const BlackHoleOrb({super.key, this.particleCount = 140});
  final int particleCount;

  @override
  State<BlackHoleOrb> createState() => _BlackHoleOrbState();
}

class _BlackHoleOrbState extends State<BlackHoleOrb> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _time = 0;
  double _lastSeconds = 0;
  late final List<_OrbParticle> _particles;

  @override
  void initState() {
    super.initState();
    _particles = List.generate(widget.particleCount, (i) => _OrbParticle(seed: i * 7919 + 13));
    _lastSeconds = AppClock.seconds();
    _ticker = createTicker((_) {
      if (!mounted) return;
      final seconds = AppClock.seconds();
      final dt = (seconds - _lastSeconds).clamp(0.0, 0.05);
      _lastSeconds = seconds;
      setState(() {
        _time = seconds;
        for (final p in _particles) {
          p.update(dt);
        }
      });
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: constraints.biggest,
          painter: _BlackHoleOrbPainter(time: _time, particles: _particles),
        );
      },
    );
  }
}

class _BlackHoleOrbPainter extends CustomPainter {
  final double time;
  final List<_OrbParticle> particles;
  _BlackHoleOrbPainter({required this.time, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final shortest = size.shortestSide;
    final scaleFactor = shortest / 340.0;
    final breathe = 0.5 + 0.5 * sin(time * 0.18);
    final baseRadius = shortest * 0.16 + shortest * 0.02 * breathe;
    const diskTilt = 0.34;
    final rotation = time * 0.22;

    // 1. Ambient bloom
    canvas.drawCircle(
      center,
      baseRadius * 4.0,
      Paint()
        ..shader = ui.Gradient.radial(
          center,
          baseRadius * 4.0,
          [
            AppColors.accent.withValues(alpha: 0.22),
            AppColors.accentSoft.withValues(alpha: 0.08),
            Colors.transparent,
          ],
          [0.0, 0.35, 1.0],
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14),
    );

    // 2. Accretion disk particles — Keplerian orbit, Doppler-tinted
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    for (final p in particles) {
      final orbitRadius = baseRadius * (1.15 + p.radius * 1.9);
      final ex = cos(p.angle) * orbitRadius;
      final ey = sin(p.angle) * orbitRadius * diskTilt;

      final approach = (sin(p.angle) + 1) / 2;
      final heat = (1 - p.radius).clamp(0.0, 1.0);
      final hue = ui.lerpDouble(28, 205, (approach * 0.6 + heat * 0.4).clamp(0.0, 1.0))!;
      final lightness = ui.lerpDouble(0.45, 0.85, approach * 0.7 + heat * 0.3)!;
      final twinkle = 0.6 + 0.4 * sin(time * 3 + p.brightnessSeed * 20);
      final alpha = (0.15 + 0.65 * approach) * (0.5 + 0.5 * heat) * twinkle;

      final dotColor = HSLColor.fromAHSL(alpha.clamp(0.0, 0.95), hue, 0.85, lightness).toColor();
      final dotRadius = p.size * (0.6 + heat * 0.8) * scaleFactor;

      canvas.drawCircle(Offset(ex, ey), dotRadius, Paint()..color = dotColor);
      if (heat > 0.6) {
        canvas.drawCircle(
          Offset(ex, ey),
          dotRadius * 2.2,
          Paint()..color = dotColor.withValues(alpha: dotColor.a * 0.25),
        );
      }
    }
    canvas.restore();

    // 3. Structural rings for density under the particles
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.scale(1.0, diskTilt);
    for (int i = 0; i < 3; i++) {
      final ringRadius = baseRadius * (1.3 + i * 0.55);
      final sweepShader = ui.Gradient.sweep(
        Offset.zero,
        [
          AppColors.accentWarm.withValues(alpha: 0.05),
          AppColors.accent.withValues(alpha: 0.28),
          AppColors.accentSecondary.withValues(alpha: 0.16),
          AppColors.accentWarm.withValues(alpha: 0.05),
        ],
        const [0.0, 0.3, 0.65, 1.0],
        TileMode.repeated,
        rotation * (i.isEven ? 1 : -0.6),
        rotation * (i.isEven ? 1 : -0.6) + 2 * pi,
      );
      canvas.drawCircle(
        Offset.zero,
        ringRadius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = (1.6 + i * 0.4) * scaleFactor
          ..shader = sweepShader,
      );
    }
    canvas.restore();

    // 4. Lensing arcs — the "far side" of the disk skimming over the poles
    final lensPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * scaleFactor
      ..shader = ui.Gradient.linear(
        Offset(center.dx - baseRadius * 1.3, center.dy),
        Offset(center.dx + baseRadius * 1.3, center.dy),
        [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.35),
          AppColors.accentSoft.withValues(alpha: 0.3),
          Colors.transparent,
        ],
        const [0.0, 0.4, 0.6, 1.0],
      );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - baseRadius * 1.02),
        width: baseRadius * 2.6,
        height: baseRadius * 0.9,
      ),
      pi,
      pi,
      false,
      lensPaint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + baseRadius * 1.02),
        width: baseRadius * 2.6,
        height: baseRadius * 0.9,
      ),
      0,
      pi,
      false,
      lensPaint,
    );

    // 5. Photon ring
    canvas.drawCircle(
      center,
      baseRadius * 1.02,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4 * scaleFactor
        ..shader = ui.Gradient.radial(
          center,
          baseRadius * 1.08,
          [
            Colors.white.withValues(alpha: 0.9),
            AppColors.accentSoft.withValues(alpha: 0.25),
          ],
          const [0.88, 1.0],
        ),
    );

    // 6. Event horizon
    canvas.drawCircle(
      center,
      baseRadius,
      Paint()
        ..color = Colors.black
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0),
    );
    canvas.drawCircle(
      center,
      baseRadius * 0.92,
      Paint()
        ..shader = ui.Gradient.radial(
          center,
          baseRadius * 0.92,
          [Colors.black, const Color(0xFF020408)],
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _BlackHoleOrbPainter old) => true;
}