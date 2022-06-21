import 'dart:ui';

class ColorUtils {
  static Color fromString(String hexColor) {
    try {
      return Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
    } catch (error) {
      return const Color(0xFF424242);
    }
  }
}
