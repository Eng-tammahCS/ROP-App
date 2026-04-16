import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../models/character_status.dart';

class IglooCharacter extends StatelessWidget {
  const IglooCharacter({
    super.key,
    required this.status,
    required this.name,
    required this.color,
    required this.idle,
  });

  final CharacterStatus status;
  final String name;
  final Color color;
  final double idle;

  @override
  Widget build(BuildContext context) {
    final sleeping = status == CharacterStatus.asleep;
    final pulse = sleeping ? 0.008 : 0.018;
    final bob = math.sin(idle * math.pi * 2) * 18 * pulse;

    return Semantics(
      label: name,
      button: true,
      child: Transform.translate(
        offset: Offset(0, bob),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              size: const Size(110, 122),
              painter: _CreaturePainter(
                color: color,
                sleeping: sleeping,
                blink: (math.sin(idle * math.pi * 6) + 1) / 2,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              sleeping ? 'نائم' : 'مستيقظ',
              style: const TextStyle(
                color: Color(0xFFEEE7F8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreaturePainter extends CustomPainter {
  const _CreaturePainter({
    required this.color,
    required this.sleeping,
    required this.blink,
  });

  final Color color;
  final bool sleeping;
  final double blink;

  @override
  void paint(Canvas canvas, Size size) {
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(12, 22, size.width - 24, size.height - 30),
      const Radius.circular(38),
    );

    final body = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.96), color.withOpacity(0.70)],
      ).createShader(bodyRect.outerRect);

    canvas.drawShadow(Path()..addRRect(bodyRect), Colors.black45, 14, false);
    canvas.drawRRect(bodyRect, body);

    final horn = Paint()..color = color.withOpacity(0.85);
    canvas.drawOval(const Rect.fromLTWH(24, 6, 24, 24), horn);
    canvas.drawOval(Rect.fromLTWH(size.width - 48, 6, 24, 24), horn);
    canvas.drawOval(
      Rect.fromLTWH(26, size.height - 26, 18, 10),
      Paint()..color = color.withOpacity(0.56),
    );
    canvas.drawOval(
      Rect.fromLTWH(size.width - 44, size.height - 26, 18, 10),
      Paint()..color = color.withOpacity(0.56),
    );

    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = sleeping ? 2.8 : 0;

    final iris = Paint()..color = const Color(0xFF2B203A);

    final eyeTop = 58.0;
    if (sleeping) {
      canvas.drawArc(const Rect.fromLTWH(34, 52, 14, 14), 0.35, 2.25, false, eyePaint);
      canvas.drawArc(
        Rect.fromLTWH(size.width - 48, 52, 14, 14),
        0.35,
        2.25,
        false,
        eyePaint,
      );
    } else {
      final openScale = 0.5 + (blink * 0.5);
      canvas.drawOval(Rect.fromLTWH(34, eyeTop, 14, 14 * openScale), Paint()..color = Colors.white);
      canvas.drawOval(
        Rect.fromLTWH(size.width - 48, eyeTop, 14, 14 * openScale),
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(const Offset(41, 64), 3.1, iris);
      canvas.drawCircle(Offset(size.width - 41, 64), 3.1, iris);
    }

    final mouth = Path()
      ..moveTo(size.width / 2 - 9, 80)
      ..quadraticBezierTo(size.width / 2, sleeping ? 85 : 90, size.width / 2 + 9, 80);
    canvas.drawPath(
      mouth,
      Paint()
        ..color = const Color(0xFF2C1A33)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.drawCircle(Offset(size.width / 2 - 22, 76), 4, Paint()..color = const Color(0x33FFC6D9));
    canvas.drawCircle(Offset(size.width / 2 + 22, 76), 4, Paint()..color = const Color(0x33FFC6D9));
  }

  @override
  bool shouldRepaint(covariant _CreaturePainter oldDelegate) {
    return oldDelegate.sleeping != sleeping || oldDelegate.blink != blink || oldDelegate.color != color;
  }
}
