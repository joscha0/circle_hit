import 'package:flutter/material.dart';

class LineCircle extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;

  const LineCircle(
      {Key? key,
      required this.size,
      required this.color,
      required this.strokeWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: this.size,
      height: this.size,
      child: CustomPaint(
        painter: LineCirclePainter(color, strokeWidth),
      ),
    );
  }
}

class LineCirclePainter extends CustomPainter {
  final Paint _paint = Paint();
  LineCirclePainter(color, strokeWidth) {
    _paint
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
