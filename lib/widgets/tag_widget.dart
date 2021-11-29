import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:onloop/bloc/content_provider.dart';
import 'package:onloop/models/tag.dart';
import 'package:onloop/widgets/tag_component.dart';
import 'package:provider/provider.dart';
import 'dart:core';

class TagWidget extends StatefulWidget {
  const TagWidget({Key? key}) : super(key: key);

  @override
  _TagWidgetState createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  double? scrollViewWidth;

  void updateScrollViewWidth(double width) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (scrollViewWidth == double.maxFinite ||
          (scrollViewWidth! - width).abs() > 10.0) {
        print('Update width $width');
        setState(() {
          scrollViewWidth = width;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    scrollViewWidth = double.maxFinite;
    Provider.of<ContentProvider>(context, listen: false).getTags();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContentProvider>(context);
    return StreamBuilder<List<Tag>?>(
      stream: provider.tags,
      builder: (BuildContext context, AsyncSnapshot<List<Tag>?> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error, please try again later'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        final data = snapshot.data!;
        print('stream builder');
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: scrollViewWidth,
            child: CustomMultiChildLayout(
              delegate: TagDelete(
                  total: data.length, updateWidth: updateScrollViewWidth),
              children: getLayoutIds(data, provider.selectTag),
            ),
          ),
        );
      },
    );
  }

  List<LayoutId> getLayoutIds(List<Tag> tags, Function select) {
    List<LayoutId> layoutIds = [];
    for (var i = 0; i < tags.length; i++) {
      layoutIds.add(LayoutId(
          id: i,
          child: TagComponent(
            tag: tags[i],
            onSelectTag: select,
          )));
    }

    return layoutIds;
  }
}

class TagDelete extends MultiChildLayoutDelegate {
  final int total;
  final Function updateWidth;

  TagDelete({required this.total, required this.updateWidth});

  @override
  void performLayout(Size size) {
    final widths = calculateWidth(size);
    final info = getInfo(widths);
    final breakpoints = info[0];
    final double widestWidth = info[1];
    double toBeDeducted = 0.0;
    late Offset offset;
    const double rowHeight = 35.0;
    for (var i = 0; i < total; i++) {
      late double x, y;
      if (breakpoints.contains(i - 1) || i == 0) {
        x = 0.0;
        int yIndex = breakpoints.indexWhere((element) => (element as int) >= i);
        if (yIndex == -1) {
          y = offset.dy + rowHeight;
        } else {
          y = rowHeight * yIndex;
        }
        toBeDeducted = i > 0 ? widths[i - 1]! : toBeDeducted;
      } else {
        x = widths[i - 1]! - toBeDeducted;
        y = offset.dy;
      }
      offset = Offset(x, y);
      // print('x = $x; y = $y; toBeDeducted = $toBeDeducted');
      positionChild(i, offset);
    }
    updateWidth(widestWidth + 10);
  }

  Map<int, double> calculateWidth(Size size) {
    final List<double> widths = [];
    double temp = 0.0;
    for (var i = 0; i < total; i++) {
      final widgetSize = layoutChild(i, BoxConstraints.loose(size));
      temp = temp + widgetSize.width;
      widths.add(temp);
    }

    return widths.asMap();
  }

  List<dynamic> getInfo(Map<int, double> widths, {int lines = 3}) {
    final lastOne = widths[widths.length - 1]!;
    final double avg = lastOne / lines;
    final double avgItemWidth = lastOne / widths.length;
    List<dynamic> breakPoints = [];
    double previousLineWidth = 0.0;
    double widestWidth = 0.0;
    for (var i = 0; i < lines - 1; i++) {
      var temp = widths.entries
          .firstWhere((element) => element.value - previousLineWidth > avg);
      if (temp.value - previousLineWidth > avg + avgItemWidth &&
          temp.key > breakPoints[breakPoints.length - 1] + 1) {
        temp =
            widths.entries.firstWhere((element) => element.key == temp.key - 1);
      }
      final currentLineWidth = temp.value - previousLineWidth;
      breakPoints.add(temp.key);
      previousLineWidth = temp.value;
      widestWidth = max(widestWidth, currentLineWidth);
    }

    widestWidth = max(widestWidth, lastOne - previousLineWidth);
    return [breakPoints, widestWidth];
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) => true;
}
