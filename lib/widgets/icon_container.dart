import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final IconData iconData;
  const IconContainer({Key? key, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(5.0)),
      child: Icon(
        iconData,
        color: Colors.black54,
      ),
    );
  }
}
