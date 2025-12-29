import 'package:flutter/material.dart';

const colorList = <Color>[Colors.blue];

class AppTheme {
  final int selectedColor;
  AppTheme({this.selectedColor = 0})
    : assert(selectedColor >= 0, 'El color debe ser mayor a 0'),
      assert(
        selectedColor < colorList.length,
        'El color debe ser < ${colorList.length - 1}',
      );

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: colorList[selectedColor],
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: colorList[selectedColor],
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
    )
  );
}
