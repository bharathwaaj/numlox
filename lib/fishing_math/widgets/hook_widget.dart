import 'package:flutter/material.dart';

class HookWidget extends StatelessWidget {
  final Offset start;
  final Offset end;
  final double progress; // 0.0 to 1.0

  const HookWidget({
    super.key,
    required this.start,
    required this.end,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final currentPos = Offset.lerp(start, end, progress)!;

    return Stack(
      children: [
        // Fishing Line
        CustomPaint(
          painter: FishingLinePainter(start: start, end: currentPos),
          size: Size.infinite,
        ),
        // Hook
        Positioned(
          left: currentPos.dx - 10,
          top: currentPos.dy - 10,
          child: Icon(Icons.anchor, color: Colors.grey[700], size: 25),
        ),
      ],
    );
  }
}

class FishingLinePainter extends CustomPainter {
  final Offset start;
  final Offset end;

  FishingLinePainter({required this.start, required this.end});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawLine(start, end, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
