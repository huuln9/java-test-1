import 'package:flutter/material.dart';
import 'package:vncitizens_account/src/config/account_app_config.dart';
import 'package:vncitizens_common/vncitizens_common.dart';

import '../controller/reset_pass_email_controller.dart';

class ResetPassEmail extends GetView<ResetPassEmailController> {
  const ResetPassEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("quen mat khau".tr),
        ),
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: AccountAppConfig.appRequireLogin == true ? null : const MyBottomAppBar(index: 3),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                        () => TextFormField(
                          controller: controller.inputController,
                          onChanged: (value) => controller.inputValidator(value),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: "Email",
                              errorText: controller.textError.value != "" ? controller.textError.value : null),
                        ),
                      ),
                      const SizedBox(height: 100),
                      ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 120),
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: () => controller.submit(),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(controller.disableButton.value ? const Color(0xFFD4D4D4) : null),
                            ),
                            child: Text(
                              "gui ma otp".tr.toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: controller.disableButton.value ? const Color.fromRGBO(125, 123, 123, 1) : Colors.white),
                            ),
                          ),
                        ),
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
