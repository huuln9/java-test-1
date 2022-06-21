import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class LinearLoadingWidget extends StatelessWidget {
  const LinearLoadingWidget({Key? key, this.title, this.maxWidth, this.background}) : super(key: key);

  final String? title;
  final double? maxWidth;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? MediaQuery.of(context).size.width * 0.7,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10)
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title ?? "dang tai du lieu".tr),
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
