import 'package:flutter/material.dart';
import 'package:flutter_interactive_map/src/models/group_item.dart';
import 'package:path_drawing/path_drawing.dart';

class TableClipper extends CustomClipper<Path> {
  TableClipper(this.table);

  final TableGroup table;

  @override
  Path getClip(Size size) {
    var path = parseSvgPathData(table.path);
    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.scale(1.1, 1.1);

    return path.transform(matrix4.storage);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
