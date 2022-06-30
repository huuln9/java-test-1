import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import '../../config/app_config.dart';

class EmptyAndReloadDataWidget extends StatelessWidget {
  const EmptyAndReloadDataWidget({Key? key, this.message, this.onCallBack})
      : super(key: key);
  final String? message;
  final Function? onCallBack;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Image(
            image: AssetImage('${AppConfig.assetsRoot}/images/cloud_off.png'),
            width: 150,
            height: 150,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            message ?? "khong co du lieu".tr,
            style: GoogleFonts.roboto(
                color: const Color(0xFF434343),
                fontSize: 16,
                letterSpacing: 0.25),
          ),
          const SizedBox(
            height: 32,
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              onPressed: () {
                if (onCallBack != null) {
                  onCallBack!();
                }
              },
              child: Text(
                "thu lai".tr.toUpperCase(),
                style: const TextStyle(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
