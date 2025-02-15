import 'package:flutter/material.dart';

abstract class GroupItem {
  final String id;
  final String path;
  final Color color;

  GroupItem({required this.id, required this.path, required this.color});
}

class TableGroup extends GroupItem {
  final bool isNumber;
  TableGroup({
    this.isNumber = false,
    required super.id,
    required super.path,
    required super.color,
  });
}

class WallGroup extends GroupItem {
  final String? strokeWidth;
  WallGroup({
    this.strokeWidth,
    required super.id,
    required super.path,
    required super.color,
  });
}
