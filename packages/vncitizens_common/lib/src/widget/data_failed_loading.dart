import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataFailedLoading extends StatelessWidget {
  const DataFailedLoading({
    this.message,
    this.buttonName,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String? message;
  final String? buttonName;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off,
            size: 120,
            color: Color(0xFFB8B7B7),
          ),
          // const SizedBox(height: 25),
          Text(
            message ?? 'khong tai duoc du lieu'.tr,
            style: const TextStyle(
                color: Color(0xFF434343), fontSize: 16, letterSpacing: 0.25),
          ),
          const SizedBox(height: 60),
          RaisedButton(
            child: Text('thu lai'.tr.toUpperCase()),
            onPressed: onPressed,
            color: Colors.white,
            textColor: const Color(0xFF263238),
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            splashColor: Colors.grey,
          )
        ],
      ),
    );
  }
}
