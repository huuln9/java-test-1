import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FullScreenCircularLoading extends StatelessWidget {
  const FullScreenCircularLoading({
    Key? key,
    this.backgroundColor,
    this.title,
  }) : super(key: key);

  final Color? backgroundColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: backgroundColor ?? Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 30),
            Text(
              (title ?? "dang xu ly".tr) + "...",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
