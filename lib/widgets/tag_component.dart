import 'package:flutter/material.dart';
import 'package:onloop/models/tag.dart';
import 'package:onloop/util/color_helper.dart';

class TagComponent extends StatelessWidget {
  final Tag tag;
  final Function? onSelectTag;
  const TagComponent({Key? key, required this.tag, required this.onSelectTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color fontColor = ColorHelper.getColorByName(tag.color);
    final Color bColor = fontColor.withAlpha(100);
    final Color regularColor = fontColor.withAlpha(150);
    final Color highlightedColor = fontColor.withAlpha(200);
    final border = tag.selected
        ? Border.all(color: highlightedColor, width: 3.0)
        : Border.all(color: regularColor);
    return InkWell(
      onTap: onSelectTag == null ? null : () => onSelectTag!(tag),
      child: Container(
        padding: tag.name.length > 6
            ? const EdgeInsets.all(5.0)
            : const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0),
        margin: onSelectTag != null
            ? const EdgeInsets.all(10.0)
            : const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
            color: bColor,
            border: border,
            borderRadius: const BorderRadius.all(Radius.circular(15.0))),
        child: Text(
          tag.name,
          style: TextStyle(color: fontColor),
        ),
      ),
    );
  }
}
