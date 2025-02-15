import 'package:flutter_interactive_map/src/models/group_item.dart';

enum SvgGroupType {
  table,
  wall,
  others;

  static SvgGroupType getType(String type) {
    if (type.toLowerCase() == SvgGroupType.table.name) {
      return SvgGroupType.table;
    } else if (type.toLowerCase() == SvgGroupType.wall.name) {
      return SvgGroupType.wall;
    }
    return SvgGroupType.others;
  }
}

class SvgGroup {
  final String id;
  final SvgGroupType type;
  final List<GroupItem> items;
  final String label;

  SvgGroup({
    required this.id,
    this.type = SvgGroupType.table,
    this.items = const [],
    required this.label,
  });
}
