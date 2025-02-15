import 'package:flutter/material.dart';
import 'package:flutter_interactive_map/src/painter/table_painter.dart';
import 'package:flutter_interactive_map/src/models/group_item.dart';

import 'src/painter/wall_painter.dart';
import 'src/models/svg_group.dart';
import 'src/parser/svg_parser.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SchemePage(),
      ),
    );
  }
}

class SchemePage extends StatefulWidget {
  const SchemePage({super.key});

  @override
  State<SchemePage> createState() => _SchemePageState();
}

class _SchemePageState extends State<SchemePage> {
  SvgGroup? currentGroup;

  List<SvgGroup> groups = [];

  @override
  void initState() {
    super.initState();
    loadDistricts();
  }

  loadDistricts() async {
    groups = await SvgParser().loadSvgImage(svgImage: 'assets/scheme.svg');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (currentGroup != null) ...[Text(currentGroup!.label)],
            Expanded(
              child: InteractiveViewer(
                maxScale: 3,
                minScale: 1.0,
                onInteractionUpdate: (_) {},
                child: Stack(
                  children: [
                    for (var group in groups) ...[
                      for (var item in group.items) ...[
                        if (item is TableGroup) ...[
                          _getClippedImage(
                            tableItem: item,
                            color: currentGroup?.id == group.id
                                ? Colors.amber
                                : item.color,
                            district: group,
                            onDistrictSelected: onSelected,
                          ),
                        ] else ...[
                          _getBorder(item as WallGroup)
                        ],
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onSelected(SvgGroup group) {
    currentGroup = group;
    setState(() {});
  }

  Widget _getBorder(WallGroup wall) {
    if (wall.strokeWidth != null) {
      return CustomPaint(
        painter: WallWithStrokePainter(wall: wall),
      );
    } else {
      return ClipPath(
        clipper: WallClipper(wall),
        child: Container(color: wall.color),
      );
    }
  }

  Widget _getClippedImage({
    required TableGroup tableItem,
    required Color color,
    required SvgGroup district,
    final Function(SvgGroup district)? onDistrictSelected,
  }) {
    return ClipPath(
      clipper: TableClipper(tableItem),
      child: GestureDetector(
        onTap: () => onDistrictSelected?.call(district),
        child: Container(
          color: tableItem.isNumber ? tableItem.color : color,
        ),
      ),
    );
  }
}
