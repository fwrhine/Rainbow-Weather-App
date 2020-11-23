import 'package:flutter/material.dart';
import 'dart:math';

String setConditionCode(String condition) {
  /* Set Flare animation code based on weather condition.*/
  var code;

  switch (condition) {
    case "Thunderstorm":
      code = "11d";
      break;
    case "Drizzle":
      code = "09d";
      break;
    case "Rain":
      code = "10d";
      break;
    case "Snow":
      code = "13d";
      break;
    case "Atmosphere":
      code = "50d";
      break;
    case "Clear":
      code = "01d";
      break;
    case "Clouds":
      code = "03d";
      break;
  }

  return code;
}

List<Color> setConditionColor(String condition) {
  /* Set background color based on weather condition.*/
  var color;

  switch (condition) {
    case "Thunderstorm":
      color = [Color(0xFF7EB2E6), Color(0xFFC49AE9)];
      break;
    case "Drizzle":
      color = [Color(0xFFFD5F7E), Color(0xFFFFD0A1)];
      break;
    case "Rain":
      color = [Color(0xFF64CAB1), Color(0xFFB0D87E)];
      break;
    case "Snow":
      color = [Color(0xFF7EA1E6), Color(0xFF7EE1E6)];
      break;
    case "Atmosphere":
      color = [Color(0xFF3C9CF8), Color(0xFFB0D87E)];
      break;
    case "Clear":
      color = [Color(0xFFFF7474), Color(0xFFFFD0A1)];
      break;
    case "Clouds":
      color = [Color(0xFFFD5F7E), Color(0xFFB08BD7)];
      break;
  }

  return color;
}

List<Color> setColor() {
  /* Set background color randomly.*/
  var colors = [
    [Color(0xFFFD5F7E), Color(0xFFB08BD7)],
    [Color(0xFFFF7474), Color(0xFFFFD0A1)],
    [Color(0xFFFD5F7E), Color(0xFFFFD0A1)],
    [Color(0xFF7EA1E6), Color(0xFF7EE1E6)],
    [Color(0xFF7EB2E6), Color(0xFFC49AE9)],
    [Color(0xFF64CAB1), Color(0xFFB0D87E)],
    [Color(0xFF3C9CF8), Color(0xFFB0D87E)],
  ];

  final _random = new Random();
  var randomColor = colors[_random.nextInt(colors.length)];
  return randomColor;
}
