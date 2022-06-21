import 'package:flutter/material.dart';
import 'package:flutter_package_template/src/controller/example_controller.dart';
import 'package:get/get.dart';

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Get.snackbar("xin chao".tr, "I'm modern snackbar");
          },
        ),
        title: Text("title".trArgs(['John'])),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetBuilder<ExampleController>(
                init: ExampleController(),
                // You can initialize your controller here the first time. Don't use init in your other GetBuilders of same controller
                builder: (_) => Text(
                  'clicks: ${_.count}',
                )),
            ElevatedButton(
              child: const Text('Next Route'),
              onPressed: () {
                Get.toNamed('/second');
              },
            ),
            ElevatedButton(
              child: const Text('Change locale to English'),
              onPressed: () {
                Get.updateLocale(const Locale('en', 'UK'));
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Get.find<ExampleController>().increment();
          }),
    );
  }
}