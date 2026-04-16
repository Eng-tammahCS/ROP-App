import 'package:flutter/material.dart';

class RoomShell extends StatelessWidget {
  const RoomShell({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2B2438), Color(0xFF17131F)],
          ),
        ),
        child: CustomPaint(
          painter: _RoomDepthPainter(),
          child: Stack(
            children: [
              const Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _FloorShadow(),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomDepthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final wall = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF6D5A84), Color(0xFF3E3652)],
      ).createShader(Offset.zero & Size(size.width, size.height * 0.62));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.62), wall);

    final floorPath = Path()
      ..moveTo(size.width * 0.12, size.height * 0.52)
      ..lineTo(size.width * 0.88, size.height * 0.52)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final floor = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF5C4B3E), Color(0xFF2F2520)],
      ).createShader(
        Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
      );
    canvas.drawPath(floorPath, floor);

    final windowGlow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.2, -0.25),
        radius: 0.35,
        colors: [const Color(0xCCFFE8B4), const Color(0x00FFE8B4)],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, windowGlow);

    final corner = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0x66745E8A), Color(0x00FFFFFF)],
      ).createShader(Offset.zero & size);
    canvas.drawPath(
      Path()
        ..moveTo(size.width * 0.72, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, size.height * 0.52)
        ..close(),
      corner,
    );

    final skirting = Paint()..color = const Color(0x88352E44);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.52, size.width, 4),
      skirting,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _FloorShadow extends StatelessWidget {
  const _FloorShadow();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        height: 84,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x660B0812), Color(0x000B0812)],
          ),
        ),
      ),
    );
  }
}
