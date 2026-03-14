import 'dart:math';
import 'package:flutter/material.dart';
import '../models/balloon_model.dart';

class BalloonWidget extends StatefulWidget {
  final BalloonModel balloon;
  final VoidCallback onPopped; // triggered when it finishes flying
  final VoidCallback onTap;

  const BalloonWidget({
    super.key,
    required this.balloon,
    required this.onPopped,
    required this.onTap,
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

  bool _popped = false;

  @override
  void initState() {
    super.initState();
    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    
    _flightAnimation = Tween<double>(begin: 1.1, end: -0.2).animate(_flightController);

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
      widget.onTap();             // Trigger correct answer logic
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
      animation: Listenable.merge([_flightAnimation, _scaleController, _shakeController]),
      builder: (context, child) {
        double shakeOffset = sin(_shakeController.value * pi * 4) * 10;

        return Align(
          alignment: FractionalOffset(
            0.1 + (widget.balloon.laneIndex * 0.25), 
            _flightAnimation.value,
          ),
          child: Transform.translate(
            offset: Offset(shakeOffset, 0),
            child: Transform.scale(
              scale: _scaleController.value,
              child: child,
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 70,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: const BorderRadius.all(Radius.circular(40)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 4),
              )
            ],
          ),
          child: Center(
            child: Text(
              widget.balloon.answerValue.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

