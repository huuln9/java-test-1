import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vncitizens_common/src/config/app_config.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({
    this.message,
    Key? key,
  }) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage("${AppConfig.assetsRoot}/images/empty_data.png"),
          ),
          const SizedBox(height: 20),
          Text(
            message ?? 'khong tim thay du lieu'.tr,
            style: const TextStyle(
                color: Color(0xFF434343), fontSize: 16, letterSpacing: 0.25),
          ),
        ],
      ),
    );
  }
}
