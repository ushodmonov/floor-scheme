import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_interactive_map/src/color.dart';
import 'package:flutter_interactive_map/src/models/group_item.dart';
import 'package:flutter_interactive_map/src/models/svg_group.dart';
import 'package:xml/xml.dart';

class SvgParser {
  Future<List<SvgGroup>> loadSvgImage({required String svgImage}) async {
    String generalString = await rootBundle.loadString(svgImage);

    XmlDocument document = XmlDocument.parse(generalString);
    List<SvgGroup> maps = [];
    final groups = document.findAllElements('g');

    for (var group in groups) {
      String groupId = group.getAttribute('id') ?? '';
      String label = group.getAttribute('inkscape:label') ?? '';

      if (groupId.isEmpty && label.isEmpty) {
        continue;
      }
      SvgGroupType type;
      if (label.contains(SvgGroupType.table.name)) {
        type = SvgGroupType.table;
      } else if (label.contains(SvgGroupType.wall.name)) {
        type = SvgGroupType.wall;
      } else {
        type = SvgGroupType.others;
      }
      if (type == SvgGroupType.others) {
        continue;
      }

      List<GroupItem> items = [];
      final paths = group.findAllElements('path');
      for (var path in paths) {
        String id = path.getAttribute('id').toString();
        String d = path.getAttribute('d').toString();

        if (type == SvgGroupType.table) {
          Color color = const Color(0xCC31AA49);
          bool isNumber = false;
          String? fill = path.getAttribute('fill');
          if ((fill ?? '').contains('white') ||
              (fill ?? '').contains('#FFFFFF')) {
            color = Colors.white;
            isNumber = true;
          }
          items.add(
            TableGroup(
              color: color,
              path: d,
              id: id,
              isNumber: isNumber,
            ),
          );
        } else {
          String? strokeWith = path.getAttribute('stroke-width');
          String? color = path.getAttribute('fill') ??
              path.getAttribute('stroke') ??
              '#d9d9d9';

          items.add(
            WallGroup(
              strokeWidth: strokeWith,
              color: hexToColor(color),
              path: d,
              id: id,
            ),
          );
        }
      }

      maps.add(
        SvgGroup(
          id: groupId,
          items: items,
          label: label,
        ),
      );
    }

    return maps;
  }
}
