import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DataNotFound extends StatelessWidget {
  const DataNotFound({
    this.message,
    Key? key,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message ?? "khong tim thay du lieu".tr,
        style: GoogleFonts.roboto(
            color: const Color(0xFF434343), fontSize: 16, letterSpacing: 0.25),
      ),
    );
  }
}
