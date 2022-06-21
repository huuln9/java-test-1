import 'package:flutter/material.dart';
import 'package:vncitizens_common/vncitizens_common.dart';
import 'package:vncitizens_petition/src/controller/otp_controller.dart';

class OtpVerify extends StatelessWidget {
  OtpVerify({Key? key}) : super(key: key);

  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("xac thuc otp".tr),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.otpFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "ma xac thuc da duoc gui den so dien thoai".tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Obx(() => Text(controller.phoneNumber.value,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ))),
                  ),
                  const SizedBox(height: 44),
                  TextFormField(
                    controller: controller.otpController,
                    keyboardType: TextInputType.number,
                    validator: (value) => controller.otpValidator(value),
                    decoration:
                        InputDecoration(hintText: "nhap ma xac thuc".tr),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "ma xac thuc se het han sau".tr,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 4),
                      Obx(() => Text(
                          controller.second.value.toString() + " " + "giay".tr,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                              fontWeight: FontWeight.w500))),
                    ],
                  ),
                  const SizedBox(height: 60),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: controller.disableResent.value
                                ? null
                                : () => controller.resetForm(),
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(BorderSide(
                                    color: controller.disableResent.value
                                        ? const Color(0xFFD4D4D4)
                                        : const Color(0xFF1565C0))),
                                backgroundColor: MaterialStateProperty.all(
                                    controller.disableResent.value
                                        ? const Color(0xFFD4D4D4)
                                        : Colors.white)),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.sync,
                                    color: controller.disableResent.value
                                        ? const Color.fromRGBO(125, 123, 123, 1)
                                        : const Color(0xFF1565C0),
                                  ),
                                ),
                                Text(
                                  "gui lai ma".tr.toUpperCase(),
                                  style: TextStyle(
                                    color: controller.disableResent.value
                                        ? const Color.fromRGBO(125, 123, 123, 1)
                                        : const Color(0xFF1565C0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () => controller.submit(),
                          child: Text(
                            "dong y".tr.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
