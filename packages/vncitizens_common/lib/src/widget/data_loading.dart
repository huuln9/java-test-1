import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DataLoading extends StatelessWidget {
  const DataLoading({
    this.message,
    this.margin,
    Key? key,
  }) : super(key: key);

  final String? message;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: margin ?? const EdgeInsets.symmetric(horizontal: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message ?? "vui long cho".tr,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const LinearProgressIndicator(
              minHeight: 4,
            ),
          ],
        ),
      ),
    );
  }
}
