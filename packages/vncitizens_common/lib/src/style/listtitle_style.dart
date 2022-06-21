import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ListTitleStyle {
  static TextStyle get title {
    return GoogleFonts.roboto(
        color: const Color(0xFF263238),
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15);
  }

  static TextStyle get subtitle {
    return GoogleFonts.roboto(
        color: const Color(0xFF263238), letterSpacing: 0.25);
  }
}
