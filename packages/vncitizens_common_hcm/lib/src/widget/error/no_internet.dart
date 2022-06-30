import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vncitizens_common/src/config/app_config.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: const Image(
                image:
                    AssetImage("${AppConfig.assetsRoot}/images/internet.png"),
                width: 300),
          ),
          const SizedBox(height: 16),
          Text(
            "loi ket noi".tr,
            style: GoogleFonts.nunitoSans(
                color: const Color(0xFF263238),
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 0.85),
          ),
          const SizedBox(height: 16),
          Column(
            children: [
              Text(
                "khong co ket noi internet".tr,
                style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF263238),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.25),
              ),
              Text(
                "vui long ket noi internet de su dung".tr,
                style: GoogleFonts.nunitoSans(
                    color: const Color(0xFF263238),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    height: 1.25),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: const Color(0xFF0A3FE2)),
              onPressed: () {
                // Get.back();
              },
              child: Text("thu lai".tr.toUpperCase()),
            ),
          )
        ],
      ),
    );
  }
}
