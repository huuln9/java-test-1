import 'package:flutter/material.dart';

class CharColorHelper {
  static String getWildcard(String text) {
    if (text.isNotEmpty) {
      return text[0];
    } else {
      return '';
    }
  }

  static String get2Wildcards(String text) {
    String textTrim = text.trim().toUpperCase();
    if (textTrim.isNotEmpty) {
      List<String> textSplits = textTrim.split(' ');
      if (textSplits.length > 1) {
        return (textSplits[0][0] + textSplits[textSplits.length - 1][0]);
      } else {
        return text.substring(0, 2);
      }
    } else {
      return '';
    }
  }

  static final Map<String, Color> characterColor = {
    'a': Colors.pink,
    'ă': Colors.pink.shade900,
    'â': Colors.red.shade900,
    'b': Colors.redAccent.shade400,
    'c': Colors.deepOrange.shade900,
    'd': Colors.deepOrangeAccent.shade400,
    'đ': Colors.orange.shade900,
    'e': Colors.orangeAccent.shade700,
    'ê': Colors.yellow.shade900,
    'g': Colors.yellowAccent.shade700,
    'h': Colors.lime.shade900,
    'i': Colors.limeAccent.shade700,
    'k': Colors.lightGreen.shade900,
    'l': Colors.limeAccent.shade700,
    'm': Colors.green.shade900,
    'n': Colors.greenAccent.shade700,
    'o': Colors.teal.shade900,
    'ô': Colors.tealAccent,
    'ơ': Colors.cyan.shade900,
    'p': Colors.cyanAccent.shade700,
    'q': Colors.lightBlue.shade900,
    'r': Colors.blue.shade900,
    's': Colors.indigo.shade900,
    't': Colors.purple,
    'u': Colors.deepPurple.shade900,
    'ư': Colors.blueGrey.shade900,
    'v': Colors.brown.shade900,
    'x': Colors.grey.shade900,
  };
}
