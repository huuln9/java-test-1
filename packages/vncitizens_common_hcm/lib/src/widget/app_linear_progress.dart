import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import '../config/app_config.dart';

class AppLinearProgress extends StatelessWidget {
  const AppLinearProgress({Key? key, this.text}) : super(key: key);
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width - 48,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text ?? "dang tai du lieu".tr,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: LinearProgressIndicator(
              backgroundColor: AppConfig.materialMainBlueColor.withOpacity(0.2),
              color: AppConfig.materialMainBlueColor,
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }
}
