import 'package:flutter/material.dart';

const MaterialColor mainColor = MaterialColor(_mainColorPrimaryValue, <int, Color>{
  50: Color(0xFFE4F7EE),
  100: Color(0xFFBCECD5),
  200: Color(0xFF90DFB9),
  300: Color(0xFF64D29D),
  400: Color(0xFF42C988),
  500: Color(_mainColorPrimaryValue),
  600: Color(0xFF1DB96B),
  700: Color(0xFF18B160),
  800: Color(0xFF14A956),
  900: Color(0xFF0B9B43),
});
const int _mainColorPrimaryValue = 0xFF21BF73;

const MaterialColor mainColorAccent = MaterialColor(_mainColorAccentValue, <int, Color>{
  100: Color(0xFFC9FFDC),
  200: Color(_mainColorAccentValue),
  400: Color(0xFF63FF98),
  700: Color(0xFF4AFF87),
});
const int _mainColorAccentValue = 0xFF96FFBA;

const Color newTaskColor = Colors.blueAccent;
const Color progressTaskColor = Color(0xFFFF0090);
const Color canceledTaskColor = Color(0xFFDC143C);
const Color completedTaskColor = mainColor;