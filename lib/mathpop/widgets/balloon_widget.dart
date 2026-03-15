import 'dart:math';
import 'package:flutter/material.dart';
import '../models/balloon_model.dart';

class BalloonWidget extends StatefulWidget {
  final BalloonModel balloon;
  final VoidCallback onPopped; // triggered when it finishes flying
  final VoidCallback onTap;
  final Function(Offset position)? onPop;

  const BalloonWidget({
    super.key,
    required this.balloon,
    required this.onPopped,
    required this.onTap,
    this.onPop,
  });

  @override
  State<BalloonWidget> createState() => _BalloonWidgetState();
}

class _BalloonWidgetState extends State<BalloonWidget>
    with TickerProviderStateMixin {
  late AnimationController _flightController;
  late Animation<double> _flightAnimation;

  late AnimationController _scaleController;
  late AnimationController _shakeController;

  final GlobalKey _balloonKey = GlobalKey();
  bool _popped = false;

  @override
  void initState() {
    super.initState();
    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _flightAnimation = Tween<double>(
      begin: 1.1,
      end: -0.2,
    ).animate(_flightController);

    _flightController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onPopped();
      }
    });

    _flightController.forward();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void _handleTap() {
    if (_popped) return;

    if (widget.balloon.isCorrect) {
      _popped = true;
      _scaleController.reverse(); // Pop (scale to 0)

      // Calculate global position for feedback effects
      if (widget.onPop != null) {
        final RenderBox? renderBox =
            _balloonKey.currentContext?.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(
            Offset(renderBox.size.width / 2, renderBox.size.height / 3),
          );
          widget.onPop!(position);
        }
      }

      widget.onTap(); // Trigger correct answer logic
    } else {
      _shakeController.forward(from: 0.0); // Shake
    }
  }

  @override
  void dispose() {
    _flightController.dispose();
    _scaleController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _flightAnimation,
        _scaleController,
        _shakeController,
      ]),
      builder: (context, child) {
        // Horizontal wobble calculation
        // _flightController.value ranges from 0.0 to 1.0
        final double wobble = sin(_flightController.value * pi * 8) * 12;
        final double shakeOffset = sin(_shakeController.value * pi * 4) * 10;

        return Align(
          alignment: FractionalOffset(
            0.1 + (widget.balloon.laneIndex * 0.25),
            _flightAnimation.value,
          ),
          child: Transform.translate(
            offset: Offset(shakeOffset + wobble, 0),
            child: Transform.scale(scale: _scaleController.value, child: child),
          ),
        );
      },
      child: GestureDetector(
        key: _balloonKey,
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 90,
          height: 150, // Increased height to accommodate the string
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              // Balloon String
              Positioned(
                top: 80,
                child: CustomPaint(
                  size: const Size(2, 60),
                  painter: BalloonStringPainter(),
                ),
              ),
              // Balloon Image body
              Image.asset(
                'assets/images/mathpop/balloon.png',
                width: 90,
                height: 100,
                fit: BoxFit.contain,
              ),
              // Answer Text
              Positioned(
                top: 25,
                child: Text(
                  widget.balloon.answerValue.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black45,
                        offset: Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BalloonStringPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black45
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.quadraticBezierTo(
      size.width / 2 + 5,
      size.height / 2,
      size.width / 2 - 2,
      size.height,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
