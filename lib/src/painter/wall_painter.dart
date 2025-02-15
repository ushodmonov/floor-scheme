import 'package:flutter/material.dart';
import 'package:flutter_interactive_map/src/models/group_item.dart';
import 'package:path_drawing/path_drawing.dart';

class WallClipper extends CustomClipper<Path> {
  WallClipper(this.wall);

  final WallGroup wall;

  @override
  Path getClip(Size size) {
    var path = parseSvgPathData(wall.path);
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(1.1, 1.1);

    return path.transform(matrix4.storage);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}

class WallWithStrokePainter extends CustomPainter {
  late final Paint borderPaint;
  final Matrix4 matrix4 = Matrix4.identity();

  final WallGroup wall;

  WallWithStrokePainter({super.repaint, required this.wall}) {
    matrix4.scale(1.1, 1.1);
    borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = double.tryParse(wall.strokeWidth ?? '1.0') ?? 1.0
      ..color = wall.color;
  }
  @override
  void paint(Canvas canvas, Size size) {
    final path = parseSvgPathData(wall.path).transform(matrix4.storage);
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
