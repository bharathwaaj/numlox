import 'dart:math';
import 'package:flutter/material.dart';

class ParticleBurst extends StatefulWidget {
  final Offset position;
  final Color color;

  const ParticleBurst({
    super.key,
    required this.position,
    this.color = Colors.redAccent,
  });

  @override
  State<ParticleBurst> createState() => _ParticleBurstState();
}

class _ParticleBurstState extends State<ParticleBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Initial 15 particles
    for (int i = 0; i < 15; i++) {
      final double angle = _random.nextDouble() * 2 * pi;
      final double speed = 2.0 + _random.nextDouble() * 4.0;
      _particles.add(
        Particle(
          velocity: Offset(cos(angle) * speed, sin(angle) * speed),
          size: 3.0 + _random.nextDouble() * 5.0,
        ),
      );
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            center: widget.position,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class Particle {
  final Offset velocity;
  final double size;

  Particle({required this.velocity, required this.size});
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Offset center;
  final Color color;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.center,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color.withValues(alpha: 1.0 - progress);

    for (var particle in particles) {
      final Offset currentPos = center + (particle.velocity * progress * 60);
      canvas.drawCircle(currentPos, particle.size * (1.0 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
