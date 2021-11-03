

import 'package:flutter/material.dart';

class ColorHelper {
  static const colorMappings = {
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'yellow': Colors.yellow
  };

  static Color getColorByName(String colorName){
    if(colorMappings.containsKey(colorName)){
      return colorMappings[colorName]!;
    }
    return Colors.black;
  }
}