import 'package:flutter/material.dart';
import 'dart:math';

class DisintegrationEffect extends StatefulWidget {
  final Duration duration;
  final VoidCallback onEnd;

  const DisintegrationEffect({
    super.key,
    required this.duration,
    required this.onEnd,
  });

  @override
  _DisintegrationEffectState createState() => _DisintegrationEffectState();
}

class _DisintegrationEffectState extends State<DisintegrationEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Particle> particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onEnd();
        }
      });
    // Generate particles
    for (int i = 0; i < 50; i++) {
      particles.add(Particle());
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
    return CustomPaint(
      painter: ParticlePainter(
        particles: particles,
        progress: _controller.value,
      ),
      child: Container(),
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  double size;

  Particle()
      : position = Offset.zero,
        velocity = Offset(
          (Random().nextDouble() - 0.5) * 5, // Random horizontal speed
          (Random().nextDouble() - 0.5) * 5, // Random vertical speed
        ),
        size = Random().nextDouble() * 3 + 1; // Random size between 1 and 4
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.grey.withOpacity(1 - progress);

    for (var particle in particles) {
      particle.position += particle.velocity;
      canvas.drawCircle(
        Offset(size.width / 2 + particle.position.dx,
            size.height / 2 + particle.position.dy),
        particle.size * (1 - progress),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}