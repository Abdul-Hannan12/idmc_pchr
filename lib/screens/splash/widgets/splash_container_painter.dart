import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class SplashDesignContainerPainter extends CustomPainter {
  final bool isBottom;
  const SplashDesignContainerPainter({this.isBottom = false});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = isBottom ? primaryOrange : primaryBlue
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path = Path();

    if (isBottom) {
      path.moveTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(0, size.height * 0.5);
      path.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.4,
        size.width * 0.5,
        size.height * 0.5,
      );
      path.quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.6,
        size.width,
        size.height * 0.5,
      );
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height * 0.5);
      path.quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.6,
        size.width * 0.5,
        size.height * 0.5,
      );
      path.quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.4,
        0,
        size.height * 0.5,
      );
      path.lineTo(0, 0);
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
