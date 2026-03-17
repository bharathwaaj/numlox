import 'package:flutter/material.dart';

class FishermanWidget extends StatelessWidget {
  const FishermanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 120,
      child: CustomPaint(painter: BoatFishermanPainter()),
    );
  }
}

class BoatFishermanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    // 1. Draw the Boat (Hull)
    final boatPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.brown[400]!, Colors.brown[800]!],
      ).createShader(Rect.fromLTWH(center.dx - 60, center.dy + 10, 120, 30));

    final boatPath = Path();
    boatPath.moveTo(center.dx - 70, center.dy + 10); // Top left
    boatPath.lineTo(center.dx + 70, center.dy + 10); // Top right
    boatPath.quadraticBezierTo(
      center.dx + 60,
      center.dy + 40,
      center.dx,
      center.dy + 45,
    ); // Bottom right curve
    boatPath.quadraticBezierTo(
      center.dx - 60,
      center.dy + 40,
      center.dx - 70,
      center.dy + 10,
    ); // Bottom left curve
    boatPath.close();
    canvas.drawPath(boatPath, boatPaint);

    // Wood texture lines
    final woodLinesPaint = Paint()
      ..color = Colors.black12
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(center.dx - 65, center.dy + 20),
      Offset(center.dx + 65, center.dy + 20),
      woodLinesPaint,
    );
    canvas.drawLine(
      Offset(center.dx - 55, center.dy + 30),
      Offset(center.dx + 55, center.dy + 30),
      woodLinesPaint,
    );

    // 2. Draw the Fisherman (Cute character)
    final bodyPaint = Paint()..color = Colors.blue[700]!;
    final headPaint = Paint()..color = const Color(0xFFFFD180); // Skin tone
    final hatPaint = Paint()..color = Colors.yellow[700]!;

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - 15, center.dy - 20, 30, 30),
        const Radius.circular(8),
      ),
      bodyPaint,
    );

    // Head
    canvas.drawCircle(Offset(center.dx, center.dy - 35), 15, headPaint);

    // Eyes
    final eyePaint = Paint()..color = Colors.black87;
    canvas.drawCircle(Offset(center.dx - 5, center.dy - 37), 2, eyePaint);
    canvas.drawCircle(Offset(center.dx + 5, center.dy - 37), 2, eyePaint);

    // Hat
    final hatPath = Path();
    hatPath.moveTo(center.dx - 20, center.dy - 45);
    hatPath.lineTo(center.dx + 20, center.dy - 45);
    hatPath.lineTo(center.dx, center.dy - 60);
    hatPath.close();
    canvas.drawPath(hatPath, hatPaint);

    // 3. Fishing Rod
    final rodPaint = Paint()
      ..color = Colors.grey[800]!
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Rod tilts toward the water
    canvas.drawLine(
      Offset(center.dx + 10, center.dy - 10), // Hand position
      Offset(center.dx + 60, center.dy - 40), // Rod tip
      rodPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
