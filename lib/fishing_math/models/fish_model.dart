import 'package:flutter/material.dart';

enum SwimDirection { leftToRight, rightToLeft }

class FishModel {
  final int id;
  final int answerValue;
  final bool isCorrect;
  final int laneIndex;
  final Color color;
  final double speed;
  final SwimDirection direction;
  bool isCaught;
  bool isShaking;
  bool isTargeted;
  bool isEscaping;
  bool isRevealing;

  FishModel({
    required this.id,
    required this.answerValue,
    required this.isCorrect,
    required this.laneIndex,
    required this.color,
    required this.speed,
    required this.direction,
    this.isCaught = false,
    this.isShaking = false,
    this.isTargeted = false,
    this.isEscaping = false,
    this.isRevealing = false,
  });
}
