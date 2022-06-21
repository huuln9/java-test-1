import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget({Key? key, this.title, this.icon, required this.retry}) : super(key: key);

  final String? title;
  final Icon? icon;
  final Function retry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, size: 60, color: Color(0xFFB8B7B7)),
          const SizedBox(height: 8),
          Text(title ?? "khong tai duoc du lieu".tr, style: const TextStyle(color: Color(0xFF7D7B7B)),),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => retry.call(),
            child: Text("thu lai".tr.toUpperCase()),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              primary: Colors.white,
              onPrimary: Colors.black
            ),
          )
        ],
      ),
    );
  }
}
