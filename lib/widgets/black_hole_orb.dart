import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:portfolio/constants/colors.dart';

class AppClock {
  AppClock._();

  static final DateTime _start = DateTime.now();

  static double seconds() =>
      DateTime.now().difference(_start).inMicroseconds / 1e6;
}

class _OrbParticle {
  double angle;
  double radius;
  final double baseAngularSpeed;
  final double size;
  final double brightnessSeed;

  _OrbParticle({required int seed})
      : angle = Random(seed).nextDouble() * 2 * pi,
        radius = 0.30 + Random(seed + 17).nextDouble() * 0.70,
        baseAngularSpeed = 0.45 + Random(seed + 31).nextDouble() * 0.75,
        size = 0.7 + Random(seed + 47).nextDouble() * 2.0,
        brightnessSeed = Random(seed + 61).nextDouble();

  void update(double dt) {
    final speed = baseAngularSpeed * (1.8 - radius);
    angle += speed * dt;

    if (angle > 2 * pi) {
      angle -= 2 * pi;
    }

    radius -= dt * (0.018 + (1 - radius) * 0.018);

    if (radius < 0.17) {
      radius = 1.02;
      angle = Random().nextDouble() * 2 * pi;
    }
  }
}

class BlackHoleOrb extends StatefulWidget {
  const BlackHoleOrb({
    super.key,
    this.particleCount = 220,
  });

  final int particleCount;

  @override
  State<BlackHoleOrb> createState() => _BlackHoleOrbState();
}

class _BlackHoleOrbState extends State<BlackHoleOrb>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;

  late final List<_OrbParticle> _particles;

  double _time = 0;
  double _last = 0;

  @override
  void initState() {
    super.initState();

    _particles = List.generate(
      widget.particleCount,
          (i) => _OrbParticle(seed: i * 7919 + 97),
    );

    _last = AppClock.seconds();

    _ticker = createTicker((_) {
      if (!mounted) return;

      final now = AppClock.seconds();
      final dt = (now - _last).clamp(0.0, 0.05);

      _last = now;

      for (final p in _particles) {
        p.update(dt);
      }

      setState(() {
        _time = now;
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
      builder: (_, constraints) {
        return CustomPaint(
          size: constraints.biggest,
          painter: _BlackHolePainter(
            time: _time,
            particles: _particles,
          ),
        );
      },
    );
  }
}

class _BlackHolePainter extends CustomPainter {
  final double time;
  final List<_OrbParticle> particles;

  const _BlackHolePainter({
    required this.time,
    required this.particles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);

    final shortest = size.shortestSide;
    final scale = shortest / 340;

    final pulse = 0.5 + 0.5 * sin(time * 0.15);
    final radius = shortest * (0.155 + pulse * 0.02);

    const tilt = 0.34;

    final rotation = time * 0.24;

    _backgroundGlow(canvas, center, radius);
    _gravitationalHalo(canvas, center, radius);
    _diskNebula(canvas, center, radius, tilt, rotation);
    _particles(canvas, center, radius, tilt, rotation, scale);
    _rings(canvas, center, radius, tilt, rotation, scale);
    _frameDragging(canvas, center, radius, scale);
    _lensing(canvas, center, radius, scale);
    _photonRing(canvas, center, radius, scale);
    _eventHorizon(canvas, center, radius);
    _core(canvas, center, radius);
  }

  void _backgroundGlow(
      Canvas canvas,
      Offset c,
      double r,
      ) {
    canvas.drawCircle(
      c,
      r * 5,
      Paint()
        ..shader = ui.Gradient.radial(
          c,
          r * 5,
          [
            AppColors.accent.withValues(alpha: .22),
            AppColors.accentSoft.withValues(alpha: .09),
            Colors.transparent,
          ],
          const [
            0,
            .4,
            1,
          ],
        )
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          28,
        ),
    );
  }

  void _gravitationalHalo(
      Canvas canvas,
      Offset c,
      double r,
      ) {
    canvas.drawCircle(
      c,
      r * 3,
      Paint()
        ..shader = ui.Gradient.radial(
          c,
          r * 3,
          [
            Colors.white.withValues(alpha: .05),
            AppColors.accentWarm.withValues(alpha: .08),
            Colors.transparent,
          ],
          const [
            0,
            .45,
            1,
          ],
        )
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          20,
        ),
    );
  }

  void _diskNebula(
      Canvas canvas,
      Offset c,
      double r,
      double tilt,
      double rot,
      ) {
    canvas.save();

    canvas.translate(c.dx, c.dy);

    canvas.rotate(rot * .45);

    canvas.scale(
      1,
      tilt,
    );

    canvas.drawOval(
      Rect.fromCircle(
        center: Offset.zero,
        radius: r * 2.9,
      ),
      Paint()
        ..shader = ui.Gradient.radial(
          Offset.zero,
          r * 2.9,
          [
            Colors.transparent,
            AppColors.accentWarm.withValues(alpha: .05),
            AppColors.accent.withValues(alpha: .08),
            AppColors.accentSecondary.withValues(alpha: .05),
            Colors.transparent,
          ],
          const [
            .12,
            .45,
            .68,
            .86,
            1,
          ],
        ),
    );

    canvas.restore();
  }

  void _particles(
      Canvas canvas,
      Offset c,
      double r,
      double tilt,
      double rot,
      double scale,
      ) {
    canvas.save();

    canvas.translate(c.dx, c.dy);

    canvas.rotate(rot);

    for (final p in particles) {
      final orbit = r * (1.15 + p.radius * 1.9);

      final x = cos(p.angle) * orbit;

      final y = sin(p.angle) * orbit * tilt;

      final approach = (sin(p.angle) + 1) * .5;

      final heat = (1 - p.radius).clamp(0.0, 1.0);

      final hue = ui.lerpDouble(
        20,
        210,
        approach * .65 + heat * .35,
      )!;

      final light = ui.lerpDouble(
        .45,
        .9,
        approach * .65 + heat * .35,
      )!;

      final alpha =
          (.15 + .75 * approach) *
              (.45 + .55 * heat) *
              (.75 +
                  .25 *
                      sin(
                        time * 4 +
                            p.brightnessSeed * 20,
                      ));

      final color = HSLColor.fromAHSL(
        alpha.clamp(0, .98),
        hue,
        .9,
        light,
      ).toColor();

      final pr =
          p.size *
              (.55 + heat) *
              scale;

      canvas.drawCircle(
        Offset(x, y),
        pr * 3,
        Paint()
          ..color = color.withValues(alpha: color.a * .06)
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            8,
          ),
      );

      canvas.drawCircle(
        Offset(x, y),
        pr,
        Paint()..color = color,
      );
    }

    canvas.restore();
  }

  void _rings(
      Canvas canvas,
      Offset c,
      double r,
      double tilt,
      double rot,
      double scale,
      ) {
    canvas.save();

    canvas.translate(
      c.dx,
      c.dy,
    );

    canvas.scale(
      1,
      tilt,
    );

    for (int i = 0; i < 6; i++) {
      final rr =
          r * (1.15 + .28 * i);

      canvas.drawCircle(
        Offset.zero,
        rr,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth =
              (1.2 + .3 * i) * scale
          ..shader =
          ui.Gradient.sweep(
            Offset.zero,
            [
              AppColors.accentWarm.withValues(alpha: .02),
              AppColors.accent.withValues(alpha: .16),
              Colors.white.withValues(alpha: .06),
              AppColors.accentSecondary.withValues(alpha: .18),
              AppColors.accentWarm.withValues(alpha: .02),
            ],
            const [
              0,
              .22,
              .48,
              .76,
              1,
            ],
            TileMode.repeated,
            rot * (i.isEven ? 1 : -.5),
            rot * (i.isEven ? 1 : -.5) + 2 * pi,
          ),
      );
    }

    canvas.restore();
  }

  void _frameDragging(
      Canvas canvas,
      Offset c,
      double r,
      double scale,
      ) {
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4 * scale
      ..shader = ui.Gradient.linear(
        Offset(
          c.dx - r * 2,
          c.dy,
        ),
        Offset(
          c.dx + r * 2,
          c.dy,
        ),
        [
          Colors.transparent,
          Colors.white.withValues(alpha: .18),
          Colors.transparent,
        ],
        const [
          0,
          .5,
          1,
        ],
      );

    for (int i = 0; i < 4; i++) {
      canvas.drawArc(
        Rect.fromCenter(
          center: c,
          width: r * (2.8 + .18 * i),
          height: r * (.92 + .06 * i),
        ),
        rotationOffset(i),
        pi,
        false,
        p,
      );
    }
  }

  double rotationOffset(int i) {
    return time * (.15 + .02 * i);
  }

  void _lensing(
      Canvas canvas,
      Offset c,
      double r,
      double scale,
      ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.3 * scale
      ..shader = ui.Gradient.linear(
        Offset(
          c.dx - r * 1.6,
          c.dy,
        ),
        Offset(
          c.dx + r * 1.6,
          c.dy,
        ),
        [
          Colors.transparent,
          Colors.white.withValues(alpha: .45),
          AppColors.accentSoft.withValues(alpha: .35),
          Colors.transparent,
        ],
        const [
          0,
          .42,
          .58,
          1,
        ],
      );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(
          c.dx,
          c.dy - r,
        ),
        width: r * 3,
        height: r,
      ),
      pi,
      pi,
      false,
      paint,
    );

    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(
          c.dx,
          c.dy + r,
        ),
        width: r * 3,
        height: r,
      ),
      0,
      pi,
      false,
      paint,
    );
  }

  void _photonRing(
      Canvas canvas,
      Offset c,
      double r,
      double scale,
      ) {
    canvas.drawCircle(
      c,
      r * 1.02,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.7 * scale
        ..shader = ui.Gradient.radial(
          c,
          r * 1.08,
          [
            Colors.white,
            AppColors.accentSoft,
          ],
          const [
            .88,
            1,
          ],
        ),
    );
  }

  void _eventHorizon(
      Canvas canvas,
      Offset c,
      double r,
      ) {
    canvas.drawCircle(
      c,
      r,
      Paint()
        ..color = Colors.black
        ..maskFilter = const MaskFilter.blur(
          BlurStyle.normal,
          3,
        ),
    );

    canvas.drawCircle(
      c,
      r * .93,
      Paint()
        ..shader = ui.Gradient.radial(
          c,
          r * .93,
          const [
            Colors.black,
            Color(0xFF020306),
          ],
        ),
    );
  }

  void _core(
      Canvas canvas,
      Offset c,
      double r,
      ) {
    canvas.drawCircle(
      c,
      r * .62,
      Paint()
        ..shader = ui.Gradient.radial(
          c,
          r * .62,
          [
            Colors.black,
            Colors.black.withValues(alpha: .92),
            Colors.transparent,
          ],
          const [
            .55,
            .82,
            1,
          ],
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _BlackHolePainter oldDelegate) => true;
}