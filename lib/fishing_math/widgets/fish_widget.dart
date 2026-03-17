import 'dart:math';
import 'package:flutter/material.dart';
import '../models/fish_model.dart';

class FishWidget extends StatefulWidget {
  final FishModel fish;
  final Function(Offset globalPosition) onTap;
  final bool isTimeout;

  const FishWidget({
    super.key,
    required this.fish,
    required this.onTap,
    this.isTimeout = false,
  });

  @override
  State<FishWidget> createState() => _FishWidgetState();
}

class _FishWidgetState extends State<FishWidget> with TickerProviderStateMixin {
  late AnimationController _swimController;
  late Animation<double> _swimAnimation;
  late AnimationController _shakeController;
  late AnimationController _wiggleController;
  late AnimationController _vibrateController;
  late AnimationController _revealController;
  late AnimationController _opacityController;

  void triggerShake() {
    _shakeController.forward(from: 0.0);
  }

  bool _lastTargeted = false;
  bool _lastEscaping = false;
  bool _lastRevealing = false;
  late double _randomPhase;

  @override
  void initState() {
    super.initState();
    _randomPhase = Random().nextDouble() * 2 * pi;

    _swimController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (12000 / widget.fish.speed).round()),
    );

    _swimAnimation = Tween<double>(
      begin: widget.fish.direction == SwimDirection.leftToRight ? -0.2 : 1.2,
      end: widget.fish.direction == SwimDirection.leftToRight ? 1.2 : -0.2,
    ).animate(_swimController);

    _swimController.repeat();

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _vibrateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _wiggleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0,
    );

    _lastTargeted = widget.fish.isTargeted;
    _lastEscaping = widget.fish.isEscaping;
    _lastRevealing = widget.fish.isRevealing;

    if (_lastTargeted || _lastRevealing) {
      _swimController.stop();
      if (_lastTargeted) _vibrateController.repeat(reverse: true);
      if (_lastRevealing) {
        _wiggleController.repeat(reverse: true);
        _revealController.value = 1.0;
      }
    }
  }

  @override
  void didUpdateWidget(FishWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 1. Escaping Logic (Vanish)
    if (widget.fish.isEscaping && !_lastEscaping) {
      _opacityController.animateTo(0.0, curve: Curves.easeOut);
      // Still swim away just to give some movement before it vanishes
      _swimController.duration = const Duration(
        milliseconds: 3000,
      ); // Slower escape
      _swimController.repeat();
    }

    // 2. Revealing Logic (Move to center and smile)
    if (widget.fish.isRevealing && !_lastRevealing) {
      _swimController.stop();
      _revealController.forward();
      _wiggleController.repeat(reverse: true);
      _vibrateController.repeat(reverse: true);
    }

    // 3. Shaking Logic
    if (widget.fish.isShaking) {
      if (!_shakeController.isAnimating) {
        _shakeController.forward(from: 0.0);
      }
    }

    // 4. Targeted Logic
    if (widget.fish.isTargeted != _lastTargeted) {
      _lastTargeted = widget.fish.isTargeted;
      if (_lastTargeted) {
        _swimController.stop();
        _vibrateController.repeat(reverse: true);
      } else {
        // Only resume if NOT escaping or revealing
        if (!widget.fish.isEscaping && !widget.fish.isRevealing) {
          _swimController.repeat();
        }
        _vibrateController.stop();
      }
    }

    _lastEscaping = widget.fish.isEscaping;
    _lastRevealing = widget.fish.isRevealing;
  }

  @override
  void dispose() {
    _swimController.dispose();
    _shakeController.dispose();
    _wiggleController.dispose();
    _vibrateController.dispose();
    _revealController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _swimAnimation,
        _shakeController,
        _wiggleController,
        _vibrateController,
        _revealController,
        _opacityController,
      ]),
      builder: (context, child) {
        final double shakeOffset = sin(_shakeController.value * pi * 4) * 8;
        final double vibrateOffset =
            widget.fish.isTargeted || widget.fish.isRevealing
            ? sin(_vibrateController.value * pi * 2) * 3
            : 0;
        final double wiggleRotation =
            (widget.isTimeout || widget.fish.isCorrect) &&
                (widget.fish.isRevealing || widget.fish.isCaught)
            ? sin(_wiggleController.value * pi * 2) * 0.2
            : 0;

        // Alignment Logic: Interpolate between swimming position and center (0.5, 0.4)
        // Add some "roaming" (vertical bobbing)
        final double bobbingY =
            sin((_swimController.value * 2 * pi) + _randomPhase) * 0.1;

        final swimAlignment = FractionalOffset(
          _swimAnimation.value,
          0.2 + (widget.fish.laneIndex * 0.2) + bobbingY,
        );

        final revealAlignment = const FractionalOffset(0.5, 0.4);

        final currentAlignment = FractionalOffset.lerp(
          swimAlignment,
          revealAlignment,
          _revealController.value,
        )!;

        // Face the movement direction during reveal
        final bool facingRight = _revealController.value > 0.1
            ? (swimAlignment.dx < 0.5)
            : widget.fish.direction == SwimDirection.leftToRight;

        return Opacity(
          opacity: _opacityController.value,
          child: Align(
            alignment: currentAlignment,
            child: Transform.rotate(
              angle: wiggleRotation,
              child: Transform.translate(
                offset: Offset(0, shakeOffset),
                child: Transform.translate(
                  offset: Offset(vibrateOffset, 0),
                  child: Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: widget.isTimeout
                            ? null
                            : () {
                                final RenderBox box =
                                    context.findRenderObject() as RenderBox;
                                // Head is at 0 in painter, Tail is at 100.
                                // If flip: head is at 100.
                                final double mouthX = facingRight ? 80 : 20;
                                final mouthPos = box.localToGlobal(
                                  Offset(mouthX, 30),
                                );
                                widget.onTap(mouthPos);
                              },
                        child: _buildFishBody(facingRight),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFishBody(bool facingRight) {
    return Container(
      width: 100,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Basic Fish Shape
          CustomPaint(
            size: Size(100, 60),
            painter: FishPainter(color: widget.fish.color, flip: facingRight),
          ),

          // Answer Value
          Text(
            widget.fish.answerValue.toString(),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FishPainter extends CustomPainter {
  final Color color;
  final bool flip;
  FishPainter({required this.color, this.flip = false});

  @override
  void paint(Canvas canvas, Size size) {
    if (flip) {
      canvas.translate(size.width, 0);
      canvas.scale(-1, 1);
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    // Body (ellipse)
    path.addOval(Rect.fromLTWH(0, 10, 80, 40));

    // Tail (triangle)
    path.moveTo(80, 30);
    path.lineTo(100, 10);
    path.lineTo(100, 50);
    path.close();

    // Eye
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(20, 25), 5, eyePaint);
    canvas.drawCircle(Offset(20, 25), 2.5, Paint()..color = Colors.black);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
