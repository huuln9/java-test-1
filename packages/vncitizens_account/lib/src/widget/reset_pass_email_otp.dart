import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_account/src/controller/reset_pass_email_otp_controller.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

class ResetPassEmailOtp extends GetView<ResetPassEmailOtpController> {
  const ResetPassEmailOtp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("xac thuc otp".tr),
        ),
        bottomNavigationBar: AccountAppConfig.appRequireLogin == true ? null : const MyBottomAppBar(index: 3),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: controller.otpFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text("ma xac thuc da duoc gui den email".tr),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Obx(() => Text(controller.email.value, style: const TextStyle(fontWeight: FontWeight.bold))),
                      ),
                      const SizedBox(height: 44),
                      TextFormField(
                        controller: controller.otpController,
                        keyboardType: TextInputType.number,
                        validator: (value) => controller.otpValidator(value),
                        decoration: InputDecoration(hintText: "nhap ma xac thuc".tr),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ma xac thuc se het han sau".tr),
                          const SizedBox(width: 4),
                          Obx(() => Text(controller.second.value.toString() + " " + "giay".tr,
                              style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500))),
                        ],
                      ),
                      const SizedBox(height: 60),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 120),
                            child: Obx(
                              () => ElevatedButton(
                                onPressed: controller.disableResent.value ? null : () => controller.resetForm(),
                                style: ButtonStyle(
                                    side: MaterialStateProperty.all(BorderSide(
                                        color: controller.disableResent.value ? const Color(0xFFD4D4D4) : const Color(0xFF1565C0))),
                                    backgroundColor:
                                        MaterialStateProperty.all(controller.disableResent.value ? const Color(0xFFD4D4D4) : Colors.white)),
                                child: Text(
                                  "gui lai ma".tr.toUpperCase(),
                                  style: TextStyle(
                                    color:
                                        controller.disableResent.value ? const Color.fromRGBO(125, 123, 123, 1) : const Color(0xFF1565C0),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          ConstrainedBox(
                            constraints: const BoxConstraints(minWidth: 120),
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
            if (AccountAppConfig.appRequireLogin == true && AccountAppConfig.remoteAppCopyright != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    AccountAppConfig.remoteAppCopyright!,
                    style: TextStyle(color: Colors.black.withOpacity(0.4)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
